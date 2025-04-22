from sqlalchemy import text
from db import get_engine
engine=get_engine()
setup_sql = """
IF OBJECT_ID('customer', 'U') IS NOT NULL DROP TABLE customer;
CREATE TABLE customer (
    cid INT PRIMARY KEY,
    name NVARCHAR(20),
    email NVARCHAR(50),
    Timestampchange DATETIME2 DEFAULT SYSDATETIME()
);

INSERT INTO customer (cid, name, email) VALUES 
(1, 'rishi', 'rishi@gmail.com'),
(2, 'sushi', 'sushi@gmail.com'),
(3, 'radha', 'radha@gmail.com');

IF OBJECT_ID('customer_backup', 'U') IS NOT NULL DROP TABLE customer_backup;
SELECT * INTO customer_backup FROM customer WHERE 1=0;
ALTER TABLE customer_backup ADD timestamp_backup DATETIME2 DEFAULT SYSDATETIME();

INSERT INTO customer_backup (cid, name, email, Timestampchange)
SELECT cid, name, email, Timestampchange FROM customer;

IF OBJECT_ID('customer_logging', 'U') IS NOT NULL DROP TABLE customer_logging;
CREATE TABLE customer_logging(updated_timestamp DATETIME2);
"""
with engine.begin() as conn:
    for statement in setup_sql.strip().split(';'):
        if statement.strip():
            conn.execute(text(statement))

print("Initial setup complete")

