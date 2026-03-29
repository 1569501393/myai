# AI4SAP 使用指南

## 概述

AI4SAP 提供了一套完整的 SAP REST API 集成解决方案，通过 ADT (ABAP Development Tools) 接口连接 SAP 系统，获取程序源码、表数据和分析结果。

## 环境准备

### 1. 安装依赖

```bash
pip install requests python-dotenv
```

### 2. 配置连接信息

复制配置模板文件：

```bash
cp .env.example .env
```

编辑 `.env` 文件，填入 SAP 连接参数：

| 参数 | 说明 | 示例 |
|------|------|------|
| SAP_USER | SAP 用户名 | U1170 |
| SAP_PASSWORD | SAP 密码 | hysoft888999 |
| SAP_CLIENT | SAP 客户端 | 400 |
| SAP_LANG | 语言 | ZH / EN |
| SAP_HOST | SAP 服务器地址 | mysap.goodsap.cn |
| SAP_PORT | 端口号 | 50400 |
| SAP_PROTOCOL | 协议 | http / https |

## 快速开始

### 运行示例脚本

```bash
cd skills/ai4sap
python sap_connector.py
```

脚本会自动：
1. 读取 `.env` 配置文件
2. 连接 SAP 系统
3. 获取示例程序源码（ZJQR0000, ZJQR0000_FRM, ZCL_TEST）
4. 查询 MARA 表数据
5. 保存结果到 `output/` 目录

### Python 代码调用

```python
from sap_connector import SAPConnector, load_config

# 加载配置并创建连接
config = load_config()
conn = SAPConnector(config)

# 获取程序源码
result = conn.get_full_object("PROG", "ZJQR0000")
if "source" in result:
    print(f"源码长度: {result['source_length']} 字符")
    print(f"包含的 INCLUDE: {result.get('includes', [])}")

# 获取表数据
table_result = conn.get_table_data("MARA", rows=10)
if "data" in table_result:
    print(f"记录数: {len(table_result['data'])}")
```

## OpenCode 使用提示词

### 提示词示例

以下是常用的 OpenCode/AI 提示词，可以直接复制使用：

---

#### 1. 获取表数据

**提示词：**
```
使用 ai4sap skill 获取 ZTJQ0003 表的前10条数据并分析
```

**返回结果：**
```json
{
  "data": [
    {"MANDT": "400", "SID": 5, "NAME": "555", "SEX": "1", "TEST_OPENCODE": "A", "REMAMRK": "555"},
    {"MANDT": "400", "SID": 1, "NAME": "jieqiang", "SEX": "1", "TEST_OPENCODE": "A", "REMAMRK": "JIEQIANG"},
    {"MANDT": "400", "SID": 2, "NAME": "张三", "SEX": "1", "TEST_OPENCODE": "B", "REMAMRK": "张三"},
    {"MANDT": "400", "SID": 3, "NAME": "333", "SEX": "1", "TEST_OPENCODE": "C", "REMAMRK": "333"}
  ]
}
```

---

#### 2. 获取程序源码

**提示词：**
```
使用 ai4sap skill 获取 ZJQR0000 源码，并分析程序结构
```

**返回结果：**
```abap
=== 程序基本信息 ===
类型: PROG
名称: ZJQR0000
源码长度: 506 字符
INCLUDE数量: 1
INCLUDE列表: ['ZJQR0000_FRM']

=== 源码内容 ===
REPORT zjqr0000.

INITIALIZATION.
  INCLUDE zjqr0000_frm.

START-OF-SELECTION.
  DATA: a TYPE i.
  DATA: b TYPE i.
  DATA: c TYPE i.
  a = 1.
  b = 2.

  PERFORM frm_add_num USING a b CHANGING c.
  WRITE:/ 'c: ', c.

  PERFORM frm_write_hello.
```

---

#### 3. 获取 INCLUDE 源码

**提示词：**
```
使用 ai4sap skill 获取 ZJQR0000_FRM INCLUDE 的源码并分析
```

**返回结果：**
```abap
=== INCLUDE ZJQR0000_FRM ===
源码长度: 1202 字符

FORM frm_add_num USING p_a p_b CHANGING p_c.
  p_c = p_a + p_b.
ENDFORM.

FORM frm_write_hello.
  WRITE:/ 'hello, abap'.
ENDFORM.
```

---

