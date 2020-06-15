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
            if ulogovan('admin'): return 2
            elif ulogovan('placen'): return 1
            else: return 0
    else: return 0

app = Flask(__name__)
app.secret_key = getenv('Cookie_secret')

@app.route('/')
def index():
    sql = '''SELECT vesti.*, DAYNAME(datum) AS dan, korisnik.ime, korisnik.prezime 
             FROM vesti LEFT JOIN korisnik 
             ON vesti.autor_id = korisnik.id 
          '''
    if ulogovan('admin'):
        sql += 'WHERE vesti.autor_id = %s'
        autor_id = (session['ulogovani_korisnik'],)
        kursor.execute(sql, autor_id)
        vesti = kursor.fetchall()
        print(vesti)
        return render_template('vesti.html', vesti = vesti, tip = 2)
    else:
        kursor.execute(sql)
        vesti = kursor.fetchall()
        if ulogovan('placen'):
            return render_template('vesti.html', vesti = vesti, tip = 1)
        return render_template('vesti.html', vesti = vesti)

@app.route('/logout')
def logout():
    session.pop('ulogovani_korisnik', None)
    return redirect(url_for('korisnici_login'))

@app.route('/korisnici_login', methods = ['GET', 'POST'])
def korisnici_login():
    if request.method == 'GET':
        return render_template('korisnici_login.html')

    forma = request.form
    upit = 'SELECT * FROM korisnik WHERE email = %s'
    podaci = (forma['email'],)
    kursor.execute(upit, podaci)
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

@app.route('/korisnik_ulogovan')
def korisnik_ulogovan():
    if ulogovan('placen'):
        sql_knjige = '''SELECT autor, naslov, isbn, vracanje_rok
                        FROM izdavanje LEFT JOIN knjiga
                        ON knjiga.id = izdavanje.knjiga_id
                        WHERE korisnik_id = %s AND vracena = 0
                     '''
        kor_id = (session['ulogovani_korisnik'],)
        kursor.execute(sql_knjige, kor_id)
        knjige = kursor.fetchall()
        #kursor.callproc('korisnik_knjige', kor_id)
        
        return render_template('korisnik_ulogovan.html', knjige = knjige, tip = 1)
    else:
        if ulogovan('korisnik'):
            return render_template('uplata.html')
        return render_template('korisnici_login.html')

@app.route('/admin_nova_vest', methods = ['GET', 'POST'])
def admin_nova_vest():
    if ulogovan('admin'):
        if request.method == 'GET':
            return render_template('admin_vest_nova.html', tip = 2)

        name = request.files['slika'].filename
        naziv, ext = splitext(name)
        naziv_fajla = naziv + '-' + str(randint(0, 999999)) + ext
        with open(join('static', 'slike', naziv_fajla), 'wb') as file:
            upload = request.files['slika']
            upload.save(file)
        pod = request.form
        sql = '''INSERT INTO 
                 vesti (naslov, tekst, slika, autor_id) 
                 VALUES (%s,%s,%s, %s)
              '''
        val = (pod['naslov'], pod['tekst'], naziv_fajla, session['ulogovani_korisnik'])
        kursor.execute(sql, val)
        konekcija.commit()
        return redirect(url_for('index'))
    else:
        return redirect(url_for('korisnici_login'))

@app.route('/admin_vest_brisanje/<id>')
def admin_vest_brisanje(id):
    if ulogovan('admin'):
        sql = 'DELETE FROM vesti WHERE id = %s'
        kursor.execute(sql, (id,))
        konekcija.commit()
        return redirect(url_for('index'))
    else:
        return redirect('korisnici_login')

@app.route('/admin_vest_izmena/<id>', methods = ['GET', 'POST'])
def admin_vest_izmena(id):
    if ulogovan('admin'):
        if request.method == 'GET':
            sql = 'SELECT * FROM vesti WHERE id = %s'
            kursor.execute(sql, (id,))
            vest = kursor.fetchone()
            return render_template('admin_vest_izmena.html', vest = vest, tip = 2)
        else:
            sql = 'UPDATE vesti SET naslov = %s, tekst = %s WHERE id = %s'
            forma = request.form
            pod = (forma['naslov'], forma['tekst'], id)
            kursor.execute(sql, pod)
            konekcija.commit()
            return redirect(url_for('index'))
    else:
        return redirect(url_for('korisnici_login'))

@app.route('/admin_korisnici', methods = ['GET', 'POST'])
def admin_korisnici():
    if ulogovan('admin'):
        if request.method == 'GET':
            sql = 'SELECT * FROM korisnik'
            kursor.execute(sql)
            korisnici = kursor.fetchall()
            return render_template('admin_korisnici.html', korisnici = korisnici, tip = 2)
        else:
            sql = 'SELECT * FROM korisnik WHERE email LIKE %s'
            kursor.execute(sql, (request.form['search'],))
            korisnik = kursor.fetchall()
            return render_template('admin_korisnici.html', korisnici = korisnik, tip = 2)
    else:
        return redirect(url_for('korisnici_login'))

@app.route('/rezervacija/<id>', methods = ['GET', 'POST'])
def rezervacija(id):
    if ulogovan('admin'):
        if request.method == 'GET':
            sql_knj = 'SELECT * FROM knjiga WHERE id = %s'
            kursor.execute(sql_knj, (id,))
            knjiga = kursor.fetchone()
            return render_template('rezervacija.html', knjiga = knjiga, tip = 2)
        else:
            sql_kor = 'SELECT id FROM korisnik WHERE email = %s'
            kursor.execute(sql_kor, (request.form['korisnik'],))
            id_kor = kursor.fetchone()
            id_kor = id_kor['id']
            sql = '''INSERT INTO 
                     izdavanje (korisnik_id, knjiga_id) 
                     VALUES (%s,%s) 
                  '''
            kursor.execute(sql, (id_kor, id))
            konekcija.commit()
            return redirect(url_for('dostupne_knjige'))
    else: 
        return redirect(url_for('korisnici_login'))

