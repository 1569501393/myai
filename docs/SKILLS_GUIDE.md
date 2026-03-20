# OpenCode Skills 使用指南

> 本文档介绍已安装的 Skills 及其最佳实践，帮助你高效使用 AI 编程助手。

---

## 已安装 Skills 总览

| # | Skill | 功能 | 评分 | 安装量 |
|---|-------|------|------|--------|
| 1 | `pptx` | PowerPoint 创建编辑 | ⭐4.9 | 90.8k |
| 2 | `pdf` | PDF 处理 | ⭐5.0 | 90.8k |
| 3 | `summarize` | URL/视频/文件摘要 | ⭐4.2 | 187.6k |
| 4 | `weather` | 天气查询 | ⭐4.8 | 187.7k |
| 5 | `find-skills` | 智能技能匹配 | ⭐8.3k | 79 |
| 6 | `skill-creator` | 自定义 Skill 创建 | ⭐187.6k | 37 |
| 7 | `agent-docs` | AI 友好文档编写 | ⭐1.9k | 19 |
| 8 | `refactor-review` | 代码重构审查 | - | - |
| 9 | `tmux` | Tmux 会话控制 | ⭐260.1k | 14 |
| 10 | `playwright-cli` | 无头浏览器自动化 | - | - |
| 11 | `skill-vetter` | Skill 安全审核 | ⭐4.9 | 1.9k |
| 12 | `github` | GitHub CLI 管理 | ⭐18.7k | 94 |
| 13 | `draft-release` | 版本发布/CHANGELOG | ⭐2.5k | - |
| 14 | `discover-testing` | 测试技能发现 | - | - |
| 15 | `exa-web-search` | 免费 AI 网页搜索 | ⭐2.6k | 14 |

**安装路径：** `~/.agents/skills/`

---

## 1. 核心技能详解

### 1.1 pptx - PowerPoint 处理

**功能：** 创建、编辑、解析 PowerPoint 文件

**触发词：** "创建 PPT"、"编辑幻灯片"、"生成演示文稿"、".pptx 文件"

**使用方法：**
```bash
# 安装依赖
npm install -g pptxgenjs  # 或使用 skill 内置工具
```

**最佳实践：**
- 明确幻灯片结构和内容要求
- 提供模板参考或指定风格
- 分步骤创建复杂演示

---

### 1.2 pdf - PDF 处理

**功能：** 合并、拆分、旋转、提取文本、水印、OCR

**触发词：** "处理 PDF"、"合并 PDF"、"提取 PDF 内容"、".pdf 文件"

**使用方法：**
```bash
# 使用 pdfplumber 提取文本
pip install pdfplumber

# 使用 pypdf2 合并
pip install PyPDF2
```

**最佳实践：**
- 大文件先拆分再处理
- OCR 前确保图像质量
- 使用书签标记重要页面

---

### 1.3 summarize - 内容摘要

**功能：** 从 URL、视频、音频、文件中提取摘要

**触发词：** "总结这个链接"、"视频摘要"、"提取主要内容"

**使用方法：**
```bash
# 摘要网页
curl -s "https://example.com/article" | summarize

# 摘要 YouTube 视频
summarize "https://youtube.com/watch?v=xxx"
```

**最佳实践：**
- 长内容设置最大 token 限制
- 视频优先提取字幕/转录
- 复杂文档分段摘要后合并

---

### 1.4 weather - 天气查询

**功能：** 获取当前天气和预报，无需 API Key

**触发词：** "天气怎么样"、"明天会下雨吗"

**使用方法：**
```bash
# 基本查询
curl -s "wttr.in/Beijing?format=3"

# 完整预报
curl -s "wttr.in/Shanghai?T"

# 带图输出
curl -s "wttr.in/Guangzhou.png" -o weather.png
```

**最佳实践：**
- 使用城市中文名或拼音
- 指定 metric 单位：`?m`
- 今天/明天/后天：`?1` / `?2` / `?3`

---

## 2. 开发效率技能

### 2.1 skill-creator - 创建自定义 Skill

**功能：** 将重复工作流封装为可复用 Skill

**触发词：** "创建 Skill"、"制作技能"、"封装工作流"

**Skill 文件结构：**
```
my-skill/
├── SKILL.md              # 必需：名称和描述
├── scripts/              # 可执行脚本
├── references/           # 参考文档
└── assets/              # 静态资源
```

**SKILL.md 格式：**
```markdown
---
name: my-skill
description: 描述技能功能和触发场景
---

# My Skill

## 使用说明
...
```

**最佳实践：**
1. **保持简洁** - 只包含 AI 不知道的信息
2. **渐进披露** - 基础在 SKILL.md，详细在 references/
3. **明确触发** - description 要说明何时使用此技能
4. **包含示例** - 代码示例优于冗长解释

---

### 2.2 agent-docs - AI 友好文档

**功能：** 编写 AI 易于理解和使用的文档

**触发词：** "写文档"、"生成 README"、"创建 API 文档"

**核心原则：**

