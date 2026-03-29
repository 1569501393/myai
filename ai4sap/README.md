# ai4sap

## 优化 python 脚本，优化代码结构，优化代码逻辑，优化代码性能，优化代码可读性，优化代码可维护性，优化代码可扩展性，优化代码可复用性，优化代码可测试性

## 写一个技能包，包含获取 sap 表结构和数据 和 sap 源码 的 rest api


## 部署到服务器，通过 服务端口 访问 api

## opencode
ai

## pyrfc
nw sdk
data analyse

## adt rest api

通过 sicf 创建 获取数据和表结构服务


sap 已经开启 获取表数据服务，例子如下 通过参数 table 获取表数据
" http://mysap.goodsap.cn:50400/sap/bc/zzjq?sap-client=400&table=mara ， 完善 py 脚本，获取 mara 前 3条数据


bc/
source analyse

```

SAP_CONFIG:
  USER: U1170
  PASSWD: hysoft888999
  CLIENT: "400"
  SN: "04"
  LANG: ZH

ADT_CONFIG:
  ADT_PROTOCOL: http
  ADT_HOST: mysap.goodsap.cn
  ADT_PORT: 50400
  # Full base URL constructed as: {protocol}://{host}:{port}
  BASE_URL: http://mysap.goodsap.cn:50400
```

http://mysap.goodsap.cn:50400/sap/bc/adt/ddic/tables/MARA/data?$top=1

http://mysap.goodsap.cn:50400/sap/bc/adt/programs/programs/zjqr000/source/main


curl --location 'http://mysap.goodsap.cn:50400//sap/bc/abap/demo?carrid=AA' \
--header 'Cookie: MYSAPSSO2=AjQxMDMBABhVADEAMQA3ADAAIAAgACAAIAAgACAAIAACAAY0ADAAMAADABBTADQASAAgACAAIAAgACAABAAYMgAwADIANgAwADMAMgA5ADEAMAA1ADAABQAEAAAACAYAAlgACQACMQD%2fAPswgfgGCSqGSIb3DQEHAqCB6jCB5wIBATELMAkGBSsOAwIaBQAwCwYJKoZIhvcNAQcBMYHHMIHEAgEBMBowDjEMMAoGA1UEAxMDUzRIAggKIBgRGAkyATAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjYwMzI5MTA1MDUyWjAjBgkqhkiG9w0BCQQxFgQU1T66xPxENQgUpQqVQn57vrh5lKgwCQYHKoZIzjgEAwQuMCwCFC5XdbYopdLlJEKEUL14vTzsK2%2frAhQGYqr52jdfNBioczV73%2fDix%2fTwHQ%3d%3d; SAP_SESSIONID_S4H_400=Mi4zMVXjJHUxCR__-3hxZSf-1gErXRHxpJd0RqChFX0%3d; sap-usercontext=sap-client=400'




curl -u U1170:hysoft888999 "http://mysap.goodsap.cn:50400/sap/bc/adt/programs/programs/zjqr000/source/main"


curl -u U1170:hysoft888999 "http://mysap.goodsap.cn:50400/sap/bc/adt/ddic/tables/MARA/data?$top=1"

curl -u USER:PASSWORD "https://sap-server:port/sap/bc/adt/ddic/tables/MARA/data?$top=1"

启用 /sap/bc/adt/ddic/tables/*/data 端点 通过 api 获取数据

表结构（字段、类型、KEY）：
/sap/bc/adt/dictionary/tables/{表名}/definition

表数据（内容）：
/sap/bc/adt/dictionary/tabledata/{表名}?rows=10


## python
使用 python 3.7.9 版本 + fastapi 框架，开发一个 restful api，用于获取 sap 系统中的数据，包括 mara 表结构和数据，以及 zjqr0000 源码，并输出到 当前目录 tmp 文件中，输出文档并提交 git


## skill



分析汇总今日任务以及todo，输出文档并提交 git

分析总结，获取 sap 源码和数据的流程，优化提示词，最佳实践，输出文档并提交 git


如何自己创建一个 sap  获取表结构和数据 的 rest api,举例说明并最佳实践，输出文档并提交 git


获取 mara 前3 条数据
获取 mara 表结构和 前 3 条数据，分析，输出文档并提交 git

获取 ZTJQ0001 表结构和 前 3 条数据，分析，输出文档并提交 git


获取 ZJQR0000 源码

获取 ZJQR0000 源码，包括 include 文件，分析并画流程图，输出文档并提交 git
获取 ZJQR0000_OPENCODE2 源码，包括 include 文件，分析并画流程图，输出文档并提交 git

获取 zjqr0000_opencode6 源码，分析并画流程图，输出文档并提交 git



