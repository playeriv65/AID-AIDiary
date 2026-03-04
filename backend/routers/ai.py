import logging
import uuid

from fastapi import APIRouter, Depends, HTTPException, Request
from fastapi.responses import StreamingResponse
from jose import jwt
from slowapi import Limiter
from slowapi.util import get_remote_address
from sqlalchemy.orm import Session

import crud
import models
import schemas
from ai_service import chat_with_ai, generate_entry_from_chat, stream_chat_with_ai
from config import settings
from database import get_db
from services.auth_service import get_current_user

logger = logging.getLogger(__name__)
ALGORITHM = "HS256"
SECRET_KEY = settings.secret_key


def get_rate_limit_key(request: Request) -> str:
    """Extract user_id from auth token for rate limiting."""
    auth_header = request.headers.get("Authorization", "")
    if auth_header.startswith("Bearer "):
        token = auth_header[7:]
        try:
            payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
            user_id = payload.get("sub")
            if user_id:
                return f"user:{user_id}"
        except jwt.JWTError:
            pass
    return f"ip:{get_remote_address(request)}"


limiter = Limiter(key_func=get_rate_limit_key)
router = APIRouter()


@router.post("/api/ai/chat", response_model=schemas.ChatResponse)
@limiter.limit("10/minute")
async def ai_chat(
    chat_request: schemas.ChatRequest,
    request: Request,
    current_user: models.User = Depends(get_current_user),
):
    messages = [{"role": msg.role, "content": msg.content} for msg in chat_request.messages]
    user_id = int(current_user.id)  # type: ignore
    result = await chat_with_ai(messages, user_id)
    return result


@router.post("/api/ai/chat/stream")
@limiter.limit("30/minute")
async def ai_chat_stream(
    chat_request: schemas.ChatRequest,
    request: Request,
    current_user: models.User = Depends(get_current_user),
):
    messages = [{"role": msg.role, "content": msg.content} for msg in chat_request.messages]
    user_id = int(current_user.id)  # type: ignore
    return StreamingResponse(
        stream_chat_with_ai(messages, user_id),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
        },
    )


@router.post("/api/ai/generate-entry", response_model=schemas.GenerateEntryResponse)
@limiter.limit("10/minute")
async def ai_generate_entry(
    entry_request: schemas.GenerateEntryRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    messages = [{"role": msg.role, "content": msg.content} for msg in entry_request.messages]
    result = await generate_entry_from_chat(
        messages, timezone=entry_request.timezone, current_time=entry_request.current_time
    )

    if not result.get("content"):
        logger.error("AI failed to generate entry content")
        raise HTTPException(status_code=502, detail="AI 生成失败，请重试")

    try:
        entry_id = str(uuid.uuid4())
        user_id_val = int(current_user.id)  # type: ignore
        entry_data = schemas.JournalEntryCreate(
            id=entry_id,
            title=result["title"],
            content=result["content"],
            tags=result["tags"],
        )
        db_entry = crud.create_entry(db=db, entry=entry_data, user_id=user_id_val)
        return {
            "id": db_entry.id,
            "title": result["title"],
            "content": result["content"],
            "tags": result["tags"],
        }
    except Exception as e:
        logger.exception("Failed to save AI-generated entry")
        raise HTTPException(
            status_code=500,
            detail="日记生成成功但保存失败，请手动保存",
        ) from e
