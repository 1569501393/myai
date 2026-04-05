"""
Database connector with SQLAlchemy.
Reads configuration from .env file.
"""

import os
from pathlib import Path
from typing import Any, Optional

from dotenv import load_dotenv
from sqlalchemy import create_engine, text, MetaData, Table, Column, Integer, String, Float, DateTime
from sqlalchemy.engine import Engine, Row
from sqlalchemy.orm import sessionmaker, Session, declarative_base
from sqlalchemy.pool import QueuePool

# Load .env file
load_dotenv()

Base = declarative_base()


class DatabaseConfig:
    """Database configuration from environment variables."""

    def __init__(self):
        self.db_type = os.getenv("DB_TYPE", "mysql").lower()
        self.host = os.getenv("DB_HOST", "localhost")
        self.port = int(os.getenv("DB_PORT", "3306"))
        self.database = os.getenv("DB_NAME", "")
        self.username = os.getenv("DB_USER", "")
        self.password = os.getenv("DB_PASSWORD", "")
        self.pool_size = int(os.getenv("DB_POOL_SIZE", "5"))
        self.max_overflow = int(os.getenv("DB_MAX_OVERFLOW", "10"))
        self.pool_recycle = int(os.getenv("DB_POOL_RECYCLE", "3600"))
        self.echo = os.getenv("DB_ECHO", "false").lower() == "true"

    def get_uri(self) -> str:
        """Build database URI."""
        if self.db_type == "mysql":
            return f"mysql+pymysql://{self.username}:{self.password}@{self.host}:{self.port}/{self.database}"
        elif self.db_type == "postgresql":
            return f"postgresql://{self.username}:{self.password}@{self.host}:{self.port}/{self.database}"
        elif self.db_type == "sqlite":
            db_path = self.database or "database.db"
            return f"sqlite:///{db_path}"
        else:
            raise ValueError(f"Unsupported database type: {self.db_type}")


class Database:
    """Database connection manager with connection pool and transactions."""

    _instance: Optional['Database'] = None

    def __new__(cls, config: Optional[DatabaseConfig] = None):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._initialized = False
        return cls._instance

    def __init__(self, config: Optional[DatabaseConfig] = None):
        if self._initialized:
            return
        self.config = config or DatabaseConfig()
        self.engine: Engine = create_engine(
            self.config.get_uri(),
            poolclass=QueuePool,
            pool_size=self.config.pool_size,
            max_overflow=self.config.max_overflow,
            pool_recycle=self.config.pool_recycle,
            echo=self.config.echo,
        )
        self.SessionLocal = sessionmaker(bind=self.engine, autocommit=False, autoflush=False)
        self._initialized = True

    def get_session(self) -> Session:
        """Get a new database session."""
        return self.SessionLocal()

    def execute(self, sql: str, params: Optional[dict] = None) -> list[Row]:
        """Execute raw SQL and return results."""
        with self.engine.connect() as conn:
            result = conn.execute(text(sql), params or {})
            return list(result)

    def execute_one(self, sql: str, params: Optional[dict] = None) -> Optional[Row]:
        """Execute raw SQL and return single row."""
        results = self.execute(sql, params)
        return results[0] if results else None

    def execute_non_query(self, sql: str, params: Optional[dict] = None) -> int:
        """Execute INSERT/UPDATE/DELETE and return affected rows."""
        with self.engine.connect() as conn:
            result = conn.execute(text(sql), params or {})
            conn.commit()
            return result.rowcount

    def get_tables(self) -> list[str]:
        """Get all table names."""
        metadata = MetaData(bind=self.engine)
        metadata.reflect()
        return list(metadata.tables.keys())

    def get_table_columns(self, table_name: str) -> list[dict]:
        """Get columns for a table."""
        metadata = MetaData(bind=self.engine)
        table = Table(table_name, metadata, autoload=True)
        return [
            {"name": col.name, "type": str(col.type), "nullable": col.nullable}
            for col in table.columns
        ]

    def table_exists(self, table_name: str) -> bool:
        """Check if table exists."""
        return table_name in self.get_tables()

    def create_table(self, name: str, columns: list[dict]) -> None:
        """Create a table."""
        cols = []
        for col in columns:
            col_type = col.get("type", "String")
            if col_type == "Integer":
                cols.append(Column(col["name"], Integer, primary_key=col.get("primary_key", False)))
            elif col_type == "Float":
                cols.append(Column(col["name"], Float))
            elif col_type == "DateTime":
                cols.append(Column(col["name"], DateTime))
            else:
                cols.append(Column(col["name"], String(255)))
        table = Table(name, Base.metadata, *cols)
        Base.metadata.create_all(self.engine)

    def close(self) -> None:
        """Close the database connection."""
        self.engine.dispose()
        Database._instance = None


def get_db() -> Database:
    """Get database instance."""
    return Database()


# === Quick Usage ===

if __name__ == "__main__":
    # Example .env file content:
    # DB_TYPE=mysql
    # DB_HOST=localhost
    # DB_PORT=3306
    # DB_NAME=testdb
    # DB_USER=root
    # DB_PASSWORD=secret
    # DB_POOL_SIZE=5
    # DB_MAX_OVERFLOW=10

    db = get_db()

    # Example queries
    # results = db.execute("SELECT * FROM users LIMIT 10")
    # for row in results:
    #     print(dict(row))

    # db.execute_non_query("INSERT INTO users (name) VALUES (:name)", {"name": "test"})
    # db.execute_non_query("UPDATE users SET name = :name WHERE id = :id", {"name": "updated", "id": 1})
    # db.execute_non_query("DELETE FROM users WHERE id = :id", {"id": 1})

    print("Database connected successfully!")
    print(f"Tables: {db.get_tables()}")
