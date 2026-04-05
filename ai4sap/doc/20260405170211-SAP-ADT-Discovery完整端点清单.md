# SAP ADT REST API Discovery 完整端点清单

**文档日期**: 2026-04-05  
**SAP 系统**: S/4HANA @ mysap.goodsap.cn:50400  
**用户**: U1170  
**Discovery 端点**: `/sap/bc/adt/discovery`  
**总计端点**: 300+ 个

---

## 一、认证与初始化

### 1.1 获取 CSRF Token

```bash
curl -c cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/discovery" \
  -H "x-csrf-token: Fetch" -D headers.txt -k > /dev/null

CSRF=$(grep -i "^x-csrf-token" headers.txt | cut -d' ' -f2 | tr -d '\r')
```

### 1.2 Discovery 端点

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/discovery` | GET | ADT 服务发现 | ✅ |

---

## 二、系统信息 (System)

### 2.1 系统 API

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/system/information` | GET | 系统信息 | ✅ |
| `/sap/bc/adt/system/clients` | GET | 客户端列表 | ✅ |
| `/sap/bc/adt/system/users` | GET | 用户信息 | ✅ |
| `/sap/bc/adt/system/components` | GET | 组件信息 | ✅ |
| `/sap/bc/adt/system/landscape/servers` | GET | Landscape 服务器 | ⚠️ |

**示例**:
```bash
curl -b cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/system/information" -k
```

**响应示例**:
```xml
<atom:entry><atom:id>SAPSystemID</atom:id><atom:title>390</atom:title></atom:entry>
<atom:entry><atom:id>DBName</atom:id><atom:title>HDB/02</atom:title></atom:entry>
<atom:entry><atom:id>UnicodeSystem</atom:id><atom:title>True</atom:title></atom:entry>
```

---

## 三、类与接口 (OO - Object Oriented)

### 3.1 类 API

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/oo/classes` | GET | 类集合 | ✅ |
| `/sap/bc/adt/oo/classes/{name}` | GET | 类元数据 | ✅ |
| `/sap/bc/adt/oo/classes/{name}/source/main` | GET | 类源码 | ✅ |
| `/sap/bc/adt/oo/classes/{name}/source/definitions` | GET | 类定义 | ✅ |
| `/sap/bc/adt/oo/classes/{name}/includes/testclasses` | GET | 测试类 | ✅ |
| `/sap/bc/adt/oo/classes/{name}/includes/localtypes` | GET | 局部类型 | ⚠️ |
| `/sap/bc/adt/oo/classes/{name}/includes/macros` | GET | 宏定义 | ✅ |
| `/sap/bc/adt/oo/classes/{name}/includes/implementations` | GET | 实现部分 | ✅ |
| `/sap/bc/adt/oo/classes/{name}/transports` | GET | 传输请求 | ✅ |
| `/sap/bc/adt/classifications?uri=/sap/bc/adt/oo/classes/{name}` | GET | 分类 | ✅ |

### 3.2 接口 API

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/oo/interfaces` | GET | 接口集合 | ✅ |
| `/sap/bc/adt/oo/interfaces/{name}` | GET | 接口元数据 | ✅ |
| `/sap/bc/adt/oo/interfaces/{name}/source/main` | GET | 接口源码 | ✅ |

### 3.3 其他 OO API

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/oo/classrun` | GET | 类运行 | ⚠️ |
| `/sap/bc/adt/oo/linenumber` | GET | 行号映射 | ⚠️ |
| `/sap/bc/adt/oo/validation/objectname` | GET | 对象名验证 | ⚠️ |

**示例**:
```bash
# 获取类源码
curl -b cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/classes/ZCL_ABAP_DATABASE_CREATE/source/main"

