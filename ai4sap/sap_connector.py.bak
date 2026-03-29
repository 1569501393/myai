#!/usr/bin/env python3
import requests
import base64
import json
import yaml
from datetime import datetime, timedelta
from pathlib import Path

CONFIG_PATH = Path(__file__).parent / "config" / "sap_config.yaml"
OUTPUT_DIR = Path(__file__).parent / "output"


def load_config():
    with open(CONFIG_PATH, "r") as f:
        return yaml.safe_load(f)


def get_auth_header(user, passwd):
    credentials = f"{user}:{passwd}"
    encoded = base64.b64encode(credentials.encode()).decode()
    return {"Authorization": f"Basic {encoded}"}


class SAPConnector:
    SUPPORTED_TYPES = {
        "PROG": "/sap/bc/adt/programs/programs",
        "INCLUDE": "/sap/bc/adt/programs/includes",
        "CLASS": "/sap/bc/adt/oo/classes",
        "DOMAIN": "/sap/bc/adt/ddic/domains",
        "DTEL": "/sap/bc/adt/ddic/dtel",
        "TABL": "/sap/bc/adt/ddic/tables",
        "VIEW": "/sap/bc/adt/ddic/views",
    }

    def __init__(self, config):
        self.base_url = config["ADT_CONFIG"]["BASE_URL"]
        self.user = config["SAP_CONFIG"]["USER"]
        self.passwd = config["SAP_CONFIG"]["PASSWD"]
        self.client = config["SAP_CONFIG"]["CLIENT"]
        self.lang = config["SAP_CONFIG"]["LANG"]
        self.auth_headers = get_auth_header(self.user, self.passwd)

    def _get_headers(self, accept="text/plain"):
        headers = self.auth_headers.copy()
        headers.update({
            "Accept": accept,
            "sap-client": self.client,
            "sap-language": self.lang,
        })
        return headers

    def _request(self, method, path, headers=None, params=None, timeout=30):
        url = f"{self.base_url}{path}"
        if headers is None:
            headers = self._get_headers()

        response = requests.request(
            method, url, headers=headers, params=params, timeout=timeout
        )
        return response

    def get_source(self, object_type, object_name):
        type_prefix = self.SUPPORTED_TYPES.get(object_type.upper())
        if not type_prefix:
            return {"error": f"Unsupported type: {object_type}"}

        path = f"{type_prefix}/{object_name}/source/main"
        response = self._request("GET", path)

        if response.status_code == 200:
            return {
                "success": True,
                "type": object_type,
                "name": object_name,
                "source": response.text,
                "length": len(response.text),
            }
        elif response.status_code == 401:
            return {"error": "Authentication failed", "status": 401}
        elif response.status_code == 404:
            return {"error": f"Object {object_name} not found", "status": 404}
        else:
            return {"error": f"HTTP {response.status_code}", "detail": response.text}

    def get_includes(self, program_name):
        path = f"/sap/bc/adt/programs/programs/{program_name}"
        response = self._request("GET", path, headers=self._get_headers("application/atom+xml"))

        includes = []
        if response.status_code == 200:
            import re
            pattern = r'adt:uri="([^"]*includes/[^"]*)"'
            matches = re.findall(pattern, response.text)
            for match in matches:
                name = match.split("/")[-1] if "/" in match else match
                includes.append(name)

        source_path = f"/sap/bc/adt/programs/programs/{program_name}/source/main"
        source_resp = self._request("GET", source_path)
        if source_resp.status_code == 200:
            import re
            include_pattern = r'INCLUDE\s+(\w+)'
            for match in re.finditer(include_pattern, source_resp.text, re.IGNORECASE):
                inc_name = match.group(1).upper()
                if inc_name not in includes:
                    includes.append(inc_name)

        return includes

    def get_text_symbols(self, object_name, object_type="PROG"):
        if object_type == "PROG":
            path = f"/sap/bc/adt/programs/programs/{object_name}/source/main"
        elif object_type == "INCLUDE":
            path = f"/sap/bc/adt/programs/includes/{object_name}/source/main"
        else:
            return {"error": f"Text symbols not supported for {object_type}"}

        response = self._request("GET", path)

        if response.status_code == 200:
            import re
            symbols = []
            for match in re.finditer(r"TEXT-\d{3}", response.text):
                if match.group() not in symbols:
                    symbols.append(match.group())
            return {"symbols": symbols, "count": len(symbols)}
        return {"error": f"HTTP {response.status_code}"}

    def get_object_info(self, object_type, object_name):
        type_prefix = self.SUPPORTED_TYPES.get(object_type.upper())
        if not type_prefix:
            return {"error": f"Unsupported type: {object_type}"}

        path = f"{type_prefix}/{object_name}"
        response = self._request("GET", path, headers=self._get_headers("application/atom+xml"))

        if response.status_code == 200:
            return {"success": True, "metadata": response.text}
        return {"error": f"HTTP {response.status_code}", "status": response.status_code}

    def search_objects(self, query, types=None):
        if types is None:
            types = list(self.SUPPORTED_TYPES.keys())

        results = {}
        for obj_type in types:
            type_prefix = self.SUPPORTED_TYPES.get(obj_type)
            if not type_prefix:
                continue

            path = f"{type_prefix}"
            params = {"query": query}
            response = self._request("GET", path, headers=self._get_headers("application/atom+xml"), params=params)

            results[obj_type] = {
                "status": response.status_code,
                "success": response.status_code == 200,
            }

        return results

    def get_full_object(self, object_type, object_name):
        result = {
            "type": object_type,
            "name": object_name,
            "timestamp": datetime.now().isoformat(),
        }

        source_result = self.get_source(object_type, object_name)
        if "source" in source_result:
            result["source"] = source_result["source"]
            result["source_length"] = source_result["length"]

        if object_type.upper() in ("PROG", "INCLUDE"):
            text_result = self.get_text_symbols(object_name, object_type.upper())
            if "symbols" in text_result:
                result["text_symbols"] = text_result["symbols"]

        if object_type.upper() == "PROG":
            includes = self.get_includes(object_name)
            result["includes"] = includes

        return result


