# Pydantic Schemas 模板

## 请求/响应模型

```python
# app/schemas/feature.py
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, Field, ConfigDict


class FeatureBase(BaseModel):
    """基础模型"""
    name: str = Field(..., min_length=1, max_length=255, description="名称")
    description: Optional[str] = Field(None, description="描述")
    status: str = Field(default="draft", description="状态")


class FeatureCreate(FeatureBase):
    """创建请求"""
    pass


class FeatureUpdate(BaseModel):
    """更新请求"""
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    description: Optional[str] = None
    status: Optional[str] = None


class FeatureResponse(FeatureBase):
    """响应模型"""
    id: int
    user_id: Optional[int] = None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class FeatureListResponse(BaseModel):
    """列表项模型"""
    id: int
    name: str
    status: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class PaginatedResponse(BaseModel):
    """分页响应"""
    data: list
    total: int
    page: int
    per_page: int
    last_page: int


class SuccessResponse(BaseModel):
    """通用成功响应"""
    success: bool = True
    message: str = "Success"
    data: Optional[dict | list] = None
```

## 嵌套模型

```python
# app/schemas/order.py
from typing import List, Optional
from pydantic import BaseModel, Field


class OrderItemSchema(BaseModel):
    """订单项"""
    id: int
    product_name: str
    quantity: int
    price: float

    model_config = ConfigDict(from_attributes=True)


class OrderSchema(BaseModel):
    """订单"""
    id: int
    order_no: str
    customer_name: str
    total_amount: float
    status: str
    items: List[OrderItemSchema] = []

    model_config = ConfigDict(from_attributes=True)


class OrderCreate(BaseModel):
    """创建订单"""
    customer_name: str = Field(..., min_length=1)
    items: List[dict] = Field(..., min_length=1)

    model_config = {
        "json_schema_extra": {
            "example": {
                "customer_name": "张三",
                "items": [
                    {"product_id": 1, "quantity": 2},
                    {"product_id": 2, "quantity": 1},
                ]
            }
        }
    }
```

## 验证器

```python
# app/schemas/user.py
from pydantic import BaseModel, Field, field_validator
import re


class UserCreate(BaseModel):
    """用户创建"""
    username: str = Field(..., min_length=3, max_length=50)
    email: str = Field(..., regex=r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
    password: str = Field(..., min_length=6)
    age: int = Field(..., ge=0, le=150)

    @field_validator("password")
    @classmethod
    def validate_password(cls, v: str) -> str:
        if not re.search(r"[A-Z]", v):
            raise ValueError("Password must contain uppercase letter")
        if not re.search(r"[a-z]", v):
            raise ValueError("Password must contain lowercase letter")
        if not re.search(r"\d", v):
            raise ValueError("Password must contain digit")
        return v

    @field_validator("username")
    @classmethod
    def validate_username(cls, v: str) -> str:
        if not re.match(r"^[a-zA-Z0-9_]+$", v):
            raise ValueError("Username must be alphanumeric")
        return v.lower()


class UserResponse(BaseModel):
    """用户响应"""
    id: int
    username: str
    email: str
    is_active: bool

    model_config = ConfigDict(from_attributes=True)
```

## 注意事项

- 使用 `Field()` 定义验证规则
- 使用 `model_config = ConfigDict(from_attributes=True)` 适配 ORM
- 使用 `@field_validator` 自定义验证
- 分离 `Create`、`Update`、`Response` 模型