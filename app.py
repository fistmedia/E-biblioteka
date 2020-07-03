#!/usr/bin/python
from os import getenv
from os.path import join, dirname, splitext
from random import randint
from dotenv import load_dotenv
from flask import Flask, render_template, url_for, request, redirect, session, flash
from mysql.connector import connect
from werkzeug.security import generate_password_hash, check_password_hash

# Create the .env file's path and load it
load_dotenv(join(dirname(__file__), '.env'))

konekcija = connect(
    host = getenv('DB_Host'),
    user = getenv('DB_User'),
    passwd = getenv('DB_Pass'),
    database = getenv('DB_Db')
)

kursor = konekcija.cursor(dictionary = True)

def ulogovan(tip = 0):
    if 'ulogovani_korisnik' in session:
        if tip == 'admin':
            sql = 'SELECT bibliotekar FROM korisnik WHERE id = %s'
            kursor.execute(sql, (session['ulogovani_korisnik'],))
            res = kursor.fetchone()
            return res['bibliotekar']
        elif tip == 'placen':
            sql = 'SELECT aktivan FROM korisnik WHERE id = %s'
            kursor.execute(sql, (session['ulogovani_korisnik'],))
            res = kursor.fetchone()
            if not res['aktivan']:
                flash('Morate platiti članarinu')
            return res['aktivan']
        elif tip == 'korisnik': return 1
        else:
            if ulogovan('admin'): return 3
            elif ulogovan('placen'): return 2
            else: return 1
    else: return 0

def logged(tip = 1):
    def decorator(func):
        def inner():
            if (ulogovan(tip)):
                func()
            else:
                return render_template('korisnici_login.html')
        return inner
    return decorator

app = Flask(__name__)
app.secret_key = getenv('Cookie_secret')

@app.route('/')
def index():
    sql = '''SELECT vesti.*, DAYNAME(datum) AS dan, korisnik.ime, korisnik.prezime
             FROM vesti LEFT JOIN korisnik ON vesti.autor_id = korisnik.id 
          '''
    if ulogovan('admin'):
        sql += 'WHERE vesti.autor_id = %s'
        kursor.execute(sql, (session['ulogovani_korisnik'],))
        vesti = kursor.fetchall()
        return render_template('vesti.html', vesti = vesti, tip = 3)
    else:
        kursor.execute(sql)
        vesti = kursor.fetchall()
        if ulogovan('placen'):
            return render_template('vesti.html', vesti = vesti, tip = 2)
        return render_template('vesti.html', vesti = vesti)

@logged('admin')
@app.route('/admin_nova_vest', methods = ['GET', 'POST'])
def admin_nova_vest():
    if request.method == 'GET':
        return render_template('admin_vest_nova.html', tip = 3)

    pod = request.form
    val = (pod['naslov'], pod['tekst'], session['ulogovani_korisnik'])
    name = request.files['slika'].filename
    if name != '':
        with open(join('static', 'slike', name), 'wb') as file:
            upload = request.files['slika']
            upload.save(file)
        
        val += (name,)
    else:
        val += ('',)

    kursor.callproc('nova_vest', val)
    konekcija.commit()

    return redirect(url_for('index'))

@logged('admin')
@app.route('/admin_vest_brisanje/<id>')
def admin_vest_brisanje(id):
    kursor.callproc('izbrisi_vest', (id,))
    konekcija.commit()

    return redirect(url_for('index'))

@logged('admin')
@app.route('/admin_vest_izmena/<id>', methods = ['GET', 'POST'])
def admin_vest_izmena(id):
    if request.method == 'GET':
        sql = 'SELECT * FROM vesti WHERE id = %s'
        kursor.execute(sql, (id,))
        vest = kursor.fetchone()

        return render_template('admin_vest_izmena.html', vest = vest, tip = 3)
    else:
        forma = request.form
        pod = (id, forma['naslov'], forma['tekst'])
        name = request.files['slika'].filename
        if name != '':
            with open(join('static', 'slike', name), 'wb') as file:
                upload = request.files['slika']
                upload.save(file)

            pod += (name,)
        else:
            pod += ('',)

        kursor.callproc('vest_izmena', pod)
        konekcija.commit()

        return redirect(url_for('index'))

