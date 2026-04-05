# SAP SICF 配置表和 ADT REST API 端点完整清单

**文档日期**: 2026-04-05  
**SAP 系统**: S/4HANA @ mysap.goodsap.cn:50400  
**用户**: U1170

---

## 一、SICF 配置存储表

### 1.1 主要表结构

| 表名 | 用途 | 说明 |
|------|------|------|
| **ICFSERVICE** | 服务定义 | 存储 ICF 服务的基本信息 |
| **ICFHANDLER** | 处理器配置 | 存储服务关联的处理器类 |
| **ICFDOCU** | 服务文档 | 存储服务的描述文档 |

### 1.2 ICFSERVICE 表结构

| 字段 | 类型 | 说明 |
|------|------|------|
| `ICF_NAME` | CHAR(240) | 服务名称（不含前缀路径） |
| `ICF_ALIAS` | CHAR(40) | 服务别名 |
| `ICF_CUSER` | CHAR(12) | 创建用户 |
| `ICF_CDATE` | DATS | 创建日期 |
| `ICF_MUSER` | CHAR(12) | 修改用户 |
| `ICF_MDATE` | DATS | 修改日期 |
| `ICF_LANGU` | LANG | 语言 |
| `ICF_DESCRIPTION` | CHAR(60) | 服务描述 |

### 1.3 ICFHANDLER 表结构

| 字段 | 类型 | 说明 |
|------|------|------|
| `ICF_NAME` | CHAR(240) | 服务名称 |
| `ICF_HANDLER` | CHAR(240) | 处理器类名 |
| `ICF_DOCU` | CHAR(60) | 处理器描述 |

---

## 二、SAP BC/ 前缀服务

### 2.1 ADT 核心服务 (`/sap/bc/adt/`)

| 路径 | 服务类型 | 说明 |
|------|----------|------|
| `/sap/bc/adt/` | ABAP Development Tools | ADT 根路径 |
| `/sap/bc/adt/oo/` | Classes & Interfaces | 类和接口开发 |
| `/sap/bc/adt/programs/` | Programs & Includes | 程序和 Include |
| `/sap/bc/adt/functions/` | Function Modules | 函数模块 |
| `/sap/bc/adt/ddic/` | Data Dictionary | 数据字典 |
| `/sap/bc/adt/ddic/tables/` | Table Definitions | 表结构定义 |
| `/sap/bc/adt/ddic/tables/*/data` | Table Data | 表数据预览 |
| `/sap/bc/adt/ddic/views/` | View Definitions | 视图定义 |
| `/sap/bc/adt/ddic/domains/` | Domain Definitions | 域定义 |
| `/sap/bc/adt/ddic/dtel/` | Data Elements | 数据元素 |
| `/sap/bc/adt/datapreview/` | Data Preview | SQL 数据预览 |
| `/sap/bc/adt/datapreview/freestyle` | Freestyle SQL | 自由 SQL 查询 |
| `/sap/bc/adt/repository/` | Repository | 仓库对象 |
| `/sap/bc/adt/vit/` | Virtual Table | 虚拟对象表 |
| `/sap/bc/adt/textelements/` | Text Elements | 文本符号（需激活） |
| `/sap/bc/adt/cts/` | CTS Transport | 传输请求 |
| `/sap/bc/adt/activation/` | Object Activation | 对象激活 |
| `/sap/bc/adt/runtime/` | Runtime | 运行时对象 |
| `/sap/bc/adt/messageclass/` | Message Classes | 消息类 |
| `/sap/bc/adt/classifications/` | Classifications | 对象分类 |
| `/sap/bc/adt/enhancements/` | Enhancements | 增强 |

### 2.2 GUI 服务 (`/sap/bc/gui/`)

| 路径 | 服务类型 | 说明 |
|------|----------|------|
| `/sap/bc/gui/sap/its/webgui` | WebGUI | Web GUI 界面 |

### 2.3 HTTP 服务 (`/sap/bc/http/`)

| 路径 | 服务类型 | 说明 |
|------|----------|------|
| `/sap/bc/http/*` | ICF Services | 自定义 HTTP 服务 |

### 2.4 其他服务

