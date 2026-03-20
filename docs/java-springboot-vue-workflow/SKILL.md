---
name: java-springboot-vue-workflow
description: Full-stack Java Spring Boot + Vue.js workflow development skill. Use when: (1) Developing Spring Boot backend APIs, (2) Creating JPA entities, (3) Building Vue.js frontend, (4) Database design with MySQL, (5) Writing Java/Vue documentation, (6) Code review and deployment
---

# Java Spring Boot + Vue Workflow Skill

全栈开发工作流：Spring Boot 后端 + Vue 前端 + MySQL 数据库

## 5-Phase Workflow

### Phase 1: 需求对齐 (Requirement Alignment)
1. 收集业务需求文档
2. 明确 REST API 接口规范
3. 确定 JPA 实体模型
4. 确认前端组件需求
5. 输出: `docs/features/YYYY-MM-DD-feature-name/requirement.md`

### Phase 2: 模板复用 (Template Reuse)
1. 搜索现有代码库中的相似功能
2. 复用标准模板:
   - Spring Boot Controller → `references/spring-controller.md`
   - JPA Entity 模板 → `references/jpa-entity.md`
   - Repository 模板 → `references/jpa-repository.md`
   - Service 层模板 → `references/spring-service.md`
   - Vue 组件模板 → `references/vue-component.md`
3. 输出: 复用的模板路径

### Phase 3: 分析设计 (Analysis & Design)
1. 创建 REST API 接口设计
2. 设计 JPA 实体和表结构
3. 编写 Vue 组件结构
4. 定义前后端数据格式 (JSON)
5. 输出: `docs/features/YYYY-MM-DD-feature-name/design.md`

### Phase 4: 严格测试 (Strict Testing)
1. 后端单元测试 (JUnit 5 + Mockito)
2. 后端 Integration 测试
3. 前端组件测试 (Vitest)
4. API 集成测试
5. 输出: `docs/features/YYYY-MM-DD-feature-name/test-report.md`

### Phase 5: 规范部署 (Standard Deployment)
1. 代码审查 (Code Review)
2. Maven/Gradle 构建检查
3. Vue 构建优化
4. 准备部署文档
5. 输出: `docs/features/YYYY-MM-DD-feature-name/deployment.md`

## 技术栈

| 层级 | 技术 | 版本 |
|------|------|------|
| 后端框架 | Spring Boot | 3.2+ |
| Java | Java | 17+ |
| 前端框架 | Vue 3 + Vite | 3.4+ |
| ORM | Spring Data JPA | - |
| 数据库 | MySQL | 8.0 |
| 构建工具 | Maven | 3.9+ |
| API | RESTful | JSON |

## 数据库连接

```yaml
# application.yml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/java_workflows?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: test
    password: test
    driver-class-name: com.mysql.cj.jdbc.Driver
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: true
    properties:
      hibernate:
        format_sql: true
```

## 目录结构

```
backend/
├── src/main/java/com/example/demo/
│   ├── controller/              # REST Controllers
│   │   └── api/
│   ├── entity/                  # JPA Entities
│   ├── repository/              # JPA Repositories
│   ├── service/                # Service Layer
│   │   └── impl/
│   ├── dto/                    # Data Transfer Objects
│   ├── mapper/                 # MapStruct Mappers
│   ├── config/                 # Configuration
│   └── DemoApplication.java    # Main Class
├── src/main/resources/
│   ├── application.yml
│   └── db/migration/           # Flyway migrations
└── pom.xml

frontend/
├── src/
│   ├── components/            # Vue 组件
│   ├── views/                # 页面视图
│   ├── api/                  # API 服务
│   └── stores/               # 状态管理
└── package.json
```

## 交付物清单

| 阶段 | 交付物 | 路径 |
|------|--------|------|
| 需求 | 需求文档 | `docs/features/*/requirement.md` |
| 设计 | API/数据库设计 | `docs/features/*/design.md` |
| 后端 | Spring Boot 代码 | `backend/src/main/java/` |
| 前端 | Vue 代码 | `frontend/src/` |
| 测试 | 测试报告 | `docs/features/*/test-report.md` |
| 部署 | 部署文档 | `docs/features/*/deployment.md` |

## Git 提交流程

```bash
git add .
git commit -m "feat: implement [feature name]

- Backend: Spring Boot Controller + JPA Entity
- Frontend: Vue Component + API Service
- Database: Entity Mapping + Migration
- Tests: Unit + Integration tests
- Documentation: API docs"
```

## 常用命令

```bash
# 后端
cd backend
./mvnw clean package -DskipTests
./mvnw spring-boot:run
./mvnw test
./mvnw checkstyle:check

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