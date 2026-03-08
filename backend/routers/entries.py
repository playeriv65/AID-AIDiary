import json

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

import crud
import models
import schemas
from database import get_db
from services.auth_service import get_current_user

router = APIRouter()


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
        "deleted": entry.deleted,
        "created_at": entry.created_at,
        "updated_at": entry.updated_at,
    }


@router.get("/api/entries")
def read_entries(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    user_id_val = int(current_user.id)  # type: ignore
    entries = crud.get_entries(db, user_id=user_id_val, skip=skip, limit=limit)
    return [serialize_entry(e) for e in entries]


@router.post("/api/entries")
def create_entry(
    entry: schemas.JournalEntryCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    user_id_val = int(current_user.id)  # type: ignore
    db_entry = crud.create_entry(db=db, entry=entry, user_id=user_id_val)
    return serialize_entry(db_entry)


@router.get("/api/entries/{entry_id}")
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


@router.put("/api/entries/{entry_id}")
def update_entry(
    entry_id: str,
    entry: schemas.JournalEntryUpdate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    user_id_val = int(current_user.id)  # type: ignore
    db_entry = crud.update_entry(db, entry_id=entry_id, entry=entry, user_id=user_id_val)
    if db_entry is None:
        raise HTTPException(status_code=404, detail="Entry not found")
    return serialize_entry(db_entry)


@router.delete("/api/entries/{entry_id}")
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
