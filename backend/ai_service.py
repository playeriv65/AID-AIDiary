"""AI service - re-export layer for backward compatibility.

This file serves as a thin re-export layer to maintain backward compatibility
with existing imports and test patches. The actual implementation has been moved
to the services/ subdirectory.
"""

# Re-export AI client components
# Re-export mem0 client for test compatibility
from mem0_client import get_mem0_client

# Re-export chat service
from services.ai_chat_service import chat_with_ai, stream_chat_with_ai
from services.ai_client import (
    AI_MAX_TOKENS_CHAT,
    AI_MAX_TOKENS_GENERATE,
    AI_MAX_TOKENS_STREAM,
    AI_TEMPERATURE,
    AI_TOP_P,
    ERROR_MSG_AUTH,
    ERROR_MSG_NETWORK,
    ERROR_MSG_PARSE,
    ERROR_MSG_RATE_LIMIT,
    ERROR_MSG_UNKNOWN,
    MODEL_NAME,
    _ClientProxy,
    get_client,
)

# Re-export diary service
from services.ai_diary_service import generate_entry_from_chat

# Re-export memory service components
from services.memory_service import (
    MEMORY_SEARCH_LIMIT,
    SYSTEM_PROMPT,
    _build_system_prompt,
    _get_memory_context,
    _store_conversation_to_memory,
)

# Create client proxy instance at module level for test patching
# This ensures patch("ai_service.client") continues to work
client = _ClientProxy()

__all__ = [
    "MODEL_NAME",
    "_ClientProxy",
    "client",
    "get_client",
    "AI_TEMPERATURE",
    "AI_TOP_P",
    "AI_MAX_TOKENS_CHAT",
    "AI_MAX_TOKENS_GENERATE",
    "AI_MAX_TOKENS_STREAM",
    "ERROR_MSG_NETWORK",
    "ERROR_MSG_AUTH",
    "ERROR_MSG_RATE_LIMIT",
    "ERROR_MSG_PARSE",
    "ERROR_MSG_UNKNOWN",
    "MEMORY_SEARCH_LIMIT",
    "SYSTEM_PROMPT",
    "_build_system_prompt",
    "_get_memory_context",
    "_store_conversation_to_memory",
    "chat_with_ai",
    "stream_chat_with_ai",
    "generate_entry_from_chat",
    "get_mem0_client",
]
