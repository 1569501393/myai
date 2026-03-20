# Full-Stack 技术设计文档模板

```markdown
# 技术设计文档

**项目名称**: 
**设计编号**: DES-YYYY-XXX
**需求编号**: FE-YYYY-XXX
**创建日期**: YYYY-MM-DD
**设计人**: 
**版本**: V1.0

---

## 1. 概述

### 1.1 功能简介
[简要描述功能]

### 1.2 设计目标
- [目标1]
- [目标2]

## 2. 系统架构

```
┌─────────────────────────────────────────────────────────────┐
│                      Frontend (Vue 3)                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ FeatureList │  │ FeatureForm │  │FeatureDetail│         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└────────────────────────────┬────────────────────────────────┘
                             │ HTTP REST API
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                     Backend (Laravel)                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ Controller  │  │  Service    │  │ Repository  │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└────────────────────────────┬────────────────────────────────┘
                             │ Eloquent ORM
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                      Database (MySQL)                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  features   │  │   users     │  │   roles     │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

## 3. 数据库设计

### 3.1 ER 图

```
┌──────────────────┐
│     features     │
├──────────────────┤
│ id (PK)          │
│ name             │
│ description      │
│ status           │
│ user_id (FK)     │
│ created_at       │
│ updated_at       │
└────────┬─────────┘
         │
         │ belongsTo
         ▼
┌──────────────────┐
│      users       │
├──────────────────┤
│ id (PK)          │
│ name             │
│ email            │
└──────────────────┘
```

### 3.2 表结构

```sql
CREATE TABLE features (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL COMMENT '名称',
    description TEXT NULL COMMENT '描述',
    status ENUM('active', 'inactive', 'draft') DEFAULT 'draft' COMMENT '状态',
    user_id BIGINT UNSIGNED NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    INDEX idx_status (status),
    INDEX idx_user_id (user_id),
    UNIQUE INDEX idx_name (name),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='功能表';
```

## 4. API 设计

### 4.1 接口列表

| 方法 | 路径 | 描述 | 权限 |
|------|------|------|------|
| GET | /api/features | 列表 | 登录 |
| GET | /api/features/{id} | 详情 | 登录 |
| POST | /api/features | 创建 | 登录 |
| PUT | /api/features/{id} | 更新 | 登录 |
| DELETE | /api/features/{id} | 删除 | 管理员 |

### 4.2 请求/响应规范

#### GET /api/features

**Request**:
```
GET /api/features?page=1&per_page=15&status=active
Authorization: Bearer {token}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "data": [...],
    "total": 100,
    "current_page": 1,
    "last_page": 10,
    "per_page": 15
  },
  "message": "success"
}
```

## 5. 后端设计

### 5.1 目录结构

```
app/
├── Http/
│   ├── Controllers/Api/
│   │   └── FeatureController.php
│   └── Requests/
│       ├── StoreFeatureRequest.php
│       └── UpdateFeatureRequest.php
├── Models/
│   └── Feature.php
├── Services/
│   └── FeatureService.php
└── Repositories/
    └── FeatureRepository.php
```

### 5.2 核心类

```php
// FeatureController
- index(Request): JsonResponse      # 列表
- show(int): JsonResponse           # 详情
- store(StoreRequest): JsonResponse # 创建
- update(UpdateRequest, int): JsonResponse # 更新
- destroy(int): JsonResponse         # 删除

// FeatureService
- getList(array): LengthAwarePaginator
- getById(int): Feature
- create(array): Feature
- update(Feature, array): Feature
- delete(Feature): bool

// Feature Model
- scopes: active(), byUser()
- relations: user(), items()
```

## 6. 前端设计

### 6.1 目录结构

```
frontend/src/
├── api/
│   └── feature/
│       ├── index.ts
│       └── types.ts
├── components/
│   └── feature/
│       ├── FeatureList.vue
│       ├── FeatureForm.vue
│       └── FeatureItem.vue
├── views/
│   └── FeatureView.vue
├── composables/
│   └── useFeature.ts
└── router/
    └── index.ts
```

### 6.2 组件说明

| 组件 | 类型 | 说明 |
|------|------|------|
| FeatureList | Page | 功能列表页 |
| FeatureForm | Dialog | 功能表单 |
| FeatureItem | Component | 功能项组件 |
| useFeature | Composable | 功能逻辑封装 |

## 7. 安全设计

### 7.1 认证授权
- API 认证: JWT Token
- 权限控制: 中间件 + 策略类

### 7.2 输入验证
- 后端: Form Request
- 前端: VeeValidate

### 7.3 SQL 注入防护
- Eloquent ORM 参数绑定
- 禁止字符串拼接 SQL

## 8. 性能设计

### 8.1 缓存策略
- 列表数据: Redis 缓存 5 分钟
- 详情数据: 按 ID 缓存

### 8.2 分页策略
- 默认每页 15 条
- 最大每页 100 条

## 9. 错误处理

| 错误码 | HTTP状态 | 描述 |
|--------|----------|------|
| 400 | 400 | 请求参数错误 |
| 401 | 401 | 未登录 |
| 403 | 403 | 权限不足 |
| 404 | 404 | 资源不存在 |
| 422 | 422 | 验证失败 |
| 500 | 500 | 服务器错误 |

## 10. 测试计划

| 测试类型 | 覆盖率目标 | 工具 |
|----------|------------|------|
| 单元测试 | 80%+ | PHPUnit |
| Feature测试 | 60%+ | PHPUnit |
| 组件测试 | 70%+ | Vitest |
| E2E测试 | 核心流程 | Playwright |