# 数据库配置

## MySQL 连接信息

| 配置项 | 值 |
|--------|-----|
| 主机 | localhost |
| 端口 | 3306 |
| 用户名 | test |
| 密码 | test |
| 数据库 | laravel_ini |

## Laravel .env 配置

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_ini
DB_USERNAME=test
DB_PASSWORD=test
```

## MySQL 连接测试

```bash
mysql -h localhost -P 3306 -u test -p
```

## 常用命令

```bash
# 连接数据库
mysql -u test -p

# 查看数据库
SHOW DATABASES;

# 使用数据库
USE laravel_ini;

# 查看表
SHOW TABLES;

# 查看表结构
DESC features;
```