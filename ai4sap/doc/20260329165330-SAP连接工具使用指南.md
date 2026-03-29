# SAP ADT Universal Object Connector

## Overview
A comprehensive Python connector for accessing SAP ABAP Development Tools (ADT) REST API. Supports retrieval of multiple object types including programs, includes, classes, domains, and more.

## Supported Object Types

| Type | Description | API Path |
|------|-------------|----------|
| PROG | ABAP Program/Report | `/sap/bc/adt/programs/programs/{name}` |
| INCLUDE | Program Include | `/sap/bc/adt/programs/includes/{name}` |
| CLASS | ABAP Class | `/sap/bc/adt/oo/classes/{name}` |
| DOMAIN | Data Element Domain | `/sap/bc/adt/ddic/domains/{name}` |
| DTEL | Data Element | `/sap/bc/adt/ddic/dtel/{name}` |
| TABL | Database Table | `/sap/bc/adt/ddic/tables/{name}` |
| VIEW | Database View | `/sap/bc/adt/ddic/views/{name}` |

## Configuration

```yaml
SAP_CONFIG:
  USER: U1170
  PASSWD: hysoft888999
  CLIENT: "400"
  LANG: ZH

ADT_CONFIG:
  ADT_PROTOCOL: http
  ADT_HOST: mysap.goodsap.cn
  ADT_PORT: 50400
  BASE_URL: http://mysap.goodsap.cn:50400
```

## Usage

### Basic Usage

```python
from sap_connector import SAPConnector, load_config

config = load_config()
conn = SAPConnector(config)

# Get program source
result = conn.get_source("PROG", "ZJQR0000")

# Get class source
result = conn.get_source("CLASS", "ZCL_TEST")

# Get include source
result = conn.get_source("INCLUDE", "ZJQR0000_FRM")
```

### Full Object Retrieval

```python
# Get complete object with all metadata
result = conn.get_full_object("PROG", "ZJQR0000")
# Returns:
# {
#   "type": "PROG",
#   "name": "ZJQR0000",
#   "source": "...",
#   "source_length": 506,
#   "text_symbols": [],
#   "includes": ["ZJQR0000_FRM"]
# }
```

## Test Results

### Object Retrieval Test (2026-03-29)

| Object | Type | Status | Source Length |
|--------|------|--------|---------------|
| ZJQR0000 | PROG | ✅ SUCCESS | 506 chars |
| ZJQR0000_FRM | INCLUDE | ✅ SUCCESS | 1202 chars |
| ZCL_TEST | CLASS | ✅ SUCCESS | 2530 chars |

### ZJQR0000 Program Structure

```
ZJQR0000 (PROG)
├── INCLUDE: ZJQR0000_FRM
│   ├── FORM: frm_add_num
│   └── FORM: frm_write_hello
├── Variables: a, b, c (TYPE i)
└── Text Symbols: 0
```

## API Endpoints Verified

| Endpoint | Status | Purpose |
|----------|--------|---------|
| `/sap/bc/adt/programs/programs/{name}/source/main` | ✅ | Program source |
| `/sap/bc/adt/programs/includes/{name}/source/main` | ✅ | Include source |
| `/sap/bc/adt/oo/classes/{name}/source/main` | ✅ | Class source |
| `/sap/bc/adt/ddic/domains/{name}/source/main` | ❌ | Domain source (not enabled) |
| `/sap/bc/adt/ddic/dtel/{name}/source/main` | ❌ | DTEL source (not enabled) |

## Files Generated

- `output/ZJQR0000_prog.json` - Program metadata and source
- `output/ZJQR0000_prog.src` - Program source only
- `output/ZJQR0000_FRM_include.json` - Include metadata
- `output/ZJQR0000_FRM_include.src` - Include source only
- `output/ZCL_TEST_class.json` - Class metadata
- `output/ZCL_TEST_class.src` - Class source only
