from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

import crud
import schemas
from database import get_db
from services.auth_service import (
    blacklist_token,
    create_access_token,
    create_refresh_token,
    hash_password,
    refresh_access_token,
    verify_password,
)

router = APIRouter()


@router.post("/api/auth/register", response_model=schemas.TokenResponse)
def register(data: schemas.UserRegister, db: Session = Depends(get_db)):
    existing = crud.get_user_by_username(db, data.username)
    if existing:
        raise HTTPException(status_code=400, detail="Username already taken")
    user = crud.create_user(db, data, hash_password(data.password))
    access_token = create_access_token({"sub": str(user.id), "username": user.username})
    refresh_token = create_refresh_token({"sub": str(user.id), "username": user.username})
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "refresh_token": refresh_token,
        "user": user,
    }


@router.post("/api/auth/login", response_model=schemas.TokenResponse)
def login(data: schemas.UserLogin, db: Session = Depends(get_db)):
    user = crud.get_user_by_username(db, data.username)
    if not user or not verify_password(data.password, str(user.hashed_password)):
        raise HTTPException(status_code=401, detail="Invalid username or password")
    access_token = create_access_token({"sub": str(user.id), "username": user.username})
    refresh_token = create_refresh_token({"sub": str(user.id), "username": user.username})
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "refresh_token": refresh_token,
        "user": user,
    }


@router.post("/api/auth/refresh", response_model=schemas.TokenResponse)
def refresh(data: schemas.TokenRefreshRequest, db: Session = Depends(get_db)):
    """刷新访问令牌

    使用 refresh token 获取新的 access token 和 refresh token。
    旧的 refresh token 会被撤销（加入黑名单）。
    """
    new_access_token, new_refresh_token = refresh_access_token(data.refresh_token)

    # 从新 token 中提取 user_id
    from jose import JWTError, jwt

    from config import settings

    try:
        payload = jwt.decode(new_access_token, settings.secret_key, algorithms=["HS256"])
        user_id_str = payload.get("sub")
        if user_id_str is None:
            raise HTTPException(status_code=401, detail="Invalid token")
        user_id = int(user_id_str)
    except (JWTError, ValueError):
        raise HTTPException(status_code=401, detail="Invalid token")

    user = crud.get_user_by_id(db, user_id)
    if user is None:
        raise HTTPException(status_code=401, detail="User not found")

    return {
        "access_token": new_access_token,
        "token_type": "bearer",
        "refresh_token": new_refresh_token,
        "user": user,
    }


@router.post("/api/auth/logout")
def logout(data: schemas.TokenRefreshRequest):
    """登出用户

    将 refresh token 加入黑名单，使其无法再用于刷新 access token。
    注意：此接口不会使当前的 access token 立即失效，
          因为 JWT 是无状态的。建议客户端删除本地存储的 token。
    """
    blacklist_token(data.refresh_token)
    return {"message": "Successfully logged out"}
