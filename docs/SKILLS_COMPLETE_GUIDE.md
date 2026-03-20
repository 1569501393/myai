# OpenCode Skills 完整指南与最佳实践

> 记录已安装的 Skills、功能详解、使用技巧和最佳实践。

---

## Skills 总览

**安装路径:** `~/.agents/skills/`

| # | Skill | 功能 | 依赖 |
|---|-------|------|------|
| 1 | `pptx` | PPT 创建与编辑 | markitdown, pptxgenjs |
| 2 | `pdf` | PDF 处理 | pypdf, pdfplumber, reportlab |
| 3 | `summarize` | URL/视频/文件摘要 | curl |
| 4 | `weather` | 天气查询 | curl |
| 5 | `find-skills` | 技能发现 | npx @lobehub/market-cli |
| 6 | `skill-creator` | 创建自定义 Skill | - |
| 7 | `agent-docs` | AI 友好文档编写 | - |
| 8 | `refactor-review` | 代码重构审查 | - |
| 9 | `tmux` | Tmux 会话控制 | tmux |
| 10 | `playwright-cli` | 浏览器自动化 | @playwright/mcp |
| 11 | `skill-vetter` | Skill 安全审核 | - |
| 12 | `github` | GitHub CLI | gh |
| 13 | `draft-release` | 版本发布 | git, gh |
| 14 | `discover-testing` | 测试技能发现 | - |
| 15 | `exa-web-search` | 免费 AI 搜索 | mcporter |

---

## 一、内容处理类 Skills

### 1.1 PPT (PowerPoint)

#### 功能
- 创建幻灯片、演示文稿
- 读取、解析 PPT 内容
- 编辑现有 PPT
- 合并/拆分幻灯片

#### 核心命令

```bash
# 读取 PPT 内容
python -m markitdown presentation.pptx

# 视觉预览
python scripts/thumbnail.py presentation.pptx

# 解包 PPT
python scripts/office/unpack.py presentation.pptx unpacked/
```

#### 设计最佳实践

**配色方案：**
```yaml
# 专业商务风格
Midnight Executive:
  - Primary: 1E2761 (深蓝)
  - Secondary: CADCFC (冰蓝)
  - Accent: FFFFFF (白)

# 科技风格
Teal Trust:
  - Primary: 028090 (青绿)
  - Secondary: 00A896 (薄荷绿)
  - Accent: 02C39A (翡翠绿)
```

**字体搭配：**
| 场景 | 标题字体 | 正文字体 |
|------|----------|----------|
| 商务 | Georgia | Calibri |
| 科技 | Arial Black | Arial |
| 创意 | Trebuchet MS | Calibri |

#### QA 检查清单
```bash
# 内容检查
python -m markitdown output.pptx

# 检查占位符残留
python -m markitdown output.pptx | grep -iE "xxxx|lorem|ipsum"
```

#### 常见错误
- ❌ 不要创建纯文字幻灯片
- ❌ 不要默认使用蓝色
- ❌ 不要使用标题下的装饰线（AI 生成标志）
- ❌ 不要让所有颜色权重相等

---

### 1.2 PDF

#### 功能
- 合并/拆分 PDF
- 提取文本和表格
- 创建新 PDF
- 旋转页面、添加水印
- OCR 扫描件

#### 核心代码

**读取 PDF：**
```python
from pypdf import PdfReader, PdfWriter

reader = PdfReader("document.pdf")
print(f"页数: {len(reader.pages)}")

# 提取文本
text = ""
for page in reader.pages:
    text += page.extract_text()
```

**合并 PDF：**
```python
from pypdf import PdfWriter, PdfReader

writer = PdfWriter()
for pdf_file in ["doc1.pdf", "doc2.pdf"]:
    reader = PdfReader(pdf_file)
    for page in reader.pages:
        writer.add_page(page)

with open("merged.pdf", "wb") as output:
    writer.write(output)
```

**提取表格：**
```python
import pdfplumber

with pdfplumber.open("document.pdf") as pdf:
    for page in pdf.pages:
        tables = page.extract_tables()
        for table in tables:
            print(table)
```

