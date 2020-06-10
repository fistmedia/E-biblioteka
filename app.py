from flask import Flask, render_template, url_for, request, redirect, session, flash
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash

konekcija = mysql.connector.connect(
	host="localhost",
	user="root",
	database="biblioteka"
)
kursor = konekcija.cursor(dictionary=True)

def ulogovan():
	if 'ulogovani_korisnik' in session:
		return True
	else: return False
def ulogovan_admin():
	if 'ulogovani_admin' in session:
		return True
	else: return False

app = Flask(__name__)
app.secret_key = '7wHtt8QURb'

k_id=0

@app.route('/')
def index():
	sql = "SELECT * FROM vesti"
	kursor.execute(sql)
	vesti = kursor.fetchall()
	if ulogovan():
		return render_template('vesti_ulogovan.html', vesti=vesti)
	else:
		 return render_template('vesti.html', vesti=vesti)

@app.route('/logout')
def logout():
	session.pop('ulogovani_korisnik', None)
	return redirect(url_for('korisnici_login'))

@app.route('/logout_admin')
def logout_admin():
	session.pop('ulogovani_admin', None)
	return redirect(url_for('korisnici_login'))

@app.route('/korisnici_login', methods=['GET', 'POST'])
def korisnici_login():
	if request.method == 'GET':
		return render_template('korisnici_login.html')
	elif request.method == 'POST':
		forma = request.form
		upit = "SELECT * FROM korisnik WHERE email=%s"
		podaci = (forma["email"],)
		kursor.execute(upit, podaci)
		korisnik = kursor.fetchone()
		if korisnik == None:
			flash('E-mail je pogrešan')
			return render_template('korisnici_login.html')
		if check_password_hash(korisnik["lozinka"], forma["lozinka"]):
			if korisnik["bibliotekar"]==0:
				session['ulogovani_korisnik'] = str(korisnik)
				return redirect(url_for('korisnik_ulogovan'))
			if korisnik["bibliotekar"]==1:
				session['ulogovani_admin']=str(korisnik)
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
	if ulogovan_admin():
		sql = "SELECT * FROM vesti"
		kursor.execute(sql)
		vesti = kursor.fetchall()
		return render_template('admin_ulogovan.html', vesti=vesti)
	else:
		return render_template('korisnici_login.html')

@app.route('/admin_korisnici')
def admin_korisnici():
	if ulogovan_admin:
		sql = "SELECT * FROM korisnici"
		kursor.execute(sql)
		korisnici = kursor.fetchall()
		return render_template('admin_korisnici.html', korisnici=korisnici)
	else:
		 return render_template('korisnici_login.html')

@app.route('/registracija', methods=['GET', 'POST'])
def registracija():
	if request.method=="GET":
		return render_template('registracija.html')
	elif request.method == 'POST':
		podaci = request.form
		sql = """ INSERT INTO 
				korisnik (ime, prezime, email, kontakt, lozinka) 
				VALUES (%s,%s,%s,%s,%s)
				"""
		hes = generate_password_hash(podaci['lozinka'])
		vrednosti = (podaci['ime'],podaci['prezime'],podaci['email'],podaci['kontakt'],hes)
		kursor.execute(sql, vrednosti)
		konekcija.commit()
		return redirect(url_for('korisnici_login'))

@app.route('/dostupne_knjige')
def dostupne_knjige():
	if ulogovan():
		sql = "SELECT * FROM knjiga"
		kursor.execute(sql)
		knjige = kursor.fetchall()
		return render_template('dostupne_knjige.html', knjige=knjige)
	else:
		return redirect(url_for('korisnici_login'))

app.run(debug=True)