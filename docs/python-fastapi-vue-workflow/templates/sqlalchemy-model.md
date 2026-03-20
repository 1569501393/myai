# SQLAlchemy Model 模板

## 基础模型定义

```python
# app/core/database.py
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase

DATABASE_URL = "mysql+aiomysql://test:test@localhost:3306/fastapi_db"

engine = create_async_engine(DATABASE_URL, echo=True)
async_session_maker = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


class Base(DeclarativeBase):
    pass


async def get_db():
    async with async_session_maker() as session:
        try:
            yield session
        finally:
            await session.close()
```

## 标准 Model

```python
# app/models/feature.py
from datetime import datetime
from typing import Optional, List
from sqlalchemy import String, Text, ForeignKey, Enum, Index
from sqlalchemy.orm import Mapped, mapped_column, relationship
import enum

from app.core.database import Base


class FeatureStatus(str, enum.Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"
    DRAFT = "draft"


class Feature(Base):
    __tablename__ = "features"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(255), unique=True, nullable=False)
    description: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    status: Mapped[str] = mapped_column(
        Enum(FeatureStatus),
        default=FeatureStatus.DRAFT,
        nullable=False,
    )
    user_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True,
    )
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
    )

    # Relationships
    user: Mapped[Optional["User"]] = relationship("User", back_populates="features")
    items: Mapped[List["FeatureItem"]] = relationship(
        "FeatureItem",
        back_populates="feature",
        cascade="all, delete-orphan",
    )

    __table_args__ = (
        Index("idx_status", "status"),
        Index("idx_user_id", "user_id"),
    )

    def __repr__(self) -> str:
        return f"<Feature(id={self.id}, name={self.name})>"
```

## Model Repository

```python
# app/repositories/feature.py
from sqlalchemy import select, update, delete
from sqlalchemy.ext.asyncio import AsyncSession
from typing import Optional, List

from app.models.feature import Feature, FeatureStatus
from app.schemas.feature import FeatureCreate, FeatureUpdate


class FeatureRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_by_id(self, feature_id: int) -> Optional[Feature]:
        result = await self.db.execute(
            select(Feature).where(Feature.id == feature_id)
        )
        return result.scalar_one_or_none()

    async def get_list(
        self,
        page: int = 1,
        per_page: int = 15,
        status: Optional[str] = None,
    ) -> tuple[List[Feature], int]:
        query = select(Feature)
        count_query = select(Feature)

        if status:
            query = query.where(Feature.status == status)
            count_query = count_query.where(Feature.status == status)

        # Total count
        count_result = await self.db.execute(count_query)
        total = len(count_result.scalars().all())

        # Paginated results
        query = query.offset((page - 1) * per_page).limit(per_page)
        result = await self.db.execute(query)

        return result.scalars().all(), total

    async def create(self, data_in: FeatureCreate) -> Feature:
        feature = Feature(**data_in.model_dump())
        self.db.add(feature)
        await self.db.commit()
        await self.db.refresh(feature)
        return feature

    async def update(self, feature_id: int, data_in: FeatureUpdate) -> Optional[Feature]:
        feature = await self.get_by_id(feature_id)
        if not feature:
            return None

        update_data = data_in.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(feature, key, value)

        await self.db.commit()
        await self.db.refresh(feature)
        return feature

    async def delete(self, feature_id: int) -> bool:
        result = await self.db.execute(
            delete(Feature).where(Feature.id == feature_id)
        )
        await self.db.commit()
        return result.rowcount > 0
```

## Service 层

```python
# app/services/feature.py
from typing import Optional, List, Dict
from sqlalchemy.ext.asyncio import AsyncSession

from app.repositories.feature import FeatureRepository
from app.schemas.feature import FeatureCreate, FeatureUpdate


class FeatureService:
    def __init__(self, db: AsyncSession):
        self.repository = FeatureRepository(db)

    async def get_by_id(self, feature_id: int) -> Optional[Dict]:
        feature = await self.repository.get_by_id(feature_id)
        if feature:
            return {
                "id": feature.id,
                "name": feature.name,
                "description": feature.description,
                "status": feature.status,
                "created_at": feature.created_at.isoformat(),
            }
        return None

    async def get_list(
        self,
        page: int = 1,
        per_page: int = 15,
        status: Optional[str] = None,
    ) -> Dict:
        features, total = await self.repository.get_list(
            page=page,
            per_page=per_page,
            status=status,
        )

        return {
            "data": [
                {
                    "id": f.id,
                    "name": f.name,
                    "status": f.status,
                    "created_at": f.created_at.isoformat(),
                }
                for f in features
            ],
            "total": total,
            "page": page,
            "per_page": per_page,
            "last_page": (total + per_page - 1) // per_page,
        }

    async def create(self, data_in: FeatureCreate) -> Dict:
        feature = await self.repository.create(data_in)
        return {"id": feature.id, "name": feature.name}

    async def update(self, feature_id: int, data_in: FeatureUpdate) -> Optional[Dict]:
        feature = await self.repository.update(feature_id, data_in)
        if feature:
            return {"id": feature.id, "name": feature.name}
        return None

    async def delete(self, feature_id: int) -> bool:
        return await self.repository.delete(feature_id)
```

## 注意事项

- 使用 `Mapped` 和 `mapped_column` 类型提示 (SQLAlchemy 2.0)
- 使用 `async/await` 异步操作
- 分离 Repository 和 Service 层
- 使用 Index 优化查询性能