**创建 PDF：**
```python
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

c = canvas.Canvas("hello.pdf", pagesize=letter)
c.drawString(100, 700, "Hello World!")
c.save()
```

#### 命令行工具
```bash
# 提取文本
pdftotext -layout input.pdf output.txt

# 合并 PDF
qpdf --empty --pages file1.pdf file2.pdf -- merged.pdf

# 旋转页面
qpdf input.pdf output.pdf --rotate=+90:1

# OCR
pytesseract.image_to_string(image)
```

---

### 1.3 Summarize (摘要)

#### 功能
- URL 内容摘要
- YouTube 视频转录摘要
- 本地文件摘要

#### 使用方法
```bash
# 摘要网页
curl -s "https://example.com/article" | summarize

# 摘要视频
summarize "https://youtube.com/watch?v=xxx"
```

#### 最佳实践
- 长内容设置最大 token 限制
- 视频优先提取字幕/转录
- 复杂文档分段摘要后合并

---

### 1.4 Weather (天气)

#### 功能
- 当前天气查询
- 天气预报
- 无需 API Key

#### 使用方法
```bash
# 基本查询
curl -s "wttr.in/Beijing?format=3"
# 输出: Beijing: ⛅️ +8°C

# 完整预报
curl -s "wttr.in/Shanghai?T"

# 明天天气
curl -s "wttr.in/Guangzhou?1"

# 城市拼音
curl -s "wttr.in/New+York?format=3"
```

#### 格式化参数
| 代码 | 说明 |
|------|------|
| `%c` | 天气状况 |
| `%t` | 温度 |
| `%h` | 湿度 |
| `%w` | 风速 |
| `%l` | 位置 |

---

## 二、开发效率类 Skills

### 2.1 Find-Skills (技能发现)

#### 功能
- 搜索可用的 Skills
- 安装新技能
- 发现重复功能

#### 使用方法
```bash
# 搜索技能
npx -y @lobehub/market-cli skills search --q "pdf"

# 安装技能
npx -y @lobehub/market-cli skills install <identifier> --global

# 评分
npx -y @lobehub/market-cli skills rate <identifier> --score 5

# 评论
npx -y @lobehub/market-cli skills comment <identifier> -c "很好用" --rating 5
```

#### 最佳实践
- 搜索前先想清楚需要什么功能
- 参考安装量和评分选择
- 安装后记录用途

---

### 2.2 Skill-Creator (创建技能)

#### 功能
- 创建自定义 Skill
- 封装重复工作流
- 团队知识共享

#### Skill 结构
```
my-skill/
├── SKILL.md              # 必需：名称和描述
├── scripts/              # 可执行脚本
├── references/           # 参考文档
└── assets/              # 静态资源
```

#### SKILL.md 格式
```markdown
---
name: my-skill
description: 描述功能和使用场景
---

# My Skill

## 使用说明
...
```

#### 最佳实践
1. **保持简洁** - 只包含 AI 不知道的信息
2. **渐进披露** - 基础在 SKILL.md，详细在 references/
3. **明确触发** - description 说明何时使用
4. **包含示例** - 代码示例优于冗长解释

---

### 2.3 Agent-Docs (文档编写)

#### 功能
- 编写 AI 友好的文档
- 优化 AGENTS.md
- RAG 优化

#### 核心原则

| 原则 | 说明 |
|------|------|
| 压缩索引 | 8KB 索引优于 40KB 全文 |
| 结构分块 | 每个 H2 节独立完整 |
| 内联优于链接 | AI 无法自动浏览外部链接 |
| 关键信息置顶 | 利用首因效应 |

#### AGENTS.md 结构
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

---

### 2.4 Refactor-Review (代码审查)

#### 功能
- 代码审查
- 重构机会发现
- Bug 追踪

#### 触发词
- "审查代码"、"重构机会"
- "找死代码"、"去重"
- "PR review"、"找 bug"

