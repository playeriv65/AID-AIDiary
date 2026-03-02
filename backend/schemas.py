from datetime import datetime
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field


class JournalEntryBase(BaseModel):
    title: str | None = None
    content: str
    category: str | None = None
    weather: str | None = None
    location: str | None = None
    tags: list[str] | None = None
    image: str | None = None


class JournalEntryCreate(JournalEntryBase):
    id: str


class JournalEntryUpdate(BaseModel):
    title: str | None = None
    content: str | None = None
    category: str | None = None
    weather: str | None = None
    location: str | None = None
    tags: list[str] | None = None
    image: str | None = None


class JournalEntry(BaseModel):
    id: str
    title: str | None = None
    content: str
    category: str | None = None
    weather: str | None = None
    location: str | None = None
    tags: list[str] | None = None
    image: str | None = None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


# Auth Schemas


class UserRegister(BaseModel):
    username: str
    password: str
    email: str | None = None


class UserLogin(BaseModel):
    username: str
    password: str


class UserOut(BaseModel):
    id: int
    username: str
    email: str | None = None

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
    messages: list[ChatMessage] = Field(..., max_length=50)
    timezone: str | None = None
    current_time: str | None = None


class ChatResponse(BaseModel):
    response: str
    success: bool


class GenerateEntryRequest(BaseModel):
    messages: list[ChatMessage]
    timezone: str | None = None
    current_time: str | None = None


class GenerateEntryResponse(BaseModel):
    id: str
    title: str
    content: str
    tags: list[str]


class AIGenerateResult(BaseModel):
    title: str = "无题"
    content: str = ""
    tags: list[str] = []