#### 4. 获取类源码

**提示词：**
```
使用 ai4sap skill 获取 ZCL_TEST 类的源码并分析
```

**返回结果：**
```abap
=== CLASS ZCL_TEST ===
源码长度: 2530 字符

CLASS zcl_test DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor,
             get_data RETURNING VALUE(rv_data) TYPE string.
  PRIVATE SECTION.
    DATA: mv_data TYPE string.
ENDCLASS.

CLASS zcl_test IMPLEMENTATION.
  METHOD constructor.
    mv_data = 'Hello World'.
  ENDMETHOD.

  METHOD get_data.
    rv_data = mv_data.
  ENDMETHOD.
ENDCLASS.
```

---

#### 5. 获取表结构

**提示词：**
```
使用 ai4sap skill 获取 MARA 表的结构信息
```

---

#### 6. 综合分析

**提示词：**
```
使用 ai4sap skill 完成以下任务：
1. 获取 ZJQR0000 程序源码
2. 获取其包含的 INCLUDE 源码
3. 获取 ZTJQ0003 表的前10条数据
4. 分析程序结构和表数据
```

---

## API 参考

### 连接配置

```python
config = load_config()  # 从 .env 文件加载
# 或指定配置文件
config = load_config("/path/to/.env")
conn = SAPConnector(config)
```

### 获取源码

```python
# 获取程序源码
source = conn.get_source("PROG", "ZJQR0000")

# 获取类的源码
source = conn.get_source("CLASS", "ZCL_TEST")

# 获取完整的对象信息（包含源码、INCLUDE、文本符号）
full_object = conn.get_full_object("PROG", "ZJQR0000")
```

### 获取表数据

```python
# 通过自定义端点获取表数据
result = conn.get_table_data("MARA", rows=10)

# result 格式:
# {"data": [...], "success": true}
```

### 获取对象信息

```python
# 获取表结构信息
info = conn.get_object_info("TABL", "MARA")

# 搜索 SAP 对象
results = conn.search_objects("ZJQR*", ["PROG", "CLASS"])
```

### 提取程序元素

```python
# 获取程序包含的 INCLUDE
includes = conn.get_includes("ZJQR0000")

# 获取文本符号
text_symbols = conn.get_text_symbols("ZJQR0000")
```

## 支持的对象类型

| 类型 | 说明 | API 路径 |
|------|------|----------|
| PROG | 程序 | /sap/bc/adt/programs/programs |
| INCLUDE | Include 程序 | /sap/bc/adt/programs/includes |
| CLASS | 类 | /sap/bc/adt/oo/classes |
| TABL | 表 | /sap/bc/adt/ddic/tables |
| VIEW | 视图 | /sap/bc/adt/ddic/views |
| DOMAIN | 域 | /sap/bc/adt/ddic/domains |
| DTEL | 数据元素 | /sap/bc/adt/ddic/dtel |

## 输出说明

### 文件输出

运行脚本后，结果保存在 `output/` 目录：

```
output/
├── ZJQR0000_prog.json      # 程序 JSON 元数据
├── ZJQR0000_prog.src       # 程序源码
├── ZJQR0000_FRM_include.json
├── ZJQR0000_FRM_include.src
├── ZCL_TEST_class.json
├── ZCL_TEST_class.src
├── mara_table_data.json
└── ...
```

### 数据格式

- **JSON 文件**: 包含完整的对象信息和元数据
- **源码文件 (.src)**: 原始 ABAP 源码

## 常见问题

### 连接失败

1. 检查 `.env` 配置是否正确
2. 确认 SAP 服务器地址和端口可访问
3. 验证用户名密码
4. 检查网络防火墙设置

### 权限不足

确保 SAP 账号具有以下权限：
- S_ADT_RES_URI (ADT 资源访问)
- S_DEVELOPER (开发对象访问)

### 表数据获取失败

部分 SAP 系统未启用 `/sap/bc/zzjq` 端点，请联系 SAP Basis 团队确认是否可用。

## 目录结构

```
ai4sap/
├── sap_connector.py     # 主连接器
├── .env.example         # 配置模板
├── .env                 # 配置文件（本地）
├── output/              # 输出目录
└── README.md           # 使用指南
```

## 相关文档

- [ADT REST API 官方文档](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/index.htm)
- [SAP ABAP 编程指南](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/index.htm)