@logged('admin')
@app.route('/admin_korisnici/<mode>', methods = ['GET', 'POST'])
def admin_korisnici(mode):
    sql = 'SELECT id, ime, prezime, email, kontakt, clan_od'
    if int(mode):
        sql += ' FROM neaktivni_korisnici '
    else:
        sql += ', aktivan FROM korisnik '

    if request.method == 'GET':
        kursor.execute(sql)
    else:
        sql += 'WHERE email LIKE %s OR ime LIKE %s'
        forma = request.form
        val = ('%' + forma['search'] + '%', '%' + forma['search'] + '%')
        kursor.execute(sql, val)

    korisnici = kursor.fetchall()

    return render_template('admin_korisnici.html', korisnici = korisnici, tip = 3)

@logged('admin')
@app.route('/admin_obrisi_korisnika/<id>')
def admin_obrisi_korisnika(id):
    kursor.callproc('izbrisi_korisnika', (id,))
    konekcija.commit()

    return redirect(url_for('index'))

@logged('admin')
@app.route('/admin_jedan_korisnik/<id>')
def admin_jedan_korisnik(id):
    sql = 'SELECT id, ime, prezime, email, kontakt, aktivan FROM korisnik WHERE id = %s'
    kursor.execute(sql, (id,))
    korisnik = kursor.fetchone()

    sql = 'SELECT naziv_fajla, datum, kolicina FROM uplatnica WHERE korisnik_id = %s'
    kursor.execute(sql, (id,))
    uplate = kursor.fetchall()

    sql = '''SELECT izdavanje.id AS i_id, knjiga.id, autor, naslov, isbn, rezerv_rok, vracanje_rok, kasni, vracena
             FROM izdavanje LEFT JOIN knjiga ON knjiga.id = izdavanje.knjiga_id
             WHERE korisnik_id = %s
             ORDER BY vracena
          '''
    kursor.execute(sql, (id,))
    knjige = kursor.fetchall()
    #kursor.callproc('jedan_korisnik', (id,))

    return render_template('admin_korisnik_jedan.html', korisnik = korisnik, knjige = knjige, uplate = uplate, tip = 3)

@logged('admin')
@app.route('/admin_vrati_knjigu/<id>/<korisnik>')
def admin_vrati_knjigu(id, korisnik):
    kursor.callproc('vrati_knjigu', (id,))
    konekcija.commit()

    if int(korisnik):
        return redirect(url_for('admin_jedan_korisnik', id = korisnik))
    return redirect(url_for('admin_knjige'))

@logged('admin')
@app.route('/admin_knjige', methods = ['GET', 'POST'])
def admin_knjige():
    sql = '''SELECT ime, email, knjiga_id AS id, autor, naslov, izdavanje_id, rezerv_rok, vracanje_rok, kasni
             FROM nevracene_knjige 
          '''
    if request.method == 'GET':
        kursor.execute(sql)
    else:
        forma = request.form
        sql += 'WHERE naslov LIKE %s OR email LIKE %s'
        val = ('%' + forma['search'] + '%', '%' + forma['search'] + '%')
        kursor.execute(sql, val)

    izdavanja = kursor.fetchall()
    return render_template('admin_knjige.html', izdavanja = izdavanja, tip = 3)

@logged('admin')
@app.route('/admin_nova_knjiga', methods = ['GET', 'POST'])
def admin_nova_knjiga():
    if request.method == 'GET':
        return render_template('admin_nova_knjiga.html', tip = 3)

    podaci = request.form
    vrednosti = (podaci['naslov'], podaci['autor'], podaci['br_dostupnih'], podaci['isbn'], podaci['izdavac'], podaci['opis'])

    name = request.files['slika'].filename
    if name != '':
        with open(join('static', 'slike', name), 'wb') as file:
            upload = request.files['slika']
            upload.save(file)
        vrednosti += (name,)
    else:
        vrednosti += ('',)

    kursor.callproc('nova_knjiga', vrednosti)
    konekcija.commit()

    return redirect(url_for('dostupne_knjige'))