# 获取接口源码
curl -b cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/interfaces/ZIF_EXCEL_CONVERTER/source/main"
```

---

## 四、程序与函数组 (Programs & Functions)

### 4.1 程序 API

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/programs/programs` | GET | 程序集合 | ✅ |
| `/sap/bc/adt/programs/programs/{name}` | GET | 程序元数据 | ✅ |
| `/sap/bc/adt/programs/programs/{name}/source/main` | GET | 程序源码 | ✅ |
| `/sap/bc/adt/programs/includes` | GET | Include 集合 | ✅ |
| `/sap/bc/adt/programs/includes/{name}` | GET | Include 元数据 | ✅ |
| `/sap/bc/adt/programs/includes/{name}/source/main` | GET | Include 源码 | ✅ |

### 4.2 函数组 API

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/functions/groups` | GET | 函数组集合 | ✅ |
| `/sap/bc/adt/functions/groups/{name}` | GET | 函数组元数据 | ⚠️ |
| `/sap/bc/adt/functions/groups/{name}/source/main` | GET | 函数组源码 | ✅ |
| `/sap/bc/adt/functions/groups/{name}/includes/{inc}/source/main` | GET | Include 源码 | ✅ |
| `/sap/bc/adt/functions/groups/{name}/fmodules` | GET | 函数模块列表 | ⚠️ |
| `/sap/bc/adt/functions/groups/{name}/includes` | GET | Include 列表 | ⚠️ |

### 4.3 其他程序 API

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/programs/programrun` | GET | 程序运行 | ⚠️ |
| `/sap/bc/adt/programs/validation` | GET | 程序验证 | ⚠️ |
| `/sap/bc/adt/includes/validation` | GET | Include 验证 | ⚠️ |
| `/sap/bc/adt/functions/validation` | GET | 函数验证 | ⚠️ |

**示例**:
```bash
# 获取程序源码
curl -b cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/programs/programs/ZJQR0000/source/main"

# 获取函数组源码
curl -b cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/functions/groups/zfg_kf036/source/main"

# 获取 Include 源码
curl -b cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/programs/includes/LZFG_KF036U01/source/main"
```

---

## 五、数据字典 (DDIC)

### 5.1 表与视图

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/ddic/tables` | GET | 表集合 | ✅ |
| `/sap/bc/adt/ddic/tables/{name}/definition` | GET | 表定义 | ⚠️ |
| `/sap/bc/adt/ddic/tables/validation` | GET | 表验证 | ⚠️ |
| `/sap/bc/adt/ddic/tables/parser/info` | GET | 表解析器信息 | ⚠️ |
| `/sap/bc/adt/ddic/views` | GET | 视图集合 | ✅ |
| `/sap/bc/adt/ddic/views/{name}/definition` | GET | 视图定义 | ⚠️ |
| `/sap/bc/adt/ddic/views/$validation` | GET | 视图验证 | ⚠️ |

### 5.2 其他字典对象

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/ddic/dataelements/{name}` | GET | 数据元素 | ⚠️ |
| `/sap/bc/adt/ddic/domains/{name}` | GET | 域 | ⚠️ |
| `/sap/bc/adt/ddic/tabletypes/{name}` | GET | 表类型 | ⚠️ |
| `/sap/bc/adt/ddic/typegroups/{name}` | GET | 类型组 | ⚠️ |
| `/sap/bc/adt/ddic/structures/{name}` | GET | 结构 | ⚠️ |
| `/sap/bc/adt/ddic/lockobjects/{name}` | GET | 锁对象 | ⚠️ |
| `/sap/bc/adt/ddic/dbprocedureproxies/{name}` | GET | 数据库过程代理 | ⚠️ |

