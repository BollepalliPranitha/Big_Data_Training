import pandas as pd
from sqlalchemy import text
from db import get_engine

engine = get_engine()

# 1. Get last logging time
with engine.connect() as conn:
    result = conn.execute(text("SELECT MAX(updated_timestamp) AS last_time FROM customer_logging")).fetchone()
    last_time = result[0] if result[0] else '2000-01-01'

# 2. Load new/updated records from customer
df_source = pd.read_sql(f"""
    SELECT * FROM customer
    WHERE Timestampchange > '{last_time}'
""", engine)

if df_source.empty:
    print("No new records to sync.")
else:
    print(f"Syncing {len(df_source)} new/updated records...")

    # 3. Load current backup
    df_backup = pd.read_sql("SELECT * FROM customer_backup", engine)

    # 4. Merge updates
    df_merged = df_backup.merge(df_source, on='cid', how='outer', suffixes=('_old', ''))
    df_merged['name'] = df_merged['name'].combine_first(df_merged['name_old'])
    df_merged['email'] = df_merged['email'].combine_first(df_merged['email_old'])
    df_merged['Timestampchange'] = df_merged['Timestampchange'].combine_first(df_merged['Timestampchange_old'])
    df_merged['timestamp_backup'] = pd.Timestamp.now()
    df_final = df_merged[['cid', 'name', 'email', 'Timestampchange', 'timestamp_backup']]

    # 5. Write back full table (or use UPSERT logic if needed)
    df_final.to_sql('customer_backup', engine, if_exists='replace', index=False)

    # 6. Log sync timestamp
    with engine.begin() as conn:
        conn.execute(text("INSERT INTO customer_logging(updated_timestamp) VALUES (SYSDATETIME())"))

    print("Sync complete.")
