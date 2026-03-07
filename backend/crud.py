import json
from datetime import UTC, datetime

from sqlalchemy.orm import Session

import models
import schemas


def get_entry(db: Session, entry_id: str, user_id: int):
    return (
        db.query(models.JournalEntry)
        .filter(models.JournalEntry.id == entry_id, models.JournalEntry.user_id == user_id)
        .first()
    )


def get_entries(db: Session, user_id: int, skip: int = 0, limit: int = 100):
    return (
        db.query(models.JournalEntry)
        .filter(models.JournalEntry.user_id == user_id)
        .order_by(models.JournalEntry.created_at.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )


def create_entry(db: Session, entry: schemas.JournalEntryCreate, user_id: int):
    db_entry = models.JournalEntry(
        id=entry.id,
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


def update_entry(db: Session, entry_id: str, entry: schemas.JournalEntryUpdate, user_id: int):
    db_entry = get_entry(db, entry_id, user_id)
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
        db_entry.updated_at = datetime.now(UTC)
        db.commit()
        db.refresh(db_entry)
    return db_entry


def delete_entry(db: Session, entry_id: str, user_id: int):
    db_entry = get_entry(db, entry_id, user_id)
    if db_entry:
        db.delete(db_entry)
        db.commit()
    return db_entry


def get_user_by_id(db: Session, user_id: int):
    return db.query(models.User).filter(models.User.id == user_id).first()


def get_user_by_username(db: Session, username: str):
    return db.query(models.User).filter(models.User.username == username).first()


def create_user(db: Session, user: schemas.UserRegister, hashed_password: str):
    db_user = models.User(
        username=user.username,
        email=user.email,
        hashed_password=hashed_password,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


# Conversation CRUD


def get_conversation(db: Session, conversation_id: str):
    return db.query(models.Conversation).filter(models.Conversation.id == conversation_id).first()


def get_conversation_with_messages(db: Session, conversation_id: str, user_id: int):
    conversation = (
        db.query(models.Conversation)
        .filter(models.Conversation.id == conversation_id, models.Conversation.user_id == user_id)
        .first()
    )
    if conversation:
        messages = (
            db.query(models.Message)
            .filter(models.Message.conversation_id == conversation_id)
            .order_by(models.Message.created_at.asc())
            .all()
        )
        conversation.messages = messages
    return conversation


def get_user_conversations(db: Session, user_id: int, skip: int = 0, limit: int = 50):
    return (
        db.query(models.Conversation)
        .filter(
            models.Conversation.user_id == user_id,
            models.Conversation.is_archived.is_(False),
        )
        .order_by(models.Conversation.updated_at.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )


def create_conversation(db: Session, user_id: int, title: str | None = None):
    db_conversation = models.Conversation(user_id=user_id, title=title)
    db.add(db_conversation)
    db.commit()
    db.refresh(db_conversation)
    return db_conversation


def update_conversation(
    db: Session, conversation_id: str, title: str | None = None, is_archived: bool | None = None
):
    db_conversation = get_conversation(db, conversation_id)
    if db_conversation:
        if title is not None:
            db_conversation.title = title
        if is_archived is not None:
            db_conversation.is_archived = is_archived
        db_conversation.updated_at = datetime.now(UTC)
        db.commit()
        db.refresh(db_conversation)
    return db_conversation


def delete_conversation(db: Session, conversation_id: str):
    db_conversation = get_conversation(db, conversation_id)
    if db_conversation:
        db_conversation.is_archived = True
        db_conversation.updated_at = datetime.now(UTC)
        db.commit()
    return db_conversation


# Message CRUD


def get_messages(db: Session, conversation_id: str, skip: int = 0, limit: int = 100):
    return (
        db.query(models.Message)
        .filter(models.Message.conversation_id == conversation_id)
        .order_by(models.Message.created_at.asc())
        .offset(skip)
        .limit(limit)
        .all()
    )


def get_messages_count(db: Session, conversation_id: int):
    return (
        db.query(models.Message).filter(models.Message.conversation_id == conversation_id).count()
    )


def create_message(db: Session, conversation_id: str, role: str, content: str):
    db_message = models.Message(
        conversation_id=conversation_id,
        role=role,
        content=content,
    )
    db.add(db_message)
    db.commit()
    db.refresh(db_message)
    return db_message