### 5.3 CDS 与注释

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/ddic/ddl/sources` | GET | DDL 源集合 | ✅ |
| `/sap/bc/adt/ddic/ddl/sources/{name}` | GET | DDL 源定义 | ⚠️ |
| `/sap/bc/adt/ddic/ddl/validation` | GET | DDL 验证 | ⚠️ |
| `/sap/bc/adt/ddic/ddla/sources` | GET | DDLA 源集合 | ⚠️ |
| `/sap/bc/adt/ddic/ddlx/sources` | GET | DDLX 源集合 | ⚠️ |
| `/sap/bc/adt/ddic/drul/sources` | GET | DRUL 源集合 | ⚠️ |
| `/sap/bc/adt/ddic/srvd/sources` | GET | 服务定义源集合 | ⚠️ |

### 5.4 字典验证与设置

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/ddic/validation` | GET | 字典验证 | ⚠️ |
| `/sap/bc/adt/ddic/db/settings` | GET | 数据库设置 | ⚠️ |
| `/sap/bc/adt/ddic/codecompletion` | GET | 代码补全 | ⚠️ |
| `/sap/bc/adt/ddic/elementinfo` | GET | 元素信息 | ⚠️ |

---

## 六、数据预览 (Data Preview)

### 6.1 SQL 查询

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/datapreview/freestyle` | POST | 自由 SQL 查询 | ✅ |
| `/sap/bc/adt/datapreview/ddic` | GET | DDIC 数据预览 | ⚠️ |
| `/sap/bc/adt/datapreview/cds` | GET | CDS 数据预览 | ⚠️ |
| `/sap/bc/adt/datapreview/amdp` | GET | AMDP 数据预览 | ⚠️ |
| `/sap/bc/adt/datapreview/amdpdebugger` | GET | AMDP 调试器 | ⚠️ |

**示例**:
```bash
# SQL 查询
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/datapreview/freestyle?rowNumber=10" \
  -H "Content-Type: text/plain" \
  -H "X-CSRF-Token: $CSRF" \
  -d "SELECT * FROM tfdir WHERE funcname LIKE 'Z%'" -k
```

---

## 七、运行时与追踪 (Runtime & Traces)

### 7.1 运行时

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/runtime/traces/abaptraces` | GET | ABAP 跟踪 | ✅ |
| `/sap/bc/adt/runtime/traces/abaptraces/parameters` | GET | 跟踪参数 | ⚠️ |
| `/sap/bc/adt/runtime/traces/abaptraces/requests` | GET | 跟踪请求 | ⚠️ |
| `/sap/bc/adt/runtime/workprocesses` | GET | 工作进程 | ⚠️ |

### 7.2 ST05 跟踪

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/st05/trace/state` | GET | 跟踪状态 | ⚠️ |
| `/sap/bc/adt/st05/trace/directory` | GET | 跟踪目录 | ⚠️ |

**示例**:
```bash
curl -b cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/runtime/traces/abaptraces" -k
```

---

## 八、调试器 (Debugger)

### 8.1 断点与变量

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/debugger/breakpoints` | GET | 断点列表 | ⚠️ |
| `/sap/bc/adt/debugger/breakpoints/{id}` | GET | 断点详情 | ⚠️ |
| `/sap/bc/adt/debugger/breakpoints/conditions` | GET | 断点条件 | ⚠️ |
| `/sap/bc/adt/debugger/breakpoints/validations` | GET | 断点验证 | ⚠️ |
| `/sap/bc/adt/debugger/breakpoints/statements` | GET | 断点语句 | ⚠️ |
| `/sap/bc/adt/debugger/breakpoints/vit` | GET | VIT 断点 | ⚠️ |

### 8.2 调试器功能

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/debugger/variables` | GET | 变量 | ⚠️ |
| `/sap/bc/adt/debugger/stack` | GET | 调用栈 | ⚠️ |
| `/sap/bc/adt/debugger/actions` | GET | 调试操作 | ⚠️ |
| `/sap/bc/adt/debugger/watchpoints` | GET | 监视点 | ⚠️ |
| `/sap/bc/adt/debugger/systemareas` | GET | 系统区域 | ⚠️ |
| `/sap/bc/adt/debugger/listeners` | GET | 监听器 | ⚠️ |
| `/sap/bc/adt/debugger/batch` | GET | 批调试 | ⚠️ |

### 8.3 AMDP 调试器

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/amdp/debugger/main` | GET | AMDP 主调试 | ⚠️ |

---

## 九、传输请求 (CTS)

