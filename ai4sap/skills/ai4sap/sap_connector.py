#!/usr/bin/env python3
"""
SAP ADT Universal Object Connector

A Python client for interacting with SAP systems via REST API (ADT - ABAP Development Tools).
Provides methods to retrieve source code, metadata, and table data from SAP systems.

Features:
- Authentication handling with Basic Auth
- Support for various SAP object types (programs, classes, domains, etc.)
- Special handling for table data via custom endpoints
- Metadata extraction (includes, text symbols)
- Comprehensive error handling
- Configurable via YAML file
- Output to JSON and source files

Example usage:
    connector = SAPConnector(config)
    source_result = connector.get_source("PROG", "ZJQR0000")
    table_result = connector.get_table_data("MARA", rows=10)
"""

import base64
import json
import os
import re
from datetime import datetime
from pathlib import Path
from typing import Dict, Any, List, Optional, Union

import requests

# Try to import dotenv, make it optional
try:
    from dotenv import load_dotenv
    _load_dotenv = load_dotenv
    DOTENV_AVAILABLE = True
except ImportError:
    _load_dotenv = None  # type: ignore
    DOTENV_AVAILABLE = False


# Constants
DEFAULT_TIMEOUT = 30
SUPPORTED_OBJECT_TYPES = {
    "PROG": "/sap/bc/adt/programs/programs",
    "INCLUDE": "/sap/bc/adt/programs/includes",
    "CLASS": "/sap/bc/adt/oo/classes",
    "DOMAIN": "/sap/bc/adt/ddic/domains",
    "DTEL": "/sap/bc/adt/ddic/dtel",
    "TABL": "/sap/bc/adt/ddic/tables",
    "VIEW": "/sap/bc/adt/ddic/views",
}

# Regex patterns
INCLUDE_PATTERN = re.compile(r'INCLUDE\S+(\w+)', re.IGNORECASE)
TEXT_SYMBOL_PATTERN = re.compile(r'TEXT-\d{3}')