| 路径 | 服务类型 | 说明 |
|------|----------|------|
| `/sap/public/` | Public Services | 公共服务 |
| `/sap/opu/` | OData Services | OData 服务 |

---

## 三、ADT REST API 端点完整清单

### 3.1 类对象 (Classes)

| URI | 方法 | 说明 |
|-----|------|------|
| `/sap/bc/adt/oo/classes/${name}` | GET | 获取类元数据 |
| `/sap/bc/adt/oo/classes/${name}/source/main` | GET | 类主实现源代码 |
| `/sap/bc/adt/oo/classes/${name}/source/main?withAbapDocFromShortTexts=true` | GET | 包含 ABAP Doc |
| `/sap/bc/adt/oo/classes/${name}/source/definitions` | GET | 类定义（局部类型） |
| `/sap/bc/adt/oo/classes/${name}/includes/testclasses` | GET | 测试类 |
| `/sap/bc/adt/oo/classes/${name}/includes/localtypes` | GET | 局部类型 |
| `/sap/bc/adt/oo/classes/${name}/includes/implementations` | GET | 实现部分 |
| `/sap/bc/adt/oo/classes/${name}/includes/macros` | GET | 宏定义 |
| `/sap/bc/adt/oo/classes/${name}/transports` | GET | 传输请求 |
| `/sap/bc/adt/oo/classes/${name}/enhancements/options` | GET | 增强选项 |
| `/sap/bc/adt/oo/classes/${name}/enhancements/implementations` | GET | 增强实现 |

### 3.2 接口对象 (Interfaces)

| URI | 方法 | 说明 |
|-----|------|------|
| `/sap/bc/adt/oo/interfaces/${name}` | GET | 获取接口元数据 |
| `/sap/bc/adt/oo/interfaces/${name}/source/main` | GET | 接口源代码 |

### 3.3 程序对象 (Programs)

| URI | 方法 | 说明 |
|-----|------|------|
| `/sap/bc/adt/programs/programs/${name}` | GET | 程序元数据 |
| `/sap/bc/adt/programs/programs/${name}/source/main` | GET | 程序源代码 |
| `/sap/bc/adt/programs/includes/${name}` | GET | Include 源代码 |
| `/sap/bc/adt/programs/programs/${name}/includes/${includeName}` | GET | 程序 Include |

### 3.4 函数模块 (Function Groups)

| URI | 方法 | 说明 |
|-----|------|------|
| `/sap/bc/adt/functions/groups/${name}` | GET | 函数组元数据 |
| `/sap/bc/adt/functions/groups/${name}/source/main` | GET | 函数组主程序 |
| `/sap/bc/adt/functions/groups/${name}/includes/${includeName}/source/main` | GET | 函数组 Include |

> **注意**: 函数组名称中的 `/` 需要编码为 `%2f`

### 3.5 数据字典 (Data Dictionary)

| URI | 方法 | 说明 |
|-----|------|------|
| `/sap/bc/adt/ddic/tables/${name}/definition` | GET | 表结构定义 |
| `/sap/bc/adt/ddic/tables/${name}/data` | GET | 表数据 |
| `/sap/bc/adt/ddic/views/${name}/definition` | GET | 视图定义 |
| `/sap/bc/adt/ddic/dtel/${name}` | GET | 数据元素定义 |
| `/sap/bc/adt/ddic/ddl/sources/${name}` | GET | DDL 源 (CDS) |
| `/sap/bc/adt/ddic/ddlx/sources/${name}` | GET | DDLX 元数据 |

### 3.6 数据预览 (Data Preview)

| URI | 方法 | 说明 |
|-----|------|------|
| `/sap/bc/adt/datapreview/freestyle` | POST | 自由 SQL 查询 |
| `/sap/bc/adt/datapreview/freestyle?rowNumber=N` | POST | 限制返回行数 |

### 3.7 VIT (Virtual Object Table)

| URI | 方法 | 说明 |
|-----|------|------|
| `/sap/bc/adt/vit/wb/object_type/clas/object_name/${name}` | GET | 类对象 |
| `/sap/bc/adt/vit/wb/object_type/clasoc/object_name/${name}` | GET | 类组件 |
| `/sap/bc/adt/vit/wb/object_type/progp/object_name/${name}` | GET | 程序 |
| `/sap/bc/adt/vit/wb/object_type/devck/object_name/${name}` | GET | 开发类(包) |
| `/sap/bc/adt/vit/wb/object_type/rq/object_name/${transport}` | GET | 传输请求 |

