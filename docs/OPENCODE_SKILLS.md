# OpenCode Skills 技术文档 - 最受欢迎的 Skills 及最佳实践

> 本文档介绍 OpenCode AI 编程助手的 Skills 系统，包括最受欢迎的技能、实际案例和最佳实践指南。

## 1. OpenCode Skills 概述

OpenCode 是一个开源 AI 编程助手（GitHub 120K+ Stars），Skills 是其核心扩展机制。Skills 基于 Agent Skills 开放标准，兼容 Claude Code、Cursor、VS Code、Gemini CLI 等多个平台。

### 技能层级架构

```
┌─────────────────────────────────────────────┐
│           PLUGINS (重量级)                   │
│   npm 包，完整工具集成                        │
│   数据库连接器、API 客户端                    │
├─────────────────────────────────────────────┤
│         AGENTS (中等)                        │
│   专业 AI 角色，专注任务                      │
│   安全审查员、架构师、TDD 指南                │
├─────────────────────────────────────────────┤
│           SKILLS (轻量级)                    │
│   可复用提示模板，快速见效                     │
│   代码审查、提交信息、文档生成                 │
└─────────────────────────────────────────────┘
```

### 三者选择指南

| 场景 | 解决方案 | 原因 |
|------|----------|------|
| 标准化代码审查提示 | Skill | 轻量级，易于团队共享 |
| 一致的安全分析 | Agent | 保持上下文，强制 OWASP 专注 |
| 连接 PostgreSQL | Plugin | 需要外部工具集成 |
| 生成提交信息 | Skill | 简单提示模板足够 |
| TDD 工作流执行 | Agent | 需要持久上下文和方法论坚持 |

## 2. 最受欢迎的 Skills

### 2.1 Vercel React Best Practices

**安装方式：**
```bash
npx -y @lobehub/market-cli skills install vercel-labs-agent-skills
```

**功能特点：**
- 包含 45 条 React 性能优化规则
- 按影响程度分类（Critical/High/Medium/Low）
- 目标：Core Web Vitals (LCP, FID/INP, CLS)

**规则分类：**

| 类别 | 优先级 | 说明 |
|------|--------|------|
| JavaScript 性能 | CRITICAL | 避免阻塞主线程的操作 |
| 消除请求瀑布 | CRITICAL | 优先并行 API 调用 |
| Bundle 大小 | CRITICAL | 移除未使用代码 |
| 服务端性能 | HIGH | 缓存策略、RSC 边界 |
| 客户端数据获取 | HIGH | 预取和缓存策略 |
| 重新渲染优化 | MEDIUM | React.memo、useMemo、useCallback |
| 列表渲染 | MEDIUM | 虚拟化大列表 |
| 高级模式 | LOW | 进阶优化技巧 |

**使用示例：**
```typescript
// ❌ 错误 - 阻塞两个分支
async function handleRequest(userId: string, skipProcessing: boolean) {
  const userData = await fetchUserData(userId);
  if (skipProcessing) {
    return userData;
  }
  return processUser(userData);
}

// ✅ 正确 - 按条件提前返回
async function handleRequest(
  userId: string,
  skipProcessing: boolean
) {
  if (skipProcessing) {
    return fetchUserData(userId);
  }
  const userData = await fetchUserData(userId);
  return processUser(userData);
}
```

### 2.2 TypeScript Skills

**功能特点：**
- 直接使用 Bun 运行 TypeScript
- 完整类型安全
- 快速启动和运行
- 兼容多语言技能生态系统

**使用示例：**
```bash
cd skills/my-ts-skill
bun run example.ts  # 直接执行，无需编译
```

### 2.3 Cloudflare Skills

**功能特点：**
- 60+ Cloudflare 产品覆盖
- 决策树引导
- 渐进式信息披露
- 60 个参考文件

**使用场景：**
- Workers vs Pages vs Durable Objects 选择
- 数百个绑定、标志和部署模式
- 复杂配置指导

