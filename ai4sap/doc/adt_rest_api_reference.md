# SAP ADT REST API 完整参考

## 概述

SAP ADT (ABAP Development Tools) REST API 是 SAP 提供的用于访问 ABAP 开发对象的 HTTP 接口。通过该 API 可以读取、搜索、修改 ABAP 源代码和开发对象。

**基础 URL**: `http://{host}:{port}/sap/bc/adt`

---

## 一、API 端点列表

### 1. 程序 (Programs)

| 端点 | 方法 | 描述 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/programs/programs` | GET | 获取程序列表 | ⚠️ 需正确参数 |
| `/sap/bc/adt/programs/programs/{name}` | GET | 程序元数据 | ⚠️ Accept 限制 |
| `/sap/bc/adt/programs/programs/{name}/source/main` | GET | 程序源码 | ✅ |
| `/sap/bc/adt/programs/programs/{name}/source/main` | PUT | 更新程序源码 | ⚠️ 需授权 |
| `/sap/bc/adt/programs/programs/{name}/includes` | GET | 获取包含文件列表 | ⚠️ |
| `/sap/bc/adt/programs/programs/{name}/textelements` | GET | 文本元素 | ⚠️ |

**示例**:
```bash
GET /sap/bc/adt/programs/programs/ZJQR0000/source/main
Accept: text/plain
```

**响应**:
```abap
REPORT zjqr0000.
INITIALIZATION.
  INCLUDE zjqr0000_frm.
START-OF-SELECTION.
  DATA: a TYPE i.
  ...
```

### 2. 包含文件 (Includes)

| 端点 | 方法 | 描述 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/programs/includes/{name}` | GET | 包含文件元数据 | ⚠️ |
| `/sap/bc/adt/programs/includes/{name}/source/main` | GET | 包含文件源码 | ✅ |
| `/sap/bc/adt/programs/includes/{name}/source/main` | PUT | 更新包含文件 | ⚠️ 需授权 |

**示例**:
```bash
GET /sap/bc/adt/programs/includes/ZJQR0000_FRM/source/main
```

### 3. ABAP 类 (Classes)

| 端点 | 方法 | 描述 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/oo/classes` | GET | 类列表 | ⚠️ 需正确参数 |
| `/sap/bc/adt/oo/classes/{name}` | GET | 类元数据 | ⚠️ |
| `/sap/bc/adt/oo/classes/{name}/source/main` | GET | 类源码(定义+实现) | ✅ |
| `/sap/bc/adt/oo/classes/{name}/source/definitions` | GET | 类定义 | ⚠️ |
| `/sap/bc/adt/oo/classes/{name}/source/implementation` | GET | 类实现 | ⚠️ |
| `/sap/bc/adt/oo/classes/{name}/includes` | GET | 类包含文件 | ⚠️ |
| `/sap/bc/adt/oo/classes/{name}/testclasses` | GET | 测试类 | ⚠️ |

**示例**:
```bash
GET /sap/bc/adt/oo/classes/ZCL_TEST/source/main
```

**响应**:
```abap
CLASS zcl_test DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_http_extension.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_test IMPLEMENTATION.
  METHOD if_http_extension~handle_request.
    ...
  ENDMETHOD.
ENDCLASS.
```

### 4. 接口 (Interfaces)

| 端点 | 方法 | 描述 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/oo/interfaces` | GET | 接口列表 | ⚠️ |
| `/sap/bc/adt/oo/interfaces/{name}` | GET | 接口元数据 | ⚠️ |
| `/sap/bc/adt/oo/interfaces/{name}/source/main` | GET | 接口源码 | ✅ |

### 5. 函数组 (Function Groups)

| 端点 | 方法 | 描述 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/functions/groups` | GET | 函数组列表 | ⚠️ |
| `/sap/bc/adt/functions/groups/{name}` | GET | 函数组元数据 | ⚠️ |
| `/sap/bc/adt/functions/groups/{name}/includes/{include}` | GET | 函数组包含文件 | ⚠️ |
| `/sap/bc/adt/functions/groups/{name}/includes/{include}/source/main` | GET | 包含文件源码 | ⚠️ |

### 6. 数据字典 (DDIC)

| 端点 | 方法 | 描述 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/ddic/tables` | GET | 表列表 | ⚠️ |
| `/sap/bc/adt/ddic/tables/{name}` | GET | 表元数据 | ⚠️ |
| `/sap/bc/adt/ddic/tables/{name}/source/main` | GET | 表定义源码 | ✅ |
| `/sap/bc/adt/ddic/views` | GET | 视图列表 | ⚠️ |
| `/sap/bc/adt/ddic/views/{name}` | GET | 视图元数据 | ⚠️ |
| `/sap/bc/adt/ddic/dtel` | GET | 数据元素列表 | ⚠️ |
| `/sap/bc/adt/ddic/dtel/{name}` | GET | 数据元素元数据 | ⚠️ |
| `/sap/bc/adt/ddic/domains` | GET | 域列表 | ⚠️ |
| `/sap/bc/adt/ddic/domains/{name}` | GET | 域元数据 | ⚠️ |
| `/sap/bc/adt/ddic/domains/{name}/source/main` | GET | 域源码 | ⚠️ |

**示例 (表定义)**:
```bash
GET /sap/bc/adt/ddic/tables/MARA/source/main
```

### 7. 传输请求 (Transports)

| 端点 | 方法 | 描述 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/cts/transportrequests` | GET | 传输请求列表 | ⚠️ |
| `/sap/bc/adt/cts/transportrequests/{request}` | GET | 传输请求详情 | ⚠️ |
| `/sap/bc/adt/cts/changelists` | GET | 更改列表 | ⚠️ |

### 8. 单元测试 (Unit Tests)

| 端点 | 方法 | 描述 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/abapunit/testruns` | POST | 执行单元测试 | ⚠️ |
| `/sap/bc/adt/abapunit/testruns/{runId}` | GET | 获取测试结果 | ⚠️ |
| `/sap/bc/adt/abapunit/testruns/{runId}/coverage` | GET | 测试覆盖率 | ⚠️ |

### 9. 搜索 (Search)

| 端点 | 方法 | 描述 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/repository/informationservice/search` | GET | 搜索对象 | ⚠️ |
| `/sap/bc/adt/search` | GET | 全局搜索 | ⚠️ |

### 10. 系统信息 (System)

| 端点 | 方法 | 描述 | 状态 |
|------|------|------|------|
| `/sap/bc/adt/system` | GET | 系统信息 | ⚠️ |
| `/sap/bc/adt/discovery` | GET | 服务发现 | ⚠️ |
| `/sap/bc/adt/core/discovery` | GET | 核心服务发现 | ⚠️ |

---

## 二、请求头规范

### 通用请求头

```http
Authorization: Basic base64(user:password)
sap-client: 400
sap-language: ZH
Accept: text/plain
```

### Accept 头选项

| Accept 值 | 用途 |
|-----------|------|
| `text/plain` | 获取纯文本源码 |
| `application/atom+xml` | 获取 XML 元数据 |
| `application/xml` | 获取 XML 格式 |
| `application/json` | 获取 JSON 格式 |

---

## 三、已验证的可用端点 (测试系统)

### 测试环境

- **URL**: http://mysap.goodsap.cn:50400
- **Client**: 400
- **User**: U1170

### 验证结果 (2026-03-29)

| 端点 | 状态 | 返回内容 |
|------|------|----------|
| `/sap/bc/adt/programs/programs/{name}/source/main` | ✅ 200 | 程序源码 |
| `/sap/bc/adt/programs/includes/{name}/source/main` | ✅ 200 | 包含文件源码 |
| `/sap/bc/adt/oo/classes/{name}/source/main` | ✅ 200 | 类源码 |
| `/sap/bc/adt/oo/interfaces/{name}/source/main` | ✅ 200 | 接口源码 |
| `/sap/bc/adt/ddic/tables/{name}/source/main` | ✅ 200 | 表定义源码 |

---

## 四、错误码

| HTTP 状态码 | 含义 |
|-------------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 认证失败 |
| 403 | 无权限 |
| 404 | 资源不存在 |
| 405 | 方法不允许 |
| 406 | Accept 头不支持 |
| 500 | 服务器内部错误 |

---

## 五、最佳实践

### 1. 认证与安全

```python
import base64
import requests

def get_headers(user, passwd, client='400', lang='ZH'):
    credentials = base64.b64encode(f'{user}:{passwd}'.encode()).decode()
    return {
        'Authorization': f'Basic {credentials}',
        'sap-client': client,
        'sap-language': lang,
        'Accept': 'text/plain'
    }
```

**建议**:
- 使用 HTTPS 而非 HTTP
- 避免在代码中硬编码密码
- 使用环境变量或配置文件存储凭据
- 考虑使用 OAuth 2.0 (S/4HANA Cloud)

### 2. 错误处理

```python
def safe_request(url, headers, timeout=30):
    try:
        response = requests.get(url, headers=headers, timeout=timeout)
        if response.status_code == 200:
            return {'success': True, 'data': response.text}
        elif response.status_code == 401:
            return {'error': 'Authentication failed'}
        elif response.status_code == 404:
            return {'error': 'Resource not found'}
        elif response.status_code == 406:
            return {'error': 'Accept header not supported'}
        else:
            return {'error': f'HTTP {response.status_code}'}
    except requests.exceptions.Timeout:
        return {'error': 'Request timeout'}
    except requests.exceptions.ConnectionError:
        return {'error': 'Connection failed'}
```

### 3. 连接池管理

```python
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

def create_session():
    session = requests.Session()
    retry = Retry(total=3, backoff_factor=0.1)
    adapter = HTTPAdapter(max_retries=retry)
    session.mount('http://', adapter)
    session.mount('https://', adapter)
    return session
```

### 4. 批量获取源码

```python
def get_multiple_sources(connector, objects):
    results = {}
    for obj_type, obj_name in objects:
        key = f'{obj_type}/{obj_name}'
        result = connector.get_source(obj_type, obj_name)
        results[key] = result
    return results
```

### 5. 源码写入更新

```python
def update_source(base_url, headers, obj_type, obj_name, new_source):
    path = f'/sap/bc/adt/{obj_type}/{obj_name}/source/main'
    response = requests.put(
        f'{base_url}{path}',
        headers={**headers, 'Content-Type': 'text/plain; charset=utf-8'},
        data=new_source.encode('utf-8')
    )
    return response.status_code == 200
```

### 6. 性能优化

- **复用连接**: 使用 `requests.Session()` 复用 HTTP 连接
- **并发请求**: 使用 `asyncio` 或 `threading` 并发获取多个对象
- **缓存结果**: 对不常变化的对象进行本地缓存
- **限制超时**: 设置合理的超时时间 (推荐 30 秒)

### 7. 对象类型映射

```python
SUPPORTED_TYPES = {
    'PROG': '/sap/bc/adt/programs/programs',
    'INCLUDE': '/sap/bc/adt/programs/includes',
    'CLASS': '/sap/bc/adt/oo/classes',
    'INTF': '/sap/bc/adt/oo/interfaces',
    'FUGR': '/sap/bc/adt/functions/groups',
    'TABL': '/sap/bc/adt/ddic/tables',
    'VIEW': '/sap/bc/adt/ddic/views',
    'DTEL': '/sap/bc/adt/ddic/dtel',
    'DOMA': '/sap/bc/adt/ddic/domains',
}
```

---

## 六、常见用例

### 用例 1: 获取程序源码

```python
from sap_connector import SAPConnector, load_config

config = load_config()
conn = SAPConnector(config)
result = conn.get_source('PROG', 'ZMY_PROGRAM')
print(result['source'])
```

### 用例 2: 获取类定义和实现

```python
result = conn.get_source('CLASS', 'ZCL_MY_CLASS')
# 包含 DEFINITION 和 IMPLEMENTATION 两部分
print(result['source'])
```

### 用例 3: 分析程序依赖

```python
result = conn.get_full_object('PROG', 'ZMY_PROGRAM')
print('Includes:', result['includes'])
print('Text Symbols:', result['text_symbols'])
```

### 用例 4: 批量导出源码

```python
objects = [
    ('PROG', 'ZPROG1'),
    ('PROG', 'ZPROG2'),
    ('CLASS', 'ZCL_CLASS1'),
]

for obj_type, obj_name in objects:
    result = conn.get_full_object(obj_type, obj_name)
    filename = f'output/{obj_name}.src'
    with open(filename, 'w') as f:
        f.write(result['source'])
```

---

## 七、限制与注意事项

1. **系统依赖**: 不同 SAP 版本的 ADT API 可能存在差异
2. **授权要求**: 需要开发权限才能访问源码
3. **Accept 头**: 某些端点对 Accept 头有严格要求
4. **并发限制**: 避免过于频繁的请求，可能导致连接被拒
5. **字符编码**: 使用 UTF-8 编码处理源码

---

## 八、参考资源

- [SAP ADT 官方文档](https://help.sap.com/docs/abap-cloud)
- [erpl-adt (开源 ADT CLI)](https://github.com/DataZooDE/erpl-adt)
- [abap-adt-api (TypeScript)](https://github.com/marcellourbani/abap-adt-api)
