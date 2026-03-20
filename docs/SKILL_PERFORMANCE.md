# Skill 性能优化分析文档

> 分析 daily-motivation skill 响应慢的原因及最佳实践

## 问题描述

调用 `/skills daily-motivation` 命令时，响应时间超过 10 秒。

## 原因分析

### 1. Skill 加载机制

OpenCode 的 skill 系统采用**渐进式披露**架构：

```
┌─────────────────────────────────────────────────────┐
│ Level 1: 元数据 (name + description)                │
│         - 始终加载到上下文 (~100 words)              │
├─────────────────────────────────────────────────────┤
│ Level 2: SKILL.md 正文                              │
│         - skill 触发后才加载 (<5k words)             │
├─────────────────────────────────────────────────────┤
│ Level 3: Bundled Resources (scripts/references)     │
│         - 按需加载 (可直接执行)                       │
└─────────────────────────────────────────────────────┘
```

### 2. 响应慢的根本原因

#### 原因 1：Skill 路径不在默认搜索路径

当前 skill 位置：`/home/jieqiang/tmp/www/daily-motivation/`

OpenCode 默认搜索路径：
- `~/.opencode/skills` (全局)
- `./.opencode/skills` (项目级)

项目根目录的 skill 可能需要额外扫描，导致延迟。

#### 原因 2：Skill 描述过于宽泛

当前 description：
```
Provides inspirational quotes in both Chinese and English. 
Use when user wants motivation, encouragement, a positive message, 
or asks for quotes, inspirational words, or daily motivation.
```

关键词太多，容易触发其他判断逻辑。

#### 原因 3：Skill 缺少优化配置

- 没有使用 `scripts/` 直接执行
- 所有逻辑都在 SKILL.md 中，需要完整解析
- 没有利用缓存机制

#### 原因 4：上下文窗口开销

每次 skill 调用都需要：
1. 扫描 skill 目录
2. 加载 YAML frontmatter
3. 匹配触发条件
4. 加载完整 SKILL.md
5. 执行 skill 逻辑

## 解决方案

### 方案 1：使用 scripts/ 目录 (推荐)

将激励语句放到 scripts/ 中，直接执行，避免加载完整文档：

```
daily-motivation/
├── SKILL.md
└── scripts/
    └── quotes.json          # 静态数据，直接读取
```

### 方案 2：优化触发描述

精确化 description，减少误匹配：

```yaml
---
name: daily-motivation
description: Provides random motivational quotes in Chinese and English. 
            Use ONLY when user explicitly requests inspirational quotes, 
            daily motivation, or encouragement.
---
```

### 方案 3：使用引用文件 (references/)

将静态数据分离：

```
daily-motivation/
├── SKILL.md
└── references/
    └── quotes.md           # quotes 列表
```

### 方案 4：移动到正确路径

将 skill 移动到默认路径：

```bash
# 方案 A: 项目级
mkdir -p .opencode/skills
mv daily-motivation .opencode/skills/

# 方案 B: 全局 (需要配置)
# 移动到 ~/.opencode/skills/
```

## 最佳实践

### 1. Skill 设计原则

| 原则 | 说明 | 适用场景 |
|------|------|----------|
| 静态数据外置 | 将数据放到 references/ 或 scripts/ | 数据量大、频繁读取 |
| 描述精确化 | 减少触发关键词 | 避免误触发 |
| 扁平化结构 | 避免深层嵌套目录 | 加快目录扫描 |
| 使用 scripts/ | 直接执行脚本 | 需要确定性输出 |

### 2. 性能优化 Checklist

- [ ] Skill 放在 `.opencode/skills/` 或 `~/.opencode/skills/`
- [ ] description 精确，避免宽泛关键词
- [ ] 静态数据使用 JSON/YAML 文件而非文档
- [ ] 复杂逻辑使用 scripts/ 而非 SKILL.md
- [ ] 避免在 SKILL.md 中包含大量示例

### 3. Skill 结构推荐

**轻量级 Skill (推荐)**:
```
my-skill/
├── SKILL.md              # < 100 lines
└── references/
    └── data.json         # 静态数据
```

**重量级 Skill**:
```
my-skill/
├── SKILL.md
└── scripts/
    └── execute.py        # 可执行脚本
```

### 4. 响应时间对比

| 方案 | 预估延迟 |
|------|----------|
| 当前 (SKILL.md 内联) | 10s+ |
| 优化后 (scripts/ + 路径修正) | < 1s |

## 实施建议

1. **立即修复**: 移动 skill 到 `.opencode/skills/`
2. **短期优化**: 将 quotes 移到 references/quotes.json
3. **长期改进**: 建立 skill 性能基准测试

## 参考资料

- OpenCode Skills 文档: `docs/OPENCODE_SKILLS.md`
- Skill 创建指南: `docs/SKILLS_GUIDE.md`
- Agent Skills 开放标准: https://github.com/anomalyco/opencode