### 2.4 PDF Tools

**安装方式：**
```bash
npx -y @lobehub/market-cli skills install lobehub-pdf-tools
```

**功能：**
- PDF 编辑、合并、拆分
- 旋转、提取页面
- 添加水印

### 2.5 Database Integration Skills

**功能：**
- 数据库查询执行
- 迁移管理
- 模式检查

## 3. 创建自定义 Skill

### 3.1 Skill 文件结构

```
my-skill/
├── SKILL.md              # 核心技能定义
├── rules/                # 具体规则文件
│   ├── 01-folder-structure.md
│   ├── 02-naming-conventions.md
│   └── 03-code-patterns.md
└── AGENTS.md             # 完整展开（可选）
```

### 3.2 SKILL.md 格式

```markdown
---
name: code-review
description: Perform comprehensive code review with security and performance focus
tags:
  - review
  - security
  - performance
---

# Code Review Skill

## Overview
This skill provides a structured approach to code reviews.

## Review Checklist

### Security
- [ ] SQL injection prevention
- [ ] XSS protection
- [ ] Authentication/Authorization checks

### Performance
- [ ] Database query optimization
- [ ] Caching considerations
- [ ] Async/await usage

### Code Quality
- [ ] Error handling
- [ ] Type safety
- [ ] Documentation
```

### 3.3 规则文件格式

```markdown
---
title: Use Strict Type Checking
impact: HIGH
impactDescription: Prevents runtime type errors
tags:
  - typescript
  - types
  - safety
---

## Use Strict Type Checking

Always use explicit types instead of `any`.

### Incorrect
```typescript
function processData(data: any) {
  return data.value;
}
```

### Correct
```typescript
interface UserData {
  value: string;
}

function processData(data: UserData): string {
  return data.value;
}
```

### When to Apply
- All function parameters
- Return types
- Variable declarations
```

### 3.4 影响级别

| 级别 | 说明 | 示例 |
|------|------|------|
| CRITICAL | 关键性能/正确性 | 安全、 hydration、瀑布流 |
| HIGH | 重要但不关键 | 重新渲染、Bundle 大小 |
| MEDIUM | 中等影响 | 代码风格、可读性 |
| LOW | 轻微影响 | 注释格式 |

## 4. LobeHub Skills Marketplace

### 4.1 安装 Skills

```bash
# 注册身份
npx -y @lobehub/market-cli register \
  --name "MyAgent" \
  --description "AI coding assistant" \
  --source open-claw

# 安装技能
npx -y @lobehub/market-cli skills install owner-repo-skill

# 指定代理安装
npx -y @lobehub/market-cli skills install owner-repo-skill --agent claude-code
npx -y @lobehub/market-cli skills install owner-repo-skill --agent cursor
```

### 4.2 搜索技能

```bash
# 关键词搜索
npx -y @lobehub/market-cli skills search --q "pdf editor"

# 按类别筛选
npx -y @lobehub/market-cli skills search --q "deploy" --category development

# 按安装量排序
npx -y @lobehub/market-cli skills search --q "api" --sort installCount

# JSON 输出
npx -y @lobehub/market-cli skills search --q "pdf" --output json
```

### 4.3 评价技能

```bash
# 评分
npx -y @lobehub/market-cli skills rate lobehub-pdf-tools --score 5

# 评论
npx -y @lobehub/market-cli skills comment lobehub-pdf-tools \
  -c "Used to merge 3 PDFs. Clear instructions, worked perfectly." \
  --rating 5

# 查看评论
npx -y @lobehub/market-cli skills comments lobehub-pdf-tools
```

### 4.4 评分标准

| 分数 | 含义 |
|------|------|
| 5 | 优秀 - 完美解决问题，指令清晰 |
| 4 | 良好 - 效果良好，有小问题 |
| 3 | 一般 - 能完成任务，指令可更清晰 |
| 2 | 较差 - 部分有效，步骤缺失或混乱 |
| 1 | 损坏 - 不工作，完全误导 |

