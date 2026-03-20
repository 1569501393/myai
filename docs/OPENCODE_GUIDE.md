# OpenCode 使用指南：知识点与最佳实践

## 目录

1. [简介](#简介)
2. [核心概念](#核心概念)
3. [安装与配置](#安装与配置)
4. [基础使用](#基础使用)
5. [高级功能](#高级功能)
6. [最佳实践](#最佳实践)
7. [常见问题](#常见问题)

---

## 简介

OpenCode 是一个开源的 AI 编程助手，支持多模型（Claude、OpenAI、DeepSeek 等），提供终端和桌面客户端，适用于各类编程任务。

### 核心特性

- **多模型支持**: 灵活切换不同 AI 模型
- **Skills 技能系统**: 可定制的开发工作流自动化
- **AGENTS.md 配置**: 项目级规则和上下文
- **MCP 插件扩展**: 连接外部工具和服务
- **跨平台**: Linux/macOS/Windows

---

## 核心概念

### 1. AGENTS.md - 项目配置

AGENTS.md 是 OpenCode 的核心配置文件，用于定义项目规则和上下文。

**位置优先级**:
1. 项目根目录 `AGENTS.md`（最高）
2. 全局配置 `~/.config/opencode/AGENTS.md`
3. Claude Code 兼容 `~/.claude/CLAUDE.md`（最低）

**示例**:
```markdown
# 我的 Laravel 项目

## 技术栈
- Laravel 12.x
- Vue 3
- MySQL 8.0

## 代码规范
- 遵循 PSR-12 标准
- 使用 Laravel Pint 格式化
- 单测优先原则
```

### 2. Skills 技能系统

Skills 是可复用的指令包，让 AI 自动化执行特定工作流。

**文件结构**:
```
~/.opencode/skills/my-skill/
└── SKILL.md          # 核心配置文件
```

**SKILL.md 示例**:
```markdown
# Laravel 代码审查技能

## 触发条件
用户说 "review"、"审查"、"代码检查"

## 工作流程
1. 检查代码规范（PSR-12）
2. 检查安全漏洞
3. 检查性能问题
4. 输出审查报告

## 输出格式
- 问题列表（严重程度分级）
- 改进建议
- 示例代码
```

### 3. MCP 插件

Model Context Protocol 插件，扩展 OpenCode 连接外部工具。

**示例 MCP 配置**:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/dir"]
    }
  }
}
```

---

## 安装与配置

### 安装命令

```bash
# macOS/Linux
curl -sL https://raw.githubusercontent.com/opencode-ai/opencode/main/install.sh | sh

# 或使用 npm
npm install -g opencode-cli
```

### 配置文件位置

- **全局配置**: `~/.config/opencode/opencode.json`
- **项目配置**: `./opencode.json`
- **AGENTS.md**: `./AGENTS.md` 或 `~/.config/opencode/AGENTS.md`

### 模型配置示例

```json
{
  "model": "anthropic/claude-sonnet-4-5",
  "temperature": 0.7,
  "maxTokens": 8192
}
```

---

## 基础使用

### 1. 启动会话

```bash
opencode                    # 当前目录
opencode ./src              # 指定目录
opencode --model claude     # 指定模型
```

### 2. 引用文件（@ 语法）

使用 `@` 引用文件或目录，保持上下文精确：

```bash
# 引用单个文件
请审查这段代码 @src/Controller/UserController.php

# 引用多个文件
比较这两个文件 @src/v1/api.ts 和 @src/v2/api.ts

# 引用目录
优化这个模块的性能 @src/services
```

### 3. 常用命令

| 命令 | 说明 |
|------|------|
| `/help` | 显示帮助信息 |
| `/model` | 切换 AI 模型 |
| `/context` | 管理上下文 |
| `/skills` | 查看可用技能 |
| `/exit` | 退出会话 |

### 4. 代码操作

```bash
# 生成代码
生成一个用户注册接口，包含验证和错误处理

# 代码审查
审查 @src/models/User.php 的安全问题

# 重构建议
分析 @src/utils/helper.ts 并提出重构建议

# 调试辅助
解释这个错误: NullPointerException at line 42
```

---

## 高级功能

### 1. 多代理协作 (Subagents)

复杂任务拆分为多个子代理并行处理：

```bash
# 使用 Task 工具启动子代理
/task "分析数据库 schema，输出优化建议"
```

### 2. Hooks 钩子

在特定时机自动执行操作：

| Hook | 时机 | 用途 |
|------|------|------|
| `pre-command` | 命令执行前 | 验证、环境检查 |
| `post-command` | 命令执行后 | 格式化、提交 |
| `pre-commit` | Git 提交前 | 代码检查 |

### 3. LSP 集成

语言服务器协议支持，提供智能补全和诊断：

```json
{
  "lsp": {
    "php": "intelephense",
    "typescript": "typescript-language-server"
  }
}
```

### 4. 远程配置

支持从远程 URL 加载配置：

```json
{
  "instructions": [
    "https://raw.githubusercontent.com/org/shared-rules/main/style.md"
  ]
}
```

---

## 最佳实践

### 实践一：精准引用文件

**❌ 不推荐**:
```
帮我看看这个文件的问题
（没有明确指定文件，AI 可能理解错误）
```

**✅ 推荐**:
```
请审查 @src/Http/Controllers/OrderController.php
检查：1) 权限验证 2) 参数校验 3) 异常处理
```

### 实践二：分步骤执行复杂任务

**❌ 不推荐**:
```
创建一个完整的电商系统
```

**✅ 推荐**:
```
1. 设计数据库 schema（用户、订单、商品）
2. 创建 Laravel Model 和 Migration
3. 实现用户认证 API
4. 实现商品 CRUD 接口
5. 实现订单流程
```

### 实践三：利用 Skills 自动化

创建常用工作流技能，减少重复工作：

**示例：代码审查技能**
```markdown
# 创建 ~/.opencode/skills/code-review/SKILL.md

## 触发
用户请求代码审查时激活

## 检查项
1. 安全：硬编码密码、SQL 注入、XSS
2. 性能：N+1 查询、循环内查询
3. 规范：命名、注释、代码结构
4. 测试：覆盖率、边界条件

## 输出
- 问题列表（高/中/低）
- 具体修复代码
- 总结建议
```

### 实践四：会话记录与知识积累

每个会话结束后保存关键信息：

```markdown
# 会话记录模板

## 项目上下文
- 学到的项目结构
- 常用的设计模式
- 特殊的业务规则

## 工具配置
- 有效的命令
- 错误的尝试

## 待办事项
- 需要进一步优化的地方
- 需要人工跟进的问题
```

### 实践五：结合 Linter 使用

在 AGENTS.md 中配置代码检查：

```markdown
## 代码质量
- 提交前运行 `./vendor/bin/pint`
- PHP 使用 PSR-12 标准
- JavaScript 使用 ESLint
```

### 实践六：多人协作配置

团队共享规则文件：

```json
// opencode.json
{
  "instructions": [
    "docs/coding-standards.md",
    "docs/api-guidelines.md",
    "packages/*/AGENTS.md"
  ]
}
```

### 实践七：安全使用建议

1. **不暴露敏感信息**
   ```bash
   # ❌ 危险
   opencode "帮我连接数据库，用户名 admin，密码 123456"
   
   # ✅ 安全
   opencode "使用环境变量连接数据库，配置见 .env"
   ```

2. **验证 AI 生成的代码**
   - 始终审查 AI 生成的代码
   - 运行测试验证
   - 检查安全漏洞

3. **定期更新配置**
   ```bash
   opencode --update  # 更新 OpenCode
   opencode /init     # 重新扫描项目
   ```

---

## 常见问题

### Q1: 如何让 AI 更好地理解项目？

**A**: 
1. 在 AGENTS.md 中详细描述项目结构
2. 使用 `@` 引用相关文件
3. 提供示例代码和文档
4. 定期运行 `/init` 更新上下文

### Q2: OpenCode 与 Claude Code 的区别？

| 特性 | OpenCode | Claude Code |
|------|----------|-------------|
| 开源 | ✅ 完全开源 | ❌ 闭源 |
| 多模型 | ✅ 支持多种 | ❌ 仅 Claude |
| 本地部署 | ✅ 支持 | ❌ 不支持 |
| 价格 | 免费 | 免费（有限制） |

### Q3: 如何创建自定义技能？

1. 创建目录：`~/.opencode/skills/my-skill/`
2. 编写 SKILL.md：定义触发条件、工作流程、输出格式
3. 在 AGENTS.md 中引用或自动加载

### Q4: AGENTS.md 太大怎么办？

**A**: 使用外部引用

```markdown
# AGENTS.md
详见外部规范：@docs/architecture.md
详见编码标准：@docs/coding-standards.md
```

或在 opencode.json 中配置：
```json
{
  "instructions": ["docs/*.md", "rules/*.md"]
}
```

### Q5: 如何调试 AI 输出？

**A**:
1. 使用 `/context` 查看当前上下文
2. 明确指定输出格式要求
3. 分步骤提问，逐步验证
4. 提供反例帮助理解

---

## 扩展资源

- [OpenCode 官方文档](https://opencode.ai/docs/)
- [OpenCode GitHub](https://github.com/opencode-ai/opencode)
- [Skills 技能市场](https://clawdhub.com/)
- [MCP 插件列表](https://modelcontextprotocol.io/)

---

## 更新日志

| 日期 | 版本 | 更新内容 |
|------|------|----------|
| 2026-03-21 | 1.0 | 初始版本，包含核心知识点和最佳实践 |
