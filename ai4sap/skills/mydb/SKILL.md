---
name: mydb
description: |
  Universal database connector using SQLAlchemy with .env configuration.
  Use when: (1) Connecting to MySQL, PostgreSQL, or SQLite databases, (2) Executing raw SQL queries, 
  (3) Managing database connections with connection pooling, (4) Schema introspection.
  Supports: MySQL, PostgreSQL, SQLite with connection pool, transactions, and CRUD operations.
---

# mydb

## Quick Start

### 1. Create .env file

Copy `references/.env.example` to your project root and configure:

```bash
DB_TYPE=mysql
DB_HOST=localhost
DB_PORT=3306
DB_NAME=testdb
DB_USER=root
DB_PASSWORD=secret
```

### 2. Use in Python

```python
from skills.mydb.scripts.db_connector import get_db

db = get_db()

# Query
rows = db.execute("SELECT * FROM users WHERE id > :id", {"id": 0})
for row in rows:
    print(dict(row))

# Insert/Update/Delete
db.execute_non_query("INSERT INTO users (name) VALUES (:name)", {"name": "test"})
db.execute_non_query("UPDATE users SET name = :name WHERE id = :id", {"name": "updated", "id": 1})
db.execute_non_query("DELETE FROM users WHERE id = :id", {"id": 1})

# Table introspection
print(db.get_tables())
print(db.get_table_columns("users"))
```

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| DB_TYPE | mysql | Database type: mysql, postgresql, sqlite |
| DB_HOST | localhost | Database host |
| DB_PORT | 3306 | Database port |
| DB_NAME | - | Database name |
| DB_USER | - | Database username |
| DB_PASSWORD | - | Database password |
| DB_POOL_SIZE | 5 | Connection pool size |
| DB_MAX_OVERFLOW | 10 | Max overflow connections |
| DB_POOL_RECYCLE | 3600 | Pool recycle time (seconds) |
| DB_ECHO | false | SQL echo mode |

## API Reference

### Database Class

```python
db = get_db()
session = db.get_session()
results = db.execute(sql, params)
row = db.execute_one(sql, params)
affected = db.execute_non_query(sql, params)
tables = db.get_tables()
columns = db.get_table_columns(table_name)
exists = db.table_exists(table_name)
db.close()
```

## Resources

- `scripts/db_connector.py` - Main database connector module
- `references/.env.example` - Environment configuration template
