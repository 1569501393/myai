# Linux 终端快捷键完全指南

> 提升命令行效率的必备技能

## 概述

掌握终端快捷键是 Linux 入门的基础，可以显著提升命令行操作效率。

---

## 光标移动

| 快捷键 | 功能 | 英文说明 |
|--------|------|----------|
| `Ctrl + A` | 光标到**行首** | Beginning of line |
| `Ctrl + E` | 光标到**行尾** | End of line |
| `Alt + B` | 光标后退**一个单词** | Back word |
| `Alt + F` | 光标前进**一个单词** | Forward word |
| `Ctrl + ←` | 后退一个单词 | (部分终端) |
| `Ctrl + →` | 前进一个单词 | (部分终端) |
| `Ctrl + XX` | 光标与行首切换 | Toggle cursor position |

---

## 字符删除

| 快捷键 | 功能 | 删除范围 |
|--------|------|----------|
| `Ctrl + D` | 删除**后一个**字符 | 光标后的 1 个字符 |
| `Backspace` | 删除**前一个**字符 | 光标前的 1 个字符 |
| `Delete` | 删除**后一个**字符 | 光标后的 1 个字符 |

---

## 单词删除

| 快捷键 | 功能 | 删除范围 |
|--------|------|----------|
| `Ctrl + W` | 删除**前一个单词** | 光标前到上一空格 |
| `Alt + D` | 删除**后一个单词** | 光标后到下一空格 |
| `Ctrl + U` | 删除**光标前**所有字符 | 行首到光标前 |
| `Ctrl + K` | 删除**光标后**所有字符 | 光标后到行尾 |
| `Ctrl + Y` | 粘贴刚才删除的内容 | Yank (粘贴) |

---

## 命令控制

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Ctrl + C` | **取消**当前命令 | 发送 SIGINT |
| `Ctrl + Z` | **暂停**当前命令 | 发送 SIGTSTP |
| `Ctrl + S` | **停止**输出到屏幕 | (XOFF) |
| `Ctrl + Q` | **恢复**输出到屏幕 | (XON) |
| `Ctrl + D` | 退出当前 Shell | EOF |
| `Ctrl + \` | 强制退出 | SIGQUIT |

---

## 搜索与补全

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Tab` | 自动补全 | 补全命令/文件/参数 |
| `Tab + Tab` | 显示所有可能选项 | 两次 Tab |
| `Ctrl + R` | **反向**搜索历史 | Reverse search |
| `Ctrl + G` | 退出搜索模式 | Cancel search |
| `Ctrl + P` | 上一个历史命令 | Previous |
| `Ctrl + N` | 下一个历史命令 | Next |
| `Alt + .` | 插入上一个命令的最后一个参数 | |

---

## 屏幕操作

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + L` | 清屏 (clear) |
| `Ctrl + S` | 暂停输出 |
| `Ctrl + Q` | 恢复输出 |
| `Shift + PgUp` | 向上滚动 |
| `Shift + PgDn` | 向下滚动 |

---

## Shell 特定

### Bash 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + X Ctrl + E` | 用编辑器编辑命令 |
| `Alt + .` | 插入上一个参数 |
| `Alt + #` | 注释当前行 |
| `Ctrl + _` | 撤销 |

### Zsh 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + X Ctrl + E` | 用编辑器编辑命令 |
| `Alt + Q` | 清除当前行 |
| `Ctrl + A` | 光标到行首 |
| `Ctrl + E` | 光标到行尾 |

---

## Vim 模式 (set -o vi)

| 快捷键 | 功能 |
|--------|------|
| `Esc` | 进入 Normal 模式 |
| `i` | 进入插入模式 |
| `v` | 进入可视模式 |
| `w` | 后跳一个单词 |
| `b` | 前跳一个单词 |
| `0` | 行首 |
| `$` | 行尾 |
| `dd` | 删除整行 |
| `yy` | 复制整行 |
| `p` | 粘贴 |

---

## tmux 快捷键

| 前缀 | 快捷键 | 功能 |
|------|--------|------|
| `Ctrl + B` | `d` | 分离会话 |
| `Ctrl + B` | `c` | 创建新窗口 |
| `Ctrl + B` | `%` | 左右分屏 |
| `Ctrl + B` | `"` | 上下分屏 |
| `Ctrl + B` | `方向键` | 切换面板 |
| `Ctrl + B` | `z` | 全屏切换 |
| `Ctrl + B` | `t` | 显示时间 |

---

## 最佳实践

### 1. 常用组合记忆

