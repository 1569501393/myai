"""
API routes for SAP SQL query.
"""

from fastapi import APIRouter, HTTPException, Depends
from typing import Optional
import os

from app.models.schemas import SQLQueryRequest, SQLQueryResponse, TableQueryRequest
from app.services.sap_service import SAPService


def get_sap_service() -> SAPService:
    return SAPService(
        base_url=os.getenv("SAP_BASE_URL", "http://mysap.goodsap.cn:50400"),
        username=os.getenv("SAP_USER", "U1170"),
        password=os.getenv("SAP_PASSWORD", "hysoft888999"),
        client=os.getenv("SAP_CLIENT", "400"),
    )


router = APIRouter()


@router.post("/query", response_model=SQLQueryResponse)
async def execute_sql(request: SQLQueryRequest, sap: SAPService = Depends(get_sap_service)):
    result = sap.execute_sql(request.sql, request.max_rows)
    return SQLQueryResponse(
        success=result.get("success", False),
        data=result.get("data"),
        row_count=result.get("row_count", 0),
        error=result.get("error"),
        execution_time_ms=result.get("execution_time_ms"),
    )


@router.post("/table", response_model=SQLQueryResponse)
async def query_table(request: TableQueryRequest, sap: SAPService = Depends(get_sap_service)):
    result = sap.query_table(
        table=request.table,
        fields=request.fields,
        where=request.where,
        order_by=request.order_by,
        limit=request.limit,
        offset=request.offset,
    )
    return SQLQueryResponse(
        success=result.get("success", False),
        data=result.get("data"),
        row_count=result.get("row_count", 0),
        error=result.get("error"),
        execution_time_ms=result.get("execution_time_ms"),
    )


@router.get("/health")
async def health_check():
    return {"status": "ok"}
