'''
Archivo inicial del servidor
'''

import re
from flask import Flask, render_template, request, redirect, url_for, flash
from flask_mysqldb import MySQL

app = Flask(__name__)
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_DB'] = ''
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '1234'
mysql = MySQL(app)

# settings
app.secret_key = "mysecretkey"

def obtain_tables(data):
    '''
    Función que extrae las tablas y permisos a partir de
    la consulta 'show grants for current_USER();'
    :param data: resultados de la consulta
    :return: lista donde el primer elemento de cada
    fila es la tabla, y el segundo los permisos sobre esta
    :rtype: list
    '''
    tables = []
    for i in range(1,len(data)-1):
        list_permits = []
        if "ALL PRIVILEGES" in data[i][0]:
            list_permits = ['SELECT', 'UPDATE', 'INSERT', 'DELETE']
        if "SELECT" in data[i][0]:
            list_permits.append('SELECT')
        if "UPDATE" in data[i][0]:
            list_permits.append('UPDATE')
        if "INSERT" in data[i][0]:
            list_permits.append('INSERT')
        if "DELETE" in data[i][0]:
            list_permits.append('DELETE')
        words = re.split(r'(\W+)',data[i][0])
        index = words.index('salvandovidas')
        tables.append((words[index+2],list_permits))
    return tables

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
            cur.close()
        except :
            flash("Usuario o contraseña incorrectos")
            return redirect(url_for("Homepage"))
    return redirect("/user/"+ perfil)

@app.route('/user/<perfil>')
def user_perfil(perfil):
    if perfil == "Administrador":
        cur = mysql.connection.cursor()
        cur.execute('SET ROLE ALL;')
        cur.execute('show tables from salvandovidas;')
        data = cur.fetchall()
        list_data = list(data)
        for i in range(0,len(list_data)):
            list_data[i] = list(list_data[i])
            list_data[i].append(['SELECT', 'UPDATE', 'INSERT', 'DELETE'])
            list_data[i] = tuple(list_data[i])
    else:
        if perfil == "Invitado":
            app.config['MYSQL_USER'] = "Anonimo"
            app.config['MYSQL_PASSWORD'] = "12345"

        cur = mysql.connection.cursor()
        cur.execute('SET ROLE ALL;')
        cur.execute('show grants for current_USER();')
        data = cur.fetchall()
        list_data = obtain_tables(data)

    return render_template('listtables.html', perfil = perfil, tables = list_data)

@app.route('/list_form/<perfil>', methods=['POST'])
def list_form(perfil):
    if request.method == 'POST':
        table = request.form['option']
        if "Elija" in table :
            return redirect("/user/" + perfil)
        words = re.split(r'\W+',table)
        while '' in words:
            words.remove('')
        if len(words) == 2:
            return redirect("/table/" + words [0] + "/" + words [1])
        if len(words) == 2:
            return redirect("/table/" + words [0] + "/" + words [1] + "/" + words [2])

    return redirect("/table/" + words [0] +"/"+ words [1] +"/"+ words [2] +"/"+ words [3] +"/"+ words [4])

@app.route('/table/<table>')
@app.route('/table/<table>/<permit1>')
@app.route('/table/<table>/<permit1>/<permit2>')
@app.route('/table/<table>/<permit1>/<permit2>/<permit3>')
@app.route('/table/<table>/<permit1>/<permit2>/<permit3>/<permit4>')
def table(table, permit1 = None, permit2 = None, permit3 = None, permit4 = None):
    print(table,permit1,permit2,permit3,permit4)
    return render_template('table.html')

if __name__ == '__main__':
    app.run(port = 3000, debug = True)
