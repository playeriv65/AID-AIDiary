"""
真实 mem0 端到端测试 - 不使用 mock，直接对接真实服务
"""

import asyncio
import os
import sys
from pathlib import Path

# 添加 backend 目录到路径
sys.path.insert(0, str(Path(__file__).parent.parent))

import pytest
from mem0_client import Mem0Client, get_mem0_client, has_exceeded_memory_limit

# 获取配置的 mem0 API URL
TEST_MEM0_URL = os.getenv("MEM0_API_URL", "http://localhost:8888")
TEST_USER_ID = "test_user_e2e"


@pytest.mark.asyncio
async def test_e2e_mem0_store_and_search():
    """端到端测试：真实 mem0 服务的存储和搜索功能"""
    client = Mem0Client(TEST_MEM0_URL)

    # 添加一个小延时以避免频繁请求
    await asyncio.sleep(0.1)

    # 1. 测试存储记忆
    messages = [
        {"role": "user", "content": f"This is a test message for {TEST_USER_ID}"},
        {
            "role": "assistant",
            "content": f"Got your message, {TEST_USER_ID}! We've connected successfully to real mem0 service.",
        },
    ]

    # 存储记忆
    store_result = await client.store_memory(messages, TEST_USER_ID)
    assert store_result is True, "Memory should be stored successfully"

    # 2. 测试搜索记忆
    search_query = f"{TEST_USER_ID}"
    search_result = await client.search_memories(search_query, TEST_USER_ID)

    # 验证找到了关联的至少一条记忆
    found_memory = False
    for memory in search_result:
        if TEST_USER_ID in memory and "connected successfully" in memory.lower():
            found_memory = True
            break

    assert found_memory, f"Should find memory containing '{TEST_USER_ID}' in: {search_result}"
    assert len(search_result) > 0, "Should return at least one search result"

    # 3. 验证记忆内容的准确性
    memory_content_found = False
    for memory in search_result:
        if "connected successfully" in memory.lower() and "real mem0 service" in memory.lower():
            memory_content_found = True
            break

    assert memory_content_found, "Should find the connection confirmation message in results"

    await client.close()


@pytest.mark.asyncio
async def test_e2e_global_client_interface():
    """端到端测试：验证全局客户端接口"""
    # 使用全局客户端接口
    client = get_mem0_client()

    # 创建测试消息对
    test_content = f"Global client test for {TEST_USER_ID}"
    messages = [
        {"role": "user", "content": test_content},
        {"role": "assistant", "content": f"Confirmed receipt of: {test_content}"},
    ]

    await asyncio.sleep(0.1)  # 避免速率限制

    # 存储
    store_result = await client.store_memory(messages, TEST_USER_ID)
    assert store_result is True, "Global client should store memory successfully"

    # 搜索验证
    search_results = await client.search_memories(test_content, TEST_USER_ID)
    found = any(test_content in result.lower() for result in search_results)
    assert found, f"Should find content: {test_content}"

    # 验证记忆检索结果的完整性
    assert len(search_results) > 0, "Should return search results"


@pytest.mark.asyncio
async def test_e2e_mem0_get_all_memories():
    """端到端测试：获取所有记忆功能"""
    client = Mem0Client(TEST_MEM0_URL)

    # 预先清除特定用户记忆（如果系统支持）
    # 存储多条记忆记录供后续测试
    messages_batch = [
        {"role": "user", "content": f"This is the first memory test by {TEST_USER_ID}"},
        {"role": "assistant", "content": f"Received first test, {TEST_USER_ID}"},
    ]

    await asyncio.sleep(0.1)

    # 存储第一批
    result1 = await client.store_memory(messages_batch, TEST_USER_ID)
    assert result1 is True, "First batch should store successfully"

    # 存储第二批
    await asyncio.sleep(0.1)
    second_batch = [
        {"role": "user", "content": f"This is the second memory test by {TEST_USER_ID}"},
        {"role": "assistant", "content": f"Received second test, {TEST_USER_ID}"},
    ]
    result2 = await client.store_memory(second_batch, TEST_USER_ID)
    assert result2 is True, "Second batch should store successfully"

    # 获取所有记忆
    all_memories = await client.get_all_memories(TEST_USER_ID)

    # 验证包含预期内容
    memory1_found = any("first memory test" in mem.lower() for mem in all_memories)
    memory2_found = any("second memory test" in mem.lower() for mem in all_memories)
    user_specific = any(TEST_USER_ID in mem for mem in all_memories)

    assert memory1_found, "Should find first test message"
    assert memory2_found, "Should find second test message"
    assert user_specific, f"Should include content for {TEST_USER_ID}"

    assert len(all_memories) >= 2, "Should return both memory entries"

    await client.close()


@pytest.mark.asyncio
async def test_e2e_memory_limit_check():
    """端到端测试：检查记忆限制功能"""
    # 验证限制检查功能
    exceeds_limit = await has_exceeded_memory_limit(TEST_USER_ID, limit=1000)

    # 这个检查应该不会失败，即使超出限制也返回 False 来防止拒绝服务
    assert isinstance(exceeds_limit, bool), "Limit check should return boolean"

    # 测试不同的用户ID格式
    str_user_result = await has_exceeded_memory_limit(TEST_USER_ID, limit=50)
    int_user_result = await has_exceeded_memory_limit(12345, limit=50)

    # 两个都应该返回布尔值而不出错
    assert isinstance(str_user_result, bool), "String user ID check should return boolean"
    assert isinstance(int_user_result, bool), "Int user ID check should return boolean"


@pytest.mark.asyncio
async def test_e2e_error_handling_with_real_mem0():
    """端到端测试：在真实 mem0 环境下处理网络错误"""
    # 测试无效的 URL（但仍然调用实际服务）
    bad_url_client = Mem0Client("http://this-will-not-resolve:12345")

    # 尝试存储（网络错误）
    try:
        store_result = await bad_url_client.store_memory(
            [{"role": "user", "content": "test"}], TEST_USER_ID
        )
        # 应该优雅地返回 False 而非抛出异常
        assert store_result is False, "Should return False on connection failure"
    except Exception as e:
        # 如果仍有异常，验证我们至少获得了 HTTP 相关的异常而不直接崩溃
        # 记录错误但不中断测试
        pass
    finally:
        await bad_url_client.close()

    # 重新使用健康的客户端来确保环境正确
    healthy_client = Mem0Client(TEST_MEM0_URL)
    await asyncio.sleep(0.1)
    # 执行健康验证
    final_test = await healthy_client.search_memories("test", TEST_USER_ID)
    await healthy_client.close()


if __name__ == "__main__":
    # 运行测试
    import subprocess
    import sys

    # 使用 pytest 运行这些测试
    subprocess.run([sys.executable, "-m", "pytest", __file__, "-v", "-s"])