## 5. 最佳实践

### 5.1 Skill 设计原则

1. **单一职责**：一个 Skill 只做一件事
   - ❌ 一个 Skill 包含 50 行指令覆盖所有问题
   - ✅ 分离为安全、性能、代码风格三个 Skill

2. **渐进式披露**：从简单到复杂
   ```markdown
   ## Basic Usage
   Quick start guide...
   
   ## Advanced Options
   For complex scenarios...
   
   ## Troubleshooting
   Common issues and solutions...
   ```

3. **使用决策树**：帮助 AI 选择正确路径
   ```
   Question: What type of deployment?
   ├─ Static Site → Use Pages
   ├─ API → Use Workers
   ├─ Real-time → Use Durable Objects
   └─ Long-running → Use Workflows
   ```

4. **包含代码示例**：正确和错误对比
   ```markdown
   ### Incorrect
   ```tsx
   // Bad code here
   ```
   
   ### Correct
   ```tsx
   // Good code here
   ```
   ```

### 5.2 工作流整合

```
1. 开发前 → 使用 Architect Agent 进行设计决策
2. 开发中 → 使用 TDD Guide Agent 实施测试驱动开发
3. 提交前 → 运行 Full Review Skill 进行全面审查
4. 部署时 → 使用 Kubernetes Plugin 处理部署
```

### 5.3 团队协作

1. **创建团队 Skill 库**
   ```bash
   # 共享团队规范
   /skills/team/
   ├── commit-conventions.md
   ├── code-style.md
   ├── testing-standards.md
   └── api-design.md
   ```

2. **版本控制**
   - 团队共享的 Skill 放在内部 Git 仓库
   - 使用 Semantic Versioning
   - 定期更新以匹配项目变化

### 5.4 常见错误

| 错误 | 原因 | 解决 |
|------|------|------|
| Skill 不加载 | YAML frontmatter 格式错误 | 确保 `---` 分隔符正确 |
| 指令被忽略 | 上下文过载 | 精简 Skill，保持专注 |
| 行为不一致 | 不同模型处理差异 | 测试多种模型 |
| 路径错误 | 安装位置不正确 | 检查 agent 对应路径 |

## 6. OpenCode 配置文件

### 6.1 opencode.jsonc

```jsonc
{
  "$schema": "https://opencode.ai/schema.json",
  "skills": {
    "paths": [
      "~/.opencode/skills",
      "./.opencode/skills"
    ],
    "autoLoad": true
  },
  "agents": {
    "build": {
      "model": "claude-sonnet-4",
      "tools": ["read", "write", "edit", "bash", "grep", "glob"]
    }
  }
}
```

### 6.2 常用命令

```bash
# 启动 OpenCode
opencode

# 使用特定 Skill
opencode run --skill code-review

# 启动子代理
opencode run --agent security-review

# 分享会话
opencode share
```

## 7. 参考资源

- [OpenCode 官方文档](https://opencode.ai/docs)
- [LobeHub Skills Marketplace](https://lobehub.com/skills)
- [Agent Skills 开放标准](https://github.com/anomalyco/opencode)
- [Vercel React Best Practices](https://github.com/vercel-labs/agent-skills)

## 8. 总结

OpenCode Skills 是 AI 编程助手的核心扩展机制，通过 Skills 可以：

1. **标准化工作流** - 团队统一的代码审查、提交流程
2. **扩展能力** - 快速获取 PDF 处理、云部署等专业技能
3. **保持一致性** - 确保 AI 遵循项目规范
4. **提升效率** - 减少重复指令，快速复用最佳实践

建议从简单的 Skill 开始，如代码审查或提交信息生成，逐步扩展到更复杂的工作流和自定义 Agent。