class SAPConnector:
    """
    A client for connecting to SAP systems via ADT REST API.
    
    This class provides methods to retrieve various SAP objects including
    programs, classes, domains, data elements, tables, and views, as well as
    table data via custom endpoints.
    """
    
    def __init__(self, config: Dict[str, Any]):
        """
        Initialize the SAP connector with configuration.
        
        Args:
            config: Dictionary containing SAP connection configuration
                   Expected structure:
                   {
                       "SAP_CONFIG": {
                           "USER": str,
                           "PASSWD": str,
                           "CLIENT": str,
                           "LANG": str
                       },
                       "ADT_CONFIG": {
                           "BASE_URL": str
                       }
                   }
        """
        self.base_url = config["ADT_CONFIG"]["BASE_URL"]
        self.user = config["SAP_CONFIG"]["USER"]
        self.passwd = config["SAP_CONFIG"]["PASSWD"]
        self.client = config["SAP_CONFIG"]["CLIENT"]
        self.lang = config["SAP_CONFIG"]["LANG"]
        self.auth_headers = self._get_auth_header()
        
        # Ensure output directory exists
        self.output_dir = Path(__file__).parent / "output"
        self.output_dir.mkdir(exist_ok=True)
    
    def _get_auth_header(self) -> Dict[str, str]:
        """
        Create Basic Authentication header.
        
        Returns:
            Dictionary containing Authorization header
        """
        credentials = f"{self.user}:{self.passwd}"
        encoded = base64.b64encode(credentials.encode()).decode()
        return {"Authorization": f"Basic {encoded}"}
    
    def _get_headers(self, accept: str = "text/plain") -> Dict[str, str]:
        """
        Get standard headers for SAP ADT requests.
        
        Args:
            accept: Accept header value
            
        Returns:
            Dictionary of headers for SAP requests
        """
        headers = self.auth_headers.copy()
        headers.update({
            "Accept": accept,
            "sap-client": self.client,
            "sap-language": self.lang,
        })
        return headers
    
    def _make_request(
        self, 
        method: str, 
        path: str, 
        headers: Optional[Dict[str, str]] = None,
        params: Optional[Dict[str, Any]] = None,
        timeout: int = DEFAULT_TIMEOUT
    ) -> requests.Response:
        """
        Make HTTP request to SAP system.
        
        Args:
            method: HTTP method (GET, POST, etc.)
            path: API path relative to base URL
            headers: Optional headers to include
            params: Optional query parameters
            timeout: Request timeout in seconds
            
        Returns:
            Response object from requests library
        """
        url = f"{self.base_url}{path}"
        if headers is None:
            headers = self._get_headers()
        
        return requests.request(
            method, url, headers=headers, params=params, timeout=timeout
        )
    
    def get_source(self, object_type: str, object_name: str) -> Dict[str, Any]:
        """
        Retrieve source code for a SAP object.
        
        Args:
            object_type: Type of SAP object (PROG, CLASS, etc.)
            object_name: Name of the SAP object
            
        Returns:
            Dictionary containing source code and metadata, or error information
        """
        type_prefix = SUPPORTED_OBJECT_TYPES.get(object_type.upper())
        if not type_prefix:
            return {
                "error": f"Unsupported object type: {object_type}",
                "supported_types": list(SUPPORTED_OBJECT_TYPES.keys())
            }
        
        path = f"{type_prefix}/{object_name}/source/main"
        response = self._make_request("GET", path)
        
        if response.status_code == 200:
            return {
                "success": True,
                "type": object_type,
                "name": object_name,
                "source": response.text,
                "length": len(response.text),
                "timestamp": datetime.now().isoformat()
            }
        elif response.status_code == 401:
            return {"error": "Authentication failed", "status": 401}
        elif response.status_code == 404:
            return {"error": f"Object {object_name} not found", "status": 404}
        else:
            return {
                "error": f"HTTP {response.status_code}",
                "detail": response.text[:500]  # Limit detail length
            }
    
    def get_includes(self, program_name: str) -> List[str]:
        """
        Extract include program names from a main program.
        
        Args:
            program_name: Name of the main program
            
        Returns:
            List of include program names
        """
        path = f"/sap/bc/adt/programs/programs/{program_name}"
        response = self._make_request("GET", path, headers=self._get_headers("application/atom+xml"))
        
        includes = []
        if response.status_code == 200:
            # Extract includes from ATOM XML
            matches = INCLUDE_PATTERN.findall(response.text)
            includes.extend(match.upper() for match in matches)
            
            # Also check source for INCLUDE statements
            source_path = f"/sap/bc/adt/programs/programs/{program_name}/source/main"
            source_resp = self._make_request("GET", source_path)
            if source_resp.status_code == 200:
                source_matches = INCLUDE_PATTERN.findall(source_resp.text)
                includes.extend(match.upper() for match in source_matches)
        
        # Remove duplicates while preserving order
        seen = set()
        return [x for x in includes if not (x in seen or seen.add(x))]
    
    def get_text_symbols(self, object_name: str, object_type: str = "PROG") -> Dict[str, Any]:
        """
        Extract text symbols (TEXT-XXX) from SAP object source.
        
        Args:
            object_name: Name of the SAP object
            object_type: Type of SAP object (PROG or INCLUDE)
            
        Returns:
            Dictionary containing text symbols and count, or error information
        """
        if object_type.upper() not in ("PROG", "INCLUDE"):
            return {
                "error": f"Text symbols not supported for {object_type}",
                "supported_types": ["PROG", "INCLUDE"]
            }
        
        path = (
            f"/sap/bc/adt/programs/programs/{object_name}/source/main"
            if object_type.upper() == "PROG"
            else f"/sap/bc/adt/programs/includes/{object_name}/source/main"
        )
        
        response = self._make_request("GET", path)
        
        if response.status_code == 200:
            symbols = TEXT_SYMBOL_PATTERN.findall(response.text)
            unique_symbols = list(dict.fromkeys(symbols))  # Preserve order, remove duplicates
            return {
                "symbols": unique_symbols,
                "count": len(unique_symbols),
                "object_type": object_type,
                "object_name": object_name
            }
        return {"error": f"HTTP {response.status_code}"}
    
    def get_object_info(self, object_type: str, object_name: str) -> Dict[str, Any]:
        """
        Get metadata information for a SAP object.
        
        Args:
            object_type: Type of SAP object
            object_name: Name of the SAP object
            
        Returns:
            Dictionary containing object metadata or error information
        """
        type_prefix = SUPPORTED_OBJECT_TYPES.get(object_type.upper())
        if not type_prefix:
            return {"error": f"Unsupported type: {object_type}"}
        
        path = f"{type_prefix}/{object_name}"
        response = self._make_request(
            "GET", path, headers=self._get_headers("application/atom+xml")
        )
        
        if response.status_code == 200:
            return {
                "success": True,
                "metadata": response.text,
                "type": object_type,
                "name": object_name
            }
        return {
            "error": f"HTTP {response.status_code}",
            "status": response.status_code
        }
    
    def search_objects(self, query: str, types: Optional[List[str]] = None) -> Dict[str, Any]:
        """
        Search for SAP objects matching a query.
        
        Args:
            query: Search query string
            types: Optional list of object types to search (defaults to all)
            
        Returns:
            Dictionary with search results by object type
        """
        if types is None:
            types = list(SUPPORTED_OBJECT_TYPES.keys())
        
        results = {}
        for obj_type in types:
            type_prefix = SUPPORTED_OBJECT_TYPES.get(obj_type)
            if not type_prefix:
                continue
            
            path = f"{type_prefix}"
            params = {"query": query}
            response = self._make_request(
                "GET", path, 
                headers=self._get_headers("application/atom+xml"),
                params=params
            )
            
            results[obj_type] = {
                "status": response.status_code,
                "success": response.status_code == 200,
                "count": len(response.text.split('<entry')) - 1 if response.status_code == 200 else 0
            }
        
        return results
    
    def get_full_object(self, object_type: str, object_name: str) -> Dict[str, Any]:
        """
        Get complete information for a SAP object including source and metadata.
        
        Args:
            object_type: Type of SAP object
            object_name: Name of the SAP object
            
        Returns:
            Dictionary containing complete object information
        """
        result = {
            "type": object_type,
            "name": object_name,
            "timestamp": datetime.now().isoformat(),
        }
        
        # Get source code
        source_result = self.get_source(object_type, object_name)
        if "source" in source_result:
            result["source"] = source_result["source"]
            result["source_length"] = source_result["length"]
        
        # Get text symbols for programs and includes
        if object_type.upper() in ("PROG", "INCLUDE"):
            text_result = self.get_text_symbols(object_name, object_type)
            if "symbols" in text_result:
                result["text_symbols"] = text_result["symbols"]
        
        # Get includes for programs
        if object_type.upper() == "PROG":
            includes = self.get_includes(object_name)
            result["includes"] = includes  # type: ignore
        
        return result
    
    def get_table_data(self, table_name: str, rows: Optional[int] = None) -> Dict[str, Any]:
        """
        Fetch table data via custom endpoint.
        
        Args:
            table_name: Name of the SAP table
            rows: Optional maximum number of rows to return
            
        Returns:
            Dictionary containing table data or error information
        """
        path = "/sap/bc/zzjq"
        params = {
            "sap-client": self.client,
            "table": table_name
        }
        
        # Add rows parameter if specified
        if rows is not None and rows > 0:
            params["rows"] = rows
        
        response = self._make_request(
            "GET", path,
            headers=self._get_headers("application/json"),
            params=params
        )
        
        if response.status_code == 200:
            try:
                return {"data": response.json()}
            except json.JSONDecodeError:
                return {
                    "data": response.text,
                    "note": "Response is not valid JSON",
                    "content_type": response.headers.get("content-type", "unknown")
                }
        elif response.status_code == 401:
            return {"error": "Authentication failed", "status": 401}
        elif response.status_code == 404:
            return {
                "error": f"Endpoint or table {table_name} not found",
                "status": 404,
                "suggestion": "Check if the custom endpoint /sap/bc/zzjq is available"
            }
        else:
            return {
                "error": f"HTTP {response.status_code}",
                "detail": response.text[:500]
            }
    
    def save_results(self, result: Dict[str, Any], filename: str) -> Path:
        """
        Save result dictionary to JSON file.
        
        Args:
            result: Dictionary to save
            filename: Name of the output file
            
        Returns:
            Path to the saved file
        """
        output_file = self.output_dir / filename
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(result, f, ensure_ascii=False, indent=2)
        return output_file
    
    def save_source(self, source: str, filename: str) -> Path:
        """
        Save source code to text file.
        
        Args:
            source: Source code string
            filename: Name of the output file
            
        Returns:
            Path to the saved file
        """
        output_file = self.output_dir / filename
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(source)
        return output_file


