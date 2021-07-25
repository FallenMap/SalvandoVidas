'''
Archivo inicial del servidor
'''

import re, datetime
from flask import Flask, render_template, request, redirect, url_for, flash
from flask_mysqldb import MySQL
import os

app = Flask(__name__)
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_DB'] = ''
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '1234'
app.config['UPLOAD_FOLDER'] = './static/uploads'
mysql = MySQL(app)

# settings
app.secret_key = "mysecretkey"

def ForeignKeyExist(a, dato):
    c = 0
    for i in a:
        if str(i[0]) == dato:
            c += 1
    return c

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

def obtain_titles(titles):
    '''
    Función que obtiene los titulos a partir de la
    consulta 'show columns from "table"' y los guarda
    en una lista
    :param titles: tupla con el resultado de la consulta
    :return: lista con los titulos de las columnas
    :rtype: list
    '''
    list_titles = []
    for i in titles:
        list_titles.append(i[0])
    return list_titles

def obtain_content(content):
    '''
    Función que obtiene el contenido corregido a partir
    de una consulta de tipo select
    :param contenct: tupla con el resultado de la consulta
    :return: lista con los elementos corregidos
    :rtype: list
    '''
    list_content = list(content)
    for i in range(len(list_content)):
        list_content[i] = list(list_content[i])
        for k in range(len(list_content[i])):
            if isinstance(list_content[i][k], datetime.date):
                t = list_content[i][k]
                t.strftime('%d/%m/%Y')
                list_content[i][k] = str(t)
    return list_content

global consultas

consultas = {
        'vw_noadopt':{
            'Gatos':{
                "callproc":["proc_cons_denominacion_mas_enadopcion",["Gato"]]
                },
            'Perros':{
                "callproc":["proc_cons_denominacion_mas_enadopcion",["Perro"]]
                },
            'Peces':{
                "callproc":["proc_cons_denominacion_mas_enadopcion",["Pez"]]
                },
            'Hamsters':{
                "callproc":["proc_cons_denominacion_mas_enadopcion",["Hamster"]]
                },
            'Loros':{
                "callproc":["proc_cons_denominacion_mas_enadopcion",["Loro"]]
                },
            'Conejos':{
                "callproc":["proc_cons_denominacion_mas_enadopcion",["Conejo"]]
                },
            'Machos':{
                "callproc":["proc_cons_sexo_mas_enadopcion",["Macho"]]
                },
            'Hembras':{
                "callproc":["proc_cons_sexo_mas_enadopcion",["Hembra"]]
                }
            },
        'empleado':{
            'Vigilantes':{
                "callproc":["proc_cons_empleado",["Vigilancia"]]
                },
            'Psicólogos':{
                "callproc":["proc_cons_empleado",["Psicólogo"]]
                },
            'Publicistas':{
                "callproc":["proc_cons_empleado",["Publicista"]]
                },
            'Veterinarios':{
                "callproc":["proc_cons_empleado",["Veterinario"]]
                },
            'Contadores':{
                "callproc":["proc_cons_empleado",["Contador"]]
                },
            'Rescatistas':{
                "callproc":["proc_cons_empleado",["Rescatista"]]
                }
            },
        'candidato':{
            'Aptos':{
                "callproc":["proc_cons_aptitud_candidato",["Apto"]]
                },
            'No_aptos':{
                "callproc":["proc_cons_aptitud_candidato",["No Apto"]]
                },
            'No_evaluados':{
                "callproc":["proc_cons_aptitud_candidato",["No evaluado"]]
                }
            }
        }

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
        list_select_tables = ['economia', 'vw_aptitud', 'vw_horario', 'vw_noadopt']
        list_update_tables = ['vw_aptitud']
        for i in range(0,len(list_data)):
            list_data[i] = list(list_data[i])
            if list_data[i][0] in list_select_tables:
                list_permits_tmp = []
                list_permits_tmp.append('SELECT')
                if list_data[i][0] in list_update_tables:
                    list_permits_tmp.append('UPDATE')
                list_data[i].append(list_permits_tmp)
            else:
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
            return redirect("/table/" + perfil + "/" + words [0] + "/" + words [1])
        if len(words) == 3:
            return redirect("/table/" + perfil + "/" + words [0] + "/" + words [1] + "/" + words [2])

    return redirect("/table/" + perfil + "/" + words [0] +"/"+ words [1] +"/"+ words [2] +"/"+ words [3] +"/"+ words [4])