```
# 删除操作 (最常用)
Ctrl + U  ← 删除光标前所有 (整行重打)
Ctrl + K  ← 删除光标后所有
Ctrl + W  ← 删除前一个单词 (修正拼写错误)
Ctrl + Y  ← 粘贴刚删除的内容

# 光标移动 (最常用)
Ctrl + A  ← 行首
Ctrl + E  ← 行尾
Alt + B   ← 后退单词
Alt + F   ← 前进单词

# 命令操作
Ctrl + C  ← 取消 (永远的第一选择)
Ctrl + Z  ← 暂停 (需要后台处理时)
Ctrl + D  ← 退出 Shell
```

### 2. 效率提升技巧

| 技巧 | 示例 |
|------|------|
| **快速清行重打** | `Ctrl + U` 删除整行，重新输入 |
| **删除单词修正** | `Ctrl + W` 删除拼错的单词，重新输入 |
| **恢复删除** | `Ctrl + Y` 粘贴误删的内容 |
| **快速历史搜索** | `Ctrl + R` 输入关键词搜索 |
| **快速参数复用** | `Alt + .` 插入上一命令的参数 |

### 3. 肌肉记忆练习

```
Day 1: Ctrl+U, Ctrl+K, Ctrl+W
Day 2: Ctrl+A, Ctrl+E, Alt+B, Alt+F
Day 3: Ctrl+C, Ctrl+R
Day 4: Ctrl+L, Ctrl+Z
Day 5: 综合练习
```

### 4. 场景应用

```bash
# 场景 1: 拼写错误
echo "Hello Wolrd"     # 拼写错误
Ctrl+W                 # 删除 "Wolrd"
ld                     # 重新输入正确
World                  # 完成修正

# 场景 2: 整行重打
ls -la /very/long/path/that/is/wrong  # 路径错误
Ctrl+U                 # 删除整行
ls -la /correct/path   # 重新输入

# 场景 3: 恢复误删
rm -rf important_file      # 误删
Ctrl+Y                     # 恢复
# 等等，这不是正确的做法！先 Ctrl+C 取消！

# 场景 4: 复用参数
mkdir /path/to/project
cd Ctrl+U /path/to/project  # 快速 cd

# 场景 5: 历史搜索
Ctrl+R                    # 进入搜索模式
git                       # 输入关键词
# 显示之前的 git 命令，按 Enter 执行
```

### 5. 注意事项

| 场景 | 建议 |
|------|------|
| `Ctrl + C` vs `Ctrl + Z` | 取消 vs 暂停 |
| `Ctrl + D` vs `Ctrl + C` | 退出 Shell vs 取消命令 |
| `rm` 操作 | 使用 `Ctrl + C` 取消，不要用 `Ctrl + Z` |
| 远程连接 | 终端快捷键可能因终端软件不同而异 |

---

## 快捷键速查表

### 必背 (10 个)

```
Ctrl + A  ← 光标到行首
Ctrl + E  ← 光标到行尾
Ctrl + U  ← 删除光标前所有
Ctrl + K  ← 删除光标后所有
Ctrl + W  ← 删除前一个单词
Ctrl + C  ← 取消命令
Ctrl + Z  ← 暂停命令
Ctrl + L  ← 清屏
Ctrl + R  ← 搜索历史
Tab       ← 自动补全
```

### 进阶 (5 个)

```
Alt + B   ← 后退单词
Alt + F   ← 前进单词
Ctrl + Y  ← 粘贴删除内容
Ctrl + D  ← 退出 Shell
Ctrl + P  ← 上一历史
```

---

## 常见问题

### Q: Ctrl+D 和 Delete 键的区别？

| 键 | 位置 | 删除内容 |
|----|------|----------|
| `Ctrl + D` | 控制字符 | 光标后的 1 个字符 |
| `Delete` | 编辑键 | 光标后的 1 个字符 |
| `Backspace` | 编辑键 | 光标前的 1 个字符 |

### Q: Ctrl+C 无法取消命令？

某些长时间运行的命令可能忽略 SIGINT，尝试：
- `Ctrl + \` 发送 SIGQUIT（强制退出）
- `kill -9 PID` 从另一个终端杀死进程

### Q: Ctrl+Z 后如何恢复？

```bash
# 查看后台任务
jobs

# 恢复到前台
fg

# 恢复到后台
bg

# 或者
fg %1  # 任务编号
```

---

## 参考资源

- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
- [Readline Keyboard Shortcuts](https://readline.kablamo.org/emacs/)

---

## 更新日志

| 日期 | 版本 | 更新内容 |
|------|------|----------|
| 2026-03-21 | 1.0 | 初始版本 |
