from sqlalchemy.orm import Session
import models, schemas
import datetime

def get_entry(db: Session, entry_id: int):
    return db.query(models.JournalEntry).filter(models.JournalEntry.id == entry_id).first()

def get_entries(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.JournalEntry).order_by(models.JournalEntry.created_at.desc()).offset(skip).limit(limit).all()

def create_entry(db: Session, entry: schemas.JournalEntryCreate):
    db_entry = models.JournalEntry(title=entry.title, content=entry.content)
    db.add(db_entry)
    db.commit()
    db.refresh(db_entry)
    return db_entry

def update_entry(db: Session, entry_id: int, entry: schemas.JournalEntryUpdate):
    db_entry = get_entry(db, entry_id)
    if db_entry:
        if entry.title is not None:
            db_entry.title = entry.title
        if entry.content is not None:
            db_entry.content = entry.content
        db_entry.updated_at = datetime.datetime.utcnow()
        db.commit()
        db.refresh(db_entry)
    return db_entry

def delete_entry(db: Session, entry_id: int):
    db_entry = get_entry(db, entry_id)
    if db_entry:
        db.delete(db_entry)
        db.commit()
    return db_entry
