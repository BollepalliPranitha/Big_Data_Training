from sqlalchemy import text
from db import get_engine

# Initialize the engine
engine = get_engine()

# SQL query to check if the tables exist
check_tables_sql = """
SELECT table_name
FROM information_schema.tables
WHERE table_name IN ('customer', 'customer_backup', 'customer_logging')
AND table_type = 'BASE TABLE';
"""

# Execute the query and fetch results
with engine.connect() as conn:
    result = conn.execute(text(check_tables_sql))
    tables = result.fetchall()

# Print the result
if tables:
    print("The following tables exist:")
    for table in tables:
        print(table[0])
else:
    print("No matching tables found.")
