from typing import List, Dict
import time
from init_db import db_init
from flask import Flask, render_template, redirect, url_for
import mysql.connector
import json
import os

db_init()
app = Flask(__name__)



def get_tables(tables = ['Customer']) -> List[Dict]:


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
    queries = [  execute_query('''SELECT p.part_id,  p.description,  s.storage_area_id,  s.area,  s.location, i.quantity FROM Inventory i JOIN Part p ON i.part_id = p.part_id JOIN StorageArea s ON i.storage_area_id = s.storage_area_id WHERE p.part_id = 1;''', 'Find Part Query','Where can I find part id a specific part in the warehouse to pick and add to an outgoing shipment? (Using part_id 1 as an example)')
               , execute_query('''SELECT SUM(i.quantity * i.cost_per_unit) AS total_value FROM Inventory i WHERE i.part_id = 1;''', 'Find Part Value', 'What is the total value of all parts of a certain type stored in the warehouse? (Using part id 1)')
               , execute_query('''SELECT * FROM StorageArea s WHERE NOT EXISTS ( SELECT i.storage_area_id FROM Inventory i WHERE i.storage_area_id = s.storage_area_id );''', 'Find Empty Storage Areas', 'Which storage areas can accommodate a new part type? (of part id = 1)')
               , execute_query('''SELECT p.part_id, p.description, p.manufacturer, p.material_type, SUM(o.quantity) AS total_outgoing_quantity FROM Part p JOIN Outgoing o ON p.part_id = o.part_id GROUP BY p.part_id, p.description, p.manufacturer, p.material_type HAVING total_outgoing_quantity = ( SELECT MAX(total_outgoing_quantity) FROM ( SELECT part_id, SUM(quantity) AS total_outgoing_quantity FROM Outgoing GROUP BY part_id ) AS outgoing_summary );''', 'Highest Outgoing Demand', 'What part is in the highest outgoing demand? (involves join, aggregation, and subquery)')
               , execute_query('''SELECT SUM(o.quantity * o.profit_per_unit) AS total_profit FROM Outgoing o WHERE o.placed_on >= DATE_FORMAT(NOW(), '%Y-01-01') AND o.placed_on < DATE_FORMAT(NOW(), '%Y-%m-%d');''', 'Profits This Year' ,'What are our profits for the current year? (involves join and aggregation)')
               ] 
    # print('RESULT HERE', result)
    return render_template('table.html', list_tables = tables, list_views = views, list_queries = queries)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port = os.environ.get('PORT'))


