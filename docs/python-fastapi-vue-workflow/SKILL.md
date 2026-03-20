---
name: python-fastapi-vue-workflow
description: Full-stack Python FastAPI + Vue.js workflow development skill. Use when: (1) Developing FastAPI backend, (2) Creating Pydantic schemas, (3) Building Vue.js frontend, (4) Database design with MySQL, (5) Writing Python/Vue documentation, (6) Code review and deployment
---

# Python FastAPI + Vue Workflow Skill

全栈开发工作流：FastAPI 后端 + Vue 前端 + MySQL 数据库

## 5-Phase Workflow

### Phase 1: 需求对齐 (Requirement Alignment)
1. 收集业务需求文档
2. 明确 API 接口规范
3. 确定数据模型
4. 确认前端组件需求
5. 输出: `docs/features/YYYY-MM-DD-feature-name/requirement.md`

### Phase 2: 模板复用 (Template Reuse)
1. 搜索现有代码库中的相似功能
2. 复用标准模板:
   - FastAPI 路由 → `references/fastapi-router.md`
   - Pydantic 模型 → `references/pydantic-schemas.md`
   - SQLAlchemy 模型 → `references/sqlalchemy-model.md`
   - Vue 组件模板 → `references/vue-component.md`
3. 输出: 复用的模板路径

### Phase 3: 分析设计 (Analysis & Design)
1. 创建 API 接口设计 (OpenAPI/Swagger)
2. 设计数据库表结构
3. 编写 Vue 组件结构
4. 定义前后端数据格式
5. 输出: `docs/features/YYYY-MM-DD-feature-name/design.md`

### Phase 4: 严格测试 (Strict Testing)
1. 后端单元测试 (pytest)
2. 后端 API 测试
3. 前端组件测试 (Vitest)
4. API 集成测试
5. 输出: `docs/features/YYYY-MM-DD-feature-name/test-report.md`

### Phase 5: 规范部署 (Standard Deployment)
1. 代码审查 (Code Review)
2. Python 代码检查 (ruff/black)
3. Vue 构建优化
4. 准备部署文档
5. 输出: `docs/features/YYYY-MM-DD-feature-name/deployment.md`

## 技术栈

| 层级 | 技术 | 版本 |
|------|------|------|
| 后端框架 | FastAPI | 0.100+ |
| Python | Python | 3.10+ |
| 前端框架 | Vue 3 + Vite | 3.4+ |
| ORM | SQLAlchemy | 2.0+ |
| 数据库 | MySQL | 8.0 |
| API | RESTful | JSON |

## 数据库连接

```python
# config.py
DATABASE_URL = "mysql+aiomysql://test:test@localhost:3306/fastapi_db"
# 或同步版本
DATABASE_URL = "mysql+pymysql://test:test@localhost:3306/fastapi_db"
```

```env
# .env
DB_HOST=localhost
DB_PORT=3306
DB_USER=test
DB_PASSWORD=test
DB_NAME=fastapi_db
```

## 目录结构

```
backend/
├── app/
│   ├── api/                    # API 路由
│   │   └── v1/
│   │       └── endpoints/      # 具体端点
│   ├── core/                   # 核心配置
│   │   ├── config.py
│   │   ├── database.py
│   │   └── security.py
│   ├── models/                # SQLAlchemy 模型
│   ├── schemas/               # Pydantic 模型
│   ├── services/              # 业务逻辑
│   └── main.py               # 应用入口
├── tests/                    # 测试
└── requirements.txt

frontend/
├── src/
│   ├── components/           # Vue 组件
│   ├── views/               # 页面视图
│   ├── api/                 # API 服务
│   └── stores/              # 状态管理
└── package.json
```

## 交付物清单

| 阶段 | 交付物 | 路径 |
|------|--------|------|
| 需求 | 需求文档 | `docs/features/*/requirement.md` |
| 设计 | API/数据库设计 | `docs/features/*/design.md` |
| 后端 | FastAPI 代码 | `backend/app/` |
| 前端 | Vue 代码 | `frontend/src/` |
| 测试 | 测试报告 | `docs/features/*/test-report.md` |
| 部署 | 部署文档 | `docs/features/*/deployment.md` |

## Git 提交流程

```bash
git add .
git commit -m "feat: implement [feature name]

- Backend: FastAPI router + Pydantic schemas
- Frontend: Vue component + API service
- Database: SQLAlchemy models + migrations
- Tests: Unit + API tests
- Documentation: API docs"
```

## 常用命令

```bash
# 后端
cd backend
uvicorn app.main:app --reload
pytest tests/
ruff check .
black .

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