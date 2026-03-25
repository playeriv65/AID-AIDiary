from datetime import UTC, datetime, timedelta
from typing import Final

import bcrypt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import JWTError, jwt
from sqlalchemy.orm import Session

import crud
import models
from config import settings
from database import get_db

SECURITY_ALGORITHM: Final = "HS256"

if not settings.secret_key:
    raise ValueError("SECRET_KEY environment variable is required")

SECRET_KEY: Final = settings.secret_key
ALGORITHM: Final = "HS256"


security = HTTPBearer()


class TokenBlacklist:
    """Token 黑名单管理（内存实现）

    用于存储已登出的 token，防止它们被再次使用。
    注意：内存实现不适合分布式部署，重启服务后会清空。
    """

    _blacklisted: set[str] = set()

    @classmethod
    def add(cls, token: str) -> None:
        """将 token 添加到黑名单"""
        cls._blacklisted.add(token)

    @classmethod
    def is_blacklisted(cls, token: str) -> bool:
        """检查 token 是否在黑名单中"""
        return token in cls._blacklisted

    @classmethod
    def clear(cls) -> None:
        """清空黑名单（主要用于测试）"""
        cls._blacklisted.clear()


def verify_password(plain: str, hashed: str) -> bool:
    return bcrypt.checkpw(plain.encode("utf-8"), hashed.encode("utf-8"))


def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")


def create_access_token(data: dict) -> str:
    """创建访问令牌

    Args:
        data: 要编码到 token 中的数据（至少包含 'sub' 字段）

    Returns:
        编码后的 JWT token
    """
    to_encode = data.copy()
    expire = datetime.now(UTC) + timedelta(minutes=settings.access_token_expire_minutes)
    to_encode.update({"exp": expire, "type": "access"})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def create_refresh_token(data: dict) -> str:
    """创建刷新令牌

    刷新令牌有效期更长，用于获取新的访问令牌。

    Args:
        data: 要编码到 token 中的数据（至少包含 'sub' 字段）

    Returns:
        编码后的 JWT refresh token
    """
    to_encode = data.copy()
    expire = datetime.now(UTC) + timedelta(days=settings.refresh_token_expire_days)
    to_encode.update({"exp": expire, "type": "refresh"})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def refresh_access_token(refresh_token: str) -> tuple[str, str]:
    """使用刷新令牌获取新的访问令牌

    Args:
        refresh_token: 有效的刷新令牌

    Returns:
        (新的访问令牌, 新的刷新令牌)

    Raises:
        HTTPException: 刷新令牌无效或已过期
    """
    try:
        payload = jwt.decode(refresh_token, SECRET_KEY, algorithms=[ALGORITHM])
        token_type = payload.get("type")
        user_id_str = payload.get("sub")

        if token_type != "refresh" or user_id_str is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid refresh token",
            )

        if TokenBlacklist.is_blacklisted(refresh_token):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Refresh token has been revoked",
            )

        user_id = int(user_id_str)
        username = payload.get("username", "")

        # 将旧的 refresh token 加入黑名单
        TokenBlacklist.add(refresh_token)

        # 生成新的 access token 和 refresh token
        new_access_token = create_access_token({"sub": str(user_id), "username": username})
        new_refresh_token = create_refresh_token({"sub": str(user_id), "username": username})

        return new_access_token, new_refresh_token

    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid refresh token",
        )


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db),
) -> models.User:
    """获取当前认证用户

    从 JWT token 中解析用户信息并验证。

    Args:
        credentials: HTTP Bearer 认证凭据
        db: 数据库会话

    Returns:
        当前认证的用户对象

    Raises:
        HTTPException: token 无效、已过期或在黑名单中
    """
    token = credentials.credentials

    # 检查 token 是否在黑名单中
    if TokenBlacklist.is_blacklisted(token):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token has been revoked",
        )

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        token_type = payload.get("type")
        user_id_str = payload.get("sub")

        if token_type != "access" or user_id_str is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication credentials",
            )

        user_id = int(user_id_str)
    except (JWTError, ValueError):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
        )

    user = crud.get_user_by_id(db, user_id)
    if user is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found")
    return user


def blacklist_token(token: str) -> None:
    """将 token 加入黑名单

    Args:
        token: 要加入黑名单的 token
    """
    TokenBlacklist.add(token)


def is_token_blacklisted(token: str) -> bool:
    """检查 token 是否在黑名单中

    Args:
        token: 要检查的 token

    Returns:
        如果在黑名单中返回 True，否则返回 False
    """
    return TokenBlacklist.is_blacklisted(token)
