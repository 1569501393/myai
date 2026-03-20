# Linux Learning Skill Package

> 技能包索引文档

## 概述

本技能包帮助用户系统学习 Linux 命令行和系统管理。

## 包含文件

| 文件 | 说明 |
|------|------|
| `SKILL.md` | 技能配置文件（位于 `~/.opencode/skills/linux-learning/`） |
| `LINUX_GUIDE.md` | 完整的 Linux 学习指南 |

## 快速开始

### 1. 安装技能

```bash
# 技能已安装在
~/.opencode/skills/linux-learning/SKILL.md
```

### 2. 学习路线

```
入门 → 进阶 → 高级 → 专家
```

### 3. 常用命令速查

```bash
# 文件操作
ls -lah /path
cd ~ && pwd
mkdir -p dir/subdir
cp -r source/ dest/
rm -rf directory/

# 文本处理
grep -r "pattern" /path
awk -F',' '{print $1}' file.csv
sed -i 's/old/new/g' file.txt

# 权限管理
chmod 755 script.sh
chown user:group file.txt

# 进程管理
ps aux | grep process
top
kill -9 PID

# 网络
curl https://example.com
ssh user@host
netstat -tuln
```

## 文档目录

### LINUX_GUIDE.md 内容索引

1. **概述** - Linux 简介和学习理由
2. **基础知识** - 终端、Shell、目录结构、快捷键
3. **文件操作** - ls, cd, cp, mv, rm, mkdir, find
4. **文本处理** - grep, awk, sed, wc, sort, uniq
5. **权限管理** - chmod, chown, sudo
6. **进程管理** - ps, top, kill, bg, fg
7. **网络工具** - curl, wget, ssh, netstat, ping
8. **磁盘管理** - df, du, mount, tar, gzip
9. **Shell 脚本** - 变量、条件、循环、函数
10. **实践练习** - 初中高级练习题

## 学习建议

### 每日练习

```bash
# Day 1: 文件操作
ls, cd, pwd, mkdir, cp, mv, rm

# Day 2: 文本处理
cat, grep, awk, sed, wc

# Day 3: 权限与用户
chmod, chown, sudo, useradd

# Day 4: 进程管理
ps, top, kill, bg, fg, nohup

# Day 5: 网络工具
curl, wget, ssh, scp, netstat

# Day 6: 磁盘管理
df, du, mount, tar, gzip

# Day 7: Shell 脚本
变量, if, for, while, 函数
```

### 实践项目

1. **自动化备份脚本** - 使用 tar + cron
2. **日志分析工具** - grep + awk + sed
3. **系统监控脚本** - ps + df + free
4. **批量文件处理** - for + rename

## 相关资源

- 技能配置: `~/.opencode/skills/linux-learning/SKILL.md`
- 学习指南: `docs/linux-learning/LINUX_GUIDE.md`

---

*创建时间: 2026-03-21*
