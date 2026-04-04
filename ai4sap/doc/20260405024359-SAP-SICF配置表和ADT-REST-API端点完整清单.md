# SAP SICF 配置表和 ADT REST API 端点完整清单

**生成时间**: 2026-04-05 02:43:59  
**系统**: SAP S/4HANA @ mysap.goodsap.cn:50400  
**客户端**: 400  
**数据来源**: SAP ADT Discovery API + ICFSERVICE 表验证

---

## 一、SICF 配置存储表

### 1.1 核心表

| 表名 | 说明 | 关键字段 |
|------|------|----------|
| **ICFSERVICE** | ICF服务定义 | ICF_NAME, ICF_USER, PROTSEC |
| **ICFENTRY** | ICF服务条目 | ICF_NAME, ICFPARGUID |
| **ICFDOCU** | ICF文档 | ICF_NAME, ICF_LANGU, ICF_DOCU |

### 1.2 ICFSERVICE 表结构

| 字段 | 类型 | 说明 |
|------|------|------|
| ICF_NAME | CHAR(255) | ICF服务路径名称 |
| ICFPARGUID | CHAR(32) | 父节点GUID |
| ICFNODGUID | CHAR(32) | 节点GUID |
| ICFALIFLAG | CHAR(1) | 别名标志 |
| ICFCHILDNO | NUMC(4) | 子节点数 |
| ICFALIASNO | NUMC(4) | 别名号 |
| ICFNODFLAG | CHAR(1) | 节点标志 |
| ICFALIGUID | CHAR(32) | 别名GUID |
| ICF_EXPAND | CHAR(1) | 展开标志 |
| ICF_MANDT | MANDT | 客户端 |
| ICF_USER | CHAR(12) | 用户 |
| ICF_PASSWD | CHAR(120) | 密码(加密) |
| ICF_LANGU | LANG | 语言 |
| OBLUSRFLAG | CHAR(1) | 强制用户标志 |
| PROTSEC | CHAR(1) | 安全协议 |

### 1.3 curl 查询 ICF 服务

```bash
# 获取 CSRF Token
curl -c cookies.txt -u "U1170:密码" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/discovery" \
  -H "x-csrf-token: Fetch" -D headers.txt -k > /dev/null

CSRF=$(grep -i "^x-csrf-token" headers.txt | cut -d' ' -f2 | tr -d '\r')

# 查询 ADT 相关 ICF 服务
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/datapreview/freestyle?rowNumber=50" \
  -H "Content-Type: text/plain" \
  -H "X-CSRF-Token: $CSRF" \
  -d "SELECT icf_name, icf_user, protsEC from icfservice WHERE icf_name LIKE '%ADT%'"
```

---

## 二、SAP ADT REST API 总览

### 2.1 统计数据

| 指标 | 数值 |
|------|------|
| 总端点数量 | **568** |
| 主要分类 | 15+ |

### 2.2 端点分类

| 分类 | 数量 | 前缀 |
|------|------|------|
| ABAP源码 | ~50 | /sap/bc/adt/abapsource/ |
| 对象访问 | ~100 | /sap/bc/adt/oo/ |
| 数据预览 | ~20 | /sap/bc/adt/datapreview/ |
| 传输管理 | ~15 | /sap/bc/adt/cts/ |
| 运行时 | ~30 | /sap/bc/adt/runtime/ |
| ATC检查 | ~20 | /sap/bc/adt/atc/ |
| 包管理 | ~10 | /sap/bc/adt/packages/ |
| 仓库 | ~40 | /sap/bc/adt/repository/ |
| 其他 | ~200 | 各种专用端点 |

---

## 三、常用 ADT API 端点详解