def load_config(env_path: Optional[Union[str, Path]] = None) -> Dict[str, Any]:
    """
    Load SAP configuration from .env file.
    
    Configuration is read from .env file with following variables:
    - SAP_USER: SAP username
    - SAP_PASSWORD: SAP password
    - SAP_CLIENT: SAP client (e.g., "400")
    - SAP_LANG: SAP language (e.g., "ZH" or "EN")
    - SAP_HOST: SAP host (e.g., "mysap.goodsap.cn")
    - SAP_PORT: SAP port (e.g., "50400")
    - SAP_PROTOCOL: SAP protocol (http or https)
    
    Args:
        env_path: Path to .env file (defaults to .env in skill directory)
        
    Returns:
        Dictionary containing configuration compatible with SAPConnector
    """
    if env_path is None:
        env_path = Path(__file__).parent / ".env"
    
    # Try to load from .env file
    if os.path.exists(env_path) and _load_dotenv:
        _load_dotenv(env_path)
    
    # Also check environment variables directly
    config = {
        "SAP_CONFIG": {
            "USER": os.getenv("SAP_USER", ""),
            "PASSWD": os.getenv("SAP_PASSWORD", ""),
            "CLIENT": os.getenv("SAP_CLIENT", "400"),
            "LANG": os.getenv("SAP_LANG", "ZH"),
        },
        "ADT_CONFIG": {
            "BASE_URL": os.getenv("SAP_BASE_URL", ""),
        }
    }
    
    # Construct BASE_URL if not explicitly provided
    if not config["ADT_CONFIG"]["BASE_URL"]:
        protocol = os.getenv("SAP_PROTOCOL", "http")
        host = os.getenv("SAP_HOST", "")
        port = os.getenv("SAP_PORT", "")
        if host:
            config["ADT_CONFIG"]["BASE_URL"] = f"{protocol}://{host}:{port}"
    
    return config


