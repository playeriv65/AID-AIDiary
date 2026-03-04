"""测试 mem0 记忆集成"""

from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from ai_service import (
    _get_memory_context,
    _store_conversation_to_memory,
    chat_with_ai,
    stream_chat_with_ai,
)
from mem0_client import Mem0Client


class TestMem0Client:
    """测试 mem0 客户端"""

    @pytest.mark.asyncio
    async def test_store_memory_success(self):
        """测试成功存储记忆"""
        with patch("mem0_client.httpx.AsyncClient") as mock_async_client:
            mock_response = MagicMock()
            mock_response.raise_for_status = MagicMock()

            mock_client_instance = MagicMock()
            mock_client_instance.post = AsyncMock(return_value=mock_response)
            mock_async_client.return_value = mock_client_instance

            client = Mem0Client("http://localhost:8888")
            result = await client.store_memory(
                [{"role": "user", "content": "test message"}], "user_123"
            )

            assert result is True

    @pytest.mark.asyncio
    async def test_store_memory_failure(self):
        """测试存储记忆失败"""
        import httpx

        with patch("mem0_client.httpx.AsyncClient") as mock_async_client:
            mock_client_instance = MagicMock()
            mock_client_instance.post = AsyncMock(side_effect=httpx.HTTPError("Connection error"))
            mock_async_client.return_value = mock_client_instance

            client = Mem0Client("http://localhost:8888")
            result = await client.store_memory([{"role": "user", "content": "test"}], "user_123")

            assert result is False

    @pytest.mark.asyncio
    async def test_search_memories_success(self):
        """测试搜索记忆"""
        with patch("mem0_client.httpx.AsyncClient") as mock_async_client:
            mock_response = MagicMock()
            mock_response.json.return_value = {
                "results": [
                    {"memory": "User likes coffee"},
                    {"memory": "User went to gym"},
                ]
            }
            mock_response.raise_for_status = MagicMock()

            mock_client_instance = MagicMock()
            mock_client_instance.post = AsyncMock(return_value=mock_response)
            mock_async_client.return_value = mock_client_instance

            client = Mem0Client("http://localhost:8888")
            memories = await client.search_memories("coffee", "user_123", limit=5)

            assert len(memories) == 2
            assert "coffee" in memories[0]

    @pytest.mark.asyncio
    async def test_search_memories_empty(self):
        """测试搜索无结果"""
        import httpx

        with patch("mem0_client.httpx.AsyncClient") as mock_async_client:
            mock_client_instance = MagicMock()
            mock_client_instance.post = AsyncMock(side_effect=httpx.HTTPError("Not found"))
            mock_async_client.return_value = mock_client_instance

            client = Mem0Client("http://localhost:8888")
            memories = await client.search_memories("query", "user_123")

            assert memories == []

    @pytest.mark.asyncio
    async def test_get_all_memories(self):
        """测试获取所有记忆"""
        with patch("mem0_client.httpx.AsyncClient") as mock_async_client:
            mock_response = MagicMock()
            mock_response.json.return_value = {
                "results": [
                    {"memory": "Memory 1"},
                    {"memory": "Memory 2"},
                ]
            }
            mock_response.raise_for_status = MagicMock()

            mock_client_instance = MagicMock()
            mock_client_instance.get = AsyncMock(return_value=mock_response)
            mock_async_client.return_value = mock_client_instance

            client = Mem0Client("http://localhost:8888")
            memories = await client.get_all_memories("user_123")

            assert len(memories) == 2


