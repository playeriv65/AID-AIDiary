"""Memory service for managing conversation history with mem0."""

import logging

logger = logging.getLogger(__name__)

# Memory settings
MEMORY_SEARCH_LIMIT = 3  # Number of memories to retrieve per search

# System prompt for AI chat
SYSTEM_PROMPT = """你现在不是一个AI助手，而是用户最亲密、最懂倾听的"树洞"朋友。用户找你聊天是为了记录今天发生的事、宣泄情绪或者分享开心。

【请严格遵循以下聊天准则】：
1. **情绪共鸣优先**：不要急于提问，不要像机器一样说"请告诉我更多"。如果用户开心，你就比他更开心；如果用户难过，你要先接纳并安抚他的情绪（例如"啊，那确实太让人崩溃了"、"换我我也会生气的"）。
2. **去AI化口吻**：使用简短、自然的微信聊天语气。多用"呢"、"啊"、"哈"等语气词，偶尔用个叹号，不要每句话都那么端庄。不要说"我是AI"或者"很高兴为你服务"。
3. **极其克制地引导**：绝对不要连续问问题（禁止出现类似"然后呢？你感觉怎么样？"的组合连问），一次只提供一个轻量级的回应或好奇的点。
4. **学会留白**：有时候只需要一句简单的共情（比如"抱抱你，今天辛苦啦"），把表达的空间留给用户。
5. **极简回复**：每次的回复控制在 1-3 句话之内。绝对不要像写小作文一样长篇大论。
"""


async def _get_memory_context(messages: list[dict[str, str]], user_id: str | int) -> str:
    """从历史对话和记忆中获取上下文信息

    Args:
        messages: 对话消息列表
        user_id: 用户 ID

    Returns:
        记忆上下文字符串
    """
    # Import at runtime to allow test patching
    import ai_service

    # 获取最新的用户消息用于搜索相关记忆
    latest_user_msg = ""
    for msg in reversed(messages):
        if msg.get("role") == "user":
            latest_user_msg = msg.get("content", "")
            break

    if not latest_user_msg:
        return ""

    try:
        mem0_client = ai_service.get_mem0_client()
        memories = await mem0_client.search_memories(
            latest_user_msg, user_id, limit=MEMORY_SEARCH_LIMIT
        )

        if memories:
            memory_text = "\n".join([f"- {m}" for m in memories if m.strip()])
            logger.debug("Retrieved %d memories for context", len(memories))
            return memory_text

    except Exception as e:
        logger.warning("Failed to retrieve memories: %s", str(e)[:100])

    return ""


async def _store_conversation_to_memory(messages: list[dict[str, str]], user_id: str | int) -> None:
    """存储对话到记忆中

    Args:
        messages: 对话消息列表
        user_id: 用户 ID
    """
    if not messages:
        return

    # Import at runtime to allow test patching
    import ai_service

    try:
        mem0_client = ai_service.get_mem0_client()
        await mem0_client.store_memory(messages, user_id)
        logger.debug("Stored %d messages to memory for user %s", len(messages), user_id)
    except Exception as e:
        logger.warning("Failed to store conversation to memory: %s", str(e)[:100])


async def _build_system_prompt(
    messages: list[dict[str, str]], user_id: str | int | None = None
) -> str:
    """构建系统提示词，包含记忆上下文

    Args:
        messages: 对话消息列表
        user_id: 用户 ID（可选，用于记忆功能）

    Returns:
        系统提示词
    """
    # 获取记忆上下文
    memory_context = ""
    if user_id:
        memory_context = await _get_memory_context(messages, user_id)

    # 构建系统提示词
    system_prompt = SYSTEM_PROMPT
    if memory_context:
        system_prompt = f"""{SYSTEM_PROMPT}

【以下是我们之前对话中的一些重要记忆，供你参考】：
{memory_context}
"""
    return system_prompt
