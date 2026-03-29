# AI4SAP 使用指南

## 概述

AI4SAP 提供了一套完整的 SAP ADT (ABAP Development Tools) REST API 集成解决方案。本技能专注于 SAP 开发对象源码的检索与分析，通过标准 RESTful 接口连接 SAP 系统，获取程序、类、Include 等开发对象的源代码及元数据。

本技能适用于需要分析 SAP ABAP 源码、进行代码审计、提取程序结构的开发者和架构师。

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

编辑 `.env` 文件，配置以下参数：

| 参数 | 必填 | 说明 | 示例 |
|------|-----|------|------|
| SAP_USER | 是 | SAP 用户名 | U1170 |
| SAP_PASSWORD | 是 | SAP 密码 | hysoft888999 |
| SAP_CLIENT | 是 | SAP 客户端 | 400 |
| SAP_LANG | 否 | 语言 | ZH |
| SAP_HOST | 是 | SAP 服务器地址 | mysap.goodsap.cn |
| SAP_PORT | 是 | 服务端口 | 50400 |
| SAP_PROTOCOL | 否 | 协议 | http / https |

## 快速开始

### 运行示例脚本

```bash
cd skills/ai4sap
python sap_connector.py
```

脚本执行流程：
1. 读取 `.env` 配置文件
2. 建立 SAP ADT REST API 连接
3. 获取示例程序源码（PROG、INCLUDE、CLASS）
4. 提取程序元素（Include、文本符号）
5. 输出结果至 `output/` 目录

### Python API 调用

```python
from sap_connector import SAPConnector, load_config

# 初始化连接
config = load_config()
conn = SAPConnector(config)

# 获取程序完整信息
result = conn.get_full_object("PROG", "ZJQR0000")
if "source" in result:
    print(f"源码长度: {result['source_length']} 字符")
    print(f"包含 INCLUDE: {result.get('includes', [])}")
    print(f"文本符号: {result.get('text_symbols', [])}")
```

## OpenCode 提示词模板

### 1. 获取程序源码

**提示词：**
```
使用 ai4sap skill 获取 ZJQR0000 程序的源码并分析程序结构
```

**预期返回：**
```json
{
  "type": "PROG",
  "name": "ZJQR0000",
  "source_length": 506,
  "includes": ["ZJQR0000_FRM"],
  "source": "REPORT zjqr0000.\n\nINITIALIZATION.\n  INCLUDE zjqr0000_frm.\n\nSTART-OF-SELECTION.\n  ..."
}
```

### 2. 获取 Include 源码

**提示词：**
```
使用 ai4sap skill 获取 ZJQR0000_FRM 的源码并分析其包含的子程序
```

**预期返回：**
```abap
FORM frm_add_num USING p_a p_b CHANGING p_c.
  p_c = p_a + p_b.
ENDFORM.

FORM frm_write_hello.
  WRITE:/ 'hello, abap'.
ENDFORM.
```

### 3. 获取类源码

**提示词：**
```
使用 ai4sap skill 获取 ZCL_TEST 类的完整源码和方法列表
```

### 4. 分析程序依赖

**提示词：**
```
使用 ai4sap skill 完成以下任务：
1. 获取 ZJQR0000 程序源码
2. 获取其包含的所有 INCLUDE
3. 分析程序的调用关系和依赖
```

### 5. 获取表结构

**提示词：**
```
使用 ai4sap skill 获取 MARA 表的结构定义
```

### 6. 批量搜索对象

**提示词：**
```
使用 ai4sap skill 搜索所有以 ZJQR 开头的程序和类
```

## API 参考

### 初始化连接

```python
# 从 .env 文件加载配置
config = load_config()

# 或指定配置文件路径
config = load_config("/path/to/.env")

# 创建连接实例
conn = SAPConnector(config)
```

### 源码检索

```python
# 获取程序源码
source = conn.get_source("PROG", "ZJQR0000")

# 获取 Include 源码
source = conn.get_source("INCLUDE", "ZJQR0000_FRM")

# 获取类源码
source = conn.get_source("CLASS", "ZCL_TEST")

# 获取完整对象信息（包含源码、INCLUDE、文本符号）
full_object = conn.get_full_object("PROG", "ZJQR0000")
```

### 程序元素提取

```python
# 获取程序包含的 INCLUDE 列表
includes = conn.get_includes("ZJQR0000")

# 获取文本符号列表
text_symbols = conn.get_text_symbols("ZJQR0000")

# 获取对象元数据信息
info = conn.get_object_info("TABL", "MARA")
```

### 对象搜索

```python
# 按模式搜索 SAP 对象
results = conn.search_objects("ZJQR*", ["PROG", "CLASS"])
```

## 支持的对象类型

| 类型 | 说明 | API 路径 |
|------|------|----------|
| PROG | ABAP 程序 | /sap/bc/adt/programs/programs |
| INCLUDE | Include 程序 | /sap/bc/adt/programs/includes |
| CLASS | ABAP 类 | /sap/bc/adt/oo/classes |
| TABL | 数据表 | /sap/bc/adt/ddic/tables |
| VIEW | 视图 | /sap/bc/adt/ddic/views |
| DOMAIN | 域定义 | /sap/bc/adt/ddic/domains |
| DTEL | 数据元素 | /sap/bc/adt/ddic/dtel |

## 输出说明

### 文件输出

运行脚本后，结果保存在 `output/` 目录：

```
output/
├── ZJQR0000_prog.json          # 程序 JSON 元数据
├── ZJQR0000_prog.src           # 程序源码文件
├── ZJQR0000_FRM_include.json   # Include JSON 元数据
├── ZJQR0000_FRM_include.src   # Include 源码文件
├── ZCL_TEST_class.json          # 类 JSON 元数据
├── ZCL_TEST_class.src          # 类源码文件
└── ...
```

### 数据格式

- **JSON 文件**: 包含完整的对象信息、元数据、元素列表
- **源码文件 (.src)**: 原始 ABAP 源代码

## 常见问题

### 连接失败

1. 验证 `.env` 配置文件参数正确
2. 确认 SAP 服务器地址和端口可访问
3. 检查用户名密码认证信息
4. 确认网络防火墙未阻止请求

### 权限不足

确保 SAP 用户账号具备以下权限：
- S_ADT_RES_URI (ADT 资源访问权限)
- S_DEVELOPER (开发对象访问权限)

### 对象未找到

1. 确认对象名称大小写正确
2. 验证对象存在于对应客户端
3. 检查 SAP 系统是否启用 ADT 服务

## 目录结构

```
ai4sap/
├── sap_connector.py     # 核心连接器
├── .env.example        # 配置模板
├── .env                # 配置文件（本地）
├── output/             # 输出目录
└── README.md          # 使用指南
```

## 参考资料

- [SAP ADT REST API 官方文档](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/index.htm)
- [SAP ABAP 编程指南](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/index.htm)
