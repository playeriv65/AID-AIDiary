"""mem0 客户端 - 用于管理用户对话记忆"""

import logging

import httpx

from config import settings

logger = logging.getLogger(__name__)


class Mem0Client:
    """mem0 记忆服务客户端"""

    def __init__(self, base_url: str | None = None):
        """初始化 mem0 客户端

        Args:
            base_url: mem0 API 地址，默认使用配置中的 mem0_api_url
        """
        self.base_url = (base_url or settings.mem0_api_url).rstrip("/")
        self._client = None

    @property
    def client(self) -> httpx.AsyncClient:
        """获取 HTTP 客户端（懒加载）"""
        if self._client is None:
            self._client = httpx.AsyncClient(timeout=10.0)
        return self._client

    async def close(self) -> None:
        """关闭 HTTP 客户端"""
        if self._client:
            await self._client.aclose()
            self._client = None

    async def store_memory(self, messages: list[dict[str, str]], user_id: str | int) -> bool:
        """存储对话消息到 mem0

        Args:
            messages: 对话消息列表，格式为 [{"role": "user/assistant", "content": "..."}]
            user_id: 用户 ID

        Returns:
            是否存储成功
        """
        try:
            payload = {
                "messages": messages,
                "user_id": str(user_id),
            }

            response = await self.client.post(f"{self.base_url}/memories", json=payload)
            response.raise_for_status()
            logger.debug("Successfully stored %d messages for user %s", len(messages), user_id)
            return True

        except httpx.HTTPError as e:
            logger.warning("Failed to store memory for user %s: %s", user_id, str(e)[:100])
            return False
        except Exception as e:
            logger.warning("Unexpected error storing memory: %s", str(e)[:100])
            return False

    async def search_memories(self, query: str, user_id: str | int, limit: int = 5) -> list[str]:
        """搜索相关记忆

        Args:
            query: 搜索查询内容
            user_id: 用户 ID
            limit: 返回结果数量限制

        Returns:
            相关记忆内容列表
        """
        try:
            payload = {
                "query": query,
                "user_id": str(user_id),
            }

            response = await self.client.post(f"{self.base_url}/search", json=payload)
            response.raise_for_status()

            data = response.json()
            memories = []

            if isinstance(data, list):
                memories = [m.get("memory", "") for m in data if m.get("memory")]
            elif isinstance(data, dict):
                # 处理可能的嵌套结构
                results = data.get("results", data.get("memories", []))
                memories = [m.get("memory", "") for m in results if m.get("memory")]

            return memories[:limit]

        except httpx.HTTPError as e:
            logger.warning("Failed to search memories for user %s: %s", user_id, str(e)[:100])
            return []
        except Exception as e:
            logger.warning("Unexpected error searching memories: %s", str(e)[:100])
            return []

    async def get_all_memories(self, user_id: str | int) -> list[str]:
        """获取用户的所有记忆

        Args:
            user_id: 用户 ID

        Returns:
            所有记忆内容列表
        """
        try:
            response = await self.client.get(
                f"{self.base_url}/memories", params={"user_id": str(user_id)}
            )
            response.raise_for_status()

            data = response.json()
            memories = []

            if isinstance(data, list):
                memories = [m.get("memory", "") for m in data if m.get("memory")]
            elif isinstance(data, dict):
                results = data.get("results", data.get("memories", []))
                memories = [m.get("memory", "") for m in results if m.get("memory")]

            return memories

        except httpx.HTTPError as e:
            logger.warning("Failed to get memories for user %s: %s", user_id, str(e)[:100])
            return []
        except Exception as e:
            logger.warning("Unexpected error getting memories: %s", str(e)[:100])
            return []


# 全局客户端实例（懒加载）
_client = None


def get_mem0_client() -> Mem0Client:
    """获取 mem0 客户端实例（懒加载）"""
    global _client
    if _client is None:
        _client = Mem0Client()
    return _client


async def cleanup_mem0_client() -> None:
    """清理 mem0 客户端连接（应用关闭时调用）"""
    global _client
    if _client is not None:
        await _client.close()
        _client = None


async def has_exceeded_memory_limit(user_id: str | int, limit: int = 1000) -> bool:
    """检查用户记忆数量是否超过限制

    Args:
        user_id: 用户 ID
        limit: 记忆数量限制

    Returns:
        是否超过限制
    """
    try:
        mem0_client = get_mem0_client()
        memories = await mem0_client.get_all_memories(user_id)
        return len(memories) >= limit
    except Exception as e:
        logger.warning("Failed to check memory limit for user %s: %s", user_id, str(e)[:100])
        return False  # 失败时返回 False，阻止拒绝服务
