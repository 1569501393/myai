---
name: php-laravel-vue-workflow
description: Full-stack PHP Laravel + Vue.js workflow development skill. Use when: (1) Developing Laravel backend APIs, (2) Creating Vue.js frontend components, (3) Full-stack feature development, (4) Database design with MySQL, (5) Writing PHP/Vue documentation, (6) Code review and deployment
---

# PHP Laravel + Vue Workflow Skill

全栈开发工作流：Laravel 后端 + Vue 前端 + MySQL 数据库

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
   - Laravel API 控制器 → `references/laravel-api-controller.md`
   - Laravel Model 模板 → `references/laravel-model.md`
   - Vue 组件模板 → `references/vue-component.md`
   - Vue API 服务模板 → `references/vue-api-service.md`
3. 输出: 复用的模板路径

### Phase 3: 分析设计 (Analysis & Design)
1. 创建 API 接口设计
2. 设计数据库表结构
3. 编写 Vue 组件结构
4. 定义前后端数据格式
5. 输出: `docs/features/YYYY-MM-DD-feature-name/design.md`

### Phase 4: 严格测试 (Strict Testing)
1. 后端单元测试 (PHPUnit)
2. 后端 Feature 测试
3. 前端组件测试 (Vitest)
4. API 集成测试
5. 输出: `docs/features/YYYY-MM-DD-feature-name/test-report.md`

### Phase 5: 规范部署 (Standard Deployment)
1. 代码审查 (Code Review)
2. Laravel 代码检查 (Pint)
3. Vue 构建优化
4. 准备部署文档
5. 输出: `docs/features/YYYY-MM-DD-feature-name/deployment.md`

## 技术栈

| 层级 | 技术 | 配置 |
|------|------|------|
| 后端框架 | Laravel 12.x | PHP 8.3+ |
| 前端框架 | Vue 3 + Vite | Node.js 18+ |
| 数据库 | MySQL 8.0 | localhost:3306 |
| ORM | Eloquent | - |
| API | RESTful | JSON |

## 数据库连接

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_ini
DB_USERNAME=test
DB_PASSWORD=test
```

## 目录结构

```
laravel-ini/
├── app/
│   ├── Http/Controllers/Api/    # API 控制器
│   ├── Models/                   # 数据模型
│   ├── Services/                 # 业务逻辑
│   ├── Repositories/             # 数据访问
│   └── Http/Requests/            # 表单验证
├── routes/api.php               # API 路由
├── database/migrations/          # 数据库迁移
└── tests/                       # 测试文件

frontend/
├── src/
│   ├── components/               # Vue 组件
│   ├── views/                   # 页面视图
│   ├── api/                     # API 服务
│   └── stores/                  # 状态管理
└── tests/                       # 前端测试
```

## 交付物清单

| 阶段 | 交付物 | 路径 |
|------|--------|------|
| 需求 | 需求文档 | `docs/features/*/requirement.md` |
| 设计 | API/数据库设计 | `docs/features/*/design.md` |
| 后端 | Laravel 代码 | `app/Http/Controllers/Api/` |
| 前端 | Vue 代码 | `frontend/src/` |
| 测试 | 测试报告 | `docs/features/*/test-report.md` |
| 部署 | 部署文档 | `docs/features/*/deployment.md` |

## Git 提交流程

```bash
# 按阶段提交
git add .
git commit -m "feat: implement [feature name]

- Backend: Laravel API controller + Model
- Frontend: Vue component + API service
- Database: Migration + Seeder
- Tests: Unit + Feature tests
- Documentation: API docs"
```

## 快速启动

当用户请求开发全栈功能时:
1. 询问业务需求
2. 按 Phase 1-5 推进
3. 每阶段完成后保存文档
4. 最终提交全部交付物

## 常用命令

```bash
# 后端
cd laravel-ini
php artisan make:controller Api/FeatureController
php artisan make:model Feature -m
php artisan migrate
php artisan test

# 前端
cd frontend
npm run dev
npm run build
npm test
```