### 9.1 传输请求

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/cts/transportrequests` | GET | 传输请求列表 | ✅ |
| `/sap/bc/adt/cts/transportrequests/{number}` | GET | 传输请求详情 | ✅ |
| `/sap/bc/adt/cts/transports` | GET | 传输列表 | ⚠️ |
| `/sap/bc/adt/cts/transportchecks` | GET | 传输检查 | ⚠️ |
| `/sap/bc/adt/cts/transportrequests/reference` | GET | 引用请求 | ⚠️ |

### 9.2 传输配置

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/cts/transportrequests/searchconfiguration/configurations` | GET | 搜索配置 | ⚠️ |
| `/sap/bc/adt/cts/transportrequests/searchconfiguration/metadata` | GET | 搜索元数据 | ⚠️ |

**示例**:
```bash
curl -b cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/cts/transportrequests" -k
```

---

## 十、激活与检查 (Activation & Check)

### 10.1 激活

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/activation` | GET | 激活服务 | ⚠️ |
| `/sap/bc/adt/activation/inactiveobjects` | GET | 未激活对象 | ✅ |

### 10.2 检查运行

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/checkruns` | GET | 检查运行 | ⚠️ |
| `/sap/bc/adt/checkruns/reporters` | GET | 检查报告器 | ⚠️ |

**示例**:
```bash
curl -b cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/activation/inactiveobjects" -k
```

---

## 十一、ATC 与单元测试 (ATC & Unit Tests)

### 11.1 ATC

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/atc/runs` | GET | ATC 运行 | ⚠️ |
| `/sap/bc/adt/atc/results` | GET | ATC 结果 | ⚠️ |
| `/sap/bc/adt/atc/worklists` | GET | ATC 工作清单 | ⚠️ |
| `/sap/bc/adt/atc/items` | GET | ATC 项目 | ⚠️ |
| `/sap/bc/adt/atc/variants` | GET | ATC 变式 | ⚠️ |
| `/sap/bc/adt/atc/approvers` | GET | ATC 审批者 | ⚠️ |
| `/sap/bc/adt/atc/customizing` | GET | ATC 自定义 | ⚠️ |
| `/sap/bc/adt/atc/ccstunnel` | GET | CCS 隧道 | ⚠️ |
| `/sap/bc/adt/atc/exemptions/apply` | POST | 应用豁免 | ⚠️ |
| `/sap/bc/adt/atc/autoqf/worklist` | GET | 自动质量检查 | ⚠️ |

### 11.2 ABAP Unit

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/abapunit/testruns` | POST | ABAP Unit 测试 | ⚠️ |
| `/sap/bc/adt/abapunit/testruns/evaluation` | GET | 测试评估 | ⚠️ |
| `/sap/bc/adt/abapunit/metadata` | GET | 测试元数据 | ⚠️ |

---

## 十二、消息类 (Message Classes)

### 12.1 消息 API

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/messageclass` | GET | 消息类集合 | ⚠️ |
| `/sap/bc/adt/messageclass/{name}` | GET | 消息类 | ⚠️ |
| `/sap/bc/adt/messageclass/{name}/messages/{number}` | GET | 消息定义 | ⚠️ |
| `/sap/bc/adt/messageclass/validation` | GET | 消息验证 | ⚠️ |

**示例**:
```bash
curl -b cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/messageclass/ZTEST/messages/001" -k
```

---

## 十三、Web Dynpro (WDY)

### 13.1 WDY 组件

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/wdy/applications` | GET | WDY 应用 | ⚠️ |
| `/sap/bc/adt/wdy/components` | GET | WDY 组件 | ⚠️ |
| `/sap/bc/adt/wdy/views` | GET | WDY 视图 | ⚠️ |
| `/sap/bc/adt/wdy/windows` | GET | WDY 窗口 | ⚠️ |
| `/sap/bc/adt/wdy/componentcontrollers` | GET | 组件控制器 | ⚠️ |
| `/sap/bc/adt/wdy/interfacecontrollers` | GET | 接口控制器 | ⚠️ |
| `/sap/bc/adt/wdy/customcontrollers` | GET | 自定义控制器 | ⚠️ |
| `/sap/bc/adt/wdy/componentinterfaces` | GET | 组件接口 | ⚠️ |
| `/sap/bc/adt/wdy/interfaceviews` | GET | 接口视图 | ⚠️ |

