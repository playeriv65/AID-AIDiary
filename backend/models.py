from sqlalchemy import Column, Integer, String, Text, DateTime, Boolean, Index, desc
from database import Base
from datetime import datetime, timezone
import uuid


class JournalEntry(Base):
    __tablename__ = "journal_entries"

    id = Column(
        String(36), primary_key=True, index=True, default=lambda: str(uuid.uuid4())
    )
    user_id = Column(Integer, index=True, nullable=False)
    title = Column(String(200), nullable=True)
    content = Column(Text, nullable=False)
    category = Column(String(50), nullable=True, index=True)
    weather = Column(String(30), nullable=True, index=True)
    location = Column(String(100), nullable=True)
    tags = Column(String(500), nullable=True)
    image = Column(String(500), nullable=True)
    created_at = Column(
        DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), index=True
    )
    updated_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    __table_args__ = (
        Index("ix_journal_entries_user_created", "user_id", desc("created_at")),
    )


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(100), unique=True, index=True, nullable=False)
    email = Column(String(200), unique=True, index=True, nullable=True)
    hashed_password = Column(String(255), nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(
        DateTime(timezone=True), default=lambda: datetime.now(timezone.utc)
    )
