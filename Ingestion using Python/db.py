from sqlalchemy import create_engine
def get_engine():
    server = 'localhost'
    database = 'python_sql'
    username = 'pranitha1'
    password = 'pranitha'
    driver = 'ODBC Driver 18 for SQL Server'
    conn_str=f"mssql+pyodbc://{server}/{database}?driver={driver}&TrustServerCertificate=yes"
    return create_engine(conn_str)
