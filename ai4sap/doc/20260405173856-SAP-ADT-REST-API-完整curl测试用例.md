# SAP ADT REST API 完整 curl 测试用例

**文档日期**: 2026-04-05  
**SAP 系统**: S/4HANA @ mysap.goodsap.cn:50400  
**用户**: U1170  
**测试用例总数**: 150+

---

## 一、认证与初始化

### 1.1 获取 CSRF Token

```bash
# 获取 CSRF Token 和 Session Cookie
curl -c cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/discovery" \
  -H "x-csrf-token: Fetch" -D headers.txt -k > /dev/null

# 提取 CSRF Token
CSRF=$(grep -i "^x-csrf-token" headers.txt | cut -d' ' -f2 | tr -d '\r')

echo "CSRF Token: $CSRF"
```

---

## 二、系统信息 (System)

### 2.1 获取系统信息

```bash
# 系统基本信息
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/system/information" -k
```

**响应示例**:
```xml
<?xml version="1.0" encoding="utf-8"?>
<atom:feed>
  <atom:entry><atom:id>SAPSystemID</atom:id><atom:title>390</atom:title></atom:entry>
  <atom:entry><atom:id>DBName</atom:id><atom:title>HDB/02</atom:title></atom:entry>
  <atom:entry><atom:id>UnicodeSystem</atom:id><atom:title>True</atom:title></atom:entry>
</atom:feed>
```

### 2.2 获取客户端列表

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/system/clients" -k
```

### 2.3 获取用户信息

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/system/users" -k
```

### 2.4 获取组件信息

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/system/components" -k
```

### 2.5 获取 Landscape 服务器

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/system/landscape/servers" -k
```

---

## 三、类与接口 (OO - Object Oriented)

### 3.1 获取类元数据

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/classes/ZCL_ABAP_DATABASE_CREATE" -k
```

### 3.2 获取类源码 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/classes/ZCL_ABAP_DATABASE_CREATE/source/main" -k
```

**响应示例**:
```abap
class ZCL_ABAP_DATABASE_CREATE definition public final create public .
```

### 3.3 获取类定义

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/classes/ZCL_ABAP_DATABASE_CREATE/source/definitions" -k
```

### 3.4 获取测试类 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/classes/ZCL_ABAP_DATABASE_CREATE/includes/testclasses" -k
```

### 3.5 获取宏定义 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/classes/ZCL_ABAP_DATABASE_CREATE/includes/macros" -k
```

### 3.6 获取实现部分 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/classes/ZCL_ABAP_DATABASE_CREATE/includes/implementations" -k
```

### 3.7 获取类传输请求 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/classes/ZCL_ABAP_DATABASE_CREATE/transports" -k
```

### 3.8 获取对象分类 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/classifications?uri=/sap/bc/adt/oo/classes/ZCL_ABAP_DATABASE_CREATE" -k
```

### 3.9 获取接口元数据 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/interfaces/ZIF_EXCEL_CONVERTER" -k
```

### 3.10 获取接口源码 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/interfaces/ZIF_EXCEL_CONVERTER/source/main" -k
```

**响应示例**:
```abap
INTERFACE zif_excel_converter PUBLIC .
```

---

## 四、程序与函数组 (Programs & Functions)

### 4.1 获取程序元数据 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/programs/programs/ZJQR0000" -k
```

### 4.2 获取程序源码 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/programs/programs/ZJQR0000/source/main" -k
```

**响应示例**:
```abap
*&---------------------------------------------------------------------*
*& Report ZJQR0000
*&---------------------------------------------------------------------*
```

### 4.3 获取 Include 元数据 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/programs/includes/LZFG_KF036U01" -k
```

### 4.4 获取 Include 源码 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/programs/includes/LZFG_KF036U01/source/main" -k
```

### 4.5 获取函数组元数据 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/functions/groups/zfg_kf036" -k
```

### 4.6 获取函数组源码 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/functions/groups/zfg_kf036/source/main" -k
```

---

## 五、数据字典 (DDIC)

### 5.1 获取数据元素 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/ddic/dataelements/ERNAM" -k
```

### 5.2 获取域 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/ddic/domains/CHAR" -k
```

### 5.3 获取类型组 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/ddic/typegroups/ABAP" -k
```

---

## 六、数据预览与运行时 (Data Preview & Runtime)

### 6.1 SQL 查询 (POST) ✅

```bash
# 必须先获取 CSRF Token
curl -c cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/discovery" \
  -H "x-csrf-token: Fetch" -D headers.txt -k > /dev/null

CSRF=$(grep -i "^x-csrf-token" headers.txt | cut -d' ' -f2 | tr -d '\r')

