from flask import Flask, render_template, request, redirect, url_for, flash
from flask_mysqldb import MySQL

# initializations
app = Flask(__name__)

# Mysql Connection
app.config['MYSQL_HOST'] = 'localhost' 
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '1234'
app.config['MYSQL_DB'] = 'salvandovidas'
mysql = MySQL(app)

# routes
@app.route('/')
def Index():
    return 'Hola mundo'

# starting the app
if __name__ == "__main__":
    app.run(port=3000, debug=True)
