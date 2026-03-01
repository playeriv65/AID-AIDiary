import pytest
import asyncio
from unittest.mock import patch, MagicMock
from ai_service import (
    chat_with_ai,
    generate_entry_from_chat,
    generate_polished_entry,
    stream_chat_with_ai,
)


@pytest.fixture
def mock_openai_client():
    with patch("ai_service.client") as mock_client:
        yield mock_client


def test_chat_with_ai_success(mock_openai_client):
    """测试正常对话"""
    mock_response = MagicMock()
    mock_response.choices = [MagicMock(message=MagicMock(content="AI response"))]
    mock_openai_client.chat.completions.create.return_value = mock_response

    result = asyncio.run(chat_with_ai([{"role": "user", "content": "Hello"}]))

    assert result["response"] == "AI response"
    assert result["success"] is True


def test_chat_with_ai_empty_response(mock_openai_client):
    """测试空响应"""
    mock_response = MagicMock()
    mock_response.choices = [MagicMock(message=MagicMock(content=""))]
    mock_openai_client.chat.completions.create.return_value = mock_response

    result = asyncio.run(chat_with_ai([{"role": "user", "content": "Hello"}]))

    assert result["response"] == ""
    assert result["success"] is True


def test_chat_with_ai_exception(mock_openai_client):
    """测试异常"""
    mock_openai_client.chat.completions.create.side_effect = Exception("API Error")

    result = asyncio.run(chat_with_ai([{"role": "user", "content": "Hello"}]))

    assert "抱歉" in result["response"]
    assert result["success"] is False


def test_generate_entry_from_chat_success(mock_openai_client):
    """测试生成日记 - 成功"""
    mock_response = MagicMock()
    mock_response.choices = [
        MagicMock(
            message=MagicMock(
                content='{"title": "My Diary", "content": "Content here", "tags": ["tag1"]}'
            )
        )
    ]
    mock_openai_client.chat.completions.create.return_value = mock_response

    result = asyncio.run(
        generate_entry_from_chat([{"role": "user", "content": "Chat"}])
    )

    assert result["title"] == "My Diary"
    assert result["content"] == "Content here"
    assert result["tags"] == ["tag1"]
    assert result["success"] is True


def test_generate_entry_from_chat_no_title(mock_openai_client):
    """测试无标题"""
    mock_response = MagicMock()
    mock_response.choices = [
        MagicMock(message=MagicMock(content='{"title": "无题", "content": "Just content"}'))
    ]
    mock_openai_client.chat.completions.create.return_value = mock_response

    result = asyncio.run(
        generate_entry_from_chat([{"role": "user", "content": "Chat"}])
    )

    assert result["title"] == "无题"
    assert result["content"] == "Just content"

def test_generate_entry_from_chat_exception(mock_openai_client):
    """测试生成日记异常"""
    mock_openai_client.chat.completions.create.side_effect = Exception("Error")

    result = asyncio.run(
        generate_entry_from_chat([{"role": "user", "content": "Chat"}])
    )

    assert result["title"] == "日记生成失败"
    assert result["content"] == ""
    assert result["success"] is False


def test_generate_polished_entry_success(mock_openai_client):
    """测试润色 - JSON 格式"""
    mock_response = MagicMock()
    mock_response.choices = [
        MagicMock(
            message=MagicMock(
                content='{"polished_text": "Polished", "tags": ["happy"]}'
            )
        )
    ]
    mock_openai_client.chat.completions.create.return_value = mock_response

    result = asyncio.run(generate_polished_entry("Original"))

    assert result["polished_text"] == "Polished"
    assert result["tags"] == ["happy"]


def test_generate_polished_entry_invalid_json(mock_openai_client):
    """测试润色 - 非 JSON 响应（fallback）"""
    mock_response = MagicMock()
    mock_response.choices = [MagicMock(message=MagicMock(content="Not JSON"))]
    mock_openai_client.chat.completions.create.return_value = mock_response

    result = asyncio.run(generate_polished_entry("Original"))

    assert result["polished_text"] == "Original"
    assert result["tags"] == []


def test_generate_polished_entry_exception(mock_openai_client):
    """测试润色异常"""
    mock_openai_client.chat.completions.create.side_effect = Exception("API Error")

    result = asyncio.run(generate_polished_entry("Text"))

    assert result["polished_text"] == "Text"
    assert result["tags"] == ["Error"]


def test_generate_entry_from_chat_with_tags(mock_openai_client):
    """测试生成日记包含标签"""
    mock_response = MagicMock()
    mock_response.choices = [
        MagicMock(
            message=MagicMock(
                content='{"title": "Title", "content": "Content", "tags": ["tag1", "tag2"]}'
            )
        )
    ]
    mock_openai_client.chat.completions.create.return_value = mock_response

    result = asyncio.run(
        generate_entry_from_chat([{"role": "user", "content": "Chat"}])
    )

    assert result["title"] == "Title"
    assert "Content" in result["content"]
    assert "tag1" in result["tags"]
    assert "tag2" in result["tags"]


@pytest.mark.asyncio
async def test_stream_chat_with_ai_success(mock_openai_client):
    """测试流式对话 - 成功"""
    mock_response = iter(
        [
            MagicMock(choices=[MagicMock(delta=MagicMock(content="Hello"))]),
            MagicMock(choices=[MagicMock(delta=MagicMock(content=" World"))]),
            MagicMock(choices=[MagicMock(delta=MagicMock(content=None))]),
        ]
    )
    mock_openai_client.chat.completions.create.return_value = mock_response

    chunks = []
    async for chunk in stream_chat_with_ai([{"role": "user", "content": "Hi"}]):
        chunks.append(chunk)

    assert len(chunks) >= 2
    assert "Hello" in chunks[0]


@pytest.mark.asyncio
async def test_stream_chat_with_ai_exception(mock_openai_client):
    """测试流式对话 - 异常"""
    mock_openai_client.chat.completions.create.side_effect = Exception("API Error")

    chunks = []
    async for chunk in stream_chat_with_ai([{"role": "user", "content": "Hi"}]):
        chunks.append(chunk)

    assert len(chunks) == 1
    assert "error" in chunks[0]
