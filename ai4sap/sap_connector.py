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


def get_mara_data(config, days=3):
    base_url = config["ADT_CONFIG"]["BASE_URL"]
    user = config["SAP_CONFIG"]["USER"]
    passwd = config["SAP_CONFIG"]["PASSWD"]
    client = config["SAP_CONFIG"]["CLIENT"]
    lang = config["SAP_CONFIG"]["LANG"]

    headers = get_auth_header(user, passwd)
    headers.update({
        "Content-Type": "application/json",
        "Accept": "application/json",
        "sap-client": client,
        "sap-language": lang
    })

    cutoff_date = (datetime.now() - timedelta(days=days)).strftime("%Y%m%d")

    endpoints_to_try = [
        f"{base_url}/sap/bc/rest/odi/v3/mara",
        f"{base_url}/sap/bc/rest/odi/mara",
        f"{base_url}/sap/bc/adt/ddic/tables/mara/data"
    ]

    for url in endpoints_to_try:
        params = {
            "$filter": f"ersda ge '{cutoff_date}'",
            "$top": 100
        }
        response = requests.get(url, headers=headers, params=params, timeout=30)
        if response.status_code == 200:
            return {"data": response.json(), "endpoint": url}

    return {
        "error": "All endpoints failed",
        "endpoints_tried": endpoints_to_try,
        "last_status": response.status_code,
        "note": "SAP ADT table access may not be enabled on this system. Program source retrieval works."
    }


def get_program_source(config, program_name):
    base_url = config["ADT_CONFIG"]["BASE_URL"]
    user = config["SAP_CONFIG"]["USER"]
    passwd = config["SAP_CONFIG"]["PASSWD"]
    client = config["SAP_CONFIG"]["CLIENT"]
    lang = config["SAP_CONFIG"]["LANG"]

    headers = get_auth_header(user, passwd)
    headers.update({
        "Accept": "text/plain",
        "sap-client": client,
        "sap-language": lang
    })

    url = f"{base_url}/sap/bc/adt/programs/programs/{program_name}/source/main"

    response = requests.get(url, headers=headers, timeout=30)

    if response.status_code == 200:
        return {"source": response.text, "program": program_name}
    elif response.status_code == 401:
        return {"error": "Authentication failed", "status": 401}
    elif response.status_code == 404:
        return {"error": f"Program {program_name} not found", "status": 404}
    else:
        return {"error": f"HTTP {response.status_code}", "detail": response.text}


def main():
    OUTPUT_DIR.mkdir(exist_ok=True)

    config = load_config()

    print("=" * 50)
    print("SAP Connection Test")
    print("=" * 50)
    print(f"Target: {config['ADT_CONFIG']['BASE_URL']}")
    print(f"User: {config['SAP_CONFIG']['USER']}")
    print(f"Client: {config['SAP_CONFIG']['CLIENT']}")
    print("=" * 50)

    print("\n[1] Testing MARA table data (last 3 days)...")
    mara_result = get_mara_data(config, days=3)

    mara_output = OUTPUT_DIR / "mara_data.json"
    with open(mara_output, "w", encoding="utf-8") as f:
        json.dump(mara_result, f, ensure_ascii=False, indent=2)
    print(f"Result saved to: {mara_output}")

    if "error" in mara_result:
        print(f"ERROR: {mara_result['error']}")
    else:
        print(f"SUCCESS: Retrieved MARA data")

    print("\n[2] Testing ZJQR0000 program source...")
    source_result = get_program_source(config, "ZJQR0000")

    source_output = OUTPUT_DIR / "ZJQR0000_source.txt"
    if "source" in source_result:
        with open(source_output, "w", encoding="utf-8") as f:
            f.write(source_result["source"])
        print(f"Result saved to: {source_output}")
        print(f"SUCCESS: Retrieved source code ({len(source_result['source'])} chars)")
    else:
        with open(source_output, "w", encoding="utf-8") as f:
            json.dump(source_result, f, ensure_ascii=False, indent=2)
        print(f"ERROR: {source_result.get('error', 'Unknown error')}")

    print("\n" + "=" * 50)
    print("Connection test completed")
    print("=" * 50)


if __name__ == "__main__":
    main()
