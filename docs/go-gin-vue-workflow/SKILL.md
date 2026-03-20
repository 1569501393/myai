---
name: go-gin-vue-workflow
description: Full-stack Go Gin + Vue.js workflow development skill. Use when: (1) Developing Gin backend APIs, (2) Creating GORM models, (3) Building Vue.js frontend, (4) Database design with MySQL, (5) Writing Go/Vue documentation, (6) Code review and deployment
---

# Go Gin + Vue Workflow Skill

全栈开发工作流：Gin 后端 + Vue 前端 + MySQL 数据库

## 5-Phase Workflow

### Phase 1: 需求对齐 (Requirement Alignment)
1. 收集业务需求文档
2. 明确 REST API 接口规范
3. 确定数据模型
4. 确认前端组件需求
5. 输出: `docs/features/YYYY-MM-DD-feature-name/requirement.md`

### Phase 2: 模板复用 (Template Reuse)
1. 搜索现有代码库中的相似功能
2. 复用标准模板:
   - Gin Handler 模板 → `references/gin-handler.md`
   - GORM Model 模板 → `references/gorm-model.md`
   - Repository 模板 → `references/repository.md`
   - Service 层模板 → `references/service.md`
   - Vue 组件模板 → `references/vue-component.md`
3. 输出: 复用的模板路径

### Phase 3: 分析设计 (Analysis & Design)
1. 创建 REST API 接口设计
2. 设计 GORM 模型和表结构
3. 编写 Vue 组件结构
4. 定义前后端数据格式 (JSON)
5. 输出: `docs/features/YYYY-MM-DD-feature-name/design.md`

### Phase 4: 严格测试 (Strict Testing)
1. 后端单元测试 (testing)
2. 后端 Integration 测试
3. 前端组件测试 (Vitest)
4. API 集成测试
5. 输出: `docs/features/YYYY-MM-DD-feature-name/test-report.md`

### Phase 5: 规范部署 (Standard Deployment)
1. 代码审查 (Code Review)
2. Go 代码检查 (golangci-lint)
3. Vue 构建优化
4. Docker 容器化
5. 输出: `docs/features/YYYY-MM-DD-feature-name/deployment.md`

## 技术栈

| 层级 | 技术 | 版本 |
|------|------|------|
| 后端框架 | Gin | 1.9+ |
| Go | Go | 1.21+ |
| 前端框架 | Vue 3 + Vite | 3.4+ |
| ORM | GORM | 2.0+ |
| 数据库 | MySQL | 8.0 |
| 构建工具 | Make | - |
| API | RESTful | JSON |

## 数据库连接

```go
// config/config.go
type Config struct {
    DBHost     string
    DBPort     string
    DBUser     string
    DBPassword string
    DBName     string
}

dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
    cfg.DBUser, cfg.DBPassword, cfg.DBHost, cfg.DBPort, cfg.DBName)
```

```env
# .env
DB_HOST=localhost
DB_PORT=3306
DB_USER=test
DB_PASSWORD=test
DB_NAME=go_workflows
```

## 目录结构

```
backend/
├── cmd/
│   └── server/
│       └── main.go              # 入口
├── config/
│   └── config.go               # 配置
├── internal/
│   ├── handler/                # HTTP Handler
│   │   └── feature.go
│   ├── model/                 # GORM Models
│   │   └── feature.go
│   ├── repository/            # Data Access
│   │   └── feature.go
│   ├── service/               # Business Logic
│   │   └── feature.go
│   └── router/                # Routes
│       └── router.go
├── pkg/
│   ├── response/              # 统一响应
│   └── middleware/            # 中间件
├── go.mod
└── Makefile

frontend/
├── src/
│   ├── components/           # Vue 组件
│   ├── views/              # 页面视图
│   ├── api/                # API 服务
│   └── stores/             # 状态管理
└── package.json
```

## 交付物清单

| 阶段 | 交付物 | 路径 |
|------|--------|------|
| 需求 | 需求文档 | `docs/features/*/requirement.md` |
| 设计 | API/数据库设计 | `docs/features/*/design.md` |
| 后端 | Gin 代码 | `backend/internal/` |
| 前端 | Vue 代码 | `frontend/src/` |
| 测试 | 测试报告 | `docs/features/*/test-report.md` |
| 部署 | 部署文档 | `docs/features/*/deployment.md` |

## Git 提交流程

```bash
git add .
git commit -m "feat: implement [feature name]

- Backend: Gin Handler + GORM Model
- Frontend: Vue Component + API Service
- Database: Migration + Seeder
- Tests: Unit + Integration tests
- Documentation: API docs"
```

## 常用命令

```bash
# 后端
cd backend
go mod tidy
go run cmd/server/main.go
go test ./...
golangci-lint run
make build

# 前端
cd frontend
npm run dev
npm run build
npm test
```

## 快速启动

当用户请求开发全栈功能时:
1. 询问业务需求
2. 按 Phase 1-5 推进
3. 每阶段完成后保存文档
4. 最终提交全部交付物