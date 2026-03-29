#!/usr/bin/env python3
"""
Example: Get source code for an SAP program using ADT REST API
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
    
    programs = ["ZJQR0000", "ZCL_TEST"]
    
    for prog_name in programs:
        print(f"\nFetching source for program: {prog_name}")
        result = conn.get_full_object("PROG", prog_name)
        
        output_dir = Path(__file__).parent.parent / "output"
        output_dir.mkdir(exist_ok=True)
        output_file = output_dir / f"example_{prog_name}_source.json"
        
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(result, f, ensure_ascii=False, indent=2)
        
        print(f"Result saved to: {output_file}")
        
        if "source" in result:
            print(f"SUCCESS: Retrieved source code ({result['source_length']} characters)")
            if "includes" in result:
                print(f"Includes: {', '.join(result['includes'])}")
            if "text_symbols" in result:
                print(f"Text symbols found: {len(result['text_symbols'])}")
        else:
            print(f"ERROR: {result.get('error', 'Unknown error')}")

if __name__ == "__main__":
    main()