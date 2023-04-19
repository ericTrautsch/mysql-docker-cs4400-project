from typing import List, Dict
from flask import Flask, render_template
import mysql.connector
import json
import os # <-----


app = Flask(__name__)


def get_tables(tables = ['Customer', 'Employee', 'Outgoing', 'Incoming', 'Part', 'StorageArea']) -> List[Dict]:
    config = {
        'user': f'{os.environ.get("DB_USER")}',
        'password': f'{os.environ.get("DB_PASSWORD")}',
        'host': f'{os.environ.get("HOST")}',
        'port': '3306',
        'database': f'{os.environ.get("DATABASE")}'
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
            results += ['error']
    return results


@app.route('/')
def index() -> str:
    result = get_tables()
    # print('RESULT HERE', result)
    return render_template('table.html', list_tables = result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port = os.environ.get('PORT'))    