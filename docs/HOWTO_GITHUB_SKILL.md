# GitHub Skill 使用指南

> 基于 gh CLI 和 GitHub API 的 GitHub 操作指南

## 概述

GitHub Skill 提供了一套使用 `gh` CLI 和 GitHub API 与 GitHub 交互的方法。

---

## 仓库信息

| 字段 | 值 |
|------|-----|
| **仓库名** | myai |
| **描述** | 我的人工智能 |
| ** Stars** | 0 |
| ** Forks** | 0 |
| ** Issues** | 0 |

---

## Pull Requests 操作

### 查看 PR CI 状态

```bash
# 检查 PR #55 的 CI 状态
gh pr checks 55 --repo owner/repo
```

### 查看 Workflow Runs

```bash
# 列出最近 10 个 workflow
gh run list --repo owner/repo --limit 10

# 查看具体 run 及失败步骤
gh run view <run-id> --repo owner/repo

# 只看失败步骤的日志
gh run view <run-id> --repo owner/repo --log-failed
```

---

## API 高级查询

### 获取 PR 特定字段

```bash
gh api repos/owner/repo/pulls/55 --jq '.title, .state, .user.login'
```

### JSON 输出过滤

```bash
# 列出 issue，格式化为 "number: title"
gh issue list --repo owner/repo --json number,title --jq '.[] | "\(.number): \(.title)"'
```

---

## GitHub API 直接调用

当 gh CLI 不可用时，可直接使用 API：

### 仓库信息

```bash
curl -s "https://api.github.com/repos/{owner}/{repo}"
```

### 最近提交

```bash
curl -s "https://api.github.com/repos/{owner}/{repo}/commits?per_page=5"
```

### 列出 Issues

```bash
curl -s "https://api.github.com/repos/{owner}/{repo}/issues?state=open"
```

---

## 常用操作速查

| 操作 | gh CLI | GitHub API |
|------|--------|------------|
| 查看仓库 | `gh repo view` | `curl /repos/{owner}/{repo}` |
| 列出 PRs | `gh pr list` | `curl /repos/{owner}/{repo}/pulls` |
| 创建 Issue | `gh issue create` | `POST /repos/{owner}/{repo}/issues` |
| 查看 Actions | `gh run list` | `curl /repos/{owner}/{repo}/actions/runs` |
| 查看提交 | `gh api /repos/{owner}/{repo}/commits` | `curl /repos/{owner}/{repo}/commits` |

---

## 本仓库最近提交

| SHA | 提交信息 |
|-----|----------|
| `84c671f` | docs: add auto-doc-git skill howto guide |
| `1c57b30` | docs: add OpenCode guide PPT and session documentation |
| `e2a5a93` | docs: add session 20260321 record with skills and best practices |
| `fef6c7c` | docs: 添加 OpenCode 使用指南：知识点与最佳实践 |
| `7e1bf06` | docs: 添加 OpenCode AI 助力 SAP ABAP 开发提效指南 |

---

## 工作流集成

### GitHub Actions 状态检查

```bash
# 查看最近运行的 workflow
gh run list --repo 1569501393/myai --limit 5
```

### PR 检查状态

```bash
# 检查所有 CI 检查
gh pr checks --repo 1569501393/myai

# 查看具体失败
gh run view <id> --repo 1569501393/myai --log-failed
```

---

## 最佳实践

1. **使用 `--repo`** 参数明确指定仓库
2. **使用 `--json`** 获取结构化输出
3. **使用 `--jq`** 过滤不需要的字段
4. **优先使用 gh CLI**，比直接调用 API 更安全
5. **设置默认仓库**: `gh repo set-default`

---

## 相关资源

- [GitHub CLI 文档](https://cli.github.com/manual/)
- [GitHub REST API](https://docs.github.com/en/rest)
- [GitHub Actions](https://docs.github.com/en/actions)

---

*文档生成时间: 2026-03-21 04:00*
