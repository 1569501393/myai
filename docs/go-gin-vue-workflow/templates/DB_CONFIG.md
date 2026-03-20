# 数据库配置

## MySQL 连接信息

| 配置项 | 值 |
|--------|-----|
| 主机 | localhost |
| 端口 | 3306 |
| 用户名 | test |
| 密码 | test |
| 数据库名 | go_workflows |

## Go 配置

```go
// config/config.go
package config

import (
	"fmt"
	"os"
)

type Config struct {
	DBHost     string
	DBPort     string
	DBUser     string
	DBPassword string
	DBName     string
	ServerAddr string
}

func Load() *Config {
	return &Config{
		DBHost:     getEnv("DB_HOST", "localhost"),
		DBPort:     getEnv("DB_PORT", "3306"),
		DBUser:     getEnv("DB_USER", "test"),
		DBPassword: getEnv("DB_PASSWORD", "test"),
		DBName:     getEnv("DB_NAME", "go_workflows"),
		ServerAddr: getEnv("SERVER_ADDR", ":8080"),
	}
}

func (c *Config) DSN() string {
	return fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		c.DBUser, c.DBPassword, c.DBHost, c.DBPort, c.DBName)
}
```

## .env 文件

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=test
DB_PASSWORD=test
DB_NAME=go_workflows
SERVER_ADDR=:8080
```

## GORM 连接

```go
import (
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

db, err := gorm.Open(mysql.Open(cfg.DSN()), &gorm.Config{})
if err != nil {
	log.Fatal(err)
}
```

## MySQL 连接测试

```bash
mysql -h localhost -P 3306 -u test -p go_workflows
```

## 常用命令

```bash
# 创建数据库
mysql -u test -p -e "CREATE DATABASE go_workflows CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 查看数据库
SHOW DATABASES;

# 使用数据库
USE go_workflows;

# 查看表
SHOW TABLES;
```