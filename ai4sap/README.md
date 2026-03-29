# ai4sap
## opencode
ai

## pyrfc
nw sdk
data analyse

## adt rest api
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



获取 mara 前3 条数据
获取 mara 表结构和 前 3 条数据，分析，输出文档并提交 git

获取 ZTJQ0001 表结构和 前 3 条数据，分析，输出文档并提交 git


获取 ZJQR0000 源码

获取 ZJQR0000 源码，包括 include 文件，分析并画流程图，输出文档并提交 git
获取 ZJQR0000_OPENCODE2 源码，包括 include 文件，分析并画流程图，输出文档并提交 git

获取 zjqr0000_opencode6 源码，分析并画流程图，输出文档并提交 git



