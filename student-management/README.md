# 学生管理系统 (Student Management System)

学生管理系统 MVP - 最小可行产品，采用前后端分离架构。

## 技术栈

- **后端**: Laravel 12.x (PHP 8.3)
- **前端**: Vue 3 + Vite + Element Plus
- **数据库**: MySQL 8.0 (Docker)
- **架构**: RESTful API

## 项目结构

```
student-management/
├── backend/                 # Laravel 后端
│   ├── app/                # 应用代码
│   ├── config/             # 配置文件
│   ├── database/          # 数据库文件
│   │   ├── migrations/    # 迁移文件
│   │   └── seeders/       # 种子数据
│   ├── routes/            # 路由定义
│   └── public/            # 公共入口
├── frontend/              # Vue3 前端
│   ├── src/              # 源代码
│   │   ├── api/          # API 接口
│   │   ├── components/   # 组件
│   │   ├── views/        # 页面视图
│   │   └── router/       # 路由配置
│   └── public/           # 静态资源
├── docker/                # Docker 配置
│   └── docker-compose.yml
└── docs/                  # 文档
    ├── SPEC.md            # 需求规格说明书
    ├── TECHNICAL_DESIGN.md # 技术设计文档
    └── ARCHITECTURE.md    # 架构设计图
```

## 环境要求

- PHP 8.3+
- Composer 2.7.7+
- Node.js 18+
- Docker & Docker Compose

## 快速开始

### 1. 启动 MySQL 数据库

```bash
cd student-management/docker
docker-compose up -d
```

验证 MySQL 容器运行状态：
```bash
docker ps
```

使用 mycli 连接数据库（WSL 环境）：
```bash
mycli -uroot -proot -h localhost -D student_db
```

### 2. 安装后端依赖

```bash
cd backend
composer install
```

复制环境配置文件：
```bash
cp .env.example .env
```

生成应用密钥：
```bash
php artisan key:generate
```

运行数据库迁移：
```bash
php artisan migrate
```

填充测试数据（可选）：
```bash
php artisan db:seed
```

启动 Laravel 开发服务器：
```bash
php artisan serve
```

后端服务运行在: http://localhost:8000

### 3. 安装前端依赖

```bash
cd frontend
npm install
```

启动前端开发服务器：
```bash
npm run dev
```

前端服务运行在: http://localhost:5173

## API 接口文档

### 学生列表
```
GET /api/students
```
- Query Parameters:
  - `page` (optional): 页码，默认 1
  - `per_page` (optional): 每页数量，默认 10

### 获取学生详情
```
GET /api/students/{id}
```

### 创建学生
```
POST /api/students
```
- Request Body:
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

### 更新学生
```
PUT /api/students/{id}
```

### 删除学生
```
DELETE /api/students/{id}
```

### 搜索学生
```
GET /api/students/search?q=关键词
```

## 功能列表

- [x] 学生列表展示（分页）
- [x] 添加学生
- [x] 编辑学生
- [x] 删除学生
- [x] 搜索学生
- [x] 数据验证

## 常用命令

### 后端
```bash
# 启动开发服务器
php artisan serve

# 运行测试
php artisan test

# 清空缓存
php artisan cache:clear
```

### 前端
```bash
# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 构建生产版本
npm run build

# 代码检查
npm run lint
```

### Docker
```bash
# 启动 MySQL
docker-compose up -d

# 停止 MySQL
docker-compose down

# 查看日志
docker-compose logs -f mysql
```

## 注意事项

1. 确保 Docker Desktop/Engine 已启动
2. 首次运行需要等待 MySQL 容器完全启动
3. 如遇到端口冲突，请修改 docker-compose.yml 中的端口映射

## 开发规范

- 遵循 PSR-12 代码规范
- 使用 RESTful API 设计原则
- 前后端分离，API 先行
- 提交前运行代码检查

## 许可证

MIT License