#### 子命令
| 命令 | 用途 |
|------|------|
| `sc-refactor` | 重构规划/执行 |
| `sc-review-pr` | PR 质量审查 |
| `sc-cleanup` | AI 会话后清理 |
| `sc-bug-hunt` | 对抗性 bug 追踪 |
| `sc-adversarial-review` | 多模型交叉审查 |

#### 最佳实践
- 定期运行 `sc-codebase-health` 全量检查
- PR 提交前使用 `sc-review-pr` 自审
- 发现问题立即用 `sc-refactor` 修复

---

### 2.5 Discover-Testing (测试发现)

#### 功能
- 发现测试相关技能
- E2E 测试
- 单元测试

#### 可用测试技能
- `e2e-testing` - 端到端测试
- `integration-testing` - 集成测试
- `performance-testing` - 性能测试
- `test-coverage-strategy` - 覆盖率策略
- `test-driven-development` - TDD 开发
- `unit-testing-patterns` - 单元测试模式

---

## 三、工具集成类 Skills

### 3.1 GitHub CLI

#### 功能
- 管理 Issues
- 管理 PR
- CI/CD 操作
- API 高级查询

#### 核心命令
```bash
# PR 操作
gh pr create                    # 创建 PR
gh pr view                     # 查看当前 PR
gh pr checks                   # 检查 CI 状态
gh pr merge                    # 合并 PR

# Issue 操作
gh issue list                  # 列出 Issues
gh issue create                # 创建 Issue
gh issue view <number>        # 查看 Issue

# CI/CD
gh run list                    # 查看 Actions 运行
gh run view <id> --log-failed # 查看失败日志

# 高级查询
gh api repos/owner/repo/pulls  # GraphQL 查询
```

#### 最佳实践
- 始终指定 `--repo owner/repo`
- 使用 `--json` 获取结构化输出
- 结合 `gh api --jq` 过滤字段

---

### 3.2 Playwright CLI (浏览器自动化)

#### 功能
- 无头浏览器控制
- 页面交互
- 截图和 PDF

#### 核心命令
```bash
# 页面操作
playwright-cli open <url>      # 打开页面
playwright-cli click <ref>     # 点击元素
playwright-cli type <text>     # 输入文本
playwright-cli snapshot        # 获取元素引用

# 导航
playwright-cli go-back         # 后退
playwright-cli go-forward      # 前进
playwright-cli reload         # 刷新

# 输出
playwright-cli screenshot     # 截图
playwright-cli pdf           # 导出 PDF

# Tab 管理
playwright-cli tab-new        # 新标签
playwright-cli tab-select <n> # 切换标签
```

#### 最佳实践
- 使用 `--session` 隔离会话
- 先 `snapshot` 获取元素引用
- 开发模式用 `--headed` 可视化调试

---

### 3.3 Tmux (终端会话)

#### 功能
- 远程控制 tmux 会话
- 发送按键
- 捕获输出

#### 核心命令
```bash
# 列表和捕获
tmux list-sessions           # 列出会话
tmux capture-pane -t <name> -p  # 捕获输出

# 发送输入
tmux send-keys -t <name> "text" Enter  # 发送命令

# 会话管理
tmux new-session -d -s <name>  # 创建会话
tmux kill-session -t <name>    # 销毁会话
```

#### 最佳实践
- 交互式应用分步发送（文本 + Enter 分离）
- 使用命名会话如 `shared`、`worker-2`
- 长输出用 `capture-pane -S -` 获取全部历史

---

### 3.4 Exa Web Search (AI 搜索)

#### 功能
- 神经网络搜索
- 代码搜索
- 公司研究

#### 工具
```bash
# 网页搜索
mcporter call 'exa.web_search_exa(query: "最新 AI 新闻", numResults: 5)'

# 代码搜索
mcporter call 'exa.get_code_context_exa(query: "React hooks 示例", tokensNum: 3000)'

# 公司研究
mcporter call 'exa.company_research_exa(companyName: "Anthropic", numResults: 3)'
```

#### 最佳实践
- 快速查询用 `type: "fast"`
- 深度研究用 `type: "deep"`
- 代码搜索降低 `tokensNum` 保持聚焦

