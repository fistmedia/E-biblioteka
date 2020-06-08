from flask import Flask, render_template, url_for, request, redirect, session, flash
#import mysql.connector
#from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)

@app.route('/')
def index():
	return render_template('vesti.html')
@app.route('/korisnici')
def korisnici():
	return render_template('korisnici.html')




app.run(debug=True)