def get_mara_data(config, days=3):
    conn = SAPConnector(config)
    cutoff_date = (datetime.now() - timedelta(days=days)).strftime("%Y%m%d")

    endpoints_to_try = [
        "/sap/bc/rest/odi/v3/mara",
        "/sap/bc/rest/odi/mara",
        "/sap/bc/adt/ddic/tables/mara/data"
    ]

    for path in endpoints_to_try:
        response = conn._request("GET", path, headers=conn._get_headers("application/json"))
        if response.status_code == 200:
            return {"data": response.json(), "endpoint": path}

    return {
        "error": "All endpoints failed",
        "endpoints_tried": endpoints_to_try,
        "note": "SAP ADT table access may not be enabled on this system."
    }


def main():
    OUTPUT_DIR.mkdir(exist_ok=True)
    config = load_config()
    conn = SAPConnector(config)

    print("=" * 60)
    print("SAP ADT Universal Object Connector")
    print("=" * 60)
    print(f"Target: {config['ADT_CONFIG']['BASE_URL']}")
    print(f"User: {config['SAP_CONFIG']['USER']}")
    print(f"Client: {config['SAP_CONFIG']['CLIENT']}")
    print("=" * 60)

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

        output_file = OUTPUT_DIR / f"{obj_name}_{obj_type.lower()}.json"
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(result, f, ensure_ascii=False, indent=2)
        print(f"Saved to: {output_file}")

        if "source" in result:
            src_file = OUTPUT_DIR / f"{obj_name}_{obj_type.lower()}.src"
            with open(src_file, "w", encoding="utf-8") as f:
                f.write(result["source"])
            print(f"Source ({result['source_length']} chars) saved to: {src_file}")

        if "includes" in result:
            print(f"Includes: {', '.join(result['includes'])}")
        if "text_symbols" in result:
            print(f"Text symbols: {len(result['text_symbols'])}")

    print("\n" + "=" * 60)
    print("Test Summary")
    print("=" * 60)
    for obj_name, result in results.items():
        status = "SUCCESS" if "source" in result else f"FAILED: {result.get('error', 'Unknown')}"
        print(f"  {result['type']}/{obj_name}: {status}")

    print("=" * 60)


if __name__ == "__main__":
    main()