### 3.8 文本符号 (Text Elements)

| URI | 方法 | 说明 |
|-----|------|------|
| `/sap/bc/adt/textelements/programs/${name}/source/symbols` | GET | 程序文本符号 |
| `/sap/bc/adt/textelements/classes/${name}/source/symbols` | GET | 类文本符号 |
| `/sap/bc/adt/textelements/functiongroups/${name}/source/symbols` | GET | 函数组文本符号 |

> **注意**: 此服务需要在 SICF 中激活

### 3.9 传输请求 (CTS)

| URI | 方法 | 说明 |
|-----|------|------|
| `/sap/bc/adt/cts/transportrequests` | GET | 传输请求列表 |
| `/sap/bc/adt/cts/transportrequests/${number}` | GET | 传输请求详情 |

### 3.10 消息类 (Message Classes)

| URI | 方法 | 说明 |
|-----|------|------|
| `/sap/bc/adt/messageclass/${name}/messages/${number}` | GET | 消息定义 |
| `/sap/bc/adt/vit/docu/object_type/NA/object_name/${msgClass}${number}` | GET | 消息长文本 |

### 3.11 其他端点

| URI | 方法 | 说明 |
|-----|------|------|
| `/sap/bc/adt/discovery` | GET | ADT 服务发现 |
| `/sap/bc/adt/packages/${name}` | GET | 包信息 |
| `/sap/bc/adt/repository/nodestructure` | GET | 仓库节点结构 |
| `/sap/bc/adt/classifications?uri=${objectUri}` | GET | 对象分类 |
| `/sap/bc/adt/runtime/dumps` | GET | 运行时转储 |
| `/sap/bc/adt/activation/inactiveobjects` | GET | 未激活对象 |
| `/sap/bc/adt/enhancements/${type}/${name}/source/main` | GET | 增强实现 |

---

## 四、curl 调用示例

### 4.1 获取 CSRF Token

```bash
curl -c cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/discovery" \
  -H "x-csrf-token: Fetch" -D headers.txt -k > /dev/null

CSRF=$(grep -i "^x-csrf-token" headers.txt | cut -d' ' -f2 | tr -d '\r')
```

### 4.2 查询数据

```bash
curl -b cookies.txt \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/datapreview/freestyle?rowNumber=10" \
  -H "Content-Type: text/plain" \
  -H "X-CSRF-Token: $CSRF" \
  -d "SELECT * FROM icfservice" -k
```

### 4.3 获取类源代码

```bash
curl -b cookies.txt -u "U1170:hysoft888999" \
  "http://mysap.goodsap.cn:50400/sap/bc/adt/oo/classes/ZCL_EXAMPLE/source/main"
```

---

## 五、URL 编码规则

| 字符 | 编码 | 示例 |
|------|------|------|
| `/` | `%2f` | `/foo/bar` → `%2ffoo%2fbar` |
| `,` | `%2c` | `KAD_52,AT520019` → `KAD_52%2cAT520019` |
| 空格 | `%20` | `    rq` → `%20%20%20%20rq` |
| `:` | `%3a` | 用于时间戳等 |

---

## 六、验证状态

| 端点类别 | 验证状态 | 说明 |
|----------|----------|------|
| 类对象 (Classes) | ✅ 已验证 | ZCL_ABAP_DATABASE_CREATE |
| 接口对象 (Interfaces) | ✅ 已验证 | ZIF_EXCEL_CONVERTER |
| 程序对象 (Programs) | ✅ 已验证 | ZJQR0000 |
| 数据预览 (Data Preview) | ✅ 已验证 | freestyle SQL |
| 文本符号 (Text Elements) | ❌ 未验证 | 服务未激活 |
| 函数组 (Function Groups) | ⚠️ 待验证 | 需要正确编码 |
| 数据字典 (DDIC) | ⚠️ 待验证 | 部分可用 |

---

**文档版本**: 1.0  
**最后更新**: 2026-04-05
