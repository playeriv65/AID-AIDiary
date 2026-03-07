
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

import crud
from database import get_db
from schemas import (
    ConversationCreate,
    ConversationListItem,
    ConversationResponse,
    ConversationUpdate,
    MessageCreate,
    MessageResponse,
)
from services.auth_service import get_current_user

router = APIRouter(prefix="/api/conversations", tags=["conversations"])


@router.get("", response_model=list[ConversationListItem])
async def list_conversations(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user),
):
    """获取当前用户的所有对话列表"""
    conversations = crud.get_user_conversations(
        db=db, user_id=current_user.id, skip=skip, limit=limit
    )
    return conversations


@router.post("", response_model=ConversationResponse)
async def create_conversation(
    conversation_data: ConversationCreate,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user),
):
    """创建新对话"""
    db_conversation = crud.create_conversation(
        db=db,
        user_id=current_user.id,
        title=conversation_data.title,
    )

    return ConversationResponse(
        id=db_conversation.id,
        user_id=db_conversation.user_id,
        title=db_conversation.title,
        is_archived=db_conversation.is_archived,
        created_at=db_conversation.created_at,
        updated_at=db_conversation.updated_at,
        messages=[],
    )


@router.get("/{conversation_id}", response_model=ConversationResponse)
async def get_conversation(
    conversation_id: str,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user),
):
    """获取单个对话及其所有消息"""
    conversation = crud.get_conversation_with_messages(
        db=db, conversation_id=conversation_id, user_id=current_user.id
    )

    if not conversation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="对话不存在")

    if conversation.user_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权访问此对话")

    return conversation


@router.delete("/{conversation_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_conversation(
    conversation_id: str,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user),
):
    """删除对话（软删除）"""
    conversation = crud.get_conversation(db=db, conversation_id=conversation_id)

    if not conversation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="对话不存在")

    if conversation.user_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权访问此对话")

    crud.delete_conversation(db=db, conversation_id=conversation_id)
    return None


@router.patch("/{conversation_id}", response_model=ConversationResponse)
async def update_conversation(
    conversation_id: str,
    conversation_data: ConversationUpdate,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user),
):
    """更新对话（标题/归档）"""
    conversation = crud.get_conversation(db=db, conversation_id=conversation_id)

    if not conversation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="对话不存在")

    if conversation.user_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权访问此对话")

    db_conversation = crud.update_conversation(
        db=db,
        conversation_id=conversation_id,
        title=conversation_data.title,
        is_archived=conversation_data.is_archived,
    )

    messages = crud.get_messages(db=db, conversation_id=conversation_id)
    message_responses = [
        MessageResponse(
            id=msg.id,
            conversation_id=msg.conversation_id,
            role=msg.role,
            content=msg.content,
            created_at=msg.created_at,
        )
        for msg in messages
    ]

    return ConversationResponse(
        id=db_conversation.id,
        user_id=db_conversation.user_id,
        title=db_conversation.title,
        is_archived=db_conversation.is_archived,
        created_at=db_conversation.created_at,
        updated_at=db_conversation.updated_at,
        messages=message_responses,
    )


@router.post("/{conversation_id}/messages", response_model=MessageResponse)
async def add_message(
    conversation_id: str,
    message_data: MessageCreate,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user),
):
    """向对话添加消息"""
    conversation = crud.get_conversation(db=db, conversation_id=conversation_id)

    if not conversation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="对话不存在")

    if conversation.user_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="无权访问此对话")

    # 如果是第一条消息，自动生成标题
    messages_count = crud.get_messages_count(db=db, conversation_id=conversation_id)
    title = conversation.title

    if messages_count == 0 and message_data.role == "user" and not title:
        # 使用第一条用户消息的前 50 字作为标题
        title = message_data.content[:50]
        crud.update_conversation(db=db, conversation_id=conversation_id, title=title)

    db_message = crud.create_message(
        db=db,
        conversation_id=conversation_id,
        role=message_data.role,
        content=message_data.content,
    )

    return MessageResponse(
        id=db_message.id,
        conversation_id=db_message.conversation_id,
        role=db_message.role,
        content=db_message.content,
        created_at=db_message.created_at,
    )
