# 数据库配置

## MySQL 连接信息

| 配置项 | 值 |
|--------|-----|
| 主机 | localhost |
| 端口 | 3306 |
| 用户名 | test |
| 密码 | test |
| 数据库名 | java_workflows |

## application.yml 配置

```yaml
spring:
  application:
    name: demo
  
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
    show-sql: false
    properties:
      hibernate:
        format_sql: true
        dialect: org.hibernate.dialect.MySQLDialect
    open-in-view: false

  flyway:
    enabled: true
    baseline-on-migrate: true
    locations: classpath:db/migration
```

## pom.xml 依赖

```xml
<dependencies>
    <!-- Spring Boot Starter -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <!-- JPA -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    
    <!-- MySQL -->
    <dependency>
        <groupId>com.mysql</groupId>
        <artifactId>mysql-connector-j</artifactId>
        <scope>runtime</scope>
    </dependency>
    
    <!-- Validation -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
    
    <!-- Lombok -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>
    
    <!-- MapStruct -->
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct</artifactId>
    </dependency>
</dependencies>
```

## MySQL 连接测试

```bash
mysql -h localhost -P 3306 -u test -p java_workflows
```

## 常用命令

```bash
# 创建数据库
CREATE DATABASE java_workflows DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 查看数据库
SHOW DATABASES;

# 使用数据库
USE java_workflows;

# 查看表
SHOW TABLES;

# 查看表结构
DESC features;
```