@app.route('/jedan_korisnik/<id>')
def jedan_korisnik(id):
    if ulogovan('admin'):
        sql = 'SELECT id, ime, prezime, email, kontakt, aktivan FROM korisnik WHERE id = %s'
        kursor.execute(sql, (id,))
        korisnik = kursor.fetchone()
        sql = 'SELECT naziv_fajla, datum, kolicina FROM uplatnica WHERE korisnik_id = %s'
        kursor.execute(sql, (id,))
        uplate = kursor.fetchall()
        sql = '''SELECT izdavanje.id, autor, naslov, isbn, vracanje_rok, vracena
                 FROM izdavanje LEFT JOIN knjiga
                 ON knjiga.id = izdavanje.knjiga_id
                 WHERE korisnik_id = %s
                 ORDER BY vracena
              '''
        kursor.execute(sql, (id,))
        knjige = kursor.fetchall()
        #kursor.callproc('jedan_korisnik', (id,))

        return render_template('admin_korisnik_jedan.html', korisnik = korisnik, knjige = knjige, uplate = uplate, tip = 2)
    else:
         return redirect (url_for('korisnici_login'))

@app.route('/vrati_knjigu/<id>')
def vrati_knjigu(id):
    if ulogovan('admin'):
        sql = 'UPDATE izdavanje SET vracena = 1 WHERE id = %s'
        kursor.execute(sql, (id,))
        konekcija.commit()
        return redirect(url_for('jedan_korisnik', id = id))
    else:
        return redirect(url_for('korisnici_login'))

@app.route('/registracija', methods = ['GET', 'POST'])
def registracija():
    if request.method == 'GET':
        return render_template('registracija.html')

    podaci = request.form
    sql = '''INSERT INTO 
             korisnik (ime, prezime, email, kontakt, lozinka) 
             VALUES (%s,%s,%s,%s,%s)
          '''
    hes = generate_password_hash(podaci['lozinka'])
    vrednosti = (podaci['ime'], podaci['prezime'], podaci['email'], podaci['kontakt'], hes)
    kursor.execute(sql, vrednosti)
    konekcija.commit()
    return redirect(url_for('korisnici_login'))

@app.route('/dostupne_knjige', methods = ['GET', 'POST'])
def dostupne_knjige():
    if ulogovan('placen'):
        if request.method == 'GET':
            sql = 'SELECT * FROM knjiga'
            kursor.execute(sql)
        else:
            forma = request.form
            sql = 'SELECT * FROM knjiga WHERE naslov LIKE %s OR autor LIKE %s'
            val = ('%' + forma['search'] + '%', '%' + forma['search'] + '%')
            kursor.execute(sql, val)
        knjige = kursor.fetchall()
        return render_template('dostupne_knjige.html', knjige = knjige, admin = ulogovan('admin'), tip = ulogovan())
    else:
        return redirect(url_for('korisnici_login'))

@app.route('/nova_knjiga', methods = ['GET', 'POST'])
def nova_knjiga():
    if ulogovan('admin'):
        if request.method == 'GET':
            return render_template('nova_knjiga.html', tip = 2)
        
        podaci = request.form
        sql = '''INSERT INTO 
                 knjiga (naslov, autor, broj_dostupnih, isbn) 
                 VALUES (%s,%s,%s,%s)
              '''
        vrednosti = (podaci['naziv'], podaci['autor'], podaci['br_dostupnih'], podaci['isbn'])
        kursor.execute(sql, vrednosti)
        konekcija.commit()
        return redirect(url_for('dostupne_knjige'))
    else:
        return redirect(url_for('korisnici_login'))

@app.route('/uplata', methods = ['GET', 'POST'])
def uplata():
    if ulogovan('korisnik'):
        if request.method == 'GET':
            return render_template('uplata.html')

        if request.files:
            name = request.files['file'].filename
            naziv, ext = splitext(name)
            naziv_fajla = naziv + '-' + str(randint(0, 999999)) + ext
            with open(join('static', 'uplatnice', naziv_fajla), 'wb') as file:
                upload = request.files['file']
                upload.save(file)
                sql = 'INSERT INTO uplatnica (korisnik_id, naziv_fajla) VALUES (%s, %s)'
                val = (session['ulogovani_korisnik'], naziv_fajla)
                kursor.execute(sql, val)

            konekcija.commit()
            flash('Uplatnica poslata')

        return render_template('uplata.html')
    else:
        return redirect(url_for('korisnici_login'))

@app.route('/admin_uplata', methods = ['GET', 'POST'])
def admin_uplata():
    if ulogovan('admin'):
        if request.method == 'GET':
            sql = '''SELECT ime, email, uplatnica.id, naziv_fajla 
                     FROM uplatnica LEFT JOIN korisnik
                     ON korisnik.id = uplatnica.korisnik_id 
                     WHERE kolicina IS NULL
                  '''
            kursor.execute(sql)
            uplate = kursor.fetchall()
            #kursor.callproc('admin_uplata')

            return render_template('admin_uplata.html', uplate = uplate, tip = 2)
        else:
            forma = request.form
            sql = 'UPDATE uplatnica SET kolicina = %s WHERE id = %s'
            val = (forma['kolicina'], forma['id'])
            kursor.execute(sql, val)
            konekcija.commit()

            return redirect(url_for('admin_uplata'))
    else:
        return render_template('korisnici_login.html')

app.run(debug = True)