class TestMemoryIntegration:
    """测试记忆集成到 AI 服务"""

    @pytest.mark.asyncio
    async def test_store_conversation_to_memory(self):
        """测试存储对话到记忆"""
        with patch("ai_service.get_mem0_client") as mock_get_client:
            mock_client = MagicMock()
            mock_client.store_memory = AsyncMock(return_value=True)
            mock_get_client.return_value = mock_client

            messages = [
                {"role": "user", "content": "Hello"},
                {"role": "assistant", "content": "Hi there!"},
            ]

            await _store_conversation_to_memory(messages, "user_123")

            mock_client.store_memory.assert_called_once_with(messages, "user_123")

    @pytest.mark.asyncio
    async def test_get_memory_context(self):
        """测试获取记忆上下文"""
        with patch("ai_service.get_mem0_client") as mock_get_client:
            mock_client = MagicMock()
            mock_client.search_memories = AsyncMock(
                return_value=["User likes coffee", "User works at tech company"]
            )
            mock_get_client.return_value = mock_client

            messages = [{"role": "user", "content": "What do I like?"}]
            context = await _get_memory_context(messages, "user_123")

            assert "coffee" in context
            assert "tech company" in context

    @pytest.mark.asyncio
    async def test_get_memory_context_no_user_message(self):
        """测试无用户消息时的记忆检索"""
        messages = [{"role": "assistant", "content": "Hello"}]

        context = await _get_memory_context(messages, "user_123")

        assert context == ""

    @pytest.mark.asyncio
    async def test_chat_with_ai_with_memory(self):
        """测试带记忆的 AI 对话"""
        with (
            patch("ai_service.get_mem0_client") as mock_get_client,
            patch("ai_service.client") as mock_openai,
        ):
            # Mock mem0 client
            mock_mem0 = MagicMock()
            mock_mem0.store_memory = AsyncMock(return_value=True)
            mock_mem0.search_memories = AsyncMock(return_value=["User likes Python"])
            mock_get_client.return_value = mock_mem0

            # Mock OpenAI client
            mock_response = MagicMock()
            mock_response.choices = [MagicMock(message=MagicMock(content="You like Python!"))]
            mock_openai.chat.completions.create.return_value = mock_response

            result = await chat_with_ai(
                [{"role": "user", "content": "What do I like?"}], user_id="user_123"
            )

            assert result["success"] is True
            assert "Python" in result["response"]

            # Verify memory was stored and searched
            mock_mem0.store_memory.assert_called_once()
            mock_mem0.search_memories.assert_called_once()

    @pytest.mark.asyncio
    async def test_chat_with_ai_no_user_id(self):
        """测试无 user_id 时正常工作（向后兼容）"""
        with patch("ai_service.client") as mock_openai:
            mock_response = MagicMock()
            mock_response.choices = [MagicMock(message=MagicMock(content="AI response"))]
            mock_openai.chat.completions.create.return_value = mock_response

            result = await chat_with_ai([{"role": "user", "content": "Hello"}])

            assert result["success"] is True
            assert result["response"] == "AI response"

    @pytest.mark.asyncio
    async def test_memory_failure_does_not_break_chat(self):
        """测试 mem0 失败不影响聊天"""
        with (
            patch("ai_service.get_mem0_client") as mock_get_client,
            patch("ai_service.client") as mock_openai,
        ):
            # Mock mem0 client to fail
            mock_mem0 = MagicMock()
            mock_mem0.store_memory = AsyncMock(side_effect=Exception("mem0 error"))
            mock_mem0.search_memories = AsyncMock(side_effect=Exception("mem0 error"))
            mock_get_client.return_value = mock_mem0

            # Mock OpenAI client
            mock_response = MagicMock()
            mock_response.choices = [MagicMock(message=MagicMock(content="AI response"))]
            mock_openai.chat.completions.create.return_value = mock_response

            result = await chat_with_ai([{"role": "user", "content": "Hello"}], user_id="user_123")

            # Chat should still work
            assert result["success"] is True
            assert result["response"] == "AI response"

    @pytest.mark.asyncio
    async def test_stream_chat_with_memory(self):
        """测试流式对话带记忆"""
        with (
            patch("ai_service.get_mem0_client") as mock_get_client,
            patch("ai_service.client") as mock_openai,
        ):
            # Mock mem0 client
            mock_mem0 = MagicMock()
            mock_mem0.store_memory = AsyncMock(return_value=True)
            mock_mem0.search_memories = AsyncMock(return_value=["User data"])
            mock_get_client.return_value = mock_mem0

            # Mock OpenAI streaming
            mock_openai.chat.completions.create.return_value = iter(
                [MagicMock(choices=[MagicMock(delta=MagicMock(content="Hi"))])]
            )

            chunks = []
            async for chunk in stream_chat_with_ai(
                [{"role": "user", "content": "Hello"}], user_id="user_123"
            ):
                chunks.append(chunk)

            assert len(chunks) > 0
            mock_mem0.store_memory.assert_called_once()

    @pytest.mark.asyncio
    async def test_memory_search_limit(self):
        """测试记忆搜索限制"""
        with patch("ai_service.get_mem0_client") as mock_get_client:
            mock_client = MagicMock()
            # Return more than limit
            mock_client.search_memories = AsyncMock(
                return_value=["Memory 1", "Memory 2", "Memory 3", "Memory 4"]
            )
            mock_get_client.return_value = mock_client

            messages = [{"role": "user", "content": "test"}]
            await _get_memory_context(messages, "user_123")

            # Verify limit=3 was passed (MEMORY_SEARCH_LIMIT)
            mock_client.search_memories.assert_called_once()
            call_args = mock_client.search_memories.call_args
            assert call_args[1]["limit"] == 3
