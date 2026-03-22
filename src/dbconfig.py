import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="appuser",
        password="1234",  # leave empty for Arch sudo login
        database="cop_friendly_app"
    )