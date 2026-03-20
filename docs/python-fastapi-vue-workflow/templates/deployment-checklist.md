# FastAPI + Vue 部署检查清单

## 1. 后端 (FastAPI) 检查

### 代码质量
- [ ] `pytest tests/` 所有测试通过
- [ ] `ruff check .` 无代码问题
- [ ] `black --check .` 格式正确
- [ ] `mypy app/` 类型检查通过

### 安全检查
- [ ] `.env` 生产配置正确
- [ ] `DEBUG=False` 关闭调试
- [ ] `SECRET_KEY` 已设置
- [ ] CORS 配置正确

### 数据库
- [ ] Alembic 迁移测试通过
- [ ] 索引已添加
- [ ] 备份生产数据

### 性能检查
- [ ] 缓存配置正确 (Redis)
- [ ] Gunicorn/Uvicorn worker 配置

## 2. 前端 (Vue) 检查

### 构建检查
- [ ] `npm run build` 构建成功
- [ ] 资源文件 < 500KB
- [ ] 图片已压缩优化

### 环境配置
- [ ] `VITE_API_BASE_URL` 指向生产 API

## 3. 部署步骤

### 3.1 后端部署
```bash
# 拉取代码
git pull origin main

# 创建虚拟环境
python -m venv venv
source venv/bin/activate

# 安装依赖
pip install -r requirements.txt

# 运行迁移
alembic upgrade head

# 使用 Gunicorn 运行
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker -b 0.0.0.0:8000
```

### 3.2 前端部署
```bash
# 构建
npm run build

# 上传 dist/ 到 CDN 或服务器
scp -r dist/* user@server:/var/www/
```

## 4. 验证检查

```bash
# 健康检查
curl http://localhost:8000/health

# API 测试
curl -X GET http://localhost:8000/api/v1/features
```

## 5. 部署记录

| 项目 | 内容 |
|------|------|
| 部署日期 | YYYY-MM-DD |
| 部署版本 | V1.0.0 |
| Git Commit | abc1234 |
| 状态 | ✅ 成功 / ❌ 失败 |