# OpenCode 最佳实践指南

> 全面指南：如何高效使用 OpenCode AI 编程助手，发挥最大生产力。

---

## 目录

1. [核心概念](#1-核心概念)
2. [安装与配置](#2-安装与配置)
3. [工作流程最佳实践](#3-工作流程最佳实践)
4. [提示词技巧](#4-提示词技巧)
5. [项目初始化](#5-项目初始化)
6. [代码质量保证](#6-代码质量保证)
7. [多 Agent 协作](#7-多-agent-协作)
8. [Skills 与扩展](#8-skills-与扩展)
9. [安全与隐私](#9-安全与隐私)
10. [高级技巧](#10-高级技巧)

---

## 1. 核心概念

### OpenCode 是什么

OpenCode 是一个开源 AI 编程助手（GitHub 120K+ Stars），提供：

| 特性 | 说明 |
|------|------|
| 终端优先 | 在终端中运行，可与任何编辑器配合 |
| 模型无关 | 支持 Claude、GPT、Gemini、Ollama 等 |
| 多会话 | 支持并行多会话处理同一项目 |
| 共享链接 | 可分享会话供团队参考 |
| 完全开源 | 代码透明，无供应商锁定 |

### 两种模式

```
┌─────────────────────────────────────────────────────┐
│  TAB 键切换                                        │
├─────────────────────────────────────────────────────┤
│                                                     │
│  📋 PLAN 模式 (只读)                               │
│  ├─ 只读取和分析代码                                │
│  ├─ 生成实现计划                                    │
│  └─ 适合复杂功能的方案设计                           │
│                                                     │
│  🔨 BUILD 模式 (可写)                              │
│  ├─ 可创建/编辑/删除文件                            │
│  ├─ 执行命令                                        │
│  └─ 适合直接实现                                    │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**建议流程：** 先 PLAN 讨论方案，确认后切换 BUILD 实现。

---

## 2. 安装与配置

### 安装方式

```bash
# 方式一：安装脚本（推荐）
curl -fsSL https://opencode.ai/install | bash

# 方式二：npm
npm install -g opencode-ai

# 方式三：Homebrew (macOS/Linux)
brew install anomalyco/tap/opencode

# 方式四：Docker
docker run -it --rm ghcr.io/anomalyco/opencode
```

### 配置 API Key

```bash
# 启动 OpenCode
opencode

# 连接 providers
/connect
# 选择 opencode.ai，登录后获取 API Key
```

**推荐 Provider：**
- **OpenCode Zen** - 经过优化的精选模型
- **Anthropic Claude** - 代码能力强
- **OpenAI GPT-4** - 通用能力强

### 配置文件

OpenCode 配置文件位于 `~/.opencode/opencode.jsonc`：

```jsonc
{
  "$schema": "https://opencode.ai/schema.json",
  "skills": {
    "paths": [
      "~/.agents/skills",  // 全局 Skills
      "./.agents/skills"    // 项目级 Skills
    ],
    "autoLoad": true
  },
  "agents": {
    "build": {
      "model": "claude-sonnet-4",
      "temperature": 0.3
    }
  },
  "tools": {
    "enabled": ["read", "write", "edit", "bash", "grep", "glob"]
  }
}
```

---

## 3. 工作流程最佳实践

### 3.1 复杂功能开发流程

```
1️⃣  PLAN 模式分析
    │
    ├─ 描述需求
    │   "我想为用户添加角色权限系统"
    │
    ├─ 引用相关代码
    │   "参考 @app/models/User.php 和 @database/migrations/"
    │
    └─ 讨论方案
        "这个设计合理吗？"
    
    ↓
    
2️⃣  获取计划
    │
    ├─ OpenCode 生成实现计划
    ├─ Review 并提供反馈
    └─ 补充细节和约束
        "使用 RBAC 模型"
        "参考现有权限实现"
    
    ↓
    
3️⃣  BUILD 模式实现
    │
    ├─ 切换模式: <TAB>
    └─ 执行
        "好的，开始实现"
```

### 3.2 简单修改流程

```
直接请求 → 详细说明 → Review → 提交

示例：
"在 @app/services/OrderService.php 的 calculateTotal 方法中，
添加优惠券折扣逻辑。参考 @app/services/CouponService.php"
```

### 3.3 撤销与重做

```bash
/undo      # 撤销上次更改
/redo      # 重做
/undo 3    # 撤销最近 3 次更改
```

---

## 4. 提示词技巧

### 4.1 有效提示词结构

```
┌─────────────────────────────────────────────────────────────┐
│ 良好的提示词 = 任务 + 上下文 + 约束 + 参考                   │
└─────────────────────────────────────────────────────────────┘
```

**示例对比：**

```markdown
# ❌ 不好的提示
"修复这个 bug"

# ✅ 好的提示
"修复 @src/api/users.ts 中的分页 bug：
- 当前问题：第2页返回的数据与第1页重复
- 期望行为：每页返回不重复的数据
- 参考：查看 @src/api/posts.ts 的分页实现
- 约束：使用游标分页而非偏移分页"
```

### 4.2 使用 @ 引用文件

```bash
# 引用单个文件
"解释 @src/auth/login.ts 的认证逻辑"

# 引用多个文件
"对比 @src/old/service.ts 和 @src/new/service.ts"

# 引用目录
"分析 @src/components/ 目录结构"
```

### 4.3 提供示例

```bash
# 提供输入输出示例
"实现一个函数来格式化日期：
输入: '2026-03-21T10:30:00Z'
输出: '2026年03月21日 10:30'
参考 moment.js 的 format 风格"
```

### 4.4 指定约束

```bash
"创建一个 API 路由：
- 使用 RESTful 规范
- 返回 JSON 格式：{success, data, message}
- 添加请求验证
- 遵循现有路由的中间件模式"
```

---

## 5. 项目初始化

### 5.1 初始化项目

```bash
cd /path/to/project
opencode
/init
```

这会分析项目结构并创建 `AGENTS.md` 文件。

### 5.2 AGENTS.md 最佳实践

```markdown
# AGENTS.md - 项目规范

## 项目信息
- 框架：Laravel 12.x
- PHP 版本：8.3+
- 数据库：MySQL 8.0

## 🚨 CRITICAL (置顶)
- 禁止直接 push 到 main 分支
- 敏感配置不提交到 Git

## 命令速查
- 开发：php artisan serve
- 测试：php artisan test --filter testMethodName
- 格式化：./vendor/bin/pint

## 代码规范
- 遵循 PSR-12
- 使用 Laravel Pint 自动格式化
- 详见 docs/STANDARDS.md

## 项目结构
- app/Http/Controllers/Api/ - API 控制器
- app/Models/ - Eloquent 模型
- database/migrations/ - 数据库迁移
```

### 5.3 提交 AGENTS.md

```bash
git add AGENTS.md
git commit -m "docs: add AGENTS.md for OpenCode project guidelines"
```

**为什么重要：**
- 团队成员使用 OpenCode 时自动遵循规范
- 每次新会话自动加载项目上下文
- 减少重复解释项目结构

---

## 6. 代码质量保证

### 6.1 提交前检查清单

```
┌─────────────────────────────────────────────┐
│ OpenCode 执行以下检查后提交：                 │
├─────────────────────────────────────────────┤
│                                             │
│ □ 代码格式化 (pint)                         │
│ □ 语法检查 (phpcs)                          │
│ □ 测试通过 (php artisan test)                │
│ □ 类型检查 (phpstan - 可选)                  │
│ □ 符合 AGENTS.md 规范                       │
│                                             │
└─────────────────────────────────────────────┘
```

### 6.2 审查代码变更

```bash
# 让 OpenCode 审查自己的变更
"在提交前，审查刚才的所有变更：
1. 检查是否有潜在 bug
2. 检查命名是否一致
3. 检查是否有重复代码"

# 使用 diff 对比
git diff | opencode --review
```

### 6.3 使用 Skills 增强

| Skill | 用途 |
|-------|------|
| `refactor-review` | 代码审查、重构、bug 追踪 |
| `discover-testing` | 发现测试技能 |
| `skill-vetter` | 审核第三方代码 |

---

## 7. 多 Agent 协作

### 7.1 并行 Agent 模式

```bash
# 主 agent 处理核心逻辑
/opencode "实现用户认证模块"

# 并行 agent 处理辅助任务
/opencode --agent analyzer "分析认证模块安全性"
/opencode --agent tester "为认证模块写测试"
```

### 7.2 Agent 类型

| Agent | 用途 | 工具权限 |
|-------|------|----------|
| `build` | 完整文件/命令访问 | 全部 |
| `plan` | 只读分析 | 读取、搜索 |
| `@general` | 通用任务 | 中等 |
| `@explore` | 代码探索 | 读取 |

### 7.3 协作示例

```
场景：重构大型模块

Agent 1 (Plan): 分析依赖关系和重构计划
Agent 2 (Build): 执行数据库迁移
Agent 3 (Review): 审查代码质量和测试覆盖
Agent 4 (Tester): 编写集成测试

主 Agent: 协调和整合
```

---

## 8. Skills 与扩展

### 8.1 Skills 层级

```
┌─────────────────────────────────────────────────┐
│ PLUGINS (重量级)                                │
│ - npm 包，完整工具集成                           │
│ - 数据库连接器、部署管道                         │
├─────────────────────────────────────────────────┤
│ AGENTS (中等)                                   │
│ - 专业 AI 角色，专注任务                        │
│ - 安全审查员、架构师                           │
├─────────────────────────────────────────────────┤
│ SKILLS (轻量级) ✅ 推荐入门                     │
│ - 可复用提示模板                                │
│ - 代码审查、提交信息、文档生成                   │
└─────────────────────────────────────────────────┘
```

### 8.2 热门 Skills 推荐

```bash
# 安装热门 Skills
npx -y @lobehub/market-cli skills install anthropics-skills-pptx --global
npx -y @lobehub/market-cli skills install anthropics-skills-pdf --global
npx -y @lobehub/market-cli skills install openclaw-openclaw-summarize --global
npx -y @lobehub/market-cli skills install openclaw-openclaw-github --global
npx -y @lobehub/market-cli skills install openclaw-openclaw-weather --global
```

### 8.3 自定义 Skill

创建 `~/.agents/skills/my-custom-skill/SKILL.md`：

```markdown
---
name: my-project-standards
description: 项目代码规范和审查清单。用于代码审查、提交前检查、
             重构机会发现。当用户提到"审查代码"、"检查规范"时触发。
---

# My Project Standards

## 代码审查清单

### 安全
- [ ] SQL 注入防护
- [ ] XSS 防护
- [ ] 权限检查

### 性能
- [ ] 数据库索引
- [ ] 缓存使用
- [ ] N+1 查询

### 代码质量
- [ ] 错误处理
- [ ] 类型声明
- [ ] 文档注释
```

---

## 9. 安全与隐私

### 9.1 敏感信息处理

```
⚠️  绝不让 OpenCode 处理：
┌─────────────────────────────────────────────────┐
│ - API 密钥和密码                                 │
│ - 个人身份信息 (PII)                            │
│ - 私钥和证书                                    │
│ - 数据库连接字符串                                │
│ - 云服务凭证                                    │
└─────────────────────────────────────────────────┘
```

### 9.2 最佳实践

1. **使用环境变量**
   ```bash
   # ❌ 不好
   "连接数据库，用户名 admin，密码 secret123"
   
   # ✅ 好
   "使用 DATABASE_URL 环境变量连接数据库"
   ```

2. **.gitignore 敏感文件**
   ```
   .env
   *.pem
   config/secrets.yml
   ```

3. **审核第三方代码**
   ```bash
   # 安装 skill-vetter
   npx -y @lobehub/market-cli skills install openclaw-skills-skill-vetter --global
   
   # 审核任何第三方 Skill
   /skill-vetter <skill-name>
   ```

### 9.3 权限控制

```jsonc
// 限制工具权限
{
  "tools": {
    "enabled": ["read", "glob", "grep"],
    "disabled": ["bash", "write", "edit"]
  }
}
```

---

## 10. 高级技巧

### 10.1 会话共享与协作

```bash
# 分享当前会话
/share
# 生成链接，可复制给团队成员

# 查看共享会话
/opencode --session https://opencode.ai/s/xxxxx
```

### 10.2 MCP 服务器集成

```jsonc
// 配置 MCP 服务器
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "./"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

### 10.3 自定义命令

```bash
# 在 ~/.opencode/commands 中创建
# my-check.md
---
name: /my-check
description: 运行项目检查
---

# 执行检查

1. 运行代码格式检查：
```bash
./vendor/bin/pint --test
```

2. 运行测试：
```bash
php artisan test
```

3. 检查安全问题：
```bash
composer audit
```

# 使用
/opencode
/my-check
```

### 10.4 终端快捷键

| 快捷键 | 功能 |
|--------|------|
| `Tab` | 切换 PLAN/BUILD 模式 |
| `Ctrl+C` | 取消当前操作 |
| `Ctrl+L` | 清屏 |
| `↑/↓` | 历史命令 |
| `@` | 引用文件 |

---

## 常见问题

### Q: OpenCode 与 Claude Code / Cursor 相比有何优势？

| 特性 | OpenCode | Claude Code | Cursor |
|------|----------|-------------|--------|
| 成本 | 免费/低 | API 费用 | 订阅制 |
| 模型选择 | 多 | Anthropic | 多 |
| 终端优先 | ✅ | ✅ | ❌ |
| 开源 | ✅ | ❌ | ❌ |
| 多会话 | ✅ | ❌ | ✅ |

### Q: 如何处理 OpenCode 生成的错误代码？

1. 使用 `/undo` 撤销
2. 提供更详细的上下文
3. 分解任务为更小的步骤
4. 参考现有代码模式

### Q: OpenCode 能完全替代人类开发者吗？

**不能。** OpenCode 是工具，不是替代品：

- ✅ 适合：重复任务、代码生成、初步探索
- ❌ 不适合：复杂架构决策、业务逻辑理解、团队协作

---

## 快速参考卡

```
┌─────────────────────────────────────────────────────────────┐
│                    OpenCode 快速参考                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  启动     opencode                                        │
│  初始化   /init                                           │
│  连接     /connect                                         │
│  分享     /share                                           │
│                                                             │
│  切换模式  Tab                                             │
│  撤销     /undo                                            │
│  重做     /redo                                            │
│                                                             │
│  引用文件  @path/to/file                                   │
│  搜索     /search <term>                                   │
│                                                             │
│  退出     Ctrl+C 或 /exit                                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 资源链接

- [官方文档](https://opencode.ai/docs)
- [GitHub 仓库](https://github.com/anomalyco/opencode)
- [Skills 市场](https://lobehub.com/skills)
- [Discord 社区](https://opencode.ai/discord)

---

*最后更新: 2026-03-21*
