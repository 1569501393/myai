# Full-Stack 部署检查清单

## 1. 后端 (Laravel) 检查

### 代码质量
- [ ] `php artisan test` 所有测试通过
- [ ] `./vendor/bin/pint --test` 无代码风格问题
- [ ] `php artisan config:cache` 配置缓存成功
- [ ] `php artisan route:cache` 路由缓存成功

### 安全检查
- [ ] `.env` 配置正确 (生产数据库、Redis)
- [ ] `APP_DEBUG=false` 生产环境关闭调试
- [ ] `APP_KEY` 已设置
- [ ] CORS 配置正确

### 数据库
- [ ] 迁移文件测试通过
- [ ] 数据填充测试通过
- [ ] 备份生产数据

### 性能检查
- [ ] 索引已添加
- [ ] 缓存配置正确
- [ ] 队列 worker 配置

## 2. 前端 (Vue) 检查

### 构建检查
- [ ] `npm run build` 构建成功
- [ ] 无 console.error
- [ ] 资源文件 < 500KB
- [ ] 图片已压缩优化

### 环境配置
- [ ] `VITE_API_BASE_URL` 指向生产 API
- [ ] `VITE_APP_ENV=production`

### 部署文件
```
dist/
├── index.html
├── assets/
│   ├── js/
│   ├── css/
│   └── images/
└── favicon.ico
```

## 3. 数据库迁移

### 迁移清单
| 表名 | 操作 | 回滚方式 |
|------|------|----------|
| features | 新增 | DROP TABLE |

### 执行命令
```bash
php artisan migrate --force
```

## 4. 部署步骤

### 4.1 后端部署
```bash
# 拉取代码
git pull origin main

# 安装依赖
composer install --optimize-autoloader --no-dev

# 运行迁移
php artisan migrate --force

# 清理缓存
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 重启队列
php artisan queue:restart
```

### 4.2 前端部署
```bash
# 构建
npm run build

# 上传 dist/ 到服务器
scp -r dist/* user@server:/var/www/html/

# 或使用 CI/CD 自动部署
```

## 5. 验证检查

### 功能验证
- [ ] 列表页加载正常
- [ ] 新建功能成功
- [ ] 编辑功能成功
- [ ] 删除功能成功
- [ ] 权限控制正常

### 接口验证
```bash
# 健康检查
curl -X GET https://api.example.com/health

# API 测试
curl -X GET https://api.example.com/api/features \
  -H "Authorization: Bearer {token}"
```

### 性能验证
- [ ] 列表接口 < 500ms
- [ ] 前端首屏 < 2s
- [ ] Lighthouse 评分 > 80

## 6. 监控配置

### 日志
- [ ] Laravel 日志写入正常
- [ ] 错误告警配置

### 性能监控
- [ ] New Relic / Sentry 配置
- [ ] APM 监控启用

## 7. 回滚方案

### 回滚触发条件
- 错误率 > 1%
- 响应时间 > 5s
- 核心功能不可用

### 回滚步骤
```bash
# 后端回滚
git revert HEAD
composer install
php artisan migrate:rollback --force

# 前端回滚
scp -r dist_backup/* user@server:/var/www/html/
```

## 8. 部署记录

| 项目 | 内容 |
|------|------|
| 部署日期 | YYYY-MM-DD HH:mm |
| 部署人员 | |
| 部署版本 | V1.0.0 |
| Git Commit | abc1234 |
| 持续时间 | X 分钟 |
| 状态 | ✅ 成功 / ❌ 失败 |
| 备注 | |