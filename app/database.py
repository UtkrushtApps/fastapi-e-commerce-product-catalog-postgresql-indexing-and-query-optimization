import psycopg2

def get_connection():
    conn = psycopg2.connect(
        dbname='ecommerce',
        user='ecommerce',
        password='ecommercepwd',
        host='db',
        port=5432
    )
    return conn
