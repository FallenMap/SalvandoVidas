'''
Archivo inicial del servidor
'''

from flask import Flask, render_template, request, redirect, url_for
from flask_mysqldb import MySQL
import re

app = Flask(__name__)
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_DB'] = ''
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '1234'
mysql = MySQL(app)
    
@app.route('/')
def Homepage():
    return render_template('homepage.html')

@app.route('/login_form', methods =['POST'])
def login_form():
    if request.method == 'POST':
        user = request.form['user']
        password = request.form['password']
        app.config['MYSQL_USER'] = user
        app.config['MYSQL_PASSWORD'] = password
        try:
            cur = mysql.connection.cursor()
            cur.execute('SET ROLE ALL;')
            cur.execute('SELECT CURRENT_ROLE();')
            data = cur.fetchall()
            perfil = re.split(r'(\W+)',(str(data[0])))[2]
            print(perfil)
        except :
            print("Usuario denegado")
            return redirect(url_for("Homepage"))
    return redirect("/user/"+ perfil)

@app.route('/user/<perfil>')
def user_perfil(perfil):
    print("Bienvenido ", perfil)
    return redirect(url_for('Homepage'))

if __name__ == '__main__':
    app.run(port = 3000, debug = True)
