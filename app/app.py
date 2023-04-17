from typing import List, Dict
from flask import Flask, render_template
import mysql.connector
import json

app = Flask(__name__)


def get_tables(tables = ['Customer']):
    config = {
        'user': 'root',
        'password': 'root',
        'host': 'db',
        'port': '3306',
        'database': 'warehouse'
    }
    results = []
    connection = mysql.connector.connect(**config)
    cursor = connection.cursor()
    cursor.execute(f'SELECT * FROM Customer')
    result = cursor.fetchall()
    cursor.close()
    connection.close()
    return result


@app.route('/')
def index():
    result = get_tables()
    print('RESULT HERE', result)
    render_template('table.html', data = result)
    return str(result)



if __name__ == '__main__':
    app.run(host='0.0.0.0')