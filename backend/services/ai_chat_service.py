"""AI chat service for conversation handling."""

import asyncio
import json
import logging
from collections.abc import AsyncGenerator

from openai import APIConnectionError, APIStatusError, AuthenticationError, RateLimitError

logger = logging.getLogger(__name__)


async def chat_with_ai(messages: list[dict[str, str]], user_id: str | int | None = None) -> dict:
    """与 AI 进行对话

    Args:
        messages: 对话消息列表
        user_id: 用户 ID（可选，用于记忆功能）

    Returns:
        AI 响应字典
    """
    # Import at runtime to allow test patching
    import ai_service

    # 存储当前对话到记忆
    if user_id:
        from services.memory_service import _store_conversation_to_memory

        await _store_conversation_to_memory(messages, user_id)

    # 构建系统提示词
    from services.memory_service import _build_system_prompt

    system_prompt = await _build_system_prompt(messages, user_id)

    try:
        full_messages = [{"role": "system", "content": system_prompt}] + messages

        response = ai_service.client.chat.completions.create(
            model=ai_service.MODEL_NAME,
            messages=full_messages,  # type: ignore
            temperature=ai_service.AI_TEMPERATURE,
            top_p=ai_service.AI_TOP_P,
            max_tokens=ai_service.AI_MAX_TOKENS_CHAT,
        )

        return {"response": response.choices[0].message.content, "success": True}
    except APIConnectionError as e:
        logger.warning("AI service connection failed: %s", str(e)[:100])
        return {
            "response": "抱歉，我现在脑瓜有点嗡嗡的，过会再跟我聊吧...",
            "success": False,
        }
    except AuthenticationError as e:
        logger.error("AI service authentication failed: %s", str(e)[:100])
        return {
            "response": "抱歉，我现在脑瓜有点嗡嗡的，过会再跟我聊吧...",
            "success": False,
        }
    except RateLimitError as e:
        logger.warning("AI service rate limited: %s", str(e)[:100])
        return {
            "response": "抱歉，我现在脑瓜有点嗡嗡的，过会再跟我聊吧...",
            "success": False,
        }
    except APIStatusError as e:
        logger.error("AI service error: status=%d", e.status_code)
        return {
            "response": "抱歉，我现在脑瓜有点嗡嗡的，过会再跟我聊吧...",
            "success": False,
        }
    except Exception:
        logger.exception("Unexpected error in chat_with_ai")
        return {
            "response": "抱歉，我现在脑瓜有点嗡嗡的，过会再跟我聊吧...",
            "success": False,
        }


async def stream_chat_with_ai(
    messages: list[dict[str, str]], user_id: str | int | None = None
) -> AsyncGenerator[str]:
    """与 AI 进行流式对话

    Args:
        messages: 对话消息列表
        user_id: 用户 ID（可选，用于记忆功能）

    Yields:
        SSE 格式的响应流

    Raises:
        HTTPException: 连接级错误（认证失败、连接失败等）
    """
    from fastapi import HTTPException

    import ai_service

    if user_id:
        from services.memory_service import _store_conversation_to_memory

        await _store_conversation_to_memory(messages, user_id)

    from services.memory_service import _build_system_prompt

    system_prompt = await _build_system_prompt(messages, user_id)

    first_chunk_sent = False
    response = None

    try:
        full_messages = [{"role": "system", "content": system_prompt}] + messages

        response = ai_service.client.chat.completions.create(
            model=ai_service.MODEL_NAME,
            messages=full_messages,
            temperature=ai_service.AI_TEMPERATURE,
            top_p=ai_service.AI_TOP_P,
            max_tokens=ai_service.AI_MAX_TOKENS_STREAM,
            stream=True,
        )

        for chunk in response:
            if not getattr(chunk, "choices", None):
                continue
            if chunk.choices and len(chunk.choices) > 0:
                delta = chunk.choices[0].delta
                if delta and delta.content:
                    content = delta.content
                    first_chunk_sent = True
                    yield f"data: {json.dumps({'content': content})}\n\n"

        await asyncio.sleep(0)
        yield f"data: {json.dumps({'done': True})}\n\n"

    except TimeoutError as e:
        logger.error("AI stream timeout: %s", str(e)[:100])
        if not first_chunk_sent:
            raise HTTPException(status_code=504, detail="AI 服务响应超时，请重试")
        else:
            yield f"data: {json.dumps({'error': 'AI 服务响应超时，请重试'})}\n\n"
    except AuthenticationError as e:
        logger.error("AI stream authentication failed: %s", str(e)[:100])
        if not first_chunk_sent:
            raise HTTPException(status_code=401, detail="AI service authentication failed")
        else:
            yield f"data: {json.dumps({'error': '认证失败，请检查 API 配置'})}\n\n"
    except APIConnectionError as e:
        logger.warning("AI stream connection failed: %s", str(e)[:100])
        if not first_chunk_sent:
            raise HTTPException(status_code=503, detail="AI service unavailable")
        else:
            yield f"data: {json.dumps({'error': 'AI 服务连接失败'})}\n\n"
    except RateLimitError as e:
        logger.warning("AI stream rate limited: %s", str(e)[:100])
        if not first_chunk_sent:
            raise HTTPException(status_code=429, detail="AI service rate limit exceeded")
        else:
            yield f"data: {json.dumps({'error': '请求过于频繁，请稍后再试'})}\n\n"
    except APIStatusError as e:
        logger.error("AI stream error: status=%d", e.status_code)
        if not first_chunk_sent:
            raise HTTPException(status_code=502, detail="AI service error")
        else:
            yield f"data: {json.dumps({'error': 'AI 服务异常'})}\n\n"
    except Exception:
        logger.exception("Unexpected error in stream_chat_with_ai")
        if not first_chunk_sent:
            raise HTTPException(status_code=500, detail="Internal server error")
        else:
            yield f"data: {json.dumps({'error': '服务器内部错误'})}\n\n"
