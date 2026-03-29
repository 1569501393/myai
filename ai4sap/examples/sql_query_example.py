#!/usr/bin/env python3
"""
SAP SQL Query API Client Examples.

Usage:
    python sql_query_example.py
"""

import requests
import json


SAP_URL = "http://mysap.goodsap.cn:50400"
SAP_USER = "U1170"
SAP_PASSWORD = "hysoft888999"
SAP_CLIENT = "400"


def query_raw_sql(sql: str, maxrows: int = 10):
    url = f"{SAP_URL}/sap/bc/zzsql"
    params = {
        "sap-client": SAP_CLIENT,
        "sql": sql,
        "maxrows": str(maxrows),
    }
    response = requests.get(url, params=params, auth=(SAP_USER, SAP_PASSWORD))
    return response.json()


def query_table(table: str, fields: str = None, where: str = None, limit: int = 10):
    sql = f"SELECT {fields or '*'} FROM {table}"
    if where:
        sql += f" WHERE {where}"
    sql += f" LIMIT {limit}"
    return query_raw_sql(sql, limit)


def main():
    print("=" * 60)
    print("SAP SQL Query Examples")
    print("=" * 60)

    print("\n1. Query MARA table (raw SQL):")
    result = query_raw_sql("SELECT * FROM mara", 3)
    print(f"   Rows: {len(result)}")

    print("\n2. Query MARA with fields:")
    result = query_raw_sql("SELECT matnr, mtart, mbrsh FROM mara", 3)
    print(f"   Rows: {len(result)}")

    print("\n3. Query MARA with WHERE:")
    result = query_raw_sql("SELECT matnr, mtart FROM mara WHERE mtart = 'HALB'", 3)
    print(f"   Rows: {len(result)}")

    print("\n4. Query custom table ZTJQ0003:")
    result = query_raw_sql("SELECT * FROM ztjq0003", 3)
    print(f"   Rows: {len(result)}")

    print("\n" + "=" * 60)


if __name__ == "__main__":
    main()
