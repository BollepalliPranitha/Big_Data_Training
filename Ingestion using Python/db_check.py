from sqlalchemy import create_engine,text
from db import get_engine
# Assuming get_engine() gives you a valid SQLAlchemy engine
engine = get_engine()

# Query to check the current database
with engine.connect() as conn:
    result = conn.execute(text("SELECT DB_NAME() AS CurrentDatabase"))
    current_db = result.fetchone()[0]

print(f"You are connected to the database: {current_db}")
