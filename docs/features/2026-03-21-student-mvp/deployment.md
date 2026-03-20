# 学生管理系统 MVP - 部署文档

## 项目结构

```
student-mvp/
├── backend/
│   ├── api/
│   │   └── index.php      # API 入口
│   └── sql/
│       └── schema.sql     # 数据库结构
├── frontend/
│   └── index.html         # 前端页面
└── README.md
```

## 部署步骤

### 1. 数据库部署

```bash
# 方式1: 命令行导入
mysql -u root -p laravel_ini < student-mvp/backend/sql/schema.sql

# 方式2: Docker 环境
docker exec -i laradock-mysql-1 mysql -uroot -proot < student-mvp/backend/sql/schema.sql
```

### 2. 后端部署

```bash
# 开发环境 - PHP 内置服务器
cd student-mvp/backend/api
php -S localhost:8080

# 生产环境 - Nginx 配置示例
server {
    listen 80;
    server_name api.example.com;
    root /path/to/student-mvp/backend/api;
    index index.php;
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    location ~ \\.php$ {
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

### 3. 前端部署

```bash
# 方式1: 直接部署静态文件
cp student-mvp/frontend/index.html /var/www/html/

# 方式2: Nginx
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    index index.html;
}
```

## 环境变量

数据库连接配置在 `backend/api/index.php`:

```php
$host = '127.0.0.1';
$port = 3306;
$dbname = 'laravel_ini';
$username = 'root';  // 根据环境修改
$password = 'root';  // 根据环境修改
```

## 安全建议

1. 生产环境禁用 DEBUG 模式
2. 添加 CSRF 防护
3. 使用预处理语句防止 SQL 注入（已实现）
4. 限制 API 访问频率
5. 使用 HTTPS

## 监控

- 访问日志: `/var/log/nginx/access.log`
- 错误日志: `/var/log/nginx/error.log`
- PHP 错误: `/var/log/php/error.log`