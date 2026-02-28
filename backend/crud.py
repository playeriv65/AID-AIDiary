from datetime import datetime, timezone
from sqlalchemy.orm import Session
import models, schemas
import json


def get_entry(db: Session, entry_id: str):
    return (
        db.query(models.JournalEntry).filter(models.JournalEntry.id == entry_id).first()
    )


def get_entries(db: Session, skip: int = 0, limit: int = 100):
    return (
        db.query(models.JournalEntry)
        .order_by(models.JournalEntry.created_at.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )


def create_entry(db: Session, entry: schemas.JournalEntryCreate, user_id: int):
    db_entry = models.JournalEntry(
        user_id=user_id,
        title=entry.title,
        content=entry.content,
        category=entry.category,
        weather=entry.weather,
        location=entry.location,
        tags=json.dumps(entry.tags) if entry.tags else None,
        image=entry.image,
    )
    db.add(db_entry)
    db.commit()
    db.refresh(db_entry)
    return db_entry


def update_entry(db: Session, entry_id: str, entry: schemas.JournalEntryUpdate):
    db_entry = get_entry(db, entry_id)
    if db_entry:
        if entry.title is not None:
            db_entry.title = entry.title
        if entry.content is not None:
            db_entry.content = entry.content
        if entry.category is not None:
            db_entry.category = entry.category
        if entry.weather is not None:
            db_entry.weather = entry.weather
        if entry.location is not None:
            db_entry.location = entry.location
        if entry.tags is not None:
            db_entry.tags = json.dumps(entry.tags)
        if entry.image is not None:
            db_entry.image = entry.image
        db_entry.updated_at = datetime.now(timezone.utc)
        db.commit()
        db.refresh(db_entry)
    return db_entry


def delete_entry(db: Session, entry_id: str):
    db_entry = get_entry(db, entry_id)
    if db_entry:
        db.delete(db_entry)
        db.commit()
    return db_entry
