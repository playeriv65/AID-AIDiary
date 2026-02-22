from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class JournalEntryBase(BaseModel):
    title: Optional[str] = None
    content: str

class JournalEntryCreate(JournalEntryBase):
    pass

class JournalEntryUpdate(JournalEntryBase):
    pass

class JournalEntry(JournalEntryBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

# AI Features

class AIPolishRequest(BaseModel):
    content: str

class AIPolishResponse(BaseModel):
    polished_text: str
    tags: List[str]

# Auth Schemas

class UserRegister(BaseModel):
    username: str
    password: str
    email: Optional[str] = None

class UserLogin(BaseModel):
    username: str
    password: str

class UserOut(BaseModel):
    id: int
    username: str
    email: Optional[str] = None
    class Config:
        from_attributes = True

class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserOut
