import json
import os
import uuid
from pathlib import Path
from typing import List, Optional

from fastapi import FastAPI, Depends, HTTPException, UploadFile, File
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session
import asyncio

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
async def ai_polish(
    request: schemas.AIPolishRequest,
    current_user: models.User = Depends(get_current_user),
):
    result = await generate_polished_entry(request.content)
    return result


@app.post("/api/ai/chat", response_model=schemas.ChatResponse)
async def ai_chat(
    request: schemas.ChatRequest,
    current_user: models.User = Depends(get_current_user),
):
    messages = [{"role": msg.role, "content": msg.content} for msg in request.messages]
    result = await chat_with_ai(messages)
    return result
