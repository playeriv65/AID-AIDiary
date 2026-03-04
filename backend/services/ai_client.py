"""AI client wrapper and configuration."""

from openai import OpenAI

from config import settings

_client = None


def get_client():
    """Lazy initialization of OpenAI client."""
    global _client
    if _client is None:
        api_key = settings.api_key
        if not api_key:
            api_key = "test-key"  # Allow tests to run without API key
        _client = OpenAI(
            api_key=api_key,
            base_url=settings.base_url,
        )
    return _client


class _ClientProxy:
    """Proxy for the OpenAI client that allows test patching."""

    def __getattr__(self, name):
        return getattr(get_client(), name)

    def __setattr__(self, name, value):
        global _client
        _client = value


# Create client proxy instance for use in services
_client_proxy = _ClientProxy()


# AI model configuration
MODEL_NAME = settings.model_name
AI_TEMPERATURE = 0.6  # Controls randomness: lower = more focused, higher = more creative
AI_TOP_P = 0.9  # Nucleus sampling threshold for token selection
AI_MAX_TOKENS_CHAT = 1024  # Max tokens for regular chat interactions
AI_MAX_TOKENS_GENERATE = 4096  # Max tokens for generating entries from chat
AI_MAX_TOKENS_STREAM = 4096  # Max tokens for streaming chat responses

# Error message constants
ERROR_MSG_NETWORK = "AI 服务暂时无法连接，请稍后再试"
ERROR_MSG_AUTH = "AI 服务认证失败，请联系管理员"
ERROR_MSG_RATE_LIMIT = "AI 请求过于频繁，请稍后再试"
ERROR_MSG_PARSE = "AI 响应解析失败"
ERROR_MSG_UNKNOWN = "AI 服务异常，请稍后再试"
