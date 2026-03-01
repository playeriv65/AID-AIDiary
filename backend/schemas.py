from pydantic import BaseModel, ConfigDict, Field
from typing import Optional, List, Literal
from datetime import datetime


class JournalEntryBase(BaseModel):
    title: Optional[str] = None
    content: str
    category: Optional[str] = None
    weather: Optional[str] = None
    location: Optional[str] = None
    tags: Optional[List[str]] = None
    image: Optional[str] = None


class JournalEntryCreate(JournalEntryBase):
    id: str


class JournalEntryUpdate(BaseModel):
    title: Optional[str] = None
    content: Optional[str] = None
    category: Optional[str] = None
    weather: Optional[str] = None
    location: Optional[str] = None
    tags: Optional[List[str]] = None
    image: Optional[str] = None


class JournalEntry(BaseModel):
    id: str
    title: Optional[str] = None
    content: str
    category: Optional[str] = None
    weather: Optional[str] = None
    location: Optional[str] = None
    tags: Optional[List[str]] = None
    image: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


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

    model_config = ConfigDict(from_attributes=True)


class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserOut


# AI Chat Schemas


class ChatMessage(BaseModel):
    role: Literal["user", "assistant"]
    content: str = Field(..., max_length=10000)


class ChatRequest(BaseModel):
    messages: List[ChatMessage] = Field(..., max_length=50)
    timezone: Optional[str] = None
    current_time: Optional[str] = None

class ChatResponse(BaseModel):
    response: str
    success: bool


class GenerateEntryRequest(BaseModel):
    messages: List[ChatMessage]
    timezone: Optional[str] = None
    current_time: Optional[str] = None


class GenerateEntryResponse(BaseModel):
    id: str
    title: str
    content: str
    tags: List[str]


# AI Service Response Validation Schemas


class AIPolishResult(BaseModel):
    polished_text: str = ""
    tags: List[str] = []


class AIGenerateResult(BaseModel):
    title: str = "无题"
    content: str = ""
    tags: List[str] = []
