# 学生管理系统 MVP

## 快速开始

### 1. 初始化数据库

```bash
# 登录 MySQL
mysql -u root -p

# 执行 SQL 脚本
source student-mvp/backend/sql/schema.sql
```

### 2. 启动后端 API

```bash
# 方式1: PHP 内置服务器 (端口 8080)
cd student-mvp/backend/api
php -S localhost:8080

# 方式2: 使用已有服务器配置
# 将 api/index.php 部署到 Web 服务器
```

### 3. 启动前端

直接打开 `student-mvp/frontend/index.html`，或使用：

```bash
# 使用 Python
cd student-mvp/frontend
python3 -m http.server 3000

# 访问 http://localhost:3000
```

## API 接口

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/students | 学生列表 |
| GET | /api/students/{id} | 学生详情 |
| POST | /api/students | 创建学生 |
| PUT | /api/students/{id} | 更新学生 |
| DELETE | /api/students/{id} | 删除学生 |

## 功能清单

- [x] 学生列表（分页）
- [x] 搜索学生（按姓名）
- [x] 添加学生
- [x] 编辑学生
- [x] 删除学生
- [x] 查看详情

## 技术栈

- 后端: 原生 PHP + PDO + MySQL
- 前端: Vue 3 (CDN) + 原生 CSS