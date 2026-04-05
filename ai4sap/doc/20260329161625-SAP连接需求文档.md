根据以下配置，连接 SAP 系统，使用 python 脚本 rest api 获取数据 和 源码, 验证连接并输出文档和提交 git, 请根据实际情况修改配置文件,并确保配置文件中包含以下内容：

验证 获取 mara 前 3 天数据，并输出文档
验证 获取 ZJQR0000 源码，并输出文档


实例  04
标识 S4H

[SAP_CONFIG]
USER = U1170
PASSWD = hysoft888999
CLIENT = 400
SN = 04
LANG = ZH

[ADT_CONFIG]
# ADT_PROTOCOL = http://mysap.goodsap.cn:50400
ADT_PROTOCOL = http
ADT_HOST = mysap.goodsap.cn
ADT_PORT = 50400