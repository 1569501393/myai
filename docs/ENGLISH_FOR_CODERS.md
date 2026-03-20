# 强迫自己只用英文：为中国程序员写的实用指南

> 为什么我们需要在代码和文档中只用英文，以及如何做到。

---

## 目录

1. [为什么要用英文](#1-为什么要用英文)
2. [常见误区](#2-常见误区)
3. [实用策略](#3-实用策略)
4. [场景应对指南](#4-场景应对指南)
5. [工具辅助](#5-工具辅助)
6. [心理建设](#6-心理建设)
7. [检查清单](#7-检查清单)

---

## 1. 为什么要用英文

### 1.1 技术领域的现实

```
全球开发者分布 (2026)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
英文文档/社区     ████████████████████ 85%
中文资源         ███ 5%
日文/韩文/其他   ██ 2%
其他             █ 8%
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**事实：**
- Stack Overflow、GitHub、Reddit 的主流语言是英文
- 90%+ 的优质技术博客和文档是英文
- 几乎所有开源项目的 issue/PR 使用英文
- 最新的技术文档往往是英文首发

### 1.2 职业发展

| 好处 | 说明 |
|------|------|
| **全球机会** | 更容易参与国际项目，获得海外工作机会 |
| **技术深度** | 直接阅读一手文档，不依赖二手翻译 |
| **社区参与** | 能向开源项目提 PR/issue |
| **代码可读** | 代码被全球开发者理解 |
| **团队协作** | 与外国同事无障碍沟通 |

### 1.3 代码中的例子

```php
// ❌ 中文变量名 - 难以在国际化团队协作
$学生列表 = Student::where('状态', '激活')->get();
$订单总额 = calculate订单金额($订单);

// ✅ 英文变量名 - 清晰且通用
$activeStudents = Student::where('status', 'active')->get();
$orderTotal = calculateOrderAmount($order);
```

---

## 2. 常见误区

### 2.1 "我英文不好，写不来"

**真相：** 你不需要完美的英文。

```php
// 即使简单的单词也足够
$userList = [];           // 比 $用户列表 好
$isValid = true;          // 比 $是否有效 好
$totalCount = 0;          // 比 $总数 好

// 技术术语直接用，程序员都懂
$callback = function() {};
$async = true;
$middleware = [];
```

### 2.2 "中文注释更清楚"

**误区：** 短期清楚，长期有害。

```php
// ❌ 中文注释 - 翻译工具无法处理
// 遍历用户列表，找到年龄大于18岁的
foreach ($users as $user) {
    if ($user->年龄 > 18) {
        // 添加到结果数组
        $result[] = $user;
    }
}

// ✅ 英文注释 + 清晰代码
foreach ($users as $user) {
    if ($user->age > 18) {
        $result[] = $user;
    }
}
```

### 2.3 "团队都是中国人，英文没必要"

**问题：** 代码终将开源或被出售、招聘时会遇到英文代码。

---

## 3. 实用策略

### 3.1 从变量命名开始

**规则：变量名 = 名词或形容词 + 名词**

```
# 格式：[形容词+]名词
good_variable_name = value

# 不好的例子
好 = true
是否 = false
结果 = []

# 好的例子
isValid = true
hasPermission = false
result = []
userList = []
totalCount = 0
```

**常用命名模式：**

| 场景 | 英文命名 |
|------|----------|
| 布尔值 | `isXxx`, `hasXxx`, `canXxx` |
| 列表/复数 | `users`, `items`, `orders` |
| 单个对象 | `user`, `item`, `order` |
| 计数 | `count`, `total`, `number` |
| 状态 | `status`, `state` |
| 获取方法 | `getXxx()`, `fetchXxx()` |
| 判断方法 | `isXxx()`, `hasXxx()`, `canXxx()` |

### 3.2 函数命名

**规则：函数名 = 动词 + 名词**

```php
// CRUD 操作
function createUser($data) {}
function getUserById($id) {}
function updateUser($id, $data) {}
function deleteUser($id) {}

// 查询操作
function findActiveUsers() {}
function searchByKeyword($keyword) {}
function filterByStatus($status) {}

// 布尔判断
function isAdmin($user) {}
function hasPermission($user, $permission) {}
function canAccess($user, $resource) {}

// 动作
function sendEmail($to, $subject) {}
function calculateTotal($items) {}
function formatDate($date) {}
```

### 3.3 注释书写

**规则：简洁、描述意图而非实现**

```php
// ❌ 冗长解释
// 这个函数用于遍历传入的用户数组
// 然后对每个用户检查年龄是否大于18岁
// 如果大于18岁就加入结果数组并返回
function filterAdults($users) {
    $result = [];
    foreach ($users as $user) {
        if ($user->age > 18) {
            $result[] = $user;
        }
    }
    return $result;
}

// ✅ 简短意图描述
// Filter users who are 18 or older
function filterAdults($users) {
    return array_filter($users, fn($user) => $user->age >= 18);
}
```

### 3.4 Git 提交信息

**规则：type: 简短描述**

```
feat: add user registration with email verification
fix: resolve pagination issue in user list
refactor: extract validation logic to service class
docs: update API documentation
test: add unit tests for order calculation
style: apply PSR-12 formatting
chore: update dependencies
```

**常用 type：**

| type | 用途 |
|------|------|
| `feat` | 新功能 |
| `fix` | Bug 修复 |
| `refactor` | 重构（无功能变化） |
| `docs` | 文档更新 |
| `test` | 测试相关 |
| `style` | 格式调整 |
| `chore` | 构建/工具变更 |
| `perf` | 性能优化 |

### 3.5 数据库表名和字段

**规则：snake_case 复数形式**

```sql
-- ❌
用户表 (id, 用户名, 密码, 创建时间)
订单表 (id, 订单号, 总金额, 客户ID)

-- ✅
users (id, username, password, created_at)
orders (id, order_no, total_amount, customer_id)
```

---

## 4. 场景应对指南

### 4.1 遇到不会翻译的词怎么办

```
策略：
1. 直接用拼音（仅限于专有名词）
2. 翻译成英文，即使不完美
3. 查词典或翻译工具
4. 参考开源项目的命名
```

```php
// 专有名词 - 可以用拼音
$waimaiOrder = getWaimaiOrder();  // 外卖订单
$laidianOrder = getLaidianOrder(); // 来电订单

// 通用概念 - 必须翻译
$orderType = 'waimai';  // 订单类型
$priority = 'high';      // 优先级
```

### 4.2 需要向同事解释怎么办

```
原则：代码用英文，口头交流随意

// 代码
function processOrder($order) {}

// 口头：可以说"处理订单"没问题
```

### 4.3 文档写作

**从简单文档开始：**

```markdown
<!-- ❌ -->
# 用户模块设计文档

## 1. 需求分析
本模块主要用于管理用户信息...

<!-- ✅ -->
# User Module

## Overview
Manage user registration, authentication, and profile.
```

### 4.4 写英文的勇气

```
"烂英文 > 没英文"

你的英文不需要完美。试试：
- 用简单的单词
- 短句
- 代码和上下文帮你表达意思
```

---

## 5. 工具辅助

### 5.1 翻译工具

| 工具 | 用途 |
|------|------|
| DeepL | 翻译变量名和注释 |
| Grammarly | 检查拼写和语法 |
| Google Translate | 快速翻译 |

### 5.2 IDE 插件

```json
// VS Code 推荐插件
{
  "recommendations": [
    "ESLint",           // 代码规范
    "Code Spell Checker", // 拼写检查
    "Chinese Input Helper" // 中文转拼音（慎用）
  ]
}
```

### 5.3 代码规范检查

```bash
# PHP
./vendor/bin/pint --test  # 检查格式
./vendor/bin/phpcs --standard=PSR12 app/  # 检查规范

# ESLint (JS/TS)
npm run lint

# Ruff (Python)
ruff check .
```

---

## 6. 心理建设

### 6.1 接受不完美

```
你不需要：
✅ 完美的语法
✅ 复杂的词汇
✅ 地道的表达

你只需要：
✅ 简单的英文
✅ 清晰的意图
✅ 一致性
```

### 6.2 循序渐进

```
阶段一（1-2周）：变量名用英文，注释中英混合
阶段二（1个月）：注释完全英文，Git message 英文
阶段三（3个月）：文档、issue、PR 完全英文
```

### 6.3 建立信心

```
每天尝试：
- 1 个英文变量名
- 1 条英文 Git message
- 1 句英文注释

累积就是进步！
```

---

## 7. 检查清单

### 代码审查

```
□ 变量名是否用英文？
□ 函数名是否用英文动词开头？
□ 注释是否用英文描述意图？
□ Git commit message 是否英文？
□ 数据库字段名是否英文？
□ API endpoint 是否英文？
```

### 项目初始化

```
□ README 用英文写
□ 目录结构用英文命名
□ 配置文件用英文 key
□ 环境变量名用英文
```

### 开源贡献

```
□ Issue 用英文写
□ PR description 英文
□ Code review 回复英文
□ 如果英文实在不行，用中英双语
```

---

## 常用英文对照表

### 中文 → 英文

| 中文 | 英文 | 场景 |
|------|------|------|
| 用户 | user | 变量名 |
| 列表 | list / items | 数组 |
| 创建 | create | 函数名 |
| 更新 | update | 函数名 |
| 删除 | delete / remove | 函数名 |
| 获取 | get / fetch | 函数名 |
| 检查 | check / validate | 函数名 |
| 是否 | is / has / can | 布尔变量 |
| 状态 | status / state | 字段名 |
| 金额 | amount / total | 字段名 |
| 时间 | time / date / at | 字段名 |
| 启用/禁用 | enable/disable | 函数名 |
| 成功/失败 | success/failure | 返回值 |
| 激活/未激活 | active/inactive | 状态值 |

### 状态值

| 中文 | 英文 | 
|------|------|
| 待处理 | pending |
| 处理中 | processing |
| 已完成 | completed |
| 已取消 | cancelled |
| 已删除 | deleted |
| 激活 | active |
| 未激活 | inactive |
| 禁用 | disabled |

---

## 行动指南

```
从今天开始：

1. 将所有新变量改成英文
2. Git message 开始用英文
3. 注释开始用英文
4. 遇到不会的词就查词典
5. 每周review一次自己的代码

30天后，你会习惯的。
```

---

*English is not about perfection, it's about communication.*