def main() -> None:
    """
    Main function demonstrating SAP connector usage.
    
    This function shows how to:
    1. Load configuration from .env
    2. Initialize the SAP connector
    3. Retrieve various SAP objects
    4. Save results to files
    """
    # Load configuration from .env
    config = load_config()
    conn = SAPConnector(config)
    
    print("=" * 60)
    print("SAP ADT Universal Object Connector")
    print("=" * 60)
    print(f"Target: {config['ADT_CONFIG']['BASE_URL']}")
    print(f"User: {config['SAP_CONFIG']['USER']}")
    print(f"Client: {config['SAP_CONFIG']['CLIENT']}")
    print("=" * 60)
    
    # Test objects to retrieve
    test_objects = [
        ("PROG", "ZJQR0000"),
        ("INCLUDE", "ZJQR0000_FRM"),
        ("CLASS", "ZCL_TEST"),
    ]
    
    results = {}
    for obj_type, obj_name in test_objects:
        print(f"\n[{obj_type}] Retrieving {obj_name}...")
        result = conn.get_full_object(obj_type, obj_name)
        results[obj_name] = result
        
        # Save JSON result
        json_file = conn.save_results(result, f"{obj_name}_{obj_type.lower()}.json")
        print(f"Saved to: {json_file}")
        
        # Save source if available
        if "source" in result:
            src_file = conn.save_source(result["source"], f"{obj_name}_{obj_type.lower()}.src")
            print(f"Source ({result['source_length']} chars) saved to: {src_file}")
        
        # Print additional information
        if "includes" in result:
            print(f"Includes: {', '.join(result['includes'])}")
        if "text_symbols" in result:
            print(f"Text symbols: {len(result['text_symbols'])}")
    
    # Test summary
    print("\n" + "=" * 60)
    print("Test Summary")
    print("=" * 60)
    for obj_name, result in results.items():
        status = "SUCCESS" if "source" in result else f"FAILED: {result.get('error', 'Unknown')}"
        print(f"  {result['type']}/{obj_name}: {status}")
    
    # Test table data retrieval via custom endpoint
    print("\n[Table] Retrieving MARA data via custom endpoint /sap/bc/zzjq...")
    table_result = conn.get_table_data("MARA", rows=3)
    table_output = conn.save_results(table_result, "mara_table_data.json")
    print(f"Saved to: {table_output}")
    
    if "data" in table_result:
        data = table_result["data"]
        if isinstance(data, dict):
            print(f"SUCCESS: Retrieved MARA data (JSON) with keys: {list(data.keys())}")
        elif isinstance(data, list):
            print(f"SUCCESS: Retrieved MARA data (list format) with {len(data)} records")
            if len(data) > 0 and isinstance(data[0], dict):
                print(f"Record fields: {list(data[0].keys())}")
        else:
            print(f"SUCCESS: Retrieved MARA data (type: {type(data)}, length: {len(str(data))} characters)")
    else:
        print(f"ERROR: {table_result.get('error', 'Unknown error')}")
    
    print("=" * 60)


if __name__ == "__main__":
    main()