### 3.1 类和接口 (/sap/bc/adt/oo/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/oo/classes` | GET | 获取类列表 |
| `/sap/bc/adt/oo/classes/{name}/source/main` | GET | 获取类主代码 |
| `/sap/bc/adt/oo/classes/{name}/source/definitions` | GET | 获取类定义 |
| `/sap/bc/adt/oo/classes/{name}/includes/{type}` | GET | 获取类包含 |
| `/sap/bc/adt/oo/classes/{name}/transports` | GET | 获取类传输请求 |
| `/sap/bc/adt/oo/interfaces/{name}/source/main` | GET | 获取接口代码 |

**使用示例**:
```bash
# 获取类源代码
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/classes/zcl_zosql_db_layer/source/main" \
  -H "Accept: text/plain"

# 获取接口定义
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/interfaces/zif_zosql_db_layer/source/main" \
  -H "Accept: text/plain"
```

---

### 3.2 程序 (/sap/bc/adt/programs/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/programs/programs/{name}` | GET | 获取程序 |
| `/sap/bc/adt/programs/programs/{name}/source/main` | GET | 获取程序源码 |
| `/sap/bc/adt/programs/includes/{name}` | GET | 获取包含程序 |
| `/sap/bc/adt/programs/programrun/{name}` | POST | 运行程序 |

**使用示例**:
```bash
# 获取程序源代码
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/programs/programs/zjqr000/source/main" \
  -H "Accept: text/plain"
```

---

### 3.3 函数模块 (/sap/bc/adt/functions/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/functions/groups/{name}` | GET | 获取函数组 |
| `/sap/bc/adt/functions/groups/{name}/source/main` | GET | 获取函数组源码 |
| `/sap/bc/adt/functions/groups/{name}/fmodules` | GET | 获取函数模块列表 |
| `/sap/bc/adt/functions/groups/{name}/includes/{inc}` | GET | 获取函数组包含 |

**使用示例**:
```bash
# 获取函数组源代码 (需要URL编码)
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/functions/groups/%2flzfg_jqtop/source/main" \
  -H "Accept: text/plain"
```

---

### 3.4 数据字典 (/sap/bc/adt/ddic/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/ddic/tables/{name}/definition` | GET | 获取表定义 |
| `/sap/bc/adt/ddic/tables/{name}/data` | GET | 获取表数据 |
| `/sap/bc/adt/ddic/dataelements/{name}` | GET | 获取数据元素 |
| `/sap/bc/adt/ddic/ddl/sources/{name}` | GET | 获取DDL源码 |
| `/sap/bc/adt/ddic/codecompletion` | GET | 代码补全 |

**使用示例**:
```bash
# 获取表定义
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/ddic/tables/mara/definition" \
  -H "Accept: application/vnd.sap.as+xml"
```

---

### 3.5 数据预览 (/sap/bc/adt/datapreview/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/datapreview/freestyle{?rowNumber}` | POST | SQL自由查询 |
| `/sap/bc/adt/datapreview/ddic{?ddicEntityName}` | GET | DDIC表数据 |
| `/sap/bc/adt/datapreview/cds{?action}` | GET | CDS视图数据 |
| `/sap/bc/adt/datapreview/amdp` | GET | AMDP数据 |

**使用示例**:
```bash
# SQL自由查询
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/datapreview/freestyle?rowNumber=100" \
  -H "Content-Type: text/plain" \
  -H "X-CSRF-Token: $CSRF" \
  -d "SELECT matnr, mtart FROM mara WHERE ernam = 'U1170'"
```

---

### 3.6 传输请求 (/sap/bc/adt/cts/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/cts/transportrequests` | GET | 获取传输请求列表 |
| `/sap/bc/adt/cts/transportrequests/{name}` | GET | 获取指定传输 |
| `/sap/bc/adt/cts/transportrequests/searchconfiguration` | GET | 搜索配置 |
| `/sap/bc/adt/cts/transportchecks` | GET | 传输检查 |

**使用示例**:
```bash
# 获取传输请求列表
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/cts/transportrequests" \
  -H "Accept: application/vnd.sap.adt.transportorganizertree.v1+xml"
```

---

