# 数据库配置

## MySQL 连接信息

| 配置项 | 值 |
|--------|-----|
| 主机 | localhost |
| 端口 | 3306 |
| 用户名 | test |
| 密码 | test |
| 数据库名 | fastapi_db |

## Python 配置

```python
# config.py
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DB_HOST: str = "localhost"
    DB_PORT: int = 3306
    DB_USER: str = "test"
    DB_PASSWORD: str = "test"
    DB_NAME: str = "fastapi_db"

    @property
    def DATABASE_URL(self) -> str:
        return f"mysql+aiomysql://{self.DB_USER}:{self.DB_PASSWORD}@{self.DB_HOST}:{self.DB_PORT}/{self.DB_NAME}"

settings = Settings()
```

## .env 文件

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=test
DB_PASSWORD=test
DB_NAME=fastapi_db
```

## SQLAlchemy 配置

```python
# app/core/database.py
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker

DATABASE_URL = f"mysql+aiomysql://{settings.DB_USER}:{settings.DB_PASSWORD}@{settings.DB_HOST}:{settings.DB_PORT}/{settings.DB_NAME}"

engine = create_async_engine(DATABASE_URL, echo=True)
async_session_maker = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
```

## MySQL 连接测试

```bash
mysql -h localhost -P 3306 -u test -p fastapi_db
```

## 常用命令

```bash
# 创建数据库
mysql -u test -p -e "CREATE DATABASE fastapi_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 查看数据库
SHOW DATABASES;

# 使用数据库
USE fastapi_db;

# 查看表
SHOW TABLES;
```