# Linux 学习指南

> 从零开始掌握 Linux 命令行

## 目录

1. [概述](#概述)
2. [基础知识](#基础知识)
3. [文件操作](#文件操作)
4. [文本处理](#文本处理)
5. [权限管理](#权限管理)
6. [进程管理](#进程管理)
7. [网络工具](#网络工具)
8. [磁盘管理](#磁盘管理)
9. [Shell 脚本](#shell-脚本)
10. [实践练习](#实践练习)

---

## 概述

Linux 是一种开源操作系统内核，广泛应用于服务器、嵌入式系统和桌面环境。掌握 Linux 命令行是开发者的核心技能。

### 为什么学习 Linux？

- **服务器**: 90%+ 的服务器运行 Linux
- **开发**: 大多数开发工具原生支持
- **云原生**: Docker、Kubernetes 基于 Linux
- **效率**: 命令行比 GUI 更高效

---

## 基础知识

### 终端与 Shell

```bash
# 打开终端
Ctrl + Alt + T

# 查看当前 shell
echo $SHELL
# 输出: /bin/bash

# 查看所有可用 shell
cat /etc/shells
```

### 基本概念

| 概念 | 说明 |
|------|------|
| **终端 (Terminal)** | 输入输出设备 |
| **Shell** | 命令解释器 (bash/zsh/fish) |
| **命令行** | 用户与系统交互的文本界面 |
| **路径** | 文件在文件系统中的位置 |

### 目录结构

```
/                   # 根目录
├── bin/            # 基础命令
├── boot/           # 启动文件
├── dev/            # 设备文件
├── etc/            # 配置文件
├── home/           # 用户目录
│   └── user/       # 用户名
├── root/           # 超级用户目录
├── tmp/            # 临时文件
├── usr/            # 用户程序
└── var/            # 变量数据
```

### 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + C` | 取消当前命令 |
| `Ctrl + Z` | 暂停当前命令 |
| `Ctrl + L` | 清屏 |
| `Ctrl + D` | 退出终端 |
| `Ctrl + A` | 光标到行首 |
| `Ctrl + E` | 光标到行尾 |
| `Tab` | 自动补全 |
| `↑/↓` | 历史命令 |

---

## 文件操作

### 基础命令

#### ls - 列出目录内容

```bash
# 基本用法
ls              # 列出当前目录
ls /path/to/dir # 列出指定目录

# 常用选项
ls -l            # 详细信息 (long format)
ls -a            # 显示隐藏文件 (all)
ls -h            # 人性化显示大小 (human)
ls -R            # 递归显示 (recursive)
ls -t            # 按时间排序 (time)
ls -S            # 按大小排序 (size)

# 组合使用
ls -lah          # 显示所有文件详细信息
ls -lt           # 按时间排序显示详情
```

#### cd - 切换目录

```bash
cd /path/to/dir    # 切换到指定目录
cd ~              # 切换到用户主目录
cd ..             # 切换到上级目录
cd -              # 切换到上一个目录
cd                # 等同于 cd ~
```

#### pwd - 显示当前目录

```bash
pwd               # 显示当前工作目录 (print working directory)
```

#### mkdir - 创建目录

```bash
mkdir dirname            # 创建单个目录
mkdir -p dir1/dir2/dir3 # 递归创建 (parents)
mkdir -m 755 dirname    # 指定权限 (mode)
```

#### rm - 删除

```bash
rm file.txt          # 删除文件
rm -r dir/           # 递归删除目录
rm -rf dir/          # 强制递归删除 (危险!)
rm -i file.txt       # 删除前确认 (interactive)
```

#### cp - 复制

```bash
cp source dest           # 复制文件
cp -r source_dir dest/   # 递归复制目录
cp -p file dest/         # 保留属性 (preserve)
cp -v file dest/         # 显示详情 (verbose)
```

#### mv - 移动/重命名

```bash
mv old_name new_name     # 重命名
mv file /path/to/dest/   # 移动文件
mv -i file dest/         # 覆盖前确认
mv -v file dest/         # 显示详情
```

### 文件查看

```bash
cat file.txt         # 查看文件内容
cat -n file.txt     # 显示行号
less file.txt        # 分页查看 (可上下滚动)
head -n 20 file.txt  # 查看前 20 行
tail -n 20 file.txt  # 查看后 20 行
tail -f file.log     # 实时查看日志 (follow)
```

### 文件查找

```bash
find /path -name "*.txt"        # 按名称查找
find /path -type d              # 查找目录
find /path -mtime -7            # 查找 7 天内修改的文件
find /path -size +100M          # 查找大于 100MB 的文件

which command                   # 查找命令位置
whereis command                 # 查找命令及源码
locate filename                 # 快速文件搜索 (需 updatedb)
```

---

## 文本处理

### grep - 文本搜索

```bash
grep "pattern" file.txt              # 基本搜索
grep -i "pattern" file.txt           # 忽略大小写 (ignore)
grep -r "pattern" dir/               # 递归搜索
grep -n "pattern" file.txt           # 显示行号
grep -c "pattern" file.txt           # 统计匹配行数
grep -v "pattern" file.txt           # 反向匹配
grep -E "pattern1|pattern2" file.txt # 扩展正则

# 常用组合
ps aux | grep nginx                  # 查找 nginx 进程
cat log.txt | grep ERROR             # 查找错误日志
```

### awk - 文本分析

```bash
# 基本语法
awk '{print $1}' file.txt            # 打印第一列
awk '{print $1, $3}' file.txt       # 打印第 1、3 列
awk -F',' '{print $2}' file.csv      # 指定分隔符

# 条件过滤
awk '/pattern/ {print $0}' file.txt  # 匹配 pattern 的行
awk '$3 > 100 {print $1}' file.txt   # 第三列大于 100

# 内置变量
NR        # 行号
NF        # 列数
$0        # 整行
$1, $2... # 各列
```

### sed - 流编辑器

```bash
# 基本替换
sed 's/old/new/' file.txt            # 替换每行第一个匹配
sed 's/old/new/g' file.txt           # 全部替换 (global)
sed 's/old/new/2' file.txt           # 替换第二个匹配

# 多命令
sed -e 's/a/b/' -e 's/c/d/' file.txt
sed '1,10s/old/new/' file.txt        # 指定行范围

# 原地编辑
sed -i 's/old/new/g' file.txt        # 直接修改文件
sed -i.bak 's/old/new/' file.txt     # 备份后修改
```

### 其他工具

```bash
# cut - 剪切列
cut -d',' -f1,3 file.csv       # 剪切第 1、3 列
cut -c1-10 file.txt             # 剪切第 1-10 字符

# sort - 排序
sort file.txt                   # 字典序排序
sort -n file.txt                # 数值排序
sort -r file.txt                # 倒序
sort -u file.txt                # 去重

# uniq - 去重
uniq file.txt                   # 去除连续重复行
uniq -c file.txt                # 显示重复次数
uniq -d file.txt                # 只显示重复行

# wc - 统计
wc -l file.txt                 # 统计行数
wc -w file.txt                 # 统计单词数
wc -c file.txt                 # 统计字符数
```

---

## 权限管理

### 权限概念

| 符号 | 含义 | 数值 |
|------|------|------|
| r | 读取 (Read) | 4 |
| w | 写入 (Write) | 2 |
| x | 执行 (Execute) | 1 |

### 权限组

```
drwxr-xr-x 2 user group 4096 Jan 20 10:00 dir/
-rw-r--r-- 1 user group 2048 Jan 20 10:00 file.txt

d         # 文件类型 (-=文件, d=目录, l=链接)
rwx       # 所有者权限 (user)
r-x       # 所属组权限 (group)
r-x       # 其他用户权限 (others)
```

### chmod - 修改权限

```bash
# 符号模式
chmod u+x file.sh          # 给所有者添加执行权限
chmod g-w file.txt         # 移除组写权限
chmod o=r file.txt         # 设置其他用户只读
chmod a+x file.sh          # 给所有人添加执行权限

# 数字模式
chmod 755 file.sh          # rwxr-xr-x
chmod 644 file.txt         # rw-r--r--
chmod 700 file.txt         # rwx------
chmod 600 file.txt         # rw-------

# 递归修改
chmod -R 755 dir/          # 递归修改目录权限
```

### chown - 修改所有者

```bash
chown user file.txt           # 修改文件所有者
chown user:group file.txt     # 同时修改所有者和组
chown :group file.txt         # 只修改组
chown -R user:group dir/      # 递归修改
```

### sudo - 超级用户权限

```bash
sudo command              # 以 root 权限执行
sudo -u user command      # 以指定用户执行
sudo -i                   # 切换到 root shell
sudo visudo               # 编辑 sudoers 文件
```

---

## 进程管理

### 查看进程

```bash
# ps - 静态进程快照
ps                         # 当前终端进程
ps aux                     # 所有进程详细信息 (BSD 风格)
ps -ef                     # 所有进程 (System V 风格)
ps -u username             # 指定用户的进程
ps -p 1234                 # 查看指定 PID

# top - 动态进程监控
top                        # 实时显示
top -u username            # 只看指定用户
top -p 1234               # 监控指定进程
# top 快捷键: q=退出, k=杀进程, M=按内存排序, P=按 CPU 排序

# htop - 更友好的 top (需安装)
htop                       # 彩色界面
```

### 进程控制

```bash
# 前台/后台
command &                  # 后台运行
Ctrl + Z                   # 暂停当前进程
bg                         # 后台继续
fg                         # 切换到前台
jobs                       # 查看后台作业

# kill - 终止进程
kill 1234                  # 正常终止进程
kill -9 1234               # 强制终止 (SIGKILL)
kill -15 1234              # 优雅终止 (SIGTERM)
kill -l                    # 查看信号列表

# 其他命令
pkill process_name         # 按名称杀进程
killall process_name       # 杀死所有同名进程
nohup command &            # 不受挂起影响的后台进程
```

### 系统资源

```bash
# 内存
free -h                    # 显示内存使用情况 (human)
free -m                    # 以 MB 显示

# CPU
uptime                     # 系统运行时间和负载
nproc                      # CPU 核心数

# 磁盘 I/O
iostat                     # I/O 统计 (需安装 sysstat)
```

---

## 网络工具

### 网络配置

```bash
# 查看 IP 地址
ip addr show               # 显示所有网络接口
ip addr show eth0          # 显示指定接口
hostname -I                # 获取本机 IP

# 配置 IP
ip addr add 192.168.1.100/24 dev eth0
ip addr del 192.168.1.100/24 dev eth0
```

### 网络测试

```bash
# ping - 测试连通性
ping baidu.com             # 测试到百度的连通性
ping -c 4 baidu.com        # 只 ping 4 次
ping -i 2 baidu.com        # 间隔 2 秒

# traceroute - 路由追踪
traceroute baidu.com       # 追踪路由路径

# mtr - 组合 ping 和 traceroute
mtr baidu.com
```

### 网络连接

```bash
# curl - HTTP 客户端
curl https://example.com              # 获取页面
curl -o file.zip https://url/        # 下载文件
curl -X POST -d "data" url           # POST 请求
curl -H "Header: value" url          # 自定义 header

# wget - 下载工具
wget https://example.com/file.zip    # 下载文件
wget -c url                          # 断点续传
wget -r url                           # 递归下载

# netstat/ss - 查看网络连接
netstat -tuln                 # 查看监听端口
ss -tuln                      # 更现代的工具
ss -tunp                      # 显示进程
```

### SSH

```bash
# 基本连接
ssh user@hostname             # 连接远程主机
ssh -p 2222 user@host        # 指定端口

# 密钥认证
ssh-keygen -t rsa             # 生成密钥
ssh-copy-id user@host         # 复制公钥到远程
```

---

## 磁盘管理

### 查看磁盘使用

```bash
# df - 文件系统使用
df -h                        # 人性化显示 (human)
df -T                        # 显示文件系统类型
df -i                        # 显示 inode 使用

# du - 目录/文件大小
du -h file.txt               # 查看文件大小
du -sh dir/                  # 查看目录总大小
du -h --max-depth=1 /home    # 限制深度
du -ah                       # 显示所有文件
```

### 挂载管理

```bash
# 挂载
mount /dev/sdb1 /mnt/usb    # 挂载
mount -o ro /dev/sdb1 /mnt  # 只读挂载
mount -t ntfs /dev/sdb1 /mnt # 指定类型

# 卸载
umount /mnt/usb              # 卸载
umount -f /mnt/nfs           # 强制卸载
umount -l /mnt/lazy          # 懒卸载
```

### 磁盘操作

```bash
# fdisk - 分区工具 (需 root)
sudo fdisk -l                # 列出分区
sudo fdisk /dev/sdb          # 编辑分区表

# mkfs - 创建文件系统
sudo mkfs.ext4 /dev/sdb1     # ext4 文件系统
sudo mkfs.xfs /dev/sdb1      # xfs 文件系统

# lsblk - 列出块设备
lsblk                        # 树形显示
lsblk -f                     # 显示文件系统
```

### 压缩解压

```bash
# tar - 打包
tar -cvf archive.tar dir/     # 创建 tar 包
tar -xvf archive.tar          # 解压 tar 包
tar -czvf archive.tar.gz dir/ # gzip 压缩
tar -xzvf archive.tar.gz      # gzip 解压
tar -cjvf archive.tar.bz2 dir/# bzip2 压缩

# zip/unzip
zip -r archive.zip dir/       # 创建 zip
unzip archive.zip             # 解压 zip

# gzip/gunzip
gzip file.txt                 # 压缩
gunzip file.txt.gz            # 解压
```

---

## Shell 脚本

### 基础语法

```bash
#!/bin/bash
# 这是注释

# 变量
name="value"
echo $name
echo ${name}

# 引号区别
echo "$name"      # 双引号: 解析变量
echo '$name'      # 单引号: 原文输出

# 特殊变量
$0    # 脚本名
$1-$9 # 命令行参数
$#    # 参数个数
$@    # 所有参数
$$    # 当前进程 ID
$?    # 上一个命令退出状态
```

### 条件判断

```bash
# 数值比较
[ $a -eq $b ]    # 等于
[ $a -ne $b ]    # 不等于
[ $a -gt $b ]    # 大于
[ $a -lt $b ]    # 小于
[ $a -ge $b ]    # 大于等于
[ $a -le $b ]    # 小于等于

# 字符串比较
[ "$str1" = "$str2" ]   # 等于
[ "$str1" != "$str2" ]  # 不等于
[ -z "$str" ]           # 为空
[ -n "$str" ]           # 非空

# 文件测试
[ -f file ]     # 是普通文件
[ -d dir ]      # 是目录
[ -r file ]     # 可读
[ -w file ]     # 可写
[ -x file ]     # 可执行

# if 语句
if [ condition ]; then
    # commands
elif [ condition ]; then
    # commands
else
    # commands
fi
```

### 循环

```bash
# for 循环
for i in 1 2 3 4 5; do
    echo $i
done

for file in *.txt; do
    echo "Processing $file"
done

# while 循环
count=1
while [ $count -le 10 ]; do
    echo $count
    count=$((count + 1))
done

# C 风格 for
for ((i=0; i<10; i++)); do
    echo $i
done
```

### 函数

```bash
# 定义函数
function hello {
    echo "Hello, $1!"
}

hello World

# 带返回值的函数
function add {
    return $(($1 + $2))
}

add 3 5
echo $?    # 输出 8
```

### 数组

```bash
# 定义数组
arr=(1 2 3 4 5)
arr[0]=10

# 访问元素
echo ${arr[0]}
echo ${arr[@]}       # 所有元素
echo ${#arr[@]}      # 数组长度

# 遍历
for item in "${arr[@]}"; do
    echo $item
done
```

---

## 实践练习

### 初级练习

```bash
# 1. 导航练习
pwd                    # 查看当前目录
cd ~                  # 回家
ls -la                # 列出所有文件
cd /tmp && ls         # 切换到 tmp 并列出

# 2. 文件操作
mkdir practice && cd practice
touch file1.txt file2.txt
cp file1.txt backup.txt
mv file2.txt renamed.txt
ls -l

# 3. 查看文件
echo "Hello World" > test.txt
cat test.txt
head -n 1 test.txt
wc -l test.txt

# 4. 搜索
grep "Hello" test.txt
find . -name "*.txt"
```

### 中级练习

```bash
# 1. 管道组合
cat /var/log/syslog | grep -i error | head -n 10

# 2. 权限管理
chmod 755 script.sh
chown user:group file.txt
ls -l script.sh

# 3. 进程管理
sleep 60 &              # 后台运行
ps aux | grep sleep     # 查找进程
kill $(pgrep sleep)     # 终止进程

# 4. 网络测试
curl -I https://baidu.com
ping -c 3 baidu.com
```

### 高级练习

```bash
# 1. 编写备份脚本
#!/bin/bash
backup_dir="/backup"
source_dir="/home/user/data"
date=$(date +%Y%m%d)
tar -czvf $backup_dir/backup_$date.tar.gz $source_dir

# 2. 日志分析
awk '/ERROR/ {count++} END {print "Total errors:", count}' logfile

# 3. 系统监控脚本
#!/bin/bash
echo "=== System Status ==="
echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
echo "Memory: $(free -h | awk '/Mem:/ {print $3 "/" $2}')"
echo "Disk: $(df -h / | awk 'NR==2 {print $5}')"

# 4. 批量处理
for file in *.jpg; do
    convert "$file" -resize 800x600 "thumb_$file"
done
```

---

## 学习路径

```
┌─────────────────────────────────────────────────────────────┐
│                    Linux 学习路径                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  入门 ──► 进阶 ──► 高级 ──► 专家                            │
│   │        │        │        │                              │
│   ├─ ls   ├─ grep  ├─ awk   ├─ Shell 脚本                   │
│   ├─ cd   ├─ sed   ├─ sed   ├─ Cron                         │
│   ├─ cp   ├─ chmod ├─ iptables├─ systemd                     │
│   ├─ mv   ├─ chown ├─ 网络  ├─ 集群管理                      │
│   └─ rm   └─ ps    └─ 磁盘  └─ 自动化运维                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 参考资源

### 在线教程
- [Linux Journey](https://linuxjourney.com/)
- [Linux Command Library](https://linuxcommand.org/)
- [Ryan's Linux Tutorial](https://ryanstutorials.net/linuxtutorial/)

### 命令速查
- [explainshell.com](https://explainshell.com/)
- [cheat.sh](https://cheat.sh/)

### 书籍
- 《鸟哥的 Linux 私房菜》
- 《Linux 命令行与 Shell 脚本编程大全》
- 《The Linux Programming Interface》

---

## 更新日志

| 日期 | 版本 | 更新内容 |
|------|------|----------|
| 2026-03-21 | 1.0 | 初始版本，包含完整 Linux 学习指南 |