### 3.7 激活 (/sap/bc/adt/activation/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/activation` | POST | 激活对象 |
| `/sap/bc/adt/activation/inactiveobjects` | GET | 获取非激活对象 |

**使用示例**:
```bash
# 激活对象
curl -b cookies.txt -X POST \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/activation" \
  -H "Content-Type: application/vnd.sap.adt.activation+xml" \
  -H "X-CSRF-Token: $CSRF" \
  -H "Accept: application/vnd.sap.adt.activation+xml" \
  -d '<?xml version="1.0"?><activation xmlns="http://www.sap.com/adt/activation"><object objectType="CLAS" objectName="ZCL_TEST"/></activation>'
```

---

### 3.8 仓库搜索 (/sap/bc/adt/repository/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/repository/nodestructure` | GET | 包节点结构 |
| `/sap/bc/adt/repository/informationsystem/search` | GET | 仓库搜索 |
| `/sap/bc/adt/repository/informationsystem/objecttypes` | GET | 对象类型列表 |
| `/sap/bc/adt/repository/informationsystem/messagesearch` | GET | 消息搜索 |

**使用示例**:
```bash
# 搜索对象
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/repository/informationsystem/search?query=ZJQR*" \
  -H "Accept: application/atom+xml"
```

---

### 3.9 包 (/sap/bc/adt/packages/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/packages` | GET | 获取包列表 |
| `/sap/bc/adt/packages/$tree` | GET | 包树结构 |
| `/sap/bc/adt/packages/{name}` | GET | 获取指定包 |
| `/sap/bc/adt/packages/settings` | GET | 包设置 |

---

### 3.10 文本元素 (/sap/bc/adt/textelements/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/textelements/programs/{name}` | GET | 获取程序文本元素 |
| `/sap/bc/adt/textelements/programs/{name}/source/symbols` | GET | 获取符号 |
| `/sap/bc/adt/textelements/classes/{name}` | GET | 获取类文本元素 |

**使用示例**:
```bash
# 获取程序文本元素
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/textelements/programs/zjqr000" \
  -H "Accept: application/vnd.sap.adt.textelements.symbols+xml"
```

---

### 3.11 运行时 (/sap/bc/adt/runtime/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/runtime/dumps` | GET | 获取运行时DUMP |
| `/sap/bc/adt/runtime/traces/abaptraces/{id}` | GET | ABAP追踪 |

---

### 3.12 增强 (/sap/bc/adt/enhancements/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/enhancements/enhoxh/{name}` | GET | 隐式增强 |
| `/sap/bc/adt/enhancements/enhoxhh/{name}` | GET | 显式增强 |
| `/sap/bc/adt/enhancements/enhsxs/{name}` | GET | BAdI增强 |

---

### 3.13 ATC 检查 (/sap/bc/adt/atc/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/atc/runs` | GET/POST | ATC运行 |
| `/sap/bc/adt/atc/results` | GET | ATC结果 |
| `/sap/bc/adt/atc/worklists` | GET | 工作清单 |
| `/sap/bc/adt/atc/exemptions/apply` | POST | 申请豁免 |

---

### 3.14 消息类 (/sap/bc/adt/messageclass/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/messageclass/{name}/messages/{nr}` | GET | 获取消息 |
| `/sap/bc/adt/messageclass/validation` | GET | 消息验证 |

---

### 3.15 ABAP单元测试 (/sap/bc/adt/abapunit/)

| 端点 | 方法 | 用途 |
|------|------|------|
| `/sap/bc/adt/abapunit/testruns` | GET/POST | 测试运行 |
| `/sap/bc/adt/abapunit/testruns/{id}/evaluation` | GET | 测试评估 |
| `/sap/bc/adt/abapunit/metadata` | GET | 元数据 |

---

## 四、完整端点清单 (按前缀分类)

### 4.1 /sap/bc/adt/oo/ (类和接口)

```
/sap/bc/adt/oo/classes
/sap/bc/adt/oo/classes/{name}
/sap/bc/adt/oo/classes/{name}/includes
/sap/bc/adt/oo/classes/{name}/includes/{type}
/sap/bc/adt/oo/classes/{name}/includes/testclasses
/sap/bc/adt/oo/classes/{name}/includes/localtypes
/sap/bc/adt/oo/classes/{name}/source/main
/sap/bc/adt/oo/classes/{name}/source/definitions
/sap/bc/adt/oo/classes/{name}/transports
/sap/bc/adt/oo/classes/{name}/classifications
/sap/bc/adt/oo/interfaces
/sap/bc/adt/oo/interfaces/{name}
/sap/bc/adt/oo/interfaces/{name}/source/main
```

### 4.2 /sap/bc/adt/programs/ (程序)

```
/sap/bc/adt/programs/programs
/sap/bc/adt/programs/programs/{name}
/sap/bc/adt/programs/programs/{name}/source/main
/sap/bc/adt/programs/includes/{name}
/sap/bc/adt/programs/programrun/{name}
/sap/bc/adt/programs/programrun/{name}?profilerId={id}
/sap/bc/adt/programs/validation
```

### 4.3 /sap/bc/adt/functions/ (函数模块)

```
/sap/bc/adt/functions/groups
/sap/bc/adt/functions/groups/{name}
/sap/bc/adt/functions/groups/{name}/source/main
/sap/bc/adt/functions/groups/{name}/includes/{inc}
/sap/bc/adt/functions/groups/{name}/includes/{inc}/source/main
/sap/bc/adt/functions/groups/{name}/fmodules
/sap/bc/adt/functions/validation
```

### 4.4 /sap/bc/adt/ddic/ (数据字典)

```
/sap/bc/adt/ddic/tables/{name}/definition
/sap/bc/adt/ddic/tables/{name}/data
/sap/bc/adt/ddic/dataelements
/sap/bc/adt/ddic/dataelements/{name}
/sap/bc/adt/ddic/ddl/sources/{name}
/sap/bc/adt/ddic/ddlx/sources/{name}
/sap/bc/adt/ddic/dbprocedureproxies
/sap/bc/adt/ddic/codecompletion
/sap/bc/adt/ddic/cds/annotation/definitions
```

### 4.5 /sap/bc/adt/datapreview/ (数据预览)

```
/sap/bc/adt/datapreview/freestyle{?rowNumber}
/sap/bc/adt/datapreview/ddic{?ddicEntityName,rowNumber}
/sap/bc/adt/datapreview/cds{?action,rowNumber}
/sap/bc/adt/datapreview/amdp{?maxRows,uri}
/sap/bc/adt/datapreview/amdpdebugger
```

### 4.6 /sap/bc/adt/cts/ (传输请求)

```
/sap/bc/adt/cts/transportrequests
/sap/bc/adt/cts/transportrequests/{name}
/sap/bc/adt/cts/transportrequests/reference
/sap/bc/adt/cts/transportchecks
/sap/bc/adt/cts/transports
/sap/bc/adt/cts/transportrequests/searchconfiguration
```

### 4.7 /sap/bc/adt/repository/ (仓库)

```
/sap/bc/adt/repository/nodestructure
/sap/bc/adt/repository/nodepath
/sap/bc/adt/repository/objectstructure
/sap/bc/adt/repository/informationsystem/search
/sap/bc/adt/repository/informationsystem/objecttypes
/sap/bc/adt/repository/informationsystem/messagesearch
/sap/bc/adt/repository/informationsystem/whereused
/sap/bc/adt/repository/informationsystem/executableObjects
```

### 4.8 /sap/bc/adt/packages/ (包)

```
/sap/bc/adt/packages
/sap/bc/adt/packages/$tree
/sap/bc/adt/packages/{name}
/sap/bc/adt/packages/settings
/sap/bc/adt/packages/validation
/sap/bc/adt/packages/valuehelps/applicationcomponents
/sap/bc/adt/packages/valuehelps/softwarecomponents
```