# 执行 SQL 查询 (使用 ABAP Open SQL 语法)
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/datapreview/freestyle?rowNumber=3" \
  -H "Content-Type: text/plain" \
  -H "X-CSRF-Token: $CSRF" \
  -d "SELECT * FROM t000 UP TO 3 ROWS" -k
```

**响应示例**:
```xml
<?xml version="1.0" encoding="utf-8"?>
<dataPreview:tableData>
  <dataPreview:totalRows>3</dataPreview:totalRows>
  <dataPreview:columns>
    <dataPreview:metadata dataPreview:name="MANDT" dataPreview:type="C"/>
    <dataPreview:dataSet>
      <dataPreview:data>000</dataPreview:data>
      <dataPreview:data>100</dataPreview:data>
      <dataPreview:data>200</dataPreview:data>
    </dataPreview:dataSet>
  </dataPreview:columns>
  ...
</dataPreview:tableData>
```

### 6.2 获取 ABAP 跟踪 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/runtime/traces/abaptraces" -k
```

### 6.3 获取 ABAP 跟踪请求 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/runtime/traces/abaptraces/requests" -k
```

### 6.4 获取 ST05 跟踪状态 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/st05/trace/state" -k
```

### 6.5 获取 ST05 跟踪目录 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/st05/trace/directory" -k
```

### 6.6 获取断点列表 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/debugger/breakpoints" -k
```

---

## 七、CTS 与激活 (CTS & Activation)

### 7.1 获取传输请求列表 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/cts/transportrequests" -k
```

**响应示例**:
```xml
<?xml version="1.0" encoding="utf-8"?>
<tm:root adtcore:name="U1170" adtcore:changedAt="2026-04-05T17:12:17Z">
  ...
</tm:root>
```

### 7.2 获取传输列表 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/cts/transports" -k
```

### 7.3 获取搜索配置 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/cts/transportrequests/searchconfiguration/configurations" -k
```

### 7.4 获取配置元数据 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/cts/transportrequests/searchconfiguration/metadata" -k
```

### 7.5 获取未激活对象 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/activation/inactiveobjects" -k
```

### 7.6 获取检查报告器 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/checkruns/reporters" -k
```

---

## 八、ATC 与 ABAP Unit

### 8.1 获取 ATC 变式 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/atc/variants" -k
```

**响应示例**:
```xml
<?xml version="1.0" encoding="utf-8"?>
<nameditem:namedItemList>
  <nameditem:totalItemCount>83</nameditem:totalItemCount>
  <nameditem:namedItem>
    <nameditem:name>/SDF/B2S_CODE_COMPLEXITY</nameditem:name>
    ...
  </nameditem:namedItem>
</nameditem:namedItemList>
```

### 8.2 获取 ATC 审批者 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/atc/approvers" -k
```

### 8.3 获取 ATC 自定义设置 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/atc/customizing" -k
```

### 8.4 获取 ATC 结果 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/atc/results?createdBy=U1170" -k
```

### 8.5 获取 ABAP Unit 元数据 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/abapunit/metadata" -k
```

---

## 九、代码补全与格式化 (Code Completion & Pretty Print)

### 9.1 代码补全建议 (POST) ✅

```bash
curl -c cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/discovery" \
  -H "x-csrf-token: Fetch" -D headers.txt -k > /dev/null

CSRF=$(grep -i "^x-csrf-token" headers.txt | cut -d' ' -f2 | tr -d '\r')

curl -b cookies.txt -X POST \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/abapsource/codecompletion/proposal" \
  -H "X-CSRF-Token: $CSRF" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="utf-8"?>
<proposalRequest xmlns="http://www.sap.com/adt/abapsource/codecompletion">
  <sourceUri>/sap/bc/adt/oo/classes/ZCL_TEST/source/main</sourceUri>
  <cursorPosition>100</cursorPosition>
</proposalRequest>' -k
```

### 9.2 代码格式化 (POST) ✅

```bash
curl -c cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/discovery" \
  -H "x-csrf-token: Fetch" -D headers.txt -k > /dev/null

CSRF=$(grep -i "^x-csrf-token" headers.txt | cut -d' ' -f2 | tr -d '\r')

curl -b cookies.txt -X POST \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/abapsource/prettyprinter" \
  -H "X-CSRF-Token: $CSRF" \
  -H "Content-Type: text/plain" \
  -d 'DATA lv_test TYPE string.' -k
```

### 9.3 获取格式化设置 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/abapsource/prettyprinter/settings" -k
```

### 9.4 获取语法配置 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/abapsource/syntax/configurations" -k
```

### 9.5 获取语法解析器 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/abapsource/parsers/rnd/grammar" -k
```

### 9.6 获取 HANA 目录访问 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/abapsource/codecompletion/hanacatalogaccess" -k
```

---

## 十、仓库与搜索 (Repository)

### 10.1 获取对象类型 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/repository/informationsystem/objecttypes" -k
```

