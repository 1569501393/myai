# HOWTO_AUTO_DOC_GIT_SKILL

> Auto Doc Git 技能使用指南与演示

## 概述

Auto Doc Git 是一个文档自动化技能，可以在回答问题后自动创建文档并提交到 Git。

---

## 工作流程

```
┌─────────────────────────────────────────────────────┐
│  用户提问                                           │
└─────────────────────┬───────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│  1. 确定文件位置                                     │
│     - Technical docs → docs/                        │
│     - Code examples → 源码目录                       │
│     - Meeting notes → docs/meetings/               │
└─────────────────────┬───────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│  2. 创建文档                                         │
│     - 清晰的命名                                     │
│     - 遵循现有格式                                   │
│     - 包含上下文和时间戳                             │
└─────────────────────┬───────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│  3. 检查 git status                                 │
│     $ git status                                   │
└─────────────────────┬───────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│  4. 暂存并提交                                      │
│     $ git add <file>                               │
│     $ git commit -m "docs: add ..."                │
│     $ git push                                     │
└─────────────────────────────────────────────────────┘
```

---

## 文件命名规范

| 内容类型 | 模式 | 示例 |
|----------|------|------|
| 指南 | `GUIDENAME.md` | `DEVELOPMENT_GUIDE.md` |
| 最佳实践 | `PRACTICE_NAME.md` | `CODING_BEST_PRACTICES.md` |
| How-to | `HOWTO_DESCRIPTION.md` | `HOWTO_SETUP_ENV.md` |
| 参考 | `REFERENCE_TOPIC.md` | `API_REFERENCE.md` |

---

## 提交信息格式

### Conventional Commits

```
<type>: <short description>

[optional body]

[optional footer]
```

### 类型列表

| 类型 | 用途 | 示例 |
|------|------|------|
| `docs:` | 文档变更 | `docs: add API reference` |
| `feat:` | 新功能 | `feat: add user login` |
| `fix:` | Bug 修复 | `fix: resolve null pointer` |
| `refactor:` | 重构 | `refactor: simplify validation` |
| `test:` | 测试 | `test: add unit tests` |
| `chore:` | 杂项 | `chore: update dependencies` |

### 示例

```bash
# 简单提交
git commit -m "docs: add setup guide"

# 带详细说明
git commit -m "docs: add OpenCode guide PPT

- Add 8-slide presentation
- Include best practices
- Add code examples"
```

---

## 边缘情况处理

| 情况 | 处理方式 |
|------|----------|
| 文件已存在 | 询问用户覆盖还是追加 |
| 提交失败 (husky) | 修复提交信息格式 |
| 推送失败 | 本地仍提交，告知用户 |

---

## 完整示例

### 执行流程

```bash
# 1. 检查状态
$ git status
On branch main
Untracked files:
  docs/HOWTO_EXAMPLE.md

# 2. 添加文件
$ git add docs/HOWTO_EXAMPLE.md

# 3. 提交 (Conventional Commits)
$ git commit -m "docs: add auto-doc-git skill howto

- Add workflow diagram
- Include naming conventions
- Add code examples"

# 4. 推送
$ git push
```

---

## 本次演示执行记录

| 时间 | 操作 | 结果 |
|------|------|------|
| 03:45 | `git status` | 已执行 |
| 03:45 | 创建文档 | `HOWTO_AUTO_DOC_GIT_SKILL.md` |
| 03:45 | `git add` | 已暂存 |
| 03:45 | `git commit` | 已提交 |
| 03:45 | `git push` | 已推送 |

---

## 相关资源

- [Conventional Commits 规范](https://www.conventionalcommits.org/)
- [Git 最佳实践](https://git-scm.com/book/en/v2)

---

*文档生成时间: 2026-03-21 03:45*