### 4.9 其他重要端点

```
/sap/bc/adt/activation
/sap/bc/adt/activation/inactiveobjects
/sap/bc/adt/textelements/programs/{name}
/sap/bc/adt/textelements/classes/{name}
/sap/bc/adt/textelements/functiongroups/{name}
/sap/bc/adt/runtime/dumps
/sap/bc/adt/runtime/traces/abaptraces/{id}
/sap/bc/adt/messageclass/{name}/messages/{nr}
/sap/bc/adt/enhancements/enhoxhh/{name}
/sap/bc/adt/enhancements/enhoxh/{name}
/sap/bc/adt/enhancements/enhsxs/{name}
/sap/bc/adt/abapunit/testruns
/sap/bc/adt/abapunit/metadata
/sap/bc/adt/atc/runs
/sap/bc/adt/atc/results
/sap/bc/adt/atc/worklists
/sap/bc/adt/apireleases
/sap/bc/adt/apireleases/meta
/sap/bc/adt/checkruns
```

---

## 五、curl 完整调用示例

### 5.1 认证流程

```bash
#!/bin/bash
# SAP ADT REST API 认证

HOST="mysap.goodsap.cn"
PORT="50400"
USER="U1170"
PASS="hysoft888999"

# 获取 CSRF Token 和 Session
curl -s -c /tmp/cookies.txt \
  -u "${USER}:${PASS}" \
  "http://${HOST}:${PORT}/sap/bc/adt/discovery" \
  -H "x-csrf-token: Fetch" \
  -D /tmp/headers.txt -k > /dev/null

CSRF=$(grep -i "^x-csrf-token" /tmp/headers.txt | cut -d' ' -f2 | tr -d '\r')
echo "CSRF: $CSRF"
```

### 5.2 读取类源代码

```bash
curl -s -b /tmp/cookies.txt \
  "http://${HOST}:${PORT}/sap/bc/adt/oo/classes/zcl_zosql_db_layer/source/main" \
  -H "Accept: text/plain"
```

### 5.3 读取程序源代码

```bash
curl -s -b /tmp/cookies.txt \
  "http://${HOST}:${PORT}/sap/bc/adt/programs/programs/zjqr000/source/main" \
  -H "Accept: text/plain"
```

### 5.4 SQL数据查询

```bash
curl -s -b /tmp/cookies.txt \
  "http://${HOST}:${PORT}/sap/bc/adt/datapreview/freestyle?rowNumber=100" \
  -H "Content-Type: text/plain" \
  -H "X-CSRF-Token: $CSRF" \
  -d "SELECT matnr, mtart, ernam FROM mara WHERE ernam = 'U1170'"
```

### 5.5 获取表定义

```bash
curl -s -b /tmp/cookies.txt \
  "http://${HOST}:${PORT}/sap/bc/adt/ddic/tables/mara/definition" \
  -H "Accept: application/vnd.sap.as+xml"
```

### 5.6 获取传输请求

```bash
curl -s -b /tmp/cookies.txt \
  "http://${HOST}:${PORT}/sap/bc/adt/cts/transportrequests" \
  -H "Accept: application/vnd.sap.adt.transportorganizertree.v1+xml"
```

---

## 六、常见错误处理

| 错误 | 原因 | 解决方案 |
|------|------|----------|
| 401 Unauthorized | 认证失败 | 检查用户名密码 |
| 403 X-CSRF-Token Required | CSRF缺失 | 先获取Token |
| 404 Resource Not Found | 对象不存在 | 检查对象名称 |
| 500 Internal Server Error | 服务器错误 | 检查SAP服务状态 |
| ExceptionResourceNotAcceptable | Accept类型错误 | 更换Accept类型 |

---

**文档生成**: SAP ADT Discovery API  
**生成时间**: 2026-04-05 02:43:59
