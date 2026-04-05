# SAP User U1170 Objects Inventory

## Overview

This document lists all ABAP objects created by user **U1170** on SAP system `mysap.goodsap.cn:50400` (Client 400).

## Object List

| Type | Object Name | Description |
|------|-------------|-------------|
| PROG | ZJQR0000 | Main report program |
| PROG | ZJQR0000_OPENCODE2 | Test program |
| PROG | ZJQR0000_OPENCODE3 | Test program |
| PROG | ZJQR0000_OPENCODE6 | Test program |
| INCL | ZJQR0000_FRM | Include with form routines |
| CLASS | ZCL_TEST | Test class |
| TABL | ZTJQ0003 | Custom table |

## Summary

- **Programs (PROG)**: 4
- **Includes (INCL)**: 1
- **Classes (CLASS)**: 1
- **Tables (TABL)**: 1
- **Total Objects**: 7

## Source Code Retrieval

To retrieve source code using the ai4sap skill:

```python
from skills.ai4sap.sap_connector import SAPConnector

connector = SAPConnector()

# Get program source
source = connector.get_source("PROG", "ZJQR0000")

# Get include source
source = connector.get_source("PROG", "ZJQR0000_FRM")

# Get class definition
source = connector.get_source("CLASS", "ZCL_TEST")

# Get table definition
source = connector.get_source("TABL", "ZTJQ0003")
```

## Last Updated

- Date: 2026-04-04
- SAP System: mysap.goodsap.cn:50400
- Client: 400
- User: U1170