---

## 四、安全质量类 Skills

### 4.1 Skill-Vetter (安全审核)

#### 功能
- 安装前审核 Skill 安全性
- 检查权限范围
- 识别可疑模式

#### 审核流程

**Step 1: 来源检查**
```
□ 来源是否可信？
□ 作者是否知名？
□ 下载量/星标？
□ 最近更新时间？
```

**Step 2: 代码审查 (必须)**
```
🚨 立即拒绝如果发现：
• curl/wget 到未知 URL
• 发送数据到外部服务器
• 请求凭据/密钥
• 读取 ~/.ssh、~/.aws
• 使用 eval/exec
• 混淆代码
```

**Step 3: 权限评估**
```
□ 需要读写哪些文件？
□ 需要网络访问吗？
□ 需要执行哪些命令？
```

#### 风险等级
| 等级 | 说明 | 操作 |
|------|------|------|
| 🟢 LOW | 笔记、天气 | 直接安装 |
| 🟡 MEDIUM | 文件操作、浏览器 | 完整代码审查 |
| 🔴 HIGH | 凭据、交易 | 需人工批准 |
| ⛔ EXTREME | 安全配置 | 拒绝安装 |

---

### 4.2 Draft-Release (版本发布)

#### 功能
- 自动版本号递增
- 生成 CHANGELOG.md
- 创建发布 PR

#### 工作流程
```bash
# 1. 确定版本号
git tag --sort=-version:refname | head -1

# 2. 创建发布分支
git checkout -b release/v1.2.0

# 3. 生成 CHANGELOG
# (根据 conventional commits 分类)

# 4. 创建 PR
gh pr create --title "Release v1.2.0"
```

#### CHANGELOG 格式
```markdown
## [1.2.0] - 2026-03-21

### Added
- 新功能描述 ([#123](link))

### Fixed
- Bug 修复描述 ([#456](link))

### Security
- 安全更新 ([#789](link))
```

#### 最佳实践
- 使用 conventional commits
- 跳过依赖更新和 CI 提交
- 合并后自动触发发布

---

## 五、使用场景矩阵

| 任务 | 推荐 Skill | 触发词 |
|------|------------|--------|
| 创建 PPT | `pptx` | "创建年度汇报 PPT" |
| 处理 PDF | `pdf` | "合并这三个 PDF" |
| 总结内容 | `summarize` | "总结这个链接" |
| 查询天气 | `weather` | "北京明天天气" |
| 代码审查 | `refactor-review` | "审查这段代码" |
| 重构代码 | `refactor-review` | "找重构机会" |
| 找 bug | `refactor-review` | "bug hunt" |
| 写测试 | `discover-testing` | "为函数写单元测试" |
| GitHub 操作 | `github` | "查看我的 PR" |
| 浏览器测试 | `playwright-cli` | "测试登录流程" |
| 终端会话 | `tmux` | "查看后台任务" |
| 网络搜索 | `exa-web-search` | "搜索 Laravel 新特性" |
| 安装技能 | `find-skills` | "找 PDF 技能" |
| 审核技能 | `skill-vetter` | "检查这个 Skill" |
| 创建技能 | `skill-creator` | "封装工作流" |
| 写文档 | `agent-docs` | "生成 API 文档" |
| 发布版本 | `draft-release` | "发布 v1.0" |

---

## 六、快速参考

### 安装新技能
```bash
# 注册
npx -y @lobehub/market-cli register --name "你的名字" --source opencode

# 安装
npx -y @lobehub/market-cli skills install <identifier> --global

# 查看已安装
ls ~/.agents/skills/
```

### 常用命令速查
```bash
# 搜索技能
npx -y @lobehub/market-cli skills search --q "关键词"

# 评分
npx -y @lobehub/market-cli skills rate <identifier> --score 5
```

---

## 更新日志

| 日期 | 操作 |
|------|------|
| 2026-03-21 | 初始安装 15 个 Skills |

---

*文档位置: `/home/jieqiang/tmp/www/docs/`*
