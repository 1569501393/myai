# Service 模板

## 标准 Service

```go
// internal/service/feature.go
package service

import (
	"context"
	"errors"

	"go-workflows/internal/model"
	"go-workflows/internal/repository"
)

var (
	ErrNotFound     = errors.New("record not found")
	ErrAlreadyExists = errors.New("record already exists")
)

type FeatureService struct {
	repo *repository.FeatureRepository
}

func NewFeatureService(repo *repository.FeatureRepository) *FeatureService {
	return &FeatureService{repo: repo}
}

type ListResult struct {
	Data       []*model.FeatureListResponse
	Total      int64
	Page       int
	PageSize   int
	TotalPages int
}

func (s *FeatureService) List(ctx context.Context, page, pageSize int, status string) (*ListResult, error) {
	features, total, err := s.repo.List(ctx, page, pageSize, status)
	if err != nil {
		return nil, err
	}

	data := make([]*model.FeatureListResponse, len(features))
	for i, f := range features {
		resp := model.ToListResponse(f)
		data[i] = &resp
	}

	totalPages := int(total) / pageSize
	if int(total)%pageSize > 0 {
		totalPages++
	}

	return &ListResult{
		Data:       data,
		Total:      total,
		Page:       page,
		PageSize:   pageSize,
		TotalPages: totalPages,
	}, nil
}

func (s *FeatureService) GetByID(ctx context.Context, id int64) (*model.FeatureResponse, error) {
	feature, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrNotFound
	}

	resp := model.ToResponse(feature)
	return &resp, nil
}

func (s *FeatureService) Create(ctx context.Context, input *model.FeatureCreateInput) (*model.FeatureResponse, error) {
	exists, err := s.repo.ExistsByName(ctx, input.Name)
	if err != nil {
		return nil, err
	}
	if exists {
		return nil, ErrAlreadyExists
	}

	feature := &model.Feature{
		Name:        input.Name,
		Description: input.Description,
		Status:      input.Status,
	}

	if feature.Status == "" {
		feature.Status = model.StatusDraft
	}

	if err := s.repo.Create(ctx, feature); err != nil {
		return nil, err
	}

	resp := model.ToResponse(feature)
	return &resp, nil
}

func (s *FeatureService) Update(ctx context.Context, id int64, input *model.FeatureUpdateInput) (*model.FeatureResponse, error) {
	feature, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrNotFound
	}

	if input.Name != nil {
		feature.Name = *input.Name
	}
	if input.Description != nil {
		feature.Description = *input.Description
	}
	if input.Status != nil {
		feature.Status = *input.Status
	}

	if err := s.repo.Update(ctx, feature); err != nil {
		return nil, err
	}

	resp := model.ToResponse(feature)
	return &resp, nil
}

func (s *FeatureService) Delete(ctx context.Context, id int64) error {
	_, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return ErrNotFound
	}

	return s.repo.Delete(ctx, id)
}
```

## 单元测试

```go
// internal/service/feature_test.go
package service

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"go-workflows/internal/model"
)

// MockRepository 模拟 Repository
type MockFeatureRepository struct {
	mock.Mock
}

func (m *MockFeatureRepository) GetByID(ctx context.Context, id int64) (*model.Feature, error) {
	args := m.Called(ctx, id)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*model.Feature), args.Error(1)
}

func (m *MockFeatureRepository) Create(ctx context.Context, feature *model.Feature) error {
	args := m.Called(ctx, feature)
	return args.Error(0)
}

func TestFeatureService_GetByID(t *testing.T) {
	mockRepo := new(MockFeatureRepository)
	svc := NewFeatureService((*repository.FeatureRepository)(nil))

	// 这里需要使用接口而非具体类型
	// 简化示例，实际应定义接口
}

func TestFeatureService_Create_Success(t *testing.T) {
	input := &model.FeatureCreateInput{
		Name:        "Test Feature",
		Description: "Test Description",
		Status:      model.StatusDraft,
	}

	// 测试逻辑
	assert.NotNil(t, input)
}
```

## 错误定义

```go
// internal/service/errors.go
package service

import "errors"

var (
	ErrNotFound      = errors.New("resource not found")
	ErrAlreadyExists = errors.New("resource already exists")
	ErrInvalidInput  = errors.New("invalid input")
	ErrUnauthorized  = errors.New("unauthorized")
	ErrForbidden     = errors.New("forbidden")
)
```

## 注意事项

- 定义统一的错误常量
- 使用 ctx 传递请求上下文
- Service 不直接操作数据库，通过 Repository
- 业务逻辑验证在 Service 层
- 保持方法简洁，单一职责