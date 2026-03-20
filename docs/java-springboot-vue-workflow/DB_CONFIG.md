# 数据库配置

## MySQL 连接信息

| 配置项 | 值 |
|--------|-----|
| 主机 | localhost |
| 端口 | 3306 |
| 用户名 | test |
| 密码 | test |
| 数据库名 | java_workflows |

## Spring Boot 配置

```yaml
# application.yml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/java_workflows?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: test
    password: test
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000

  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: true
    properties:
      hibernate:
        format_sql: true
        dialect: org.hibernate.dialect.MySQLDialect
```

## pom.xml 依赖

```xml
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <scope>runtime</scope>
</dependency>
```

## MySQL 连接测试

```bash
mysql -h localhost -P 3306 -u test -p java_workflows
```

## 常用命令

```bash
# 创建数据库
mysql -u test -p -e "CREATE DATABASE java_workflows CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 查看数据库
SHOW DATABASES;

# 使用数据库
USE java_workflows;

# 查看表
SHOW TABLES;
```