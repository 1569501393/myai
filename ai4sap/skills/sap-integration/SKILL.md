---
name: sap-integration
description: 创建和使用SAP REST API集成技能，用于连接SAP系统、分析源码和表数据，提供最佳实践和使用场景
---

# SAP集成技能

此技能提供了一个完整的SAP REST API集成解决方案，包括Python连接器、使用示例和最佳实践指南。

## 何时使用此技能

当您需要：
1. 通过REST API连接到SAP系统
2. 检索SAP对象源码（程序、类、包括等）
3. 获取SAP表数据和结构
4. 分析SAP源码和表数据
5. 了解SAP REST API的最佳实践和使用场景

## 技能组成部分

此技能包括：
1. **SAP连接器** (`sap_connector.py`) - 优化的Python类，用于与SAP系统交互
2. **使用示例** (`examples/`目录) - 演示常见使用场景的脚本
3. **最佳实践文档** (`doc/`目录) - 详细的使用指南和分析报告
4. **配置文件** (`config/sap_config.yaml`) - SAP连接参数

## 工作流程

### 1. 环境准备
```bash
# 确保已安装依赖
pip install requests pyyaml

# 配置SAP连接参数
cp config/sap_config.yaml.template config/sap_config.yaml
# 编辑config/sap_config.yaml填入您的SAP连接信息
```

### 2. 基本使用
```python
from sap_connector import SAPConnector
import yaml

# 加载配置
config = yaml.safe_load(open("config/sap_config.yaml"))

# 创建连接器实例
conn = SAPConnector(config)

# 检索SAP程序源码
result = conn.get_full_object("PROG", "ZJQR0000")
if "source" in result:
    print(f"程序源码长度: {result['source_length']} 字符")
    print(f"包含的包括: {', '.join(result.get('includes', []))}")

# 获取表数据（通过自定义端点）
table_result = conn.get_table_data("MARA", rows=10)
if "data" in table_result:
    print(f"成功获取MARA表数据，共{len(table_result['data'])}条记录")
```

### 3. 高级功能
- 检索SAP类源码：`conn.get_full_object("CLASS", "ZCL_TEST")`
- 获取对象包含的包括：`conn.get_includes("ZJQR0000")`
- 提取文本符号：`conn.get_text_symbols("ZJQR0000")`
- 搜索SAP对象：`conn.search_objects("ZJQR*", ["PROG", "CLASS"])`

## 使用场景

### 场景1：SAP程序分析
```python
# 分析SAP程序结构和依赖
def analyze_sap_program(program_name):
    result = conn.get_full_object("PROG", program_name)
    if "source" not in result:
        return f"无法获取程序 {program_name} 的源码: {result.get('error')}"
    
    analysis = {
        "程序名": program_name,
        "源码长度": result["source_length"],
        "包括数量": len(result.get("includes", [])),
        "文本符号数量": len(result.get("text_symbols", [])),
        "包括列表": result.get("includes", []),
        "文本符号": result.get("text_symbols", [])
    }
    return analysis

# 使用示例
program_analysis = analyze_sap_program("ZJQR0000")
print(f"程序分析结果: {program_analysis}")
```

### 场景2：表数据提取和分析
```python
# 提取和分析SAP表数据
def extract_table_data(table_name, max_rows=100):
    result = conn.get_table_data(table_name, rows=max_rows)
    if "data" not in result:
        return f"无法获取表 {table_name} 的数据: {result.get('error')}"
    
    data = result["data"]
    if not isinstance(data, list) or len(data) == 0:
        return "表数据为空或格式不正确"
    
    # 分析数据结构
    first_record = data[0] if isinstance(data[0], dict) else {}
    analysis = {
        "表名": table_name,
        "记录数量": len(data),
        "字段列表": list(first_record.keys()) if isinstance(first_record, dict) else [],
        "数据类型": "JSON数组" if isinstance(data, list) else type(data).__name__,
        "样本数据": data[:3] if len(data) >= 3 else data
    }
    return analysis

# 使用示例
table_analysis = extract_table_data("MARA", 50)
print(f"表数据分析: {table_analysis}")
```

### 场景3：自定义SAP REST API集成
参考文档：`doc/20260329193536-创建自定义-SAP-REST-API-获取表结构和数据指南.md`

## 最佳实践

### 连接和认证
1. 始终使用配置文件管理敏感信息（用户名/密码）
2. 在生产环境中考虑使用证书或令牌认证
3. 实现连接超时和重试机制
4. 监控API调用频率以避免超过SAP系统限制

### 错误处理
1. 检查HTTP状态码并相应处理不同错误类型
2. 处理JSON解析错误（某些端点可能返回非JSON数据）
3. 实现指数回退重试机制应对临时网络问题
4. 记录详细错误信息以便故障排除

### 性能优化
1. 批量请求：尽可能一次获取多条记录而非多次单条请求
2. 缓存策略：对于经常访问且很少变化的数据（如表结构）实施缓存
3. 选择性字段：仅请求需要的字段以减少数据传输量
4. 异步处理：对于独立的API调用考虑使用异步请求

### 数据安全
1. 永远不要在代码中硬编码凭据
2. 使用环境变量或安全 vault 管理敏感信息
3. 加密存储包含敏感数据的输出文件
4. 实施访问控制审计谁何时访问了SAP数据

## 常见问题解决

### 问题：认证失败
- 检查用户名和密码是否正确
- 确认SAP用户具有所需的ADT权限
- 验证基础URL是否正确指向SAP系统
- 检查是否需要额外的头信息（如特定的客户端）

### 问题：端点返回404
- 验证对象名称是否正确（注意大小写）
- 确认SAP系统是否启用了相应的ADT服务
- 检查是否使用了正确的对象类型前缀
- 尝试使用对象的完整技术名称

### 问题：表数据无法通过标准ADT端点获取
- 并非所有SAP系统都启用了`/sap/bc/adt/ddic/tables/*/data`端点
- 使用自定义端点（如`/sap/bc/zzjq`）作为替代方案
- 考虑使用ODATA服务或BAPI作为替代数据获取方式
- 咨询SAP Basis团队以启用所需的ADT端点

## 文件结构

```
ai4sap/
├── sap_connector.py          # 主连接器类
├── config/
│   └── sap_config.yaml       # SAP连接配置
├── examples/
│   ├── read_table_mara.py    # 表数据读取示例
│   ├── get_program_source.py # 源码读取示例
│   └── README.md             # 示例说明
├── doc/                      # 详细文档和最佳实践
│   ├── 20260329165244-ADT接口参考文档.md
│   ├── 20260329193536-创建自定义-SAP-REST-API-获取表结构和数据指南.md
│   └── ... (其他分析报告)
├── output/                   # 输出文件目录
└── skills/
    └── sap-integration/      # 本技能目录
        └── SKILL.md          # 此文件
```

## 持续改进

此技能将定期更新以包括：
1. 支持更多SAP对象类型
2. 改进错误处理和恢复机制
3. 添加异步操作支持
4. 集成更多SAP数据访问方法（ODATA、BAPI、RFC）
5. 提高性能和缓存策略

## 贡献指南

如果您希望为此技能做出贡献：
1. Fork此仓库
2. 创建功能分支：`git checkout -b feature/your-feature-name`
3. 提交更改：`git commit -m 'feat: 添加新功能'`
4. 推送到分支：`git push origin feature/your-feature-name`
5. 提交Pull Request

---

*此技能基于实际SAP系统集成经验开发，提供了可生产使用的SAP REST API集成解决方案。*