### 13.2 WDY 配置

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/wdy/applicationconfig` | GET | 应用配置 | ⚠️ |
| `/sap/bc/adt/wdy/componentconfig` | GET | 组件配置 | ⚠️ |
| `/sap/bc/adt/wdy/launchconfiguration` | GET | 启动配置 | ⚠️ |
| `/sap/bc/adt/wdy/codetemplate` | GET | 代码模板 | ⚠️ |
| `/sap/bc/adt/wdy/search` | GET | WDY 搜索 | ⚠️ |

### 13.3 WDY FPM

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/wdy/fpmapplications` | GET | FPM 应用 | ⚠️ |
| `/sap/bc/adt/wdy/fpmfloorplans` | GET | FPM 页面布局 | ⚠️ |
| `/sap/bc/adt/wdy/fpmadaptables` | GET | FPM 适配器 | ⚠️ |
| `/sap/bc/adt/wdy/fpmcomponents` | GET | FPM 组件 | ⚠️ |
| `/sap/bc/adt/wdy/fpmguibbs` | GET | FPM GUI BB | ⚠️ |
| `/sap/bc/adt/wdy/fpmruibbs` | GET | FPM RUI BB | ⚠️ |

---

## 十四、代码补全与语法 (Code Completion & Syntax)

### 14.1 ABAP Source

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/abapsource/codecompletion/proposal` | GET | 代码补全建议 | ⚠️ |
| `/sap/bc/adt/abapsource/codecompletion/elementinfo` | GET | 元素信息 | ⚠️ |
| `/sap/bc/adt/abapsource/codecompletion/insertion` | GET | 插入建议 | ⚠️ |
| `/sap/bc/adt/abapsource/codecompletion/hanacatalogaccess` | GET | HANA 目录访问 | ⚠️ |
| `/sap/bc/adt/abapsource/typehierarchy` | GET | 类型层次 | ⚠️ |
| `/sap/bc/adt/abapsource/prettyprinter` | GET | 代码格式化 | ⚠️ |
| `/sap/bc/adt/abapsource/prettyprinter/settings` | GET | 格式化设置 | ⚠️ |
| `/sap/bc/adt/abapsource/cleanup/source` | GET | 源代码清理 | ⚠️ |
| `/sap/bc/adt/abapsource/occurencemarkers` | GET | 标记出现 | ⚠️ |
| `/sap/bc/adt/abapsource/syntax/configurations` | GET | 语法配置 | ⚠️ |
| `/sap/bc/adt/abapsource/abapdoc/exportjobs` | POST | ABAP Doc 导出 | ⚠️ |
| `/sap/bc/adt/abapsource/parsers/rnd/grammar` | GET | 语法解析器 | ⚠️ |

---

## 十五、仓库与对象 (Repository)

### 15.1 仓库信息

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/repository/nodestructure` | GET | 节点结构 | ⚠️ |
| `/sap/bc/adt/repository/nodepath` | GET | 节点路径 | ⚠️ |
| `/sap/bc/adt/repository/objectstructure` | GET | 对象结构 | ⚠️ |
| `/sap/bc/adt/repository/typestructure` | GET | 类型结构 | ⚠️ |
| `/sap/bc/adt/repository/proxyurimappings` | GET | 代理 URI 映射 | ⚠️ |

