# Go Gin + Vue 功能需求文档模板

```markdown
# 功能需求文档

**项目名称**: 
**需求编号**: FE-YYYY-XXX
**创建日期**: YYYY-MM-DD
**需求方**: 
**开发负责人**: 
**优先级**: [高/中/低]
**预估工时**: X 人天

---

## 1. 业务背景

[描述业务场景和需求来源]

## 2. 功能需求

### 2.1 功能列表

| 序号 | 功能点 | 优先级 | 备注 |
|------|--------|--------|------|
| 1 | 功能点1 | 高 | |
| 2 | 功能点2 | 中 | |

### 2.2 功能详细描述

#### 2.2.1 功能点1

**描述**: [功能详细描述]

**API端点**: POST /api/v1/features

**请求示例**:
```json
{
  "name": "功能名称",
  "description": "功能描述",
  "status": "draft"
}
```

**响应示例**:
```json
{
  "code": 201,
  "success": true,
  "message": "Created successfully",
  "data": {
    "id": 1,
    "name": "功能名称",
    "status": "draft",
    "created_at": "2024-01-01T00:00:00Z"
  }
}
```

## 3. 数据模型

### 3.1 GORM Model

```go
type Feature struct {
    ID          int64     `gorm:"primaryKey;autoIncrement"`
    Name        string    `gorm:"type:varchar(255);not null"`
    Description string    `gorm:"type:text"`
    Status      string    `gorm:"type:varchar(20);default:draft"`
    CreatedAt   time.Time `gorm:"autoCreateTime"`
    UpdatedAt   time.Time `gorm:"autoUpdateTime"`
}
```

### 3.2 Input Struct

```go
type FeatureCreateInput struct {
    Name        string `json:"name" binding:"required"`
    Description string `json:"description"`
    Status      string `json:"status"`
}
```

## 4. 前端组件

| 组件 | 路径 | 描述 |
|------|------|------|
| FeatureList | views/FeatureList.vue | 列表页 |
| FeatureForm | components/FeatureForm.vue | 表单 |

## 5. 测试用例

| 用例ID | 描述 | 预期结果 |
|--------|------|----------|
| TC001 | 创建功能 | 成功返回201 |
| TC002 | 名称重复 | 返回错误 |
| TC003 | 未登录访问 | 返回401 |

## 6. 附件

- [ ] 流程图
- [ ] 界面原型