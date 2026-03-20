# Repository 模板

## 标准 Repository

```go
// internal/repository/feature.go
package repository

import (
	"context"

	"gorm.io/gorm"
	"go-workflows/internal/model"
)

type FeatureRepository struct {
	db *gorm.DB
}

func NewFeatureRepository(db *gorm.DB) *FeatureRepository {
	return &FeatureRepository{db: db}
}

func (r *FeatureRepository) GetByID(ctx context.Context, id int64) (*model.Feature, error) {
	var feature model.Feature
	if err := r.db.WithContext(ctx).First(&feature, id).Error; err != nil {
		return nil, err
	}
	return &feature, nil
}

func (r *FeatureRepository) GetByName(ctx context.Context, name string) (*model.Feature, error) {
	var feature model.Feature
	if err := r.db.WithContext(ctx).Where("name = ?", name).First(&feature).Error; err != nil {
		return nil, err
	}
	return &feature, nil
}

func (r *FeatureRepository) List(ctx context.Context, page, pageSize int, status string) ([]*model.Feature, int64, error) {
	var features []*model.Feature
	var total int64

	query := r.db.WithContext(ctx).Model(&model.Feature{})

	if status != "" {
		query = query.Where("status = ?", status)
	}

	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}

	offset := (page - 1) * pageSize
	if err := query.Offset(offset).Limit(pageSize).Order("created_at DESC").Find(&features).Error; err != nil {
		return nil, 0, err
	}

	return features, total, nil
}

func (r *FeatureRepository) Create(ctx context.Context, feature *model.Feature) error {
	return r.db.WithContext(ctx).Create(feature).Error
}

func (r *FeatureRepository) Update(ctx context.Context, feature *model.Feature) error {
	return r.db.WithContext(ctx).Save(feature).Error
}

func (r *FeatureRepository) Delete(ctx context.Context, id int64) error {
	return r.db.WithContext(ctx).Delete(&model.Feature{}, id).Error
}

func (r *FeatureRepository) ExistsByName(ctx context.Context, name string) (bool, error) {
	var count int64
	if err := r.db.WithContext(ctx).Model(&model.Feature{}).Where("name = ?", name).Count(&count).Error; err != nil {
		return false, err
	}
	return count > 0, nil
}

// BatchCreate 批量创建
func (r *FeatureRepository) BatchCreate(ctx context.Context, features []*model.Feature) error {
	return r.db.WithContext(ctx).CreateInBatches(features, 100).Error
}

// GetByIDs 批量查询
func (r *FeatureRepository) GetByIDs(ctx context.Context, ids []int64) ([]*model.Feature, error) {
	var features []*model.Feature
	if err := r.db.WithContext(ctx).Where("id IN ?", ids).Find(&features).Error; err != nil {
		return nil, err
	}
	return features, nil
}
```

## 条件查询

```go
// internal/repository/query.go
package repository

import (
	"context"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type FeatureFilter struct {
	Status  string
	Keyword string
	UserID  *int64
}

func (r *FeatureRepository) Search(ctx context.Context, filter *FeatureFilter, page, pageSize int) ([]*model.Feature, int64, error) {
	var features []*model.Feature
	var total int64

	query := r.db.WithContext(ctx).Model(&model.Feature{})

	if filter.Status != "" {
		query = query.Where("status = ?", filter.Status)
	}

	if filter.Keyword != "" {
		query = query.Where("name LIKE ?", "%"+filter.Keyword+"%")
	}

	if filter.UserID != nil {
		query = query.Where("user_id = ?", *filter.UserID)
	}

	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}

	offset := (page - 1) * pageSize
	if err := query.Offset(offset).Limit(pageSize).Order("created_at DESC").Find(&features).Error; err != nil {
		return nil, 0, err
	}

	return features, total, nil
}

// WithTransaction 事务操作
func (r *FeatureRepository) WithTransaction(fn func(repo *FeatureRepository) error) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		txRepo := &FeatureRepository{db: tx}
		return fn(txRepo)
	})
}

// UpdateFields 更新指定字段
func (r *FeatureRepository) UpdateFields(ctx context.Context, id int64, updates map[string]interface{}) error {
	return r.db.WithContext(ctx).Model(&model.Feature{}).Where("id = ?", id).Updates(updates).Error
}

// Upsert 插入或更新
func (r *FeatureRepository) Upsert(ctx context.Context, feature *model.Feature) error {
	return r.db.WithContext(ctx).Clauses(clause.OnConflict{
		Columns:   []clause.Column{{Name: "name"}},
		DoUpdates: clause.AssignmentColumns([]string{"description", "status", "updated_at"}),
	}).Create(feature).Error
}
```

## 注意事项

- 使用 `WithContext` 传递 context
- 使用 `Transaction` 处理事务
- 使用 `CreateInBatches` 批量插入
- 使用 `Clauses` 处理 UPSERT
- 使用 `Select` 指定更新字段
- 返回 error 而不是 gorm.ErrRecordNotFound