| 原则 | 说明 |
|------|------|
| 压缩索引 | 8KB 索引优于 40KB 全文 |
| 结构分块 | 每个 H2 节独立完整 |
| 内联优于链接 | AI 无法自动浏览外部链接 |
| 关键信息置顶 | 利用首因效应 |

**AGENTS.md 结构：**
```markdown
# AGENTS.md

## 🚨 CRITICAL (置顶)
- 安全规则
- 架构约束

## 📚 DOCS INDEX
- 路径映射
- 命令速查

## 详细说明...
```

**最佳实践：**
- 关键规则放在文档顶部
- 每个段落自包含
- 避免链接，改用内联摘要

---

### 2.3 refactor-review - 代码重构审查

**功能：** 代码审查、重构机会发现、bug 追踪

**触发词：**
- "审查代码"、"重构机会"
- "找死代码"、"去重"
- "PR review"、"找 bug"
- "红队审查"、"对抗测试"

**子命令：**

| 命令 | 用途 |
|------|------|
| `sc-refactor` | 重构规划/执行 |
| `sc-review-pr` | PR 质量审查 |
| `sc-cleanup` | AI 会话后清理 |
| `sc-bug-hunt` | 对抗性 bug 追踪 |
| `sc-adversarial-review` | 多模型交叉审查 |

**最佳实践：**
- 定期运行 `sc-codebase-health` 全量检查
- PR 提交前使用 `sc-review-pr` 自审
- 发现问题立即用 `sc-refactor` 修复

---

### 2.4 discover-testing - 测试技能发现

**功能：** 自动发现相关测试技能

**触发词：** "写测试"、"单元测试"、"E2E"、"TDD"

**可用测试技能：**
- `e2e-testing` - 端到端测试
- `integration-testing` - 集成测试
- `performance-testing` - 性能测试
- `test-coverage-strategy` - 覆盖率策略
- `test-driven-development` - TDD 开发
- `unit-testing-patterns` - 单元测试模式

**最佳实践：**
- 测试任务时自动激活
- 使用渐进加载：gateway → INDEX → specific skill
- 结合 refactor-review 检查测试覆盖

---

## 3. 工具集成技能

### 3.1 github - GitHub CLI

**功能：** 通过 `gh` CLI 管理 GitHub

**触发词：** "查看 PR"、"创建 Issue"、"检查 CI"

**核心命令：**
```bash
# PR 操作
gh pr create                    # 创建 PR
gh pr view                     # 查看当前 PR
gh pr checks                   # 检查 CI 状态
gh pr merge                    # 合并 PR

# Issue 操作
gh issue list                  # 列出 Issues
gh issue create                # 创建 Issue
gh issue view <number>         # 查看 Issue

# CI/CD
gh run list                    # 查看 Actions 运行
gh run view <id> --log-failed  # 查看失败日志

# 高级查询
gh api repos/owner/repo/pulls  # GraphQL 查询
```

**最佳实践：**
- 始终指定 `--repo owner/repo`
- 使用 `--json` 获取结构化输出
- 结合 `gh api --jq` 过滤字段

---

### 3.2 playwright-cli - 浏览器自动化

**功能：** Playwright 无头浏览器控制

**触发词：** "测试网页"、"自动化浏览器"、"截图"

**核心命令：**
```bash
# 页面操作
playwright-cli open <url>      # 打开页面
playwright-cli click <ref>     # 点击元素
playwright-cli type <text>     # 输入文本
playwright-cli snapshot        # 获取元素引用

# 导航
playwright-cli go-back         # 后退
playwright-cli go-forward      # 前进
playwright-cli reload          # 刷新

# 输出
playwright-cli screenshot      # 截图
playwright-cli pdf             # 导出 PDF
playwright-cli console         # 查看控制台

# Tab 管理
playwright-cli tab-new         # 新标签
playwright-cli tab-select <n>  # 切换标签
```

**最佳实践：**
- 使用 `--session` 隔离会话
- 先 `snapshot` 获取元素引用
- 开发模式用 `--headed` 可视化调试

---

### 3.3 tmux - 终端会话管理

**功能：** 远程控制 tmux 会话

**触发词：** "查看 tmux"、"发送命令到后台"

**核心命令：**
```bash
# 列表和捕获
tmux list-sessions            # 列出会话
tmux capture-pane -t <name> -p  # 捕获输出

# 发送输入
tmux send-keys -t <name> "text" Enter  # 发送命令

# 会话管理
tmux new-session -d -s <name>  # 创建会话
tmux kill-session -t <name>    # 销毁会话
```

**最佳实践：**
- 交互式应用分步发送（文本 + Enter 分离）
- 使用命名会话如 `shared`、`worker-2`
- 长输出用 `capture-pane -S -` 获取全部历史

---

### 3.4 exa-web-search - AI 搜索

**功能：** 神经网络搜索网页、代码、公司信息

**触发词：** "搜索最新资讯"、"查找代码示例"

**工具：**
```bash
# 网页搜索
mcporter call 'exa.web_search_exa(query: "最新 AI 新闻", numResults: 5)'

# 代码搜索
mcporter call 'exa.get_code_context_exa(query: "React hooks 示例", tokensNum: 3000)'

# 公司研究
mcporter call 'exa.company_research_exa(companyName: "Anthropic", numResults: 3)'
```