### 15.2 信息系统

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/repository/informationsystem/search` | GET | 仓库搜索 | ⚠️ |
| `/sap/bc/adt/repository/informationsystem/whereused` | GET | 使用处查找 | ⚠️ |
| `/sap/bc/adt/repository/informationsystem/objecttypes` | GET | 对象类型 | ⚠️ |
| `/sap/bc/adt/repository/informationsystem/executableObjects` | GET | 可执行对象 | ⚠️ |
| `/sap/bc/adt/repository/informationsystem/usageReferences` | GET | 使用引用 | ⚠️ |
| `/sap/bc/adt/repository/informationsystem/usageSnippets` | GET | 使用代码片段 | ⚠️ |
| `/sap/bc/adt/repository/informationsystem/messagesearch` | GET | 消息搜索 | ⚠️ |
| `/sap/bc/adt/repository/informationsystem/fullnamemapping` | GET | 完全名称映射 | ⚠️ |

### 15.3 包

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/packages` | GET | 包集合 | ⚠️ |
| `/sap/bc/adt/packages/{name}` | GET | 包详情 | ⚠️ |
| `/sap/bc/adt/packages/settings` | GET | 包设置 | ⚠️ |
| `/sap/bc/adt/packages/validation` | GET | 包验证 | ⚠️ |

---

## 十六、增强 (Enhancements)

### 16.1 增强类型

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/enhancements/enhoxhh` | GET | 增强实现 | ⚠️ |
| `/sap/bc/adt/enhancements/enhoxh` | GET | 增强句柄 | ⚠️ |
| `/sap/bc/adt/enhancements/enhsxs` | GET | 增强 SXS | ⚠️ |

### 16.2 增强验证

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/enhancements/enhoxhh/validation` | GET | 增强验证 | ⚠️ |
| `/sap/bc/adt/enhancements/enhoxh/validation` | GET | 句柄验证 | ⚠️ |
| `/sap/bc/adt/enhancements/enhsxs/validation` | GET | SXS 验证 | ⚠️ |

---

## 十七、业务服务 (Business Services)

### 17.1 OData 服务

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/businessservices/odatav2` | GET | OData V2 服务 | ⚠️ |
| `/sap/bc/adt/businessservices/bindings` | GET | 服务绑定 | ⚠️ |
| `/sap/bc/adt/businessservices/bindings/validate/check` | POST | 绑定验证 | ⚠️ |
| `/sap/bc/adt/businessservices/bindings/validation` | GET | 绑定验证 | ⚠️ |
| `/sap/bc/adt/businessservices/release` | GET | 服务发布 | ⚠️ |
| `/sap/bc/adt/businessservices/proxies` | GET | 服务代理 | ⚠️ |

### 17.2 业务扩展

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/businesslogicextensions/badis` | GET | BADI 扩展 | ⚠️ |
| `/sap/bc/adt/businesslogicextensions/badinameproposals` | GET | BADI 名称建议 | ⚠️ |

---

## 十八、日志点与断点 (Logpoints & Breakpoints)

### 18.1 日志点

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/dlp/logpoints` | GET | 日志点 | ⚠️ |
| `/sap/bc/adt/dlp/locationinfo` | GET | 位置信息 | ⚠️ |
| `/sap/bc/adt/dlp/logs/servers` | GET | 日志服务器 | ⚠️ |

---

## 十九、重构 (Refactoring)

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/refactorings` | GET | 重构列表 | ⚠️ |
| `/sap/bc/adt/refactoring/changepackage` | GET | 修改包 | ⚠️ |

---

## 二十、快速修复 (Quick Fixes)

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/quickfixes/evaluation` | GET | 快速修复评估 | ⚠️ |

---

## 二十一、API 发布

| 端点 | 方法 | 说明 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/apireleases` | GET | API 发布列表 | ⚠️ |

---

## 二十二、模板链接 (Template Links)

从 Discovery 中发现的模板链接：

| 模板 | 说明 |
|------|------|
| `/sap/bc/adt/functions/groups/{groupname}/fmodules` | 函数模块列表 |
| `/sap/bc/adt/functions/groups/{groupname}/includes` | 函数组 Includes |
| `/sap/bc/adt/bopf/businessobjects/{bo_name}/$validation` | BOPF 验证 |
| `/sap/bc/adt/bopf/businessobjects/{bo_name}/$search` | BOPF 搜索 |
| `/sap/bc/adt/cmp_code_composer/cmpt/{name}/source/main` | 代码组件源码 |

