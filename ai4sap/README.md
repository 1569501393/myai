# ai4sap
## 写一个技能包，包含获取 sap 表结构和数据 和 sap 源码 的 rest api

## 创建一个新的 SAP REST API集成技能，用于连接SAP系统、分析源码和表数据，将 sap_connector.py 也打包到 skill, 提供最佳实践和使用场景， 不要包括 git 内容，部分用户没有安装 git

## 优化 python sap_connector.py 脚本，优化代码结构，优化代码逻辑，优化代码性能，注释完整，优化代码可读性，优化代码可维护性，优化代码可扩展性，优化代码可复用性，优化代码可测试性, 最佳实践，输出文档并提交 git

## 写一个 rest api，兼容 ecc,传递 sql 给 sap，返回相关记录

## 复制一份 ai4sap skill, 优化，将用户名密码通过 .env 文件读取，不从 yaml 读取，减少依赖，去除 config 和 examples 目录，skill 中也不要提及 git, 如果有其他优化建议也可以和我提供，尽量 优化简单这个 skill, 使 计算机小白也能配置并使用该技能，连接 sap 查询源码和数据并做分析,完成 skill 后，验证，输出文档并提交 git

## 备份一份 ai4sap skill, 优化，将用户名密码通过 .env 文件读取，不从 yaml 读取，减少依赖，skill 中也不要提及 git, 如果有其他优化建议也可以和我提供，尽量 优化简单这个 skill, 使 计算机小白也能配置并使用该技能，连接 sap 查询源码和数据并做分析,完成 skill 后，验证，输出文档并提交 git



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

获取 ZJQR0000 源码，并分析

获取 ZJQR0000 源码，包括 include 文件，分析并画流程图，输出文档并提交 git
获取 ZJQR0000_OPENCODE2 源码，包括 include 文件，分析并画流程图，输出文档并提交 git

获取 zjqr0000_opencode6 源码，分析并画流程图，输出文档并提交 git