@app.route('/table/<perfil>/<table>')
@app.route('/table/<perfil>/<table>/<permit1>')
@app.route('/table/<perfil>/<table>/<permit1>/<permit2>')
@app.route('/table/<perfil>/<table>/<permit1>/<permit2>/<permit3>')
@app.route('/table/<perfil>/<table>/<permit1>/<permit2>/<permit3>/<permit4>')
def table(table, perfil, permit1 = None, permit2 = None, permit3 = None, permit4 = None):
    global table_global, permits_global, perfil_global
    perfil_global = perfil
    table_global = table
    permits = [permit1, permit2, permit3, permit4]
    permits_global = permits
    if table in consultas.keys():
        permits.append('FILTER')
        filter_data = consultas[table]
    else:
        filter_data = " "
    cur = mysql.connection.cursor()
    cur.execute('SET ROLE ALL')
    cur.execute('Use salvandovidas')
    cur.execute('show columns from {0}'.format(table))
    titles = obtain_titles(cur.fetchall())
    #print("titles:\n\n", titles)
    cur.execute('select * from {0}'.format(table))
    data = obtain_content(cur.fetchall())
    #print("contenido:\n\n", data)
    return render_template('table.html',perfil = perfil, permits = permits, table = table, titles = titles, content = data, filter_data=filter_data)

@app.route('/table_cons', methods=['POST'])
def table_cons():
    if request.method == 'POST':
        table = request.form['filter']
        global consultas, table_global, permits_global
        data= consultas[table_global][table]
        if 'callproc' in data.keys():
            cur = mysql.connection.cursor()
            cur.execute('SET ROLE ALL')
            cur.execute('Use salvandovidas')
            cur.callproc(data['callproc'][0],data['callproc'][1])
            titles =  [desc[0] for desc in cur.description]
            content = obtain_content(cur.fetchall())
    return render_template('table.html', table =table ,titles=titles, content = content, permits = permits_global, atras = " ", filter_off = True)

@app.route('/add/<op>/<tab>/<nomid>/<idup>')
def add(op,tab,nomid,idup):
    datos = []
    cur = mysql.connection.cursor()
    cur.execute('SET ROLE ALL')
    cur.execute('Use salvandovidas')
    if op == 'update':
        cur.execute(f'select * from {tab} where {nomid} = {idup}')
        datos =  cur.fetchall()
    global permits_global, perfil_global
    return render_template('add.html', perfil = perfil_global, permits = permits_global, op = op,tab=tab, datos = datos, nomid = nomid, idup=idup)

@app.route('/delete_fila/<id>/<perfil>/<permits>/<table>/<nombre_id>')
def delete_fila(id,perfil,permits,table,nombre_id):
    cur = mysql.connection.cursor()
    cur.execute('SET ROLE ALL')
    cur.execute('USE salvandovidas')

    cur.execute(f'DELETE FROM {table} WHERE {nombre_id} = {id}')

    cur.execute('show columns from {0}'.format(table))
    titles = obtain_titles(cur.fetchall())
    cur.execute('select * from {0}'.format(table))
    data = obtain_content(cur.fetchall())

    mysql.connection.commit()
    global permits_global
    return redirect(url_for('table', table=table, perfil = perfil, permit1 = permits_global[0], permit2=permits_global[1], permit3 =permits_global[2], permit4=permits_global[3]))
    #return render_template('table.html', perfil = perfil, permits = permits, table = table, titles = titles, content = data)

