# Gin Handler 模板

## 标准 HTTP Handler

```go
// internal/handler/feature.go
package handler

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"go-workflows/internal/model"
	"go-workflows/internal/service"
	"go-workflows/pkg/response"
)

type FeatureHandler struct {
	svc *service.FeatureService
}

func NewFeatureHandler(svc *service.FeatureService) *FeatureHandler {
	return &FeatureHandler{svc: svc}
}

// List godoc
// @Summary 获取列表
// @Tags Feature
// @Param page query int false "页码" default(1)
// @Param page_size query int false "每页数量" default(15)
// @Param status query string false "状态筛选"
// @Success 200 {object} response.Response
// @Router /api/v1/features [get]
func (h *FeatureHandler) List(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	pageSize, _ := strconv.Atoi(c.DefaultQuery("page_size", "15"))
	status := c.Query("status")

	result, err := h.svc.List(c.Request.Context(), page, pageSize, status)
	if err != nil {
		response.Error(c, http.StatusInternalServerError, err.Error())
		return
	}

	response.Success(c, result)
}

// GetByID godoc
// @Summary 获取详情
// @Tags Feature
// @Param id path int true "ID"
// @Success 200 {object} response.Response
// @Router /api/v1/features/{id} [get]
func (h *FeatureHandler) GetByID(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		response.Error(c, http.StatusBadRequest, "invalid id")
		return
	}

	feature, err := h.svc.GetByID(c.Request.Context(), id)
	if err != nil {
		response.Error(c, http.StatusNotFound, "not found")
		return
	}

	response.Success(c, feature)
}

// Create godoc
// @Summary 创建
// @Tags Feature
// @Accept json
// @Produce json
// @Param data body model.FeatureCreateInput true "数据"
// @Success 201 {object} response.Response
// @Router /api/v1/features [post]
func (h *FeatureHandler) Create(c *gin.Context) {
	var input model.FeatureCreateInput
	if err := c.ShouldBindJSON(&input); err != nil {
		response.Error(c, http.StatusBadRequest, err.Error())
		return
	}

	feature, err := h.svc.Create(c.Request.Context(), &input)
	if err != nil {
		response.Error(c, http.StatusInternalServerError, err.Error())
		return
	}

	response.Created(c, feature, "Created successfully")
}

// Update godoc
// @Summary 更新
// @Tags Feature
// @Accept json
// @Produce json
// @Param id path int true "ID"
// @Param data body model.FeatureUpdateInput true "数据"
// @Success 200 {object} response.Response
// @Router /api/v1/features/{id} [put]
func (h *FeatureHandler) Update(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		response.Error(c, http.StatusBadRequest, "invalid id")
		return
	}

	var input model.FeatureUpdateInput
	if err := c.ShouldBindJSON(&input); err != nil {
		response.Error(c, http.StatusBadRequest, err.Error())
		return
	}

	feature, err := h.svc.Update(c.Request.Context(), id, &input)
	if err != nil {
		response.Error(c, http.StatusInternalServerError, err.Error())
		return
	}

	response.Success(c, feature, "Updated successfully")
}

// Delete godoc
// @Summary 删除
// @Tags Feature
// @Param id path int true "ID"
// @Success 200 {object} response.Response
// @Router /api/v1/features/{id} [delete]
func (h *FeatureHandler) Delete(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		response.Error(c, http.StatusBadRequest, "invalid id")
		return
	}

	if err := h.svc.Delete(c.Request.Context(), id); err != nil {
		response.Error(c, http.StatusInternalServerError, err.Error())
		return
	}

	response.Success(c, nil, "Deleted successfully")
}
```

## 统一响应

```go
// pkg/response/response.go
package response

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type Response struct {
	Code    int         `json:"code"`
	Success bool        `json:"success"`
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
}

func Success(c *gin.Context, data interface{}, message ...string) {
	msg := "Success"
	if len(message) > 0 {
		msg = message[0]
	}
	c.JSON(http.StatusOK, Response{
		Code:    http.StatusOK,
		Success: true,
		Message: msg,
		Data:    data,
	})
}

func Created(c *gin.Context, data interface{}, message ...string) {
	msg := "Created"
	if len(message) > 0 {
		msg = message[0]
	}
	c.JSON(http.StatusCreated, Response{
		Code:    http.StatusCreated,
		Success: true,
		Message: msg,
		Data:    data,
	})
}

func Error(c *gin.Context, code int, message string) {
	c.JSON(code, Response{
		Code:    code,
		Success: false,
		Message: message,
	})
}

func Paginated(c *gin.Context, data interface{}, total int64, page, pageSize int) {
	c.JSON(http.StatusOK, Response{
		Code:    http.StatusOK,
		Success: true,
		Message: "Success",
		Data: gin.H{
			"data":       data,
			"total":      total,
			"page":       page,
			"page_size":  pageSize,
			"total_pages": (total + int64(pageSize) - 1) / int64(pageSize),
		},
	})
}
```

## 路由注册

```go
// internal/router/router.go
package router

import (
	"github.com/gin-gonic/gin"
	"go-workflows/internal/handler"
)

func Setup(r *gin.Engine, featureHandler *handler.FeatureHandler) {
	api := r.Group("/api/v1")
	{
		features := api.Group("/features")
		{
			features.GET("", featureHandler.List)
			features.GET("/:id", featureHandler.GetByID)
			features.POST("", featureHandler.Create)
			features.PUT("/:id", featureHandler.Update)
			features.DELETE("/:id", featureHandler.Delete)
		}
	}
}
```

## main.go

```go
// cmd/server/main.go
package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"go-workflows/config"
	"go-workflows/internal/handler"
	"go-workflows/internal/model"
	"go-workflows/internal/repository"
	"go-workflows/internal/router"
	"go-workflows/internal/service"
)

func main() {
	cfg := config.Load()

	db, err := gorm.Open(mysql.Open(cfg.DSN()), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}

	db.AutoMigrate(&model.Feature{})

	repo := repository.NewFeatureRepository(db)
	svc := service.NewFeatureService(repo)
	h := handler.NewFeatureHandler(svc)

	r := gin.Default()
	router.Setup(r, h)

	r.Run(cfg.ServerAddr())
}
```

## 注意事项

- 使用 `ShouldBindJSON` 绑定请求
- 统一响应格式 `{"success": true, "data": ...}`
- 使用 `context.Context` 传递请求上下文
- 添加 Swagger 注释生成 API 文档
- 路由分组便于管理