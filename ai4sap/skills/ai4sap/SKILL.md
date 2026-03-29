---
name: ai4sap
description: 简单易用的SAP REST API集成技能 - 连接SAP系统获取源码和表数据
---

# AI4SAP 技能

这是一个简单易用的SAP REST API集成技能，专门为计算机小白设计。只需配置一个文件，就能连接SAP系统获取程序源码和表数据。

## 什么时候使用这个技能

当你需要：
- 连接SAP系统读取程序源码
- 获取SAP表的数据和结构
- 分析SAP程序内容
- 不用写代码就能查询SAP数据

## 快速开始

### 第一步：安装依赖

```bash
pip install requests python-dotenv
```

### 第二步：配置连接信息

1. 复制 `.env.example` 文件为 `.env`

2. 用记事本或编辑器打开 `.env`，填入你的SAP连接信息：

```
SAP_USER=你的用户名
SAP_PASSWORD=你的密码
SAP_CLIENT=400
SAP_LANG=ZH
SAP_HOST=你的SAP服务器地址
SAP_PORT=端口号
SAP_PROTOCOL=http
```

**填写示例：**
```
SAP_USER=U1170
SAP_PASSWORD=hysoft888999
SAP_CLIENT=400
SAP_LANG=ZH
SAP_HOST=mysap.goodsap.cn
SAP_PORT=50400
SAP_PROTOCOL=http
```

### 第三步：运行示例

```bash
cd skills/ai4sap
python sap_connector.py
```

这个脚本会：
1. 自动读取 `.env` 配置
2. 连接SAP系统
3. 获取示例程序源码
4. 保存结果到 `output/` 文件夹

## 常用查询示例

### 查询表数据

```python
from sap_connector import SAPConnector, load_config

# 加载配置并连接
config = load_config()
conn = SAPConnector(config)

# 查询MARA表前10条数据
result = conn.get_table_data("MARA", rows=10)
print(result)
```

### 查询程序源码

```python
# 获取程序源码
result = conn.get_full_object("PROG", "ZJQR0000")
print(result["source"])  # 打印源码
```

### 查询类源码

```python
# 获取类源码
result = conn.get_full_object("CLASS", "ZCL_TEST")
```

### 查询表结构

```python
# 获取表结构信息
result = conn.get_object_info("TABL", "MARA")
```

## 技能文件说明

```
ai4sap/
├── sap_connector.py    # 主程序（Python脚本）
├── .env.example        # 配置模板（复制为 .env 使用）
├── .env               # 你的配置文件（不要提交给他人！）
└── output/            # 查询结果保存目录
```

## 常见问题

### 连接失败怎么办？

1. 检查 `.env` 配置是否正确
2. 确认SAP服务器地址和端口
3. 确认用户名密码正确
4. 检查网络是否能访问SAP服务器

### 提示没有权限？

联系SAP管理员，给你的账号开通ADT权限。

### 结果保存在哪里？

默认保存在 `output/` 文件夹，可以打开查看JSON格式的结果。

## 技术支持

支持的SAP对象类型：
- PROG - 程序
- CLASS - 类
- INCLUDE - Include程序
- TABL - 表
- VIEW - 视图
- DOMAIN - 域
- DTEL - 数据元素

---

*简单、稳定、实用 - 连接SAP就是这么快！*
