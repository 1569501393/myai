# 学生管理系统 MVP - 设计文档

## 1. 目录结构

```
student-mvp/
├── backend/
│   ├── config.php          # 数据库配置
│   ├── api/
│   │   ├── students.php    # 学生 API
│   │   └── index.php       # API 入口
│   └── sql/
│       └── schema.sql       # 数据库表结构
├── frontend/
│   ├── src/
│   │   ├── main.js
│   │   ├── App.vue
│   │   ├── api/
│   │   │   └── student.js  # 学生 API 服务
│   │   ├── components/
│   │   │   ├── StudentList.vue
│   │   │   ├── StudentForm.vue
│   │   │   └── StudentModal.vue
│   │   └── views/
│   │       └── Home.vue
│   ├── index.html
│   └── vite.config.js
└── README.md
```

## 2. 数据库设计

### 2.1 students 表

```sql
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_no VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    gender ENUM('男', '女') DEFAULT '男',
    birth_date DATE NULL,
    phone VARCHAR(20) DEFAULT '',
    email VARCHAR(100) DEFAULT '',
    address VARCHAR(255) DEFAULT '',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## 3. API 接口规范

### 3.1 GET /api/students
获取学生列表

**Query Parameters:**
| 参数 | 类型 | 说明 |
|------|------|------|
| page | int | 页码，默认 1 |
| per_page | int | 每页条数，默认 10 |
| search | string | 搜索关键词（姓名） |

**Response:**
```json
{
    "success": true,
    "data": {
        "data": [
            {"id": 1, "student_no": "2024001", "name": "张三", "gender": "男", "birth_date": "2010-01-01", "phone": "13800138000", "email": "zhangsan@example.com", "address": "北京市"}
        ],
        "total": 100,
        "page": 1,
        "per_page": 10
    }
}
```

### 3.2 GET /api/students/{id}
获取单个学生详情

**Response:**
```json
{
    "success": true,
    "data": {"id": 1, "student_no": "2024001", "name": "张三", ...}
}
```

### 3.3 POST /api/students
创建学生

**Request Body:**
```json
{
    "student_no": "2024001",
    "name": "张三",
    "gender": "男",
    "birth_date": "2010-01-01",
    "phone": "13800138000",
    "email": "zhangsan@example.com",
    "address": "北京市"
}
```

**Response:**
```json
{
    "success": true,
    "message": "创建成功",
    "data": {"id": 1}
}
```

### 3.4 PUT /api/students/{id}
更新学生

**Request Body:** 同 POST

**Response:**
```json
{
    "success": true,
    "message": "更新成功"
}
```

### 3.5 DELETE /api/students/{id}
删除学生

**Response:**
```json
{
    "success": true,
    "message": "删除成功"
}
```

## 4. 前端组件设计

### 4.1 StudentList.vue
- 学生列表展示（表格）
- 分页控件
- 搜索框
- 操作按钮（编辑、删除）

### 4.2 StudentForm.vue
- 学生表单（新增/编辑）
- 字段验证
- 学号唯一性校验

### 4.3 StudentModal.vue
- 模态框组件
- 用于新增/编辑学生

## 5. 错误处理

| 状态码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 404 | 资源不存在 |
| 422 | 验证失败 |
| 500 | 服务器错误 |

## 6. 安全考虑

- SQL 注入防护：使用预处理语句
- 输入验证：验证必填字段和数据格式
- CORS 跨域配置