**最佳实践：**
- 快速查询用 `type: "fast"`
- 深度研究用 `type: "deep"`
- 代码搜索降低 `tokensNum` 保持聚焦

---

## 4. 安全与质量技能

### 4.1 skill-vetter - Skill 安全审核

**功能：** 安装前审核 Skill 安全性

**触发词：** "审核这个 Skill"、"检查安全"

**审核流程：**

```
1️⃣  来源检查
    - 作者是否可信？
    - 下载量/星标？
    - 最近更新？

2️⃣  代码审查 (必须)
    检查红牌：
    ❌ curl/wget 到未知 URL
    ❌ 发送数据到外部服务器
    ❌ 请求凭据/密钥
    ❌ 读取 ~/.ssh、~/.aws
    ❌ 使用 eval/exec
    ❌ 混淆代码

3️⃣  权限评估
    - 需要读写哪些文件？
    - 需要网络访问吗？
    - 需要执行哪些命令？
```

**风险等级：**

| 等级 | 说明 | 操作 |
|------|------|------|
| 🟢 LOW | 笔记、天气 | 直接安装 |
| 🟡 MEDIUM | 文件操作、浏览器 | 完整代码审查 |
| 🔴 HIGH | 凭据、交易 | 需人工批准 |
| ⛔ EXTREME | 安全配置 | 拒绝安装 |

**最佳实践：**
- 所有 Skill 安装前必审核
- 记录审核结果
- 高风险 Skill 请人工确认

---

### 4.2 draft-release - 版本发布

**功能：** 自动生成 CHANGELOG 和发布 PR

**触发词：** "创建发布"、"版本更新"

**工作流程：**
```bash
# 1. 确定版本号
git tag --sort=-version:refname | head -1

# 2. 创建发布分支
git checkout -b release/v1.2.0

# 3. 自动生成 CHANGELOG
# (根据 conventional commits 分类)

# 4. 创建 PR
gh pr create --title "Release v1.2.0"
```

**CHANGELOG 格式：**
```markdown
## [1.2.0] - 2026-03-21

### Added
- 新功能描述 ([#123](link))

### Fixed
- Bug 修复描述 ([#456](link))

### Security
- 安全更新 ([#789](link))
```

**最佳实践：**
- 使用 conventional commits
- 跳过依赖更新和 CI 提交
- 合并后自动触发发布

---

## 5. 技能发现与搜索

### 5.1 find-skills - 技能匹配

**功能：** 发现和安装新技能

**触发词：** "找技能"、"有这个功能吗"、"安装..."

**使用方法：**
```bash
# 搜索技能
npx -y @lobehub/market-cli skills search --q "pdf"

# 安装技能
npx -y @lobehub/market-cli skills install <identifier> --global

# 查看已安装
ls ~/.agents/skills/
```

**最佳实践：**
- 先搜索是否有现成技能
- 参考热门技能和评分
- 安装后记录用途和用法

---

## 6. 技能使用场景矩阵

| 任务 | 推荐技能 | 触发词示例 |
|------|----------|------------|
| 处理 .pptx 文件 | `pptx` | "创建年度汇报 PPT" |
| 处理 .pdf 文件 | `pdf` | "合并这三个 PDF" |
| 总结文章/视频 | `summarize` | "总结这个链接的内容" |
| 查询天气 | `weather` | "北京明天天气" |
| 代码审查 | `refactor-review` | "审查这段代码" |
| 重构代码 | `refactor-review` | "找重构机会" |
| 找 bug | `refactor-review` | "bug hunt" |
| 写测试 | `discover-testing` | "为这个函数写单元测试" |
| GitHub 操作 | `github` | "查看我的 PR" |
| 浏览器自动化 | `playwright-cli` | "测试登录流程" |
| 终端会话 | `tmux` | "查看后台任务" |
| 网络搜索 | `exa-web-search` | "搜索 Laravel 12 新特性" |
| 安装新技能 | `find-skills` | "找 PDF 处理的技能" |
| 审核技能安全 | `skill-vetter` | "检查这个 Skill" |
| 创建新技能 | `skill-creator` | "封装我的工作流" |
| 写文档 | `agent-docs` | "生成 API 文档" |
| 发布版本 | `draft-release` | "发布 v1.0" |

---

## 7. 快速参考

### 安装新技能
```bash
npx -y @lobehub/market-cli register --name "你的名字" --source opencode
npx -y @lobehub/market-cli skills install <identifier> --global
```

### 技能存放位置
```
~/.agents/skills/           # 全局安装
<project>/.agents/skills/   # 项目级安装
```

### 常用命令
```bash
# 搜索技能
npx -y @lobehub/market-cli skills search --q "关键词"

# 评分
npx -y @lobehub/market-cli skills rate <identifier> --score 5

# 评论
npx -y @lobehub/market-cli skills comment <identifier> -c "很好用" --rating 5
```

---

*最后更新: 2026-03-21*
