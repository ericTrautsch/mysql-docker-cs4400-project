from typing import List, Dict
import time
from init_db import db_init
from flask import Flask, render_template, redirect, url_for
import mysql.connector
import json
import os

db_init()
app = Flask(__name__)



def get_tables(tables) -> List[Dict]:


    config = {
    'user': f'{os.environ.get("DB_USER")}',
    'password': f'{os.environ.get("DB_PASSWORD")}',
    'host': f'{os.environ.get("HOST")}',
    'port': '3306',
    'database': f'{os.environ.get("DATABASE")}'}
 
    results = []
    for table in tables:
        try:
            connection = mysql.connector.connect(**config)
            cursor = connection.cursor()
            cursor.execute(f'SELECT * FROM {table}')
            names = [field_md[0] for field_md in cursor.description]
            data = cursor.fetchall()
            results += [(table, names, data)]
            cursor.close()
            connection.close()
        except:
            # todo: flash an error message to html display
            results += [('error', 'error', 'error')]
    return results

def execute_query(sql, query_name, query_desciption) -> List[Dict]:

    config = {
    'user': f'{os.environ.get("DB_USER")}',
    'password': f'{os.environ.get("DB_PASSWORD")}',
    'host': f'{os.environ.get("HOST")}',
    'port': '3306',
    'database': f'{os.environ.get("DATABASE")}'}
 
    results = []
    try:
        connection = mysql.connector.connect(**config)
        cursor = connection.cursor()
        cursor.execute(sql)
        names = [field_md[0] for field_md in cursor.description]
        data = cursor.fetchall()
        results = (query_name, names, data, query_desciption)
        cursor.close()
        connection.close()
    except:
        # todo: flash an error message to html display
        results += [('error', 'error', 'error', 'error')]
    return results

@app.route('/')
def index() -> str:
    tables = get_tables(['Inventory', 'Outgoing', 'Incoming', 'Part', 'StorageArea', 'Customer', 'Supplier', 'Employee'])
    views = get_tables(['inventory_summary', 'customer_sales_summary'])
    queries = [execute_query('SELECT * FROM Customer', 'Customer Query', 'Select all the tuples from Customer table'),
               execute_query('SELECT * FROM Supplier', 'Supplier Query', 'SELECT all tuples from Supplier Table!')
               ] 
    # print('RESULT HERE', result)
    return render_template('table.html', list_tables = tables, list_views = views, list_queries = queries)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port = os.environ.get('PORT'))


