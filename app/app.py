from typing import List, Dict
from flask import Flask, render_template
import mysql.connector
import json

app = Flask(__name__)


def get_tables(tables = ['Customer', 'Employee', 'Outgoing', 'Incoming', 'Part', 'StorageArea']) -> List[Dict]:
    config = {
        'user': 'root',
        'password': 'root',
        'host': 'db',
        'port': '3306',
        'database': 'warehouse'
    }
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
            print('error error')
    return results


@app.route('/')
def index() -> str:
    result = get_tables()
    print('RESULT HERE', result)
    return render_template('table.html', list_tables = result)


if __name__ == '__main__':
    app.run(host='0.0.0.0')