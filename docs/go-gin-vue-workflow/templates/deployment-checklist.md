# Go Gin + Vue 部署检查清单

## 1. 后端 (Go Gin) 检查

### 代码质量
- [ ] `go test ./...` 所有测试通过
- [ ] `golangci-lint run` 无代码问题
- [ ] `go build -o server cmd/server/main.go` 构建成功
- [ ] `go mod tidy` 依赖完整

### 安全检查
- [ ] `.env` 生产配置正确
- [ ] 无硬编码凭证
- [ ] CORS 配置正确
- [ ] SQL 注入防护

### 数据库
- [ ] 迁移脚本测试通过
- [ ] 索引已添加
- [ ] 备份生产数据

### 性能检查
- [ ] 连接池配置合理
- [ ] 超时配置正确
- [ ] 日志级别合理

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

# 构建
go build -o server cmd/server/main.go

# 运行
./server

# 或使用 Docker
docker build -t go-app .
docker run -p 8080:8080 go-app
```

### 3.2 Docker Compose
```yaml
version: '3.8'
services:
  backend:
    build: ./backend
    ports:
      - "8080:8080"
    environment:
      - DB_HOST=mysql
      - DB_USER=test
      - DB_PASSWORD=test
      - DB_NAME=go_workflows
    depends_on:
      - mysql

  mysql:
    image: mysql:8
    environment:
      - MYSQL_ROOT_PASSWORD=test
      - MYSQL_DATABASE=go_workflows
      - MYSQL_USER=test
      - MYSQL_PASSWORD=test
    ports:
      - "3306:3306"
```

### 3.3 前端部署
```bash
# 构建
npm run build

# 上传 dist/ 到 CDN 或服务器
scp -r dist/* user@server:/var/www/
```

## 4. Makefile 示例

```makefile
.PHONY: build run test lint clean docker

build:
	go build -o server cmd/server/main.go

run:
	go run cmd/server/main.go

test:
	go test -v ./...

lint:
	golangci-lint run

clean:
	rm -f server

docker-build:
	docker build -t go-app .

docker-run:
	docker run -p 8080:8080 go-app
```

## 5. 验证检查

```bash
# 健康检查
curl http://localhost:8080/health

# API 测试
curl -X GET http://localhost:8080/api/v1/features
```

## 6. 部署记录

| 项目 | 内容 |
|------|------|
| 部署日期 | YYYY-MM-DD |
| 部署版本 | V1.0.0 |
| Git Commit | abc1234 |
| 状态 | ✅ 成功 / ❌ 失败 |