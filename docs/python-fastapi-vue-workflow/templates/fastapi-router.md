# FastAPI Router 模板

## 标准 API 路由

```python
# app/api/v1/endpoints/feature.py
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from typing import Annotated

from app.core.database import get_db
from app.schemas.feature import FeatureCreate, FeatureUpdate, FeatureResponse
from app.services.feature import FeatureService
from app.models.user import User
from app.api.deps import get_current_active_user

router = APIRouter(prefix="/features", tags=["Features"])


@router.get("/", response_model=dict)
async def list_features(
    page: int = Query(1, ge=1),
    per_page: int = Query(15, ge=1, le=100),
    status: str | None = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
) -> dict:
    """获取功能列表"""
    service = FeatureService(db)
    result = await service.get_list(
        page=page,
        per_page=per_page,
        status=status,
    )
    return {
        "success": True,
        "data": result["data"],
        "total": result["total"],
        "page": page,
        "per_page": per_page,
    }


@router.get("/{feature_id}", response_model=dict)
async def get_feature(
    feature_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
) -> dict:
    """获取功能详情"""
    service = FeatureService(db)
    feature = await service.get_by_id(feature_id)
    if not feature:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Feature not found",
        )
    return {"success": True, "data": feature}


@router.post("/", response_model=dict, status_code=status.HTTP_201_CREATED)
async def create_feature(
    data_in: FeatureCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
) -> dict:
    """创建功能"""
    service = FeatureService(db)
    feature = await service.create(data_in)
    return {"success": True, "data": feature, "message": "Created successfully"}


@router.put("/{feature_id}", response_model=dict)
async def update_feature(
    feature_id: int,
    data_in: FeatureUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
) -> dict:
    """更新功能"""
    service = FeatureService(db)
    feature = await service.update(feature_id, data_in)
    if not feature:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Feature not found",
        )
    return {"success": True, "data": feature, "message": "Updated successfully"}


@router.delete("/{feature_id}", response_model=dict)
async def delete_feature(
    feature_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
) -> dict:
    """删除功能"""
    service = FeatureService(db)
    result = await service.delete(feature_id)
    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Feature not found",
        )
    return {"success": True, "data": None, "message": "Deleted successfully"}
```

## 路由注册

```python
# app/api/v1/router.py
from fastapi import APIRouter

from app.api.v1.endpoints import feature, user, auth

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["Auth"])
api_router.include_router(user.router, prefix="/users", tags=["Users"])
api_router.include_router(feature.router, prefix="/features", tags=["Features"])
```

```python
# app/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1.router import api_router
from app.core.config import settings

app = FastAPI(
    title="FastAPI Project",
    description="API Documentation",
    version="1.0.0",
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Router
app.include_router(api_router, prefix="/api/v1")


@app.get("/health")
async def health_check():
    return {"status": "ok"}
```

## 注意事项

- 使用异步 (`async def`) 提高性能
- 依赖注入管理数据库会话
- 返回统一格式 `{"success": True, "data": ...}`
- 使用 Pydantic 验证输入