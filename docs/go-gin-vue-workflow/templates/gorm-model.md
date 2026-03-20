# GORM Model 模板

## 标准 Model

```go
// internal/model/feature.go
package model

import (
	"time"
)

type FeatureStatus string

const (
	StatusActive   FeatureStatus = "active"
	StatusInactive FeatureStatus = "inactive"
	StatusDraft    FeatureStatus = "draft"
)

type Feature struct {
	ID          int64          `gorm:"primaryKey;autoIncrement" json:"id"`
	Name        string         `gorm:"type:varchar(255);not null;uniqueIndex" json:"name"`
	Description string         `gorm:"type:text" json:"description"`
	Status      FeatureStatus  `gorm:"type:varchar(20);default:draft;index" json:"status"`
	UserID      *int64         `gorm:"index" json:"user_id,omitempty"`
	User        *User          `gorm:"foreignKey:UserID" json:"user,omitempty"`
	CreatedAt   time.Time      `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt   time.Time      `gorm:"autoUpdateTime" json:"updated_at"`
}

func (Feature) TableName() string {
	return "features"
}

type FeatureItem struct {
	ID        int64     `gorm:"primaryKey;autoIncrement" json:"id"`
	FeatureID int64     `gorm:"index;not null" json:"feature_id"`
	Feature   *Feature  `gorm:"foreignKey:FeatureID" json:"feature,omitempty"`
	Title     string    `gorm:"type:varchar(255)" json:"title"`
	Content   string    `gorm:"type:text" json:"content"`
	CreatedAt time.Time `gorm:"autoCreateTime" json:"created_at"`
}

func (FeatureItem) TableName() string {
	return "feature_items"
}
```

## 输入输出结构

```go
// internal/model/feature_input.go
package model

type FeatureCreateInput struct {
	Name        string        `json:"name" binding:"required,max=255"`
	Description string        `json:"description"`
	Status      FeatureStatus `json:"status"`
}

type FeatureUpdateInput struct {
	Name        *string        `json:"name"`
	Description *string        `json:"description"`
	Status      *FeatureStatus `json:"status"`
}

type FeatureResponse struct {
	ID          int64          `json:"id"`
	Name        string         `json:"name"`
	Description string         `json:"description"`
	Status      FeatureStatus  `json:"status"`
	CreatedAt   string         `json:"created_at"`
	UpdatedAt   string         `json:"updated_at"`
}

type FeatureListResponse struct {
	ID        int64          `json:"id"`
	Name      string         `json:"name"`
	Status    FeatureStatus  `json:"status"`
	CreatedAt string         `json:"created_at"`
}

func ToResponse(f *Feature) FeatureResponse {
	return FeatureResponse{
		ID:          f.ID,
		Name:        f.Name,
		Description: f.Description,
		Status:      f.Status,
		CreatedAt:   f.CreatedAt.Format(time.RFC3339),
		UpdatedAt:   f.UpdatedAt.Format(time.RFC3339),
	}
}

func ToListResponse(f *Feature) FeatureListResponse {
	return FeatureListResponse{
		ID:        f.ID,
		Name:      f.Name,
		Status:    f.Status,
		CreatedAt: f.CreatedAt.Format(time.RFC3339),
	}
}
```

## 软删除 Model

```go
// internal/model/soft_delete.go
package model

import (
	"time"

	"gorm.io/plugin/soft_delete"
)

type SoftDeleteModel struct {
	ID        int64     `gorm:"primaryKey" json:"id"`
	CreatedAt time.Time `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt time.Time `gorm:"autoUpdateTime" json:"updated_at"`
	DeletedAt soft_delete.DeletedAt `gorm:"index" json:"-"`
}

type Product struct {
	SoftDeleteModel
	Name  string  `gorm:"type:varchar(100);not null" json:"name"`
	Price float64 `gorm:"type:decimal(10,2)" json:"price"`
}
```

## 配置和初始化

```go
// config/config.go
package config

import (
	"fmt"
	"os"
)

type Config struct {
	DBHost     string
	DBPort     string
	DBUser     string
	DBPassword string
	DBName     string
	ServerAddr string
}

func Load() *Config {
	return &Config{
		DBHost:     getEnv("DB_HOST", "localhost"),
		DBPort:     getEnv("DB_PORT", "3306"),
		DBUser:     getEnv("DB_USER", "test"),
		DBPassword: getEnv("DB_PASSWORD", "test"),
		DBName:     getEnv("DB_NAME", "go_workflows"),
		ServerAddr: getEnv("SERVER_ADDR", ":8080"),
	}
}

func (c *Config) DSN() string {
	return fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		c.DBUser, c.DBPassword, c.DBHost, c.DBPort, c.DBName)
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
```

## 迁移

```go
// internal/model/migration.go
package model

import "gorm.io/gorm"

func Migrate(db *gorm.DB) error {
	return db.AutoMigrate(
		&User{},
		&Feature{},
		&FeatureItem{},
	)
}
```

## 注意事项

- 使用 `gorm:"type:varchar(255)"` 指定字段类型
- 使用 `autoIncrement` 自增主键
- 使用 `autoCreateTime` / `autoUpdateTime` 自动时间戳
- 使用 `index` 创建索引
- 使用 `uniqueIndex` 唯一索引
- 使用 `foreignKey` 定义外键
- 实现 `TableName()` 自定义表名
- 软删除使用 `soft_delete.DeletedAt`