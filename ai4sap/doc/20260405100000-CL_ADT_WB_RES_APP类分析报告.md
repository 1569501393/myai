# SAP CL_ADT_WB_RES_APP 类分析报告

**文档日期**: 2026-04-05  
**类名**: CL_ADT_WB_RES_APP  
**描述**: Default Application for the ADT REST Framework  
**包**: SADT_REST  
**创建者**: SAP  
**主语言**: EN

---

## 一、类概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 类名 | CL_ADT_WB_RES_APP |
| 类型 | CLAS/OC (Class Pool) |
| 包 | SADT_REST |
| 描述 | Default Application for the ADT REST Framework |
| 创建者 | SAP |
| 创建日期 | 2010-07-13 |
| 最后修改 | 2018-11-26 |
| 主语言 | EN |
| Unicode 检查 | Active |
| 定点算术 | Disabled |

### 1.2 类特性

- **Final**: No
- **Abstract**: No
- **Shared Memory Enabled**: No
- **Category**: General Object Type

---

## 二、接口实现

类实现了以下接口：

| 接口 | 说明 |
|------|------|
| `IF_HTTP_EXTENSION` | HTTP 扩展接口，用于处理 HTTP 请求 |
| `IF_OAUTH2_CONSUMER` | OAuth2 消费者接口 |

---

## 三、常量定义

```abap
constants:
  co_service_path  type string value '/sap/bc/adt',       " 服务路径
  co_service_name  type string value 'ADT_0001',          " 服务名称
  co_session_type  type string value 'X-sap-adt-sessiontype',  " 会话类型头
  co_header_adt_saplb type string value 'sap-adt-saplb',  " SAP LB 头
  co_header_adt_trace type string value 'X-adt-runtime-tracing', " 追踪头
  co_header_val_true  type string value 'true',
  co_header_val_fetch type string value 'fetch'.

constants: co_rfc_destination_none type rfcdest value 'NONE'.
```

---

## 四、方法列表

### 4.1 公开方法 (Public Methods)

| 方法名 | 返回类型 | 说明 |
|--------|----------|------|
| `IS_FRONTEND_ENDPOINT` | ABAP_BOOL | 检查是否为前端端点 |
| `CHECK_DEVELOP_AUTHORIZATION` | - | 检查开发授权 |
| `CHECK_RESOURCE_AUTHORIZATION` | - | 检查资源授权 |
| `CLASS_CONSTRUCTOR` | - | 类构造函数 |

### 4.2 保护方法 (Protected Methods)

| 方法名 | 说明 |
|--------|------|
| `GET_DESTINATION` | 根据系统别名返回 RFC 目的地 |
| `GET_SYSTEM_ALIASES_CONFIGURED` | 获取配置的网关系统别名 |
| `SYSTEM_ALIAS_CHECKPOINT` | 系统别名检查点 |
| `SERVICE_AUTHORITY_CHECK` | 服务授权检查 |

### 4.3 私有方法 (Private Methods)

| 方法名 | 说明 |
|--------|------|
| `GET_REQUEST_PROXY` | 获取请求代理 |
| `GET_HTTP_REQUEST_PROXY` | 获取 HTTP 请求代理 |
| `GET_RFC_REQUEST_PROXY_FES` | 获取 RFC 请求代理 (前端服务) |
| `GET_RFC_REQUEST_PROXY_DBG` | 获取 RFC 请求代理 (调试器) |
| `GET_RFC_REQUEST_PROXY_TRC` | 获取 RFC 请求代理 (追踪) |
| `FINAL_CACHE_CONTROL` | 最终缓存控制 |
| `CONFIGURE_SESSION_STATE` | 配置会话状态 |
| `REMOVE_ALIAS_FROM_URI` | 从 URI 中移除别名 |
| `GET_DEBUGGER_DESTINATION` | 获取调试器目的地 |
| `FETCH_SYSTEM_ALIASES_FROM_GW` | 从网关获取系统别名 |

---

## 五、核心方法分析

### 5.1 IF_HTTP_EXTENSION~HANDLE_REQUEST

这是类的主入口方法，处理所有 ADT HTTP 请求：

```abap
method if_http_extension~handle_request.
  " 获取请求代理
  handler_proxy = get_request_proxy( p_server = server ).

  " 抑制默认内容类型
  server->response->suppress_content_type( ).

  " 处理请求
  handler_proxy->set_start_time( time_start ).
  handler_proxy->handle_request( ).

  " 缓存控制
  final_cache_control( p_server = server ).

  " 会话状态配置
  configure_session_state( p_server = server ).
endmethod.
```

**请求流程**:
1. 获取请求代理（HTTP 或 RFC）
2. 抑制默认内容类型
3. 处理请求
4. 设置缓存控制
5. 配置会话状态

### 5.2 GET_REQUEST_PROXY

根据请求头决定使用哪种代理：

```abap
method get_request_proxy.
  " 1. 检查系统别名路由
  if system_alias is not initial.
    " RFC 代理 (前端服务)
    result = get_rfc_request_proxy_fes( ... ).
    return.
  endif.

  " 2. 检查调试器头
  if destination is not initial.
    " RFC 代理 (调试器)
    result = get_rfc_request_proxy_dbg( ... ).
    return.
  endif.

  " 3. 检查追踪头
  if trace_header is not initial.
    " RFC 代理 (追踪)
    result = get_rfc_request_proxy_trc( ... ).
    return.
  endif.

  " 4. 默认 HTTP 代理
  result = get_http_request_proxy( p_server ).
endmethod.
```

**代理类型优先级**:
1. 系统别名路由 (RFC FES)
2. 调试器重定向 (RFC DBG)
3. 追踪请求 (RFC TRC)
4. 本地 HTTP 处理

### 5.3 SYSTEM_ALIAS_CHECKPOINT

解析 URI 中的系统别名信息：

```abap
" URI 格式: /sap/bc/adt;o=SYSTEM_ALIAS/path/to/resource

" 显式路由: URI 中包含 ;o=ALIAS
if sy-subrc = 0.
  p_system_alias = alias_string.
  return.
endif.

" 隐式路由: 使用默认别名
if lines( adt_aliases ) = 1.
  p_system_alias = adt_aliases[1].
endif.

" 多别名无默认: 不路由
```

---

## 六、请求处理架构

```
┌─────────────────────────────────────────────────────────────┐
│                    HTTP Request                              │
│              (/sap/bc/adt/*)                                │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│          CL_ADT_WB_RES_APP                                  │
│     IF_HTTP_EXTENSION~HANDLE_REQUEST                        │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│           GET_REQUEST_PROXY                                 │
│  ┌─────────────┬─────────────┬─────────────┬─────────────┐  │
│  │ System Alias │  Debugger   │   Trace     │   Default   │  │
│  │   (RFC FES) │  (RFC DBG)  │  (RFC TRC)  │   (HTTP)    │  │
│  └─────────────┴─────────────┴─────────────┴─────────────┘  │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│                  RFC/HTTP Call                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 七、授权检查

### 7.1 开发授权检查

```abap
authority-check object 'S_ADT_RES'
  id 'URI' field uri_string.
```

### 7.2 服务授权检查

```abap
authority-check object 'S_SERVICE'
  id 'SRV_NAME'  field '7798C832C6E3A00AEECA353E508524'
  id 'SRV_TYPE'  field 'HT'.
```

---

## 八、缓存控制

```abap
" GET + CSRF fetch 请求
if ( method = 'GET' and csrf_token = 'fetch' )
   or cache_control = 'no-store'.
  " 不缓存
  set_header( 'cache-control', 'no-store' ).
  set_header( 'pragma', 'no-cache' ).
  set_header( 'expires', '-1' ).
endif.

" SAP 缓存控制
if sap_cache_control is initial.
  server_cache_expire_rel( 0 ).
else.
  server_cache_expire_rel( sap_cache_control ).
endif.
```

---

## 九、会话状态管理

```abap
case session_type:
  when 'stateful'.
    set_session_stateful( CO_ENABLED ).
  when 'stateless'.
    set_session_stateful( CO_DISABLED ).
endcase.
```

---

## 十、关键类数据

```abap
class-data:
  g_badi_mode type ref to lcl_badi_safe_mode,
  g_develop_auth_checker type ref to lcl_develop_authority_checker.

" 测试注入的代理 (仅用于单元测试)
data:
  m_injected_proxy_fes  type ref to lcl_abstract_request_proxy,
  m_injected_proxy_dbg  type ref to lcl_abstract_request_proxy,
  m_injected_proxy_trc  type ref to lcl_abstract_request_proxy,
  m_injected_proxy_http type ref to lcl_abstract_request_proxy.
```

---

## 十一、相关类和接口

| 类型 | 名称 | 说明 |
|------|------|------|
| Local | `LCL_ABSTRACT_REQUEST_PROXY` | 抽象请求代理基类 |
| Local | `LCL_HTTP_REQUEST_PROXY` | HTTP 请求代理 |
| Local | `LCL_RFC_REQUEST_PROXY_FES` | RFC 前端服务代理 |
| Local | `LCL_RFC_REQUEST_PROXY_DBG` | RFC 调试器代理 |
| Local | `LCL_RFC_REQUEST_PROXY_TRC` | RFC 追踪代理 |
| Local | `LCL_BADI_SAFE_MODE` | BADI 安全模式 |
| Local | `LCL_DEVELOP_AUTHORITY_CHECKER` | 开发授权检查器 |

---

## 十二、总结

`CL_ADT_WB_RES_APP` 是 SAP ADT REST 框架的核心入口类，负责：

1. **路由分发**: 根据 URI 和请求头决定请求处理方式
2. **系统别名解析**: 支持多系统路由（通过 Gateway 配置）
3. **授权检查**: 验证开发者和资源访问权限
4. **代理选择**: HTTP 本地处理 vs RFC 远程调用
5. **缓存管理**: 控制响应缓存行为
6. **会话管理**: 支持有状态和无状态会话

这个类是所有 `/sap/bc/adt/*` 请求的中央调度器，是理解 SAP ADT REST API 架构的关键。