@logged('admin')
@app.route('/admin_knjiga_brisanje/<id>')
def admin_knjiga_brisanje(id):
    kursor.callproc('izbrisi_knjigu', (id,))
    konekcija.commit()

    return redirect(url_for('dostupne_knjige'))

@logged('admin')
@app.route('/admin_knjiga_izmena/<id>', methods = ['GET', 'POST'])
def admin_knjiga_izmena(id):
    if request.method == 'GET':
        sql = '''SELECT id, autor, naslov, isbn, broj_dostupnih, izdavac, opis
                 FROM knjiga
                 WHERE id = %s
              '''
        kursor.execute(sql, (id,))
        knjiga = kursor.fetchone()

        return render_template('admin_knjiga_izmena.html', knjiga = knjiga, tip = 3)
    else:
        forma = request.form
        pod = (id, forma['autor'], forma['naslov'], forma['isbn'], forma['br_dostupnih'], forma['izdavac'], forma['opis'])
        name = request.files['slika'].filename
        if name != '':
            with open(join('static', 'slike', name), 'wb') as file:
                upload = request.files['slika']
                upload.save(file)

            pod += (name,)
        else:
            pod += ('',)

        kursor.callproc('knjiga_izmena', pod)
        konekcija.commit()

        return redirect(url_for('dostupne_knjige'))

@logged('admin')
@app.route('/admin_uplata', methods = ['GET', 'POST'])
def admin_uplata():
    if request.method == 'GET':
        sql = '''SELECT ime, email, uplatnica.id, naziv_fajla
                 FROM uplatnica LEFT JOIN korisnik
                 ON korisnik.id = uplatnica.korisnik_id
                 WHERE kolicina = 0
              '''
        kursor.execute(sql)
        uplate = kursor.fetchall()
        #kursor.callproc('admin_uplata')

        return render_template('admin_uplata.html', uplate = uplate, tip = 3)
    else:
        forma = request.form
        val = (forma['kolicina'], forma['id'])
        kursor.callproc('update_uplatnica', val)
        konekcija.commit()

        return redirect(url_for('admin_uplata'))

@logged('admin')
@app.route('/admin_uplata_brisanje/<id>')
def admin_uplata_brisanje(id):
    kursor.callproc('izbrisi_uplatu', (id,))
    konekcija.commit()

    return redirect(url_for('admin_uplata'))

@logged('placen')
@app.route('/rezervacija/<id>', methods = ['GET', 'POST'])
def rezervacija(id):
    if request.method == 'GET':
        sql = 'SELECT autor, naslov, isbn, broj_dostupnih, id FROM knjiga WHERE id = %s'
        kursor.execute(sql, (id,))
        knjiga = kursor.fetchone()

        return render_template('admin_rezervacija.html', knjiga = knjiga, tip = ulogovan())
    else:
        forma = request.form
        if int(forma['mode']):
            sql = 'SELECT id FROM korisnik WHERE email = %s'
            kursor.execute(sql, (forma['korisnik'],))
            id_kor = kursor.fetchone()
            if not id_kor:
                flash('Nepostojeći korisnik')
                return redirect(url_for('admin_rezervacija', id = id))
            id_kor = id_kor['id']
        else:
            id_kor = session['ulogovani_korisnik']

        kursor.callproc('izdavanje', (id_kor, id))
        konekcija.commit()

        return redirect(url_for('dostupne_knjige'))

@logged()
@app.route('/korisnik_ulogovan')
def korisnik_ulogovan():
    sql_knjige = '''SELECT knjiga_id AS id, autor, naslov, isbn, vracanje_rok
                    FROM nevracene_knjige
                    WHERE korisnik_id = %s
                 '''
    kursor.execute(sql_knjige, (session['ulogovani_korisnik'],))
    knjige = kursor.fetchall()
    #kursor.callproc('korisnik_knjige', (session['ulogovani_korisnik'],))
    
    return render_template('korisnik_ulogovan.html', knjige = knjige, tip = 2)

@logged()
@app.route('/dostupne_knjige', methods = ['GET', 'POST'])
def dostupne_knjige():
    sql = 'SELECT id, autor, naslov, isbn, broj_dostupnih FROM knjiga '
    if request.method == 'GET':
        kursor.execute(sql)
    else:
        forma = request.form
        sql += 'WHERE naslov LIKE %s OR autor LIKE %s'
        val = ('%' + forma['search'] + '%', '%' + forma['search'] + '%')
        kursor.execute(sql, val)
    knjige = kursor.fetchall()

    return render_template('dostupne_knjige.html', knjige = knjige, tip = ulogovan())

@logged()
@app.route('/jedna_knjiga/<id>', methods = ['GET', 'POST'])
def jedna_knjiga(id):
    if request.method == 'GET':
        sql = 'SELECT * FROM knjiga WHERE id = %s'
        kursor.execute(sql, (id,))
        knjiga = kursor.fetchone()

        sql = '''SELECT ime, ocena, tekst
                 FROM ocena INNER JOIN korisnik ON ocena.korisnik_id=korisnik.id
                 WHERE knjiga_id = %s
              '''
        kursor.execute(sql, (id,))
        ocene = kursor.fetchall()

        sql = 'SELECT COUNT(*) as izdata FROM izdavanje WHERE knjiga_id = %s AND korisnik_id = %s'
        val = (id, session['ulogovani_korisnik'])
        kursor.execute(sql, val)
        izdata = kursor.fetchone()

        sql = 'SELECT ocena, tekst FROM ocena WHERE knjiga_id = %s AND korisnik_id = %s'
        kursor.execute(sql, val)
        ocena = kursor.fetchone()

        return render_template('jedna_knjiga.html', knjiga = knjiga, ocene = ocene, izdata = izdata, ocena = ocena, tip = ulogovan())
    else:
        forma = request.form
        val = (id, session['ulogovani_korisnik'])

        if int(forma['mode']):
            kursor.callproc('izbrisi_ocenu', val)
            konekcija.commit()
        
        val += (forma['ocena'], forma['tekst'])
        kursor.callproc('dodaj_ocenu', val)
        konekcija.commit()

        return redirect(url_for('jedna_knjiga', id = id))

@logged()
@app.route('/uplata', methods = ['GET', 'POST'])
def uplata():
        if request.method == 'GET':
            return render_template('uplata.html', tip = 1)

        name = request.files['file'].filename
        if name != '':
            naziv, ext = splitext(name)
            naziv_fajla = naziv + '-' + str(randint(0, 99999)) + ext

            with open(join('static', 'uplatnice', naziv_fajla), 'wb') as file:
                upload = request.files['file']
                upload.save(file)
                val = (session['ulogovani_korisnik'], naziv_fajla)
                kursor.callproc('uplata', val)

            konekcija.commit()
            flash('Uplatnica poslata')

        return render_template('uplata.html', tip = 1)

@app.route('/logout')
def logout():
    session.pop('ulogovani_korisnik', None)
    return redirect(url_for('korisnici_login'))

@app.route('/korisnici_login', methods = ['GET', 'POST'])
def korisnici_login():
    if ulogovan('korisnik'):
        return redirect(url_for('logout'))
    if request.method == 'GET':
        return render_template('korisnici_login.html')

    forma = request.form
    upit = 'SELECT id, lozinka, bibliotekar FROM korisnik WHERE email = %s'
    kursor.execute(upit, (forma['email'],))
    korisnik = kursor.fetchone()
    if not korisnik:
        flash('E-mail je pogrešan')
        return render_template('korisnici_login.html')
    if check_password_hash(korisnik['lozinka'], forma['lozinka']):
        session['ulogovani_korisnik'] = korisnik['id']
        if korisnik['bibliotekar']:
            return redirect(url_for('index'))
        return redirect(url_for('korisnik_ulogovan'))
    else:
        flash('Šifra je pogrešna')
        return render_template('korisnici_login.html')

@app.route('/registracija', methods = ['GET', 'POST'])
def registracija():
    if request.method == 'GET':
        return render_template('registracija.html')

    podaci = request.form
    hes = generate_password_hash(podaci['lozinka'])
    vrednosti = (podaci['ime'], podaci['prezime'], podaci['email'], podaci['kontakt'], hes)
    kursor.callproc('registracija', vrednosti)
    konekcija.commit()

    return redirect(url_for('korisnici_login'))

app.run(debug = True)
