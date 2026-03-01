import json
import os
import uuid
from pathlib import Path
from typing import List, Optional

from fastapi import FastAPI, Depends, HTTPException, UploadFile, File, Request
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session
import asyncio
from jose import jwt
from slowapi import Limiter
from slowapi.util import get_remote_address
from slowapi.middleware import SlowAPIMiddleware

import crud
import models
import schemas
from ai_service import (
    chat_with_ai,
    generate_entry_from_chat,
    generate_polished_entry,
    stream_chat_with_ai,
)
from auth import (
    create_access_token,
    get_current_user,
    hash_password,
    verify_password,
)
from database import SessionLocal, engine, get_db
from config import settings

SECRET_KEY = settings.secret_key
ALGORITHM = "HS256"


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
        except:
            pass
    return f"ip:{get_remote_address(request)}"


limiter = Limiter(key_func=get_rate_limit_key)

UPLOAD_DIR = Path(settings.upload_dir)
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="AID-AIDiary Backend")

app.mount("/static", StaticFiles(directory=str(UPLOAD_DIR.parent)), name="static")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.state.limiter = limiter
app.add_middleware(SlowAPIMiddleware)


def serialize_entry(entry: models.JournalEntry) -> dict:
    tags = None
    entry_tags = getattr(entry, "tags", None)
    if entry_tags:
        if isinstance(entry_tags, str):
            tags = json.loads(entry_tags)
        elif isinstance(entry_tags, list):
            tags = entry_tags
    return {
        "id": entry.id,
        "user_id": entry.user_id,
        "title": entry.title,
        "content": entry.content,
        "category": entry.category,
        "weather": entry.weather,
        "location": entry.location,
        "tags": tags,
        "image": entry.image,
        "created_at": entry.created_at,
        "updated_at": entry.updated_at,
    }


@app.get("/")
def read_root():
    return {"message": "Welcome to the AID-AIDiary API"}


@app.get("/api/entries")
def read_entries(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    user_id_val = int(current_user.id)  # type: ignore
    entries = crud.get_entries(db, user_id=user_id_val, skip=skip, limit=limit)
    return [serialize_entry(e) for e in entries]


@app.post("/api/entries")
def create_entry(
    entry: schemas.JournalEntryCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    user_id_val = int(current_user.id)  # type: ignore
    db_entry = crud.create_entry(db=db, entry=entry, user_id=user_id_val)
    return serialize_entry(db_entry)


@app.get("/api/entries/{entry_id}")
def read_entry(
    entry_id: str,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    user_id_val = int(current_user.id)  # type: ignore
    db_entry = crud.get_entry(db, entry_id, user_id=user_id_val)
    if db_entry is None:
        raise HTTPException(status_code=404, detail="Entry not found")
    return serialize_entry(db_entry)


@app.put("/api/entries/{entry_id}")
def update_entry(
    entry_id: str,
    entry: schemas.JournalEntryUpdate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    user_id_val = int(current_user.id)  # type: ignore
    db_entry = crud.update_entry(
        db, entry_id=entry_id, entry=entry, user_id=user_id_val
    )
    if db_entry is None:
        raise HTTPException(status_code=404, detail="Entry not found")
    return serialize_entry(db_entry)


@app.delete("/api/entries/{entry_id}")
def delete_entry(
    entry_id: str,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    user_id_val = int(current_user.id)  # type: ignore
    db_entry = crud.delete_entry(db, entry_id=entry_id, user_id=user_id_val)
    if db_entry is None:
        raise HTTPException(status_code=404, detail="Entry not found")
    return db_entry


@app.post("/api/upload")
async def upload_image(
    file: UploadFile = File(...),
    current_user: models.User = Depends(get_current_user),
):
    filename = file.filename or "photo.jpg"
    ext = filename.split(".")[-1] if "." in filename else "jpg"
    unique_filename = f"{uuid.uuid4()}.{ext}"
    filepath = UPLOAD_DIR / unique_filename

    content = await file.read()
    with open(filepath, "wb") as f:
        f.write(content)

    return {
        "filename": f"uploads/{unique_filename}",
        "url": f"/static/uploads/{unique_filename}",
    }


@app.post("/api/ai/polish", response_model=schemas.AIPolishResponse)
@limiter.limit("10/minute")
async def ai_polish(
    polish_request: schemas.AIPolishRequest,
    request: Request,
    current_user: models.User = Depends(get_current_user),
):
    result = await generate_polished_entry(polish_request.content)
    return result


@app.post("/api/ai/chat", response_model=schemas.ChatResponse)
@limiter.limit("10/minute")
async def ai_chat(
    chat_request: schemas.ChatRequest,
    request: Request,
    current_user: models.User = Depends(get_current_user),
):
    messages = [{"role": msg.role, "content": msg.content} for msg in chat_request.messages]
    result = await chat_with_ai(messages)
    return result

@app.post("/api/ai/chat/stream")
@limiter.limit("30/minute")
async def ai_chat_stream(
    chat_request: schemas.ChatRequest,
    request: Request,
    current_user: models.User = Depends(get_current_user),
):
    messages = [{"role": msg.role, "content": msg.content} for msg in chat_request.messages]
    return StreamingResponse(
        stream_chat_with_ai(messages),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
        },
    )


@app.post("/api/ai/generate-entry", response_model=schemas.GenerateEntryResponse)
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
    
    # Check if AI generation succeeded
    if not result.get("content"):
        logger.error("AI failed to generate entry content")
        raise HTTPException(status_code=502, detail="AI 生成失败，请重试")
    
    # Store in database with error handling
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
        return {"id": db_entry.id, "title": result["title"], "content": result["content"], "tags": result["tags"]}
    except Exception as e:
        logger.exception("Failed to save AI-generated entry")
        raise HTTPException(
            status_code=500,
            detail="日记生成成功但保存失败，请手动保存",
        ) from e


@app.post("/api/auth/register", response_model=schemas.TokenResponse)
def register(data: schemas.UserRegister, db: Session = Depends(get_db)):
    existing = (
        db.query(models.User).filter(models.User.username == data.username).first()
    )
    if existing:
        raise HTTPException(status_code=400, detail="Username already taken")
    user = models.User(
        username=data.username,
        email=data.email,
        hashed_password=hash_password(data.password),
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    token = create_access_token({"sub": str(user.id), "username": user.username})
    return {"access_token": token, "token_type": "bearer", "user": user}


@app.post("/api/auth/login", response_model=schemas.TokenResponse)
def login(data: schemas.UserLogin, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.username == data.username).first()
    if not user or not verify_password(data.password, str(user.hashed_password)):
        raise HTTPException(status_code=401, detail="Invalid username or password")
    token = create_access_token({"sub": str(user.id), "username": user.username})
    return {"access_token": token, "token_type": "bearer", "user": user}
