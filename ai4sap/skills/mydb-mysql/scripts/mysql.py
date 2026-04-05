import os
import sys
from pathlib import Path
from typing import Optional

sys.path.insert(0, str(Path(__file__).parent.parent))

from dotenv import load_dotenv
from sqlalchemy import create_engine, text, MetaData, Table
from sqlalchemy.engine import Engine, Row
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.pool import QueuePool

load_dotenv()


class MySQL:
    _instance: Optional['MySQL'] = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._initialized = False
        return cls._instance

    def __init__(self):
        if self._initialized:
            return
        self.host = os.getenv("MYSQL_HOST", "localhost")
        self.port = int(os.getenv("MYSQL_PORT", "3306"))
        self.database = os.getenv("MYSQL_DATABASE", "")
        self.username = os.getenv("MYSQL_USER", "root")
        self.password = os.getenv("MYSQL_PASSWORD", "")
        self.pool_size = int(os.getenv("MYSQL_POOL_SIZE", "5"))
        self.max_overflow = int(os.getenv("MYSQL_MAX_OVERFLOW", "10"))
        self.pool_recycle = int(os.getenv("MYSQL_POOL_RECYCLE", "3600"))
        self.echo = os.getenv("MYSQL_ECHO", "false").lower() == "true"

        uri = f"mysql+pymysql://{self.username}:{self.password}@{self.host}:{self.port}/{self.database}"
        self.engine: Engine = create_engine(
            uri,
            poolclass=QueuePool,
            pool_size=self.pool_size,
            max_overflow=self.max_overflow,
            pool_recycle=self.pool_recycle,
            echo=self.echo,
        )
        self.SessionLocal = sessionmaker(bind=self.engine, autocommit=False, autoflush=False)
        self._initialized = True

    def get_session(self) -> Session:
        return self.SessionLocal()

    def execute(self, sql: str, params: Optional[dict] = None) -> list[Row]:
        with self.engine.connect() as conn:
            result = conn.execute(text(sql), params or {})
            return list(result)

    def execute_one(self, sql: str, params: Optional[dict] = None) -> Optional[Row]:
        results = self.execute(sql, params)
        return results[0] if results else None

    def execute_non_query(self, sql: str, params: Optional[dict] = None) -> int:
        with self.engine.connect() as conn:
            result = conn.execute(text(sql), params or {})
            conn.commit()
            return result.rowcount

    def get_tables(self) -> list[str]:
        metadata = MetaData(bind=self.engine)
        metadata.reflect()
        return list(metadata.tables.keys())

    def get_table_columns(self, table_name: str) -> list[dict]:
        metadata = MetaData(bind=self.engine)
        table = Table(table_name, metadata, autoload=True)
        return [
            {"name": col.name, "type": str(col.type), "nullable": col.nullable}
            for col in table.columns
        ]

    def close(self) -> None:
        self.engine.dispose()
        MySQL._instance = None


def get_db() -> MySQL:
    return MySQL()


if __name__ == "__main__":
    db = get_db()
    print(f"Tables: {db.get_tables()}")