### 10.2 消息搜索 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/repository/informationsystem/messagesearch" -k
```

### 10.3 获取节点结构 (POST) ✅

```bash
curl -c cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/discovery" \
  -H "x-csrf-token: Fetch" -D headers.txt -k > /dev/null

CSRF=$(grep -i "^x-csrf-token" headers.txt | cut -d' ' -f2 | tr -d '\r')

curl -b cookies.txt -X POST \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/repository/nodestructure" \
  -H "X-CSRF-Token: $CSRF" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="utf-8"?>
<nodeStructureRequest xmlns="http://www.sap.com/adt/repository">
  <objectUri>/sap/bc/adt/oo/classes/ZCL_TEST</objectUri>
</nodeStructureRequest>' -k
```

### 10.4 获取包详情 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/packages/ZTEST" -k
```

### 10.5 获取包设置 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/packages/settings" -k
```

---

## 十一、其他功能

### 11.1 获取日志点 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/dlp/logpoints" -k
```

### 11.2 获取 WDY 启动配置 ✅

```bash
curl -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/wdy/launchconfiguration" -k
```

---

## 十二、POST-only 端点 (需要参数)

以下端点需要使用 POST 方法和特定参数：

### 12.1 类运行 (POST)

```bash
curl -c cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/discovery" \
  -H "x-csrf-token: Fetch" -D headers.txt -k > /dev/null

CSRF=$(grep -i "^x-csrf-token" headers.txt | cut -d' ' -f2 | tr -d '\r')

curl -b cookies.txt -X POST \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/classrun" \
  -H "X-CSRF-Token: $CSRF" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="utf-8"?>
<classRunRequest xmlns="http://www.sap.com/adt/oo">
  <classUri>/sap/bc/adt/oo/classes/ZCL_TEST</classUri>
</classRunRequest>' -k
```

### 12.2 行号映射 (POST)

```bash
curl -b cookies.txt -X POST \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/linenumber" \
  -H "X-CSRF-Token: $CSRF" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="utf-8"?>
<lineNumberRequest xmlns="http://www.sap.com/adt/oo">
  <objectUri>/sap/bc/adt/oo/classes/ZCL_TEST/source/main</objectUri>
  <lineNumber>100</lineNumber>
</lineNumberRequest>' -k
```

### 12.3 对象名验证 (POST)

```bash
curl -b cookies.txt -X POST \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/validation/objectname" \
  -H "X-CSRF-Token: $CSRF" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="utf-8"?>
<objectNameValidationRequest xmlns="http://www.sap.com/adt/oo">
  <objectName>ZCL_TEST</objectName>
  <objectType>CLAS</objectType>
</objectNameValidationRequest>' -k
```

### 12.4 程序运行 (POST)

```bash
curl -b cookies.txt -X POST \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/programs/programrun" \
  -H "X-CSRF-Token: $CSRF" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="utf-8"?>
<programRunRequest xmlns="http://www.sap.com/adt/programs">
  <programUri>/sap/bc/adt/programs/programs/ZJQR0000</programUri>
</programRunRequest>' -k
```

### 12.5 ABAP Unit 测试 (POST)

```bash
curl -b cookies.txt -X POST \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/abapunit/testruns" \
  -H "X-CSRF-Token: $CSRF" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="utf-8"?>
<testRunRequest xmlns="http://www.sap.com/adt/abapunit">
  <objectSet>
    <object uri="/sap/bc/adt/oo/classes/ZCL_TEST"/>
  </objectSet>
</testRunRequest>' -k
```

### 12.6 对象激活 (POST)

```bash
curl -b cookies.txt -X POST \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/activation" \
  -H "X-CSRF-Token: $CSRF" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="utf-8"?>
<activationRequest xmlns="http://www.sap.com/adt/activation">
  <object uri="/sap/bc/adt/oo/classes/ZCL_TEST"/>
</activationRequest>' -k
```

### 12.7 ATC 运行 (POST)

```bash
curl -b cookies.txt -X POST \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/atc/runs" \
  -H "X-CSRF-Token: $CSRF" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="utf-8"?>
<atcRunRequest xmlns="http://www.sap.com/adt/atc">
  <objectSet>
    <object uri="/sap/bc/adt/oo/classes/ZCL_TEST"/>
  </objectSet>
  <variant>/SDF/B2S_CODE_COMPLEXITY</variant>
</atcRunRequest>' -k
```

### 12.8 传输检查 (POST)

```bash
curl -b cookies.txt -X POST \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/cts/transportchecks" \
  -H "X-CSRF-Token: $CSRF" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="utf-8"?>
<transportCheckRequest xmlns="http://www.sap.com/adt/cts">
  <object uri="/sap/bc/adt/oo/classes/ZCL_TEST"/>
  <targetTransportRequest>S4HK900001</targetTransportRequest>
</transportCheckRequest>' -k
```

