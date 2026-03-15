# 学生管理系统 MVP - 技术设计文档

## 1. 系统架构

### 1.1 整体架构
本系统采用前后端分离架构 (BFF - Backend for Frontend)。

```
┌─────────────────────────────────────────────────────────────┐
│                      Client Layer                           │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                 Vue 3 SPA (Port 5173)                │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      API Layer                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │            Laravel RESTful API (Port 8000)          │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Data Layer                                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              MySQL 8.0 (Docker Port 3306)            │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 技术选型

| 层级 | 技术 | 版本 |
|-----|------|------|
| 后端框架 | Laravel | 12.x |
| PHP | PHP | 8.3 |
| 前端框架 | Vue | 3.x |
| 构建工具 | Vite | 5.x |
| UI组件 | Element Plus | 2.x |
| HTTP客户端 | Axios | 1.x |
| 数据库 | MySQL | 8.0 |
| 容器 | Docker | latest |

---

## 2. 模块设计

### 2.1 后端模块

```
backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── StudentController.php    # 学生控制器
│   │   ├── Requests/
│   │   │   └── StudentRequest.php        # 学生表单请求
│   │   └── Middleware/
│   │       └── ApiResponse.php           # API响应中间件
│   ├── Models/
│   │   └── Student.php                   # 学生模型
│   └── Providers/
│       └── AppServiceProvider.php         # 应用服务提供者
├── config/
│   └── database.php                       # 数据库配置
├── database/
│   ├── migrations/
│   │   └── 2024_01_01_000001_create_students_table.php
│   └── seeders/
│       └── StudentSeeder.php              # 学生数据填充
├── routes/
│   └── api.php                            # API路由
└── bootstrap/
    └── app.php                            # 应用引导
```

### 2.2 前端模块

```
frontend/
├── src/
│   ├── api/
│   │   └── student.js                     # 学生API封装
│   ├── assets/
│   │   └── styles/
│   │       └── main.css                   # 全局样式
│   ├── components/
│   │   ├── StudentForm.vue                # 学生表单组件
│   │   ├── StudentTable.vue               # 学生表格组件
│   │   └── SearchBar.vue                  # 搜索栏组件
│   ├── views/
│   │   └── StudentList.vue                # 学生列表页
│   ├── router/
│   │   └── index.js                       # 路由配置
│   ├── App.vue                            # 根组件
│   └── main.js                            # 入口文件
├── public/
│   └── index.html
├── package.json
└── vite.config.js
```

---

## 3. 数据库设计

### 3.1 E-R 图

```
┌─────────────────┐
│    students     │
├─────────────────┤
│ id (PK)         │
│ student_no      │◄── UNIQUE
│ name            │
│ gender          │
│ birth_date      │
│ class_name      │
│ phone           │
│ email           │
│ address         │
│ created_at      │
│ updated_at      │
└─────────────────┘
```

### 3.2 索引设计

| 索引名 | 字段 | 类型 | 唯一 |
|-------|------|------|------|
| PRIMARY | id | BTREE | 是 |
| students_student_no_unique | student_no | BTREE | 是 |
| students_name_index | name | BTREE | 否 |
| students_class_index | class_name | BTREE | 否 |

---

## 4. 接口设计

### 4.1 学生列表 GET /api/students

**请求参数**
```
GET /api/students?page=1&per_page=10
```

**响应示例**
```json
{
  "success": true,
  "data": {
    "data": [
      {
        "id": 1,
        "student_no": "2024001",
        "name": "张三",
        "gender": "male",
        "birth_date": "2005-03-15",
        "class_name": "高三(1)班",
        "phone": "13800138000",
        "email": "zhangsan@example.com",
        "address": "北京市朝阳区",
        "created_at": "2024-01-01T00:00:00Z",
        "updated_at": "2024-01-01T00:00:00Z"
      }
    ],
    "current_page": 1,
    "per_page": 10,
    "total": 100,
    "last_page": 10
  },
  "message": "获取成功"
}
```

### 4.2 创建学生 POST /api/students

**请求体**
```json
{
  "student_no": "2024001",
  "name": "张三",
  "gender": "male",
  "birth_date": "2005-03-15",
  "class_name": "高三(1)班",
  "phone": "13800138000",
  "email": "zhangsan@example.com",
  "address": "北京市朝阳区"
}
```

**响应示例**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "student_no": "2024001",
    "name": "张三"
  },
  "message": "创建成功"
}
```

### 4.3 更新学生 PUT /api/students/{id}

**请求体**
```json
{
  "student_no": "2024001",
  "name": "张三（修改）",
  "gender": "male",
  "birth_date": "2005-03-15",
  "class_name": "高三(2)班"
}
```

### 4.4 删除学生 DELETE /api/students/{id}

**响应示例**
```json
{
  "success": true,
  "data": null,
  "message": "删除成功"
}
```

---

## 5. 验证规则

### 5.1 后端验证规则

| 字段 | 规则 |
|-----|------|
| student_no | required, string, max:20, unique:students,regex:/^[0-9A-Za-z]+$/ |
| name | required, string, max:50 |
| gender | required, in:male,female,other |
| birth_date | required, date, before:today |
| class_name | required, string, max:50 |
| phone | nullable, string, max:20, regex:/^[0-9-]+$/ |
| email | nullable, email, max:100 |
| address | nullable, string, max:255 |

### 5.2 前端验证规则

| 字段 | 规则 |
|-----|------|
| student_no | 必填，1-20位字母数字 |
| name | 必填，1-50字符 |
| gender | 必选 |
| birth_date | 必选，不能是未来日期 |
| class_name | 必填，1-50字符 |
| phone | 可选，11位手机号或固定电话 |
| email | 可选，邮箱格式 |

---

## 6. 错误处理

### 6.1 HTTP 状态码

| 状态码 | 含义 |
|-------|------|
| 200 | OK - 请求成功 |
| 201 | Created - 资源创建成功 |
| 400 | Bad Request - 请求参数错误 |
| 404 | Not Found - 资源不存在 |
| 422 | Unprocessable Entity - 验证失败 |
| 500 | Internal Server Error - 服务器错误 |

### 6.2 错误响应格式

```json
{
  "success": false,
  "data": null,
  "message": "学号已存在",
  "errors": {
    "student_no": ["学号已存在"]
  }
}
```

---

## 7. 部署架构

### 7.1 开发环境

```
┌──────────────────────────────────────────────────────────┐
│                      WSL / Linux                          │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐         │
│  │   Vue 3    │  │  Laravel   │  │    MySQL   │         │
│  │   :5173    │  │   :8000    │  │   :3306    │         │
│  └────────────┘  └────────────┘  └────────────┘         │
│      localhost      localhost     localhost              │
└──────────────────────────────────────────────────────────┘
```

### 7.2 Docker 配置

```yaml
# docker-compose.yml
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    container_name: student_mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: student_db
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
```

---

## 8. 安全考虑

### 8.1 后端安全
- Laravel CSRF 保护（对于 API 可关闭）
- SQL 注入防护（使用 Eloquent ORM）
- XSS 防护（自动转义输出）
- 输入验证（Form Request）

### 8.2 前端安全
- Vue 自动转义 HTML
- 敏感信息不存储在本地
- HTTPS 生产环境强制
