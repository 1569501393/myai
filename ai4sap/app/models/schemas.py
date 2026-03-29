"""
Pydantic schemas for SQL query API.
"""

from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field


class SQLQueryRequest(BaseModel):
    sql: str = Field(..., description="SQL query to execute")
    max_rows: Optional[int] = Field(100, ge=1, le=1000, description="Maximum rows to return")


class SQLQueryResponse(BaseModel):
    success: bool
    data: Optional[List[Dict[str, Any]]] = None
    row_count: int = 0
    error: Optional[str] = None
    execution_time_ms: Optional[float] = None


class TableQueryRequest(BaseModel):
    table: str = Field(..., description="Table name")
    fields: Optional[str] = Field(None, description="Comma-separated field names")
    where: Optional[str] = Field(None, description="WHERE clause")
    order_by: Optional[str] = Field(None, description="ORDER BY clause")
    limit: Optional[int] = Field(10, ge=1, le=1000, description="Limit rows")
    offset: Optional[int] = Field(0, ge=0, description="Offset rows")