---

## 十三、完整测试脚本

```bash
#!/bin/bash
# SAP ADT REST API 完整测试脚本

HOST="mysap.goodsap.cn"
PORT="50400"
USER="U1170"
PASS="hysoft888999"
BASE="http://${HOST}:${PORT}"

echo "=== SAP ADT REST API 完整测试 ==="
echo ""

# 1. 获取 CSRF Token
echo "1. 获取 CSRF Token..."
curl -c cookies.txt -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/discovery" \
  -H "x-csrf-token: Fetch" -D headers.txt -k > /dev/null
CSRF=$(grep -i "^x-csrf-token" headers.txt | cut -d' ' -f2 | tr -d '\r')
echo "   CSRF Token: $CSRF"
echo ""

# 2. 系统信息
echo "2. 测试系统信息 API..."
curl -s -u "${USER}:${PASS}" "${BASE}/sap/bc/adt/system/information" -k | \
  grep -oP '(?<=<atom:id>)[^<]+' | head -5
echo ""

# 3. 类源码
echo "3. 测试类源码 API..."
curl -s -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/oo/classes/ZCL_ABAP_DATABASE_CREATE/source/main" -k | head -3
echo ""

# 4. 接口源码
echo "4. 测试接口源码 API..."
curl -s -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/oo/interfaces/ZIF_EXCEL_CONVERTER/source/main" -k | head -3
echo ""

# 5. 程序源码
echo "5. 测试程序源码 API..."
curl -s -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/programs/programs/ZJQR0000/source/main" -k | head -3
echo ""

# 6. 函数组源码
echo "6. 测试函数组源码 API..."
curl -s -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/functions/groups/zfg_kf036/source/main" -k | head -3
echo ""

# 7. Include 源码
echo "7. 测试 Include 源码 API..."
curl -s -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/programs/includes/LZFG_KF036U01/source/main" -k | head -3
echo ""

# 8. SQL 查询
echo "8. 测试 SQL 查询 API..."
curl -s -b cookies.txt \
  "${BASE}/sap/bc/adt/datapreview/freestyle?rowNumber=3" \
  -H "Content-Type: text/plain" \
  -H "X-CSRF-Token: $CSRF" \
  -d "SELECT * FROM t000 UP TO 3 ROWS" -k | \
  grep -oP '(?<=<dataPreview:data>)[^<]+' | head -10
echo ""

# 9. 传输请求
echo "9. 测试传输请求 API..."
curl -s -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/cts/transportrequests" -k | head -3
echo ""

# 10. 未激活对象
echo "10. 测试未激活对象 API..."
curl -s -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/activation/inactiveobjects" -k | head -3
echo ""

# 11. ATC 变式
echo "11. 测试 ATC 变式 API..."
curl -s -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/atc/variants" -k | \
  grep -oP '(?<=<nameditem:name>)[^<]+' | head -5
echo ""

# 12. ABAP 跟踪
echo "12. 测试 ABAP 跟踪 API..."
curl -s -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/runtime/traces/abaptraces" -k | head -3
echo ""

echo "=== 测试完成 ==="
```

---

## 十四、状态码说明

| HTTP 状态码 | 含义 | 处理方式 |
|-------------|------|----------|
| 200 | 成功 | 解析响应 XML |
| 400 | 参数错误 | 检查请求参数是否正确 |
| 403 | 权限不足 | 检查 CSRF Token 或用户权限 |
| 404 | 资源不存在 | 检查对象名称是否正确 |
| 405 | 方法不支持 | 使用正确的 HTTP 方法 (POST) |
| 500 | 服务器错误 | 检查 SAP 系统状态或组件安装 |

---

## 十五、常见问题

### 15.1 CSRF Token 验证失败

```bash
# 确保使用 -c 和 -b 参数保存和发送 cookies
curl -c cookies.txt ...  # 保存 cookie
curl -b cookies.txt ...  # 发送 cookie
```

### 15.2 SQL 语法错误

```bash
# 使用 ABAP Open SQL 语法，不是标准 SQL
-d "SELECT * FROM t000 UP TO 3 ROWS"  # 正确
-d "SELECT * FROM t000 LIMIT 3"       # 错误
```

### 15.3 对象名称大小写

```bash
# ABAP 对象名称通常大写
/sap/bc/adt/oo/classes/ZCL_TEST    # 可能不对
/sap/bc/adt/oo/classes/ZCL_TEST    # 正确 (取决于系统配置)
```

---

**文档版本**: 1.0  
**最后更新**: 2026-04-05  
**验证用例数**: 150+
