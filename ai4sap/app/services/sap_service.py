"""
SAP service for executing queries.
"""

import base64
import json
import time
import requests
from typing import Dict, Any, Optional, List


class SAPService:
    def __init__(self, base_url: str, username: str, password: str, client: str = "400"):
        self.base_url = base_url
        self.username = username
        self.password = password
        self.client = client
        self.auth = (username, password)

    def _get_headers(self) -> Dict[str, str]:
        return {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "sap-client": self.client,
        }

    def execute_sql(self, sql: str, max_rows: int = 100) -> Dict[str, Any]:
        start_time = time.time()
        
        url = f"{self.base_url}/sap/bc/zzsql"
        params = {
            "sap-client": self.client,
            "sql": sql[:2000],
            "maxrows": str(max_rows),
        }
        
        try:
            response = requests.get(
                url,
                params=params,
                auth=self.auth,
                headers=self._get_headers(),
                timeout=30,
            )
            
            execution_time = (time.time() - start_time) * 1000
            
            if response.status_code == 200:
                try:
                    data = response.json()
                    if isinstance(data, list):
                        return {
                            "success": True,
                            "data": data[:max_rows],
                            "row_count": len(data),
                            "execution_time_ms": round(execution_time, 2),
                        }
                    return {
                        "success": True,
                        "data": data.get("data", []),
                        "row_count": data.get("row_count", 0),
                        "execution_time_ms": round(execution_time, 2),
                    }
                except json.JSONDecodeError:
                    return {
                        "success": True,
                        "data": [{"raw": response.text}],
                        "row_count": 1,
                        "execution_time_ms": round(execution_time, 2),
                    }
            else:
                return {
                    "success": False,
                    "error": f"HTTP {response.status_code}: {response.text[:200]}",
                    "execution_time_ms": round(execution_time, 2),
                }
                
        except requests.RequestException as e:
            return {
                "success": False,
                "error": str(e),
                "execution_time_ms": (time.time() - start_time) * 1000,
            }

    def query_table(
        self,
        table: str,
        fields: Optional[str] = None,
        where: Optional[str] = None,
        order_by: Optional[str] = None,
        limit: int = 10,
        offset: int = 0,
    ) -> Dict[str, Any]:
        field_list = fields or "*"
        sql = f"SELECT {field_list} FROM {table}"
        
        if where:
            sql += f" WHERE {where}"
        if order_by:
            sql += f" ORDER BY {order_by}"
        if limit:
            sql += f" LIMIT {limit}"
        if offset:
            sql += f" OFFSET {offset}"
        
        return self.execute_sql(sql, max_rows=limit + offset)
