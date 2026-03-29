#!/usr/bin/env python3
"""
Example: Read MARA table data using the custom endpoint /sap/bc/zzjq
"""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from sap_connector import SAPConnector
import yaml
from pathlib import Path
import json

def main():
    config_path = Path(__file__).parent.parent / "config" / "sap_config.yaml"
    with open(config_path, "r") as f:
        config = yaml.safe_load(f)
    
    conn = SAPConnector(config)
    
    print("Fetching MARA table data via custom endpoint /sap/bc/zzjq...")
    result = conn.get_table_data("MARA", rows=5)
    
    output_dir = Path(__file__).parent.parent / "output"
    output_dir.mkdir(exist_ok=True)
    output_file = output_dir / "example_mara_data.json"
    
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(result, f, ensure_ascii=False, indent=2)
    
    print(f"Result saved to: {output_file}")
    
    if "data" in result:
        data = result["data"]
        if isinstance(data, dict):
            print(f"Successfully retrieved MARA data (JSON format) with keys: {list(data.keys())}")
        elif isinstance(data, list):
            print(f"Successfully retrieved MARA data (list format) with {len(data)} records")
            if len(data) > 0:
                if isinstance(data[0], dict):
                    print(f"Record fields: {list(data[0].keys())}")
                else:
                    print(f"First record type: {type(data[0])}")
        else:
            print(f"Successfully retrieved MARA data (type: {type(data)}, length: {len(str(data))} characters)")
            # Try to parse as JSON if it looks like JSON
            text = str(data).strip()
            if text.startswith('{') or text.startswith('['):
                try:
                    parsed = json.loads(text)
                    print(f"Parsed JSON contains: {type(parsed)}")
                except:
                    pass
    else:
        print(f"Error: {result.get('error', 'Unknown error')}")

if __name__ == "__main__":
    main()