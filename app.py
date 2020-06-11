#!/usr/bin/python
from os import getenv
from os.path import join, dirname
from dotenv import load_dotenv
from flask import Flask, render_template, url_for, request, redirect, session, flash
from mysql.connector import connect
from werkzeug.security import generate_password_hash, check_password_hash
#from werkzeug.utils import secure_filename

# Create the .env file's path and load it
load_dotenv(join(dirname(__file__), '.env'))

konekcija = connect(
    host = getenv('DB_Host'),
    user = getenv('DB_User'),
    passwd = getenv('DB_Pass'),
    database = getenv('DB_Db')
)

kursor = konekcija.cursor(dictionary = True)

def ulogovan(tip = 'korisnik'):
    if 'ulogovani_korisnik' in session:
        if tip == 'admin':
            kursor.execute('SELECT bibliotekar FROM korisnik WHERE id=%s', (session['ulogovani_korisnik'],))
            res = kursor.fetchone()
            return res['bibliotekar']
        else:
            kursor.execute('SELECT aktivan FROM korisnik WHERE id=%s', (session['ulogovani_korisnik'],))
            res = kursor.fetchone()
            return res['aktivan']
    else: return False

app = Flask(__name__)
app.secret_key = getenv('Cookie_secret')

@app.route('/')
def index():
    sql = '''SELECT vesti.*, korisnik.ime, korisnik.prezime 
                 FROM vesti 
                 LEFT JOIN korisnik 
                 ON vesti.autor_id = korisnik.id
                '''
    kursor.execute(sql)
    vesti = kursor.fetchall()
    if ulogovan():
        return render_template('vesti_ulogovan.html', vesti = vesti)
    else:
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
    upit = 'SELECT * FROM korisnik WHERE email=%s'
    podaci = (forma["email"],)
    kursor.execute(upit, podaci)
    korisnik = kursor.fetchone()
    if korisnik == None:
        flash('E-mail je pogrešan')
        return render_template('korisnici_login.html')
    if check_password_hash(korisnik['lozinka'], forma['lozinka']):
        session['ulogovani_korisnik'] = korisnik['id']
        if korisnik['bibliotekar'] == 0:
            return redirect(url_for('korisnik_ulogovan'))
        if korisnik['bibliotekar'] == 1:
            return redirect(url_for('admin_ulogovan'))
    else:
        flash('Šifra je pogrešna')
        return render_template('korisnici_login.html')

@app.route('/korisnik_ulogovan')
def korisnik_ulogovan():
    if ulogovan():
        return render_template('korisnik_ulogovan.html')
    else:
        return render_template('korisnici_login.html')    

@app.route('/admin_ulogovan')
def admin_ulogovan():
    if ulogovan('admin'):
        sql = '''SELECT vesti.*, korisnik.ime, korisnik.prezime 
                 FROM vesti 
                 LEFT JOIN korisnik 
                 ON vesti.autor_id = korisnik.id 
                 WHERE vesti.autor_id = %s
                 '''
        autor_id=(session['ulogovani_korisnik'],)
        kursor.execute(sql, autor_id)
        vesti = kursor.fetchall()
        return render_template('admin_ulogovan.html', vesti = vesti)
    else:
        return render_template('korisnici_login.html')

@app.route('/admin_nova_vest', methods=['GET', 'POST'])
def admin_nova_vest():
    if ulogovan('admin'):
        if request.method=='GET':
            return render_template('admin_vest_nova.html')
        if request.method=='POST':
            pod=request.form
            sql= '''INSERT INTO 
                    vesti (naslov, tekst, autor_id) 
                    VALUES (%s,%s,%s)
                    '''
            val= (pod['naslov'], pod['tekst'], session['ulogovani_korisnik'])
            kursor.execute(sql,val)
            konekcija.commit()
            return redirect(url_for('admin_ulogovan'))
    else:
        return redirect(url_for('korisnici_login'))

