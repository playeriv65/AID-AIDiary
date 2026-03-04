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
            max_tokens=ai_service.AI_MAX_TOKENS_STREAM,
            stream=True,
        )

        for chunk in response:  # type: ignore[union-attr]
            if not getattr(chunk, "choices", None):
                continue
            if chunk.choices and len(chunk.choices) > 0:  # type: ignore[union-attr]
                delta = chunk.choices[0].delta  # type: ignore[union-attr]
                if delta and delta.content:
                    content = delta.content
                    yield f"data: {json.dumps({'content': content})}\n\n"
        # 刷新输出缓冲，确保立即发送
        await asyncio.sleep(0)

        yield f"data: {json.dumps({'done': True})}\n\n"
    except APIConnectionError as e:
        logger.warning("AI stream connection failed: %s", str(e)[:100])
        yield f"data: {json.dumps({'error': '抱歉，我现在有点走神了，等会再跟我说好吗...'})}\n\n"
    except AuthenticationError as e:
        logger.error("AI stream authentication failed: %s", str(e)[:100])
        yield f"data: {json.dumps({'error': '抱歉，我现在有点走神了，等会再跟我说好吗...'})}\n\n"
    except RateLimitError as e:
        logger.warning("AI stream rate limited: %s", str(e)[:100])
        yield f"data: {json.dumps({'error': '抱歉，我现在有点走神了，等会再跟我说好吗...'})}\n\n"
    except APIStatusError as e:
        logger.error("AI stream error: status=%d", e.status_code)
        yield f"data: {json.dumps({'error': '抱歉，我现在有点走神了，等会再跟我说好吗...'})}\n\n"
    except Exception:
        logger.exception("Unexpected error in stream_chat_with_ai")
        yield f"data: {json.dumps({'error': '抱歉，我现在有点走神了，等会再跟我说好吗...'})}\n\n"