@app.route('/insert/<op>/<tab>/<nomid>/<idup>', methods=['POST'])
def insert(op, tab,nomid,idup):
    if request.method == 'POST':
        cur = mysql.connection.cursor()
        cur.execute('SET ROLE ALL')
        cur.execute('Use salvandovidas')
        datos = []
        try:
            #candidato
            if tab == 'Candidato':
                for i in range(7):
                    datos.append(request.form[str(i)])
                if datos[0] == '' or (not datos[0].isdigit()) or len(datos[0]) > 10:
                     ms = 'No ha insertado un documento valido'
                     raise
                elif datos[1] == '':
                    ms = 'No ha insertado un nombre'
                    raise
                elif datos[2] == '':
                    ms = 'No ha insertado un apellido'
                    raise
                elif datos[3] == '' or datos[3].isalpha()or datos[3].isdigit():
                    ms = 'No ha insertado una fecha de nacimiento valida'
                    raise
                elif datos[4] == '':
                    ms = 'No ha insertado una residencia'
                    raise
                elif datos[5] == '' or (not datos[5].isdigit()) or(not datos[5].isdigit() and datos[5] <= 0):
                    ms = 'No ha insertado un ingreso valido'
                    raise
                else:
                    ms = 'Debes ser mayor de edad'
                if op == 'insert':
                    cur.execute('insert into Candidato (can_Documento,can_Nombre,can_Apellido,can_Fecha,can_Residencia,can_Ingreso,can_Estado) values (%s,%s,%s,%s,%s,%s,%s)',(datos[0],datos[1],datos[2],datos[3],datos[4],datos[5],datos[6]))
                elif op == 'update':
                    cur.callproc("proc_up_candidato",[idup,datos[0],datos[1],datos[2],datos[3],datos[4],datos[5],datos[6]])
            #adopcion
            elif tab == 'Adopcion':
                for i in range(2):
                    datos.append(request.form[str(i)])
                cur.execute('select apl_id from Adopcion')
                tip = cur.fetchall()
                cur.execute('select emp_id from vw_Horario')
                tip1 = cur.fetchall()
                cur.execute('select apl_id from Aplica')
                tip2 = cur.fetchall()
                cur.execute('select mas_id from vw_NoAdopt')
                tip3 = cur.fetchall()
                v = True
                if op == 'update':
                    ms = 'Datos no validos'
                    cur.execute(f'select emp_id from adopcion where ado_id = {idup}')
                    tip4 = cur.fetchall()
                    cur.execute(f'select apl_id from adopcion where ado_id = {idup}')
                    tip5 = cur.fetchall()
                    cur.execute(f'select mas_id from Aplica where apl_id = {datos[0]}')
                    apl = cur.fetchall()
                    if (ForeignKeyExist(tip,datos[0]) == 0 or ForeignKeyExist(tip2,datos[0]) != 0) and ((str(tip4[0][0]) != datos[1] and str(tip5[0][0]) == datos[0]) or (str(tip4[0][0]) == datos[1] and str(tip5[0][0]) == datos[0]) or (ForeignKeyExist(tip3,str(apl[0][0])) != 0)):
                        v = False
                        cur.execute(f'update adopcion set apl_ID = {datos[0]}, emp_ID = {datos[1]},ado_Fecha = current_date() where ado_id = {idup}')
                        mysql.connection.commit()
                    else:
                        raise
                if (ForeignKeyExist(tip,datos[0]) != 0 or ForeignKeyExist(tip2,datos[0])) == 0 and v:
                    ms = 'No ha ingresado una aplicacion valida'
                    raise
                elif ForeignKeyExist(tip1,datos[1]) == 0:
                    ms = 'No ha ingresado un empleado valido'
                    raise
                cur.execute(f'select mas_id from Aplica where apl_id = {datos[0]}')
                apl = cur.fetchall()
                if ForeignKeyExist(tip3,str(apl[0][0])) != 0:
                    if op == 'insert':
                        cur.execute('insert into Adopcion (apl_ID,emp_ID,ado_Fecha) values(%s,%s,current_date())',(datos[0],datos[1]))
            #Aplica
            elif tab == 'Aplica':
                for i in range(2):
                    datos.append(request.form[str(i)])
                ms = 'Candidato no apto'
                cur.execute('select can_id from Candidato')
                tip = cur.fetchall()
                cur.execute('select mas_Id from vw_NoAdopt')
                tip1 = cur.fetchall()
                if ForeignKeyExist(tip,datos[0]) == 0:
                    ms = 'No existe el Candidato ' + datos[0]
                    raise
                elif ForeignKeyExist(tip1,datos[1]) == 0:
                    ms = 'No existe la mascota ' + datos[1]
                    raise
                cur.execute(f'select can_Estado from Candidato where can_id = {datos[0]}')
                tip = cur.fetchall()
                if tip[0][0] == 'No Apto':
                    raise
                if op == 'insert':
                    cur.execute('insert into Aplica (can_ID,mas_ID,apl_FechaAplicacion) values(%s,%s,current_date())',(datos[0],datos[1]))
                elif op == 'update':
                    cur.execute(f'update aplica set can_ID = {datos[0]}, mas_ID = {datos[1]}, apl_FechaAplicacion = current_date() where apl_id = {idup}')
            #Contribuidor
            elif tab == 'Contribuidor':
                for i in range(6):
                    if i == 5:
                        f = request.files[str(i)]
                        if f.filename != '':
                            f.save(os.path.join(app.config['UPLOAD_FOLDER'], f.filename))
                        else:
                            f.filename = 'Por agregar'
                        datos.append(f.filename)
                        break
                    datos.append(request.form[str(i)])
                if datos[0] == '' or (not datos[0].isdigit()) or len(datos[0]) > 10:
                     ms = 'No ha insertado un documento valido'
                     raise
                elif datos[1] == '':
                    ms = 'No ha insertado un nombre'
                    raise
                elif datos[2] == '':
                    ms = 'No ha insertado un apellido'
                    raise
                elif datos[3] == '' or datos[3].isalpha()or datos[3].isdigit():
                    ms = 'No ha insertado una fecha de nacimiento valida'
                    raise
                elif datos[4] == '':
                    ms = 'No ha insertado una labor'
                    raise
                else:
                    ms = 'Debes ser mayor de edad'
                if op == 'insert':
                    cur.execute('insert into Contribuidor (con_Documento,con_Nombre,con_Apellido,con_Fecha,con_Labor,con_Foto) values (%s,%s,%s,%s,%s,%s)',(datos[0],datos[1],datos[2],datos[3],datos[4],datos[5]))
                elif op == 'update':
                    if datos[5] == 'Por agregar':
                        cur.execute(f'select con_foto from contribuidor where con_id = {idup}')
                        foto = cur.fetchall()
                        datos[5] = foto[0][0]
                    cur.callproc("proc_up_contribuidor",[idup,datos[0],datos[1],datos[2],datos[3],datos[4],datos[5]])
            #Donacion
            elif tab == 'Donacion':
                for i in range(4):
                    datos.append(request.form[str(i)])
                cur.execute('select don_Numero from Donacion')
                tip2 = cur.fetchall()
                cur.execute('select con_Id from Contribuidor')
                tip = cur.fetchall()
                if len(datos[0]) != 6 or (not datos[0].isdigit()) or datos[0] == '' or (ForeignKeyExist(tip2,datos[0]) != 0 and op != 'update'):
                    ms = 'No ha ingresado un numero de donacion valido'
                    raise
                elif datos[1] == '' or (not datos[1].isdigit()) or(not datos[1].isdigit() and datos[1] <= 0):
                    ms = 'No ha insertado un valor valido'
                    raise
                elif datos[2] == '':
                    ms = 'No ha insertado un lugar de donacion'
                    raise
                elif ForeignKeyExist(tip,datos[3]) == 0:
                    ms = 'No ha insertado un contribuidor valido'
                    raise
                if op == 'insert':
                    cur.execute('insert into Donacion (don_Numero,don_Valor,don_Lugar,con_ID,don_Fecha) values (%s,%s,%s,%s,current_date())',(datos[0],datos[1],datos[2],datos[3]))
                elif op == 'update':
                    cur.execute(f'update donacion set don_Numero = "{datos[0]}", don_Valor = {datos[1]}, don_Lugar = "{datos[2]}", con_ID ={datos[3]}, don_Fecha = current_date() where don_Numero = {idup}')
                    idup = datos[0]
            #Empleado
            elif tab == 'Empleado':
                for i in range(5):
                    datos.append(request.form[str(i)])
                cur.execute('select fun_id from Funcion')
                tip = cur.fetchall()
                if datos[0] == '' or (not datos[0].isdigit()) or len(datos[0]) > 10:
                     ms = 'No ha insertado un documento valido'
                     raise
                elif datos[1] == '':
                    ms = 'No ha insertado un nombre'
                    raise
                elif datos[2] == '':
                    ms = 'No ha insertado un apellido'
                    raise
                elif datos[3] == '' or datos[3].isalpha()or datos[3].isdigit():
                    ms = 'No ha insertado una fecha de nacimiento valida'
                    raise
                elif ForeignKeyExist(tip,datos[4]) == 0:
                    ms = 'No ha insertado una funcion valida'
                    raise
                else:
                    ms = 'Debes ser mayor de edad'
                if op == 'insert':
                    cur.execute('insert into Empleado (emp_Documento,emp_Nombre,emp_Apellido,emp_Fecha,fun_ID) values (%s,%s,%s,%s,%s)',(datos[0],datos[1],datos[2],datos[3],datos[4]))
                elif op == 'update':
                    cur.execute('update empleado set emp_Documento = %s,emp_Nombre = %s,emp_Apellido = %s,emp_Fecha = %s,fun_ID = %s where emp_id = %s',(datos[0],datos[1],datos[2],datos[3],datos[4],idup))
            #Funcion
            elif tab == 'Funcion':
                for i in range(5):
                    datos.append(request.form[str(i)])
                if datos[0] == '':
                    ms = 'No ha insertado una funcion'
                    raise
                elif datos[1] == '':
                    ms = 'No ha insertado una descripcion'
                    raise
                elif datos[2] == '':
                    ms = 'No ha insertado un horario'
                    raise
                elif datos[4] == '' or (not datos[4].isdigit()) or(not datos[4].isdigit() and datos[4] <= 0):
                    ms = 'No ha insertado un pago valido'
                    raise
                if datos[3] == '':
                    datos[3] == 'NULL'
                if op == 'insert':
                    cur.execute('insert into Funcion (fun_Tipo,fun_Descripción,fun_Horario1,fun_Horario2,fun_Pago) values (%s,%s,%s,%s,%s)',(datos[0],datos[1],datos[2],datos[3],datos[4]))
                elif op == 'update':
                    cur.execute('update funcion set fun_Tipo = %s,fun_Descripción = %s,fun_Horario1 = %s,fun_Horario2 = %s,fun_Pago = %s where fun_id = %s',(datos[0],datos[1],datos[2],datos[3],datos[4],idup))
            #Mascota
            elif tab == 'Mascota':
                for i in range(5):
                    if i == 4:
                        f = request.files[str(i)]
                        if f.filename != '':
                            f.save(os.path.join(app.config['UPLOAD_FOLDER'], f.filename))
                        else:
                            f.filename = 'Por agregar'
                        datos.append(f.filename)
                        break
                    datos.append(request.form[str(i)])
                cur.execute('select tip_id from TipodeMascota')
                tip = cur.fetchall()
                if ForeignKeyExist(tip,datos[0]) == 0:
                    ms = 'No existe el tipo de mascota ' + datos[0]
                    raise
                elif datos[1] == '':
                    ms = 'No ha insertado un color'
                    raise
                elif datos[3] == '':
                    ms = 'No ha insertado una descripcion'
                    raise
                if op == 'insert':
                    cur.execute('insert into Mascota (tip_ID,mas_Color,mas_Sexo,mas_Descripcion,mas_Foto) values (%s,%s,%s,%s,%s)',(datos[0],datos[1],datos[2],datos[3],datos[4]))
                elif op == 'update':
                    if datos[4] == 'Por agregar':
                        cur.execute(f'select mas_foto from Mascota where mas_id = {idup}')
                        foto = cur.fetchall()
                        datos[4] = foto[0][0]
                    cur.callproc("proc_up_mascota",[idup,datos[0],datos[1],datos[2],datos[3],datos[4]])
            #Pagoadicionalempleado
            elif tab == 'Pagoadicionalempleado':
                for i in range(2):
                    datos.append(request.form[str(i)])
                if datos[0] == '' or (not datos[0].isdigit()) or(not datos[0].isdigit() and datos[0] <= 0):
                    ms = 'No ha insertado un valor valido'
                    raise
                elif datos[1] == '':
                    ms = 'No ha insertado una descripcion'
                    raise
                if op == 'insert':
                    cur.execute('insert into PagoAdicionalEmpleado (pad_Valor,pad_Descripción) values(%s,%s)',(datos[0],datos[1]))
                elif op == 'update':
                    cur.callproc("proc_up_pagoadicionalempleado",[idup,datos[0],datos[1]])

            #Pagoempleado
            elif tab == 'Pagoempleado':
                for i in range(3):
                    datos.append(request.form[str(i)])
                cur.execute('select emp_id from Empleado')
                tip = cur.fetchall()
                cur.execute('select pad_id from PagoAdicionalEmpleado')
                tip1 = cur.fetchall()
                cur.execute('select pag_Numero from PagoEmpleado')
                tip2 = cur.fetchall()
                ms = 'No ha insertado un número de pago valido'
                if len(datos[0]) != 7 or (not datos[0].isdigit()) or datos[0] == '' or (ForeignKeyExist(tip2,datos[0]) != 0 and op != 'update'):
                    ms = 'No ha insertado un número de pago valido'
                    raise
                elif ForeignKeyExist(tip,datos[1]) == 0:
                    ms = 'No existe el empleado ' + datos[1]
                    raise
                elif ForeignKeyExist(tip1,datos[2]) == 0 and datos[2] != '':
                    ms = 'No existe el pago adicional ' + datos[2]
                    raise
                if datos[2] == '':
                    if op == 'insert':
                        cur.execute('insert into PagoEmpleado (pag_Numero,emp_ID,pad_ID,pag_Total,pag_Fecha) values (%s,%s,NULL,0,current_date())',(datos[0],datos[1]))
                    elif op == 'update':
                        cur.execute(f'update pagoempleado set pag_Numero = {datos[0]}, emp_id = {datos[1]}, pad_id = NULL, pag_total = 0, pag_Fecha = current_date() where pag_Numero = {idup}')
                else:
                    if op == 'insert':
                        cur.execute('insert into PagoEmpleado (pag_Numero,emp_ID,pad_ID,pag_Total,pag_Fecha) values (%s,%s,%s,0,current_date())',(datos[0],datos[1],datos[2]))
                    elif op == 'update':
                        cur.execute(f'update pagoempleado set pag_Numero = {datos[0]}, emp_id = {datos[1]}, pad_id = {datos[2]}, pag_total = 0, pag_Fecha = current_date() where pag_Numero = {idup}')
                idup = datos[0]
            #Tipo de mascota
            elif tab == 'Tipodemascota':
                for i in range(5):
                    if i == 4:
                        f = request.files[str(i)]
                        if f.filename != '':
                            f.save(os.path.join(app.config['UPLOAD_FOLDER'], f.filename))
                        else:
                            f.filename = 'Por agregar'
                        datos.append(f.filename)
                        break
                    datos.append(request.form[str(i)])
                if datos[0] == '' or not (datos[0] == 'Agua' or datos[0] == 'Tierra' or datos[0] == 'Aire') :
                    ms = 'No ha insertado un habitat valido'
                    raise
                elif datos[1] == '':
                    ms = 'No ha insertado una denominación'
                    raise
                elif datos[2] == '':
                    ms = 'No ha insertado generalidades'
                    raise
                elif datos[3] == '':
                    ms = 'No ha insertado alimento'
                    raise
                if op == 'insert':
                    cur.execute('insert into TipoDeMascota (tip_Habitat,tip_Denominacion,tip_Generalidades,tip_Alimento,tip_Foto) values (%s,%s,%s,%s,%s)',(datos[0],datos[1],datos[2],datos[3],datos[4]))
                elif op == 'update':
                    if datos[4] == 'Por agregar':
                        cur.execute(f'select tip_foto from tipodemascota where tip_id = {idup}')
                        foto = cur.fetchall()
                        datos[4] = foto[0][0]
                    cur.callproc("proc_up_tipodemascota",[idup,datos[0],datos[1],datos[2],datos[3],datos[4]])
            elif tab == 'Vw_aptitud':
                datos.append(request.form[str(1)])
                cur.callproc("proc_up_vw_aptitud",[idup,datos[0]])
            mysql.connection.commit()
            flash('Datos agregados correctamente', 'correcto')
            return redirect(url_for("add",idup= idup, op = op, nomid = nomid, tab = tab))
        except Exception as err1:
            try:
                flash(f'{ms}', 'error')
                return redirect(url_for("add",idup= idup, op = op, nomid = nomid, tab = tab))
            except Exception as err:
                return redirect(url_for("add",idup= idup, op = op, nomid = nomid, tab = tab))


if __name__ == '__main__':
    app.run(port = 3000, debug = True)
