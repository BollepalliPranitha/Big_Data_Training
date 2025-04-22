import pyodbc

# Connection parameters
server = 'localhost'
database = 'python_sql'
username = 'pranitha1'
password = 'pranitha'
driver = '{ODBC Driver 18 for SQL Server}'
conn=None
try:
    conn=pyodbc.connect(f'DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password};TrustServerCertificate=yes')
    cursor=conn.cursor()
    print('successful connection')
except pyodbc.Error as ex:
    sqlstate=ex.args[0]
    print(f'error: {ex}')
finally:
    if conn:
        cursor.close()
        conn.close()
        print('conn closed')

