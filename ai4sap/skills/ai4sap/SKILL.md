---
name: ai4sap
description: SAP ADT REST API 源码集成技能 - 通过ABAP Development Tools接口获取SAP程序源码、类、Include等开发对象的源代码
---

# AI4SAP 技能

## 技能概述

AI4SAP 提供了一套完整的 SAP ADT (ABAP Development Tools) REST API 集成解决方案。本技能专注于 SAP 开发对象源码的检索与分析，支持程序、类、Include、域、数据元素、表结构等对象的源码获取。

## 适用场景

- 检索 SAP 程序源代码
- 获取 ABAP 类实现
- 分析 Include 程序依赖关系
- 提取文本符号和程序结构
- 批量搜索 SAP 开发对象

## 核心功能

### 支持的对象类型

| 对象类型 | 说明 | API 端点 |
|---------|------|---------|
| PROG | ABAP 程序 | /sap/bc/adt/programs/programs |
| INCLUDE | Include 程序 | /sap/bc/adt/programs/includes |
| CLASS | ABAP 类 | /sap/bc/adt/oo/classes |
| TABL | 数据表结构 | /sap/bc/adt/ddic/tables |
| VIEW | 视图结构 | /sap/bc/adt/ddic/views |
| DOMAIN | 域定义 | /sap/bc/adt/ddic/domains |
| DTEL | 数据元素 | /sap/bc/adt/ddic/dtel |

### 主要功能

1. **源码检索** - 获取任意 SAP 开发对象的源代码
2. **依赖分析** - 自动提取程序包含的 Include 列表
3. **结构解析** - 提取文本符号、类方法等元素
4. **对象搜索** - 按名称模式搜索 SAP 对象

## 配置说明

### 环境依赖

```bash
pip install requests python-dotenv
```

### 配置文件

复制 `.env.example` 为 `.env` 并配置以下参数：

| 参数 | 必填 | 说明 | 示例 |
|------|-----|------|------|
| SAP_USER | 是 | SAP 用户名 | U1170 |
| SAP_PASSWORD | 是 | SAP 密码 | ****** |
| SAP_CLIENT | 是 | SAP 客户端 | 400 |
| SAP_LANG | 否 | 语言 | ZH |
| SAP_HOST | 是 | SAP 服务器地址 | mysap.goodsap.cn |
| SAP_PORT | 是 | 服务端口 | 50400 |
| SAP_PROTOCOL | 否 | 协议 | http |

## 使用示例

### 基本用法

```python
from sap_connector import SAPConnector, load_config

# 初始化连接
config = load_config()
conn = SAPConnector(config)

# 获取程序源码
result = conn.get_full_object("PROG", "ZJQR0000")
print(result["source"])
```

### 获取 Include 源码

```python
# 获取 Include 程序源码
include_source = conn.get_source("INCLUDE", "ZJQR0000_FRM")
```

### 获取类源码

```python
# 获取 ABAP 类源码
class_source = conn.get_full_object("CLASS", "ZCL_TEST")
```

### 提取程序元素

```python
# 获取程序包含的 Include
includes = conn.get_includes("ZJQR0000")

# 获取文本符号
text_symbols = conn.get_text_symbols("ZJQR0000")
```

## 技能文件结构

```
ai4sap/
├── sap_connector.py     # 核心连接器
├── .env.example        # 配置模板
├── .env                # 配置文件（本地）
├── output/             # 输出目录
└── README.md          # 详细文档
```

## 注意事项

1. 确保 SAP 账号具有 S_ADT_RES_URI 和 S_DEVELOPER 权限
2. 部分老旧 SAP 系统可能不支持 ADT REST API
3. 建议使用 HTTPS 协议确保通信安全

## 相关文档

详细使用说明请参阅 [README.md](./README.md)