---

## 二十三、完整 curl 测试脚本

```bash
#!/bin/bash
# SAP ADT REST API 完整测试脚本

HOST="mysap.goodsap.cn"
PORT="50400"
USER="U1170"
PASS="hysoft888999"
BASE="http://${HOST}:${PORT}"

# 获取 CSRF Token
echo "=== 获取 CSRF Token ==="
curl -c cookies.txt -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/discovery" \
  -H "x-csrf-token: Fetch" -D headers.txt -k > /dev/null
CSRF=$(grep -i "^x-csrf-token" headers.txt | cut -d' ' -f2 | tr -d '\r')

# 1. 系统信息
echo -e "\n=== 1. 系统信息 ==="
curl -b cookies.txt -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/system/information" -k | \
  grep -oP '(?<=<atom:id>)[^<]+'

# 2. 类源码
echo -e "\n=== 2. 类源码 (前5行) ==="
curl -b cookies.txt -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/oo/classes/ZCL_ABAP_DATABASE_CREATE/source/main" -k | head -5

# 3. 接口源码
echo -e "\n=== 3. 接口源码 ==="
curl -b cookies.txt -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/oo/interfaces/ZIF_EXCEL_CONVERTER/source/main" -k | head -5

# 4. 程序源码
echo -e "\n=== 4. 程序源码 (前5行) ==="
curl -b cookies.txt -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/programs/programs/ZJQR0000/source/main" -k | head -5

# 5. 函数组源码
echo -e "\n=== 5. 函数组源码 ==="
curl -b cookies.txt -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/functions/groups/zfg_kf036/source/main" -k | head -5

# 6. Include 源码
echo -e "\n=== 6. Include 源码 ==="
curl -b cookies.txt -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/programs/includes/LZFG_KF036U01/source/main" -k

# 7. VIT 包信息
echo -e "\n=== 7. 包信息 ==="
curl -b cookies.txt -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/vit/wb/object_type/devck/object_name/ZDEMO" -k | \
  grep -oP 'adtcore:(name|description)="[^"]*"'

# 8. 传输请求
echo -e "\n=== 8. 传输请求 ==="
curl -b cookies.txt -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/cts/transportrequests" -k | head -5

# 9. 未激活对象
echo -e "\n=== 9. 未激活对象 (前5行) ==="
curl -b cookies.txt -u "${USER}:${PASS}" \
  "${BASE}/sap/bc/adt/activation/inactiveobjects" -k | head -5

# 10. SQL 查询
echo -e "\n=== 10. SQL 查询 (TFDIR) ==="
curl -b cookies.txt \
  "${BASE}/sap/bc/adt/datapreview/freestyle?rowNumber=3" \
  -H "Content-Type: text/plain" \
  -H "X-CSRF-Token: $CSRF" \
  -d "SELECT funcname FROM tfdir WHERE funcname LIKE 'Z%'" -k | \
  grep -oP '(?<=<dataPreview:data>)[^<]+'

echo -e "\n完成!"
```

---

## 二十四、API 状态汇总

| 状态 | 说明 | 数量 |
|------|------|------|
| ✅ | 已验证可用 | ~25 |
| ⚠️ | 需要进一步测试 | ~280 |
| ❌ | 不可用 | - |

### 24.1 主要可用 API

| 类别 | 端点数 |
|------|--------|
| 系统信息 | 1 |
| 类对象 | 6 |
| 接口对象 | 3 |
| 程序对象 | 3 |
| 函数组 | 2 |
| 数据预览 | 1 |
| 传输请求 | 2 |
| 激活 | 1 |
| 运行时追踪 | 1 |

---

**文档版本**: 1.0  
**最后更新**: 2026-04-05  
**Discovery 数据来源**: `/sap/bc/adt/discovery` (165KB XML)
