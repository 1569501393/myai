#!/usr/bin/env python3
"""
Example: Get source code for SAP objects using ADT REST API
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
    
    objects = [
        ("PROG", "ZJQR0000"),
        ("CLASS", "ZCL_TEST")
    ]
    
    for obj_type, obj_name in objects:
        print(f"\nFetching source for {obj_type}: {obj_name}")
        result = conn.get_full_object(obj_type, obj_name)
        
        output_dir = Path(__file__).parent.parent / "output"
        output_dir.mkdir(exist_ok=True)
        output_file = output_dir / f"example_{obj_name}_{obj_type.lower()}.json"
        
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(result, f, ensure_ascii=False, indent=2)
        
        print(f"Result saved to: {output_file}")
        
        if "source" in result:
            print(f"SUCCESS: Retrieved source code ({result['source_length']} characters)")
            if obj_type.upper() in ("PROG", "INCLUDE"):
                if "includes" in result:
                    print(f"Includes: {', '.join(result['includes'])}")
                if "text_symbols" in result:
                    print(f"Text symbols found: {len(result['text_symbols'])}")
        else:
            print(f"ERROR: {result.get('error', 'Unknown error')}")

if __name__ == "__main__":
    main()