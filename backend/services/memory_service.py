"""Memory service for managing conversation history with mem0."""

import logging

import prompts

logger = logging.getLogger(__name__)

MEMORY_SEARCH_LIMIT = 3

# OpenAI Function Calling schema for search_memories
SEARCH_MEMORIES_TOOL = {
    "type": "function",
    "function": {
        "name": "search_memories",
        "description": "搜索用户记忆，当用户提及过往内容或需要历史信息时调用",
        "parameters": {
            "type": "object",
            "properties": {
                "query": {"type": "string", "description": "搜索查询，用于匹配记忆内容"},
                "limit": {"type": "integer", "description": "返回的记忆数量", "default": 3},
            },
            "required": ["query"],
        },
    },
}


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
    """构建系统提示词，包含记忆上下文"""
    memory_context = ""
    if user_id:
        memory_context = await _get_memory_context(messages, user_id)

    system_prompt = prompts.get_chat_system_prompt()
    if memory_context:
        memory_template = prompts.get_chat_memory_template()
        system_prompt = (
            f"{system_prompt}\n\n{memory_template.format(memory_context=memory_context)}"
        )
    return system_prompt
