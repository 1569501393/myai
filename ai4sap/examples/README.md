# SAP Connector Examples

This directory contains example scripts demonstrating how to use the SAP connector for various tasks.

## Examples

1. `read_table_mara.py` - Demonstrates reading MARA table data via the custom endpoint `/sap/bc/zzjq`
2. `get_program_source.py` - Demonstrates retrieving source code for SAP programs using ADT REST API

## Usage

Each example can be run directly:

```bash
python read_table_mara.py
python get_program_source.py
```

Before running, ensure:
1. The SAP connector (`sap_connector.py`) is in the parent directory
2. The configuration file (`config/sap_config.yaml`) is properly set up
3. You have network access to the SAP system

## Output

Examples save their results to the `output/` directory in JSON format for further processing.