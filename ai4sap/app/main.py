"""
FastAPI application for SAP SQL query REST API.
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api import routes


app = FastAPI(
    title="SAP SQL Query API",
    description="REST API for executing SQL queries on SAP ECC systems",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(routes.router, prefix="/api/sap", tags=["SAP"])


@app.get("/")
async def root():
    return {
        "service": "SAP SQL Query API",
        "version": "1.0.0",
        "endpoints": {
            "query": "POST /api/sap/query - Execute raw SQL",
            "table": "POST /api/sap/table - Query table with parameters",
            "health": "GET /api/sap/health",
        },
    }
