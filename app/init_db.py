from typing import List, Dict
from flask import Flask, render_template
import mysql.connector
import json
import os

def db_init(config = {
    'user': f'{os.environ.get("DB_USER")}',
    'password': f'{os.environ.get("DB_PASSWORD")}',
    'host': f'{os.environ.get("HOST")}',
    'port': '3306',
    'database': f'{os.environ.get("DATABASE")}'}):
  
    connection = mysql.connector.connect(**config)
    cursor = connection.cursor()
    with open('init.sql') as f:
        for query in (f.read().strip().split(sep = ';')[:-1]):
            cursor.execute(query + ';')

        #cursor.executemany(f.read(), multi=True)
    connection.commit()

    cursor.close()
    connection.close()

db_init()