# Java Spring Boot + Vue 部署检查清单

## 1. 后端 (Spring Boot) 检查

### 代码质量
- [ ] `./mvnw test` 所有测试通过
- [ ] `./mvnw checkstyle:check` 代码规范通过
- [ ] `./mvnw spotless:check` 格式检查通过
- [ ] `./mvnw clean package` 构建成功

### 安全检查
- [ ] `application-prod.yml` 生产配置正确
- [ ] `spring.jpa.hibernate.ddl-auto=validate` 生产环境验证
- [ ] `DEBUG=false` 关闭调试
- [ ] CORS 配置正确

### 数据库
- [ ] Flyway 迁移测试通过
- [ ] 索引已添加
- [ ] 备份生产数据

### 性能检查
- [ ] 连接池配置正确 (HikariCP)
- [ ] 缓存配置正确 (Redis)
- [ ] 线程池配置合理

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
./mvnw clean package -DskipTests

# 运行
java -jar target/demo-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod

# 或使用 Docker
docker build -t demo-app .
docker run -p 8080:8080 demo-app
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
curl http://localhost:8080/actuator/health

# API 测试
curl -X GET http://localhost:8080/api/v1/features
```

## 5. 监控配置

- [ ] Spring Actuator 端点配置
- [ ] Micrometer 指标收集
- [ ] 日志级别配置
- [ ] Sentry/Graylog 集成

## 6. 部署记录

| 项目 | 内容 |
|------|------|
| 部署日期 | YYYY-MM-DD |
| 部署版本 | V1.0.0 |
| Git Commit | abc1234 |
| 状态 | ✅ 成功 / ❌ 失败 |