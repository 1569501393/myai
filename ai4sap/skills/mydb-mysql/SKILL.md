---
name: mydb-mysql
description: |
  MySQL database connector using SQLAlchemy with .env configuration.
  Use when: (1) Connecting to MySQL database, (2) Executing raw SQL queries, 
  (3) Managing connection pool, (4) Schema introspection.
---

# mydb-mysql

## Quick Start

### 1. Configure .env

```
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DATABASE=testdb
MYSQL_USER=root
MYSQL_PASSWORD=secret
```

### 2. Use in Python

```python
from skills.mydb_mysql.scripts.mysql import get_db

db = get_db()

rows = db.execute("SELECT * FROM users LIMIT 10")
for row in rows:
    print(row._mapping)

db.execute_non_query("INSERT INTO users (name) VALUES (:name)", {"name": "test"})
db.execute_non_query("UPDATE users SET name = :name WHERE id = :id", {"name": "updated", "id": 1})
db.execute_non_query("DELETE FROM users WHERE id = :id", {"id": 1})

print(db.get_tables())
print(db.get_table_columns("users"))
```

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| MYSQL_HOST | localhost | Database host |
| MYSQL_PORT | 3306 | Database port |
| MYSQL_DATABASE | - | Database name |
| MYSQL_USER | root | Username |
| MYSQL_PASSWORD | - | Password |
| MYSQL_POOL_SIZE | 5 | Pool size |
| MYSQL_MAX_OVERFLOW | 10 | Max overflow |
| MYSQL_ECHO | false | SQL echo |

## Resources

- `scripts/mysql.py` - Main connector
- `references/.env.example` - Config template