@app.route('/admin_vest_brisanje/<id>')
def admin_vest_brisanje(id):
    if ulogovan('admin'):
        sql = "DELETE FROM vesti WHERE id=%s"
        val = (id,)
        kursor.execute(sql, val)
        konekcija.commit()
        return redirect(url_for('admin_ulogovan'))
    else:
        return redirect('korisnici_login')

@app.route('/admin_vest_izmena/<id>', methods=['GET', 'POST'])
def admin_vest_izmena(id):
    if ulogovan('admin'):
        if request.method== 'GET':
            sql = 'SELECT * FROM vesti WHERE id=%s'
            val = (id,)
            kursor.execute(sql, val)
            vest= kursor.fetchone()
            return render_template('admin_vest_izmena.html', vest=vest)
        elif request.method=='POST':
            sql = "UPDATE vesti SET naslov=%s, tekst=%s WHERE id=%s"
            forma=request.form
            pod=(forma['naslov'], forma['tekst'], id)
            kursor.execute(sql,pod)
            konekcija.commit()
            return redirect(url_for('admin_ulogovan'))
    else:
        return redirect(url_for('korisnici_login'))



@app.route('/admin_korisnici', methods=['GET', 'POST'])
def admin_korisnici():
    if ulogovan('admin'):
        if request.method=='GET':
            sql = 'SELECT * FROM korisnik'
            kursor.execute(sql)
            korisnici = kursor.fetchall()
            return render_template('admin_korisnici.html', korisnici = korisnici)
        if request.method=='POST':
            sql = "SELECT * FROM korisnik WHERE email LIKE '%" + request.form['search'] + "%'"
            kursor.execute(sql)
            korisnik = kursor.fetchall()
            print(request.form['search'])
            return render_template('admin_korisnici.html', korisnici=korisnik)
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
    if ulogovan():
        if request.method == 'GET':
            sql = 'SELECT * FROM knjiga'
        else:
            sql = "SELECT * FROM knjiga WHERE naslov LIKE '%" + request.form['search'] + "%'"
        kursor.execute(sql)
        knjige = kursor.fetchall()
        return render_template('dostupne_knjige.html', knjige = knjige, admin = ulogovan('admin'))

    else:
        return redirect(url_for('korisnici_login'))

@app.route('/nova_knjiga', methods = ['GET', 'POST'])
def nova_knjiga():
    if ulogovan():
        if request.method == 'GET':
            return render_template('nova_knjiga.html')
        
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

@app.route('/uplata',  methods = ['GET', 'POST'])
def uplata():
    if 'ulogovani_korisnik' in session:
        if request.method == 'GET':
            return render_template('uplata.html')

        if request.files:
            for name in request.files:
                with open(join('static', 'uplatnice', name), 'w+') as file:
                    upload = request.files[name]
                    upload.save(file)
                    kursor.execute('INSERT INTO uplatnica (korisnik_id, naziv_fajla) VALUES (%s, %s)', (session['ulogovani_korisnik'], name))

            konekcija.commit()
            flash('Uplatnica poslata')

        return render_template('uplata.html')
    else:
        return redirect(url_for('korisnici_login'))

@app.route('/admin_uplata',  methods = ['GET', 'POST'])
def admin_uplata():
    if ulogovan('admin'):
        if request.method == 'GET':
            kursor.execute('SELECT ime, email, korisnik_id FROM korisnik LEFT JOIN uplatnica ON korisnik.id=uplatnica.korisnik_id WHERE kolicina IS NULL)')
            korisnici = kursor.fetchall()
            return render_template('admin_uplata.html', korisnici = korisnici)
        else:
            forma = request.form
            kursor.execute('UPDATE uplatnica SET kolicina=%s WHERE korisnik_id=%s', (forma['kolicina'], forma['korisnik']))
            konekcija.commit()
    else:
        return render_template('korisnici_login.html')

app.run(debug = True)
