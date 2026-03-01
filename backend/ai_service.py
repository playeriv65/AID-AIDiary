import json
import asyncio
import logging
from datetime import datetime
from typing import List, Dict, AsyncGenerator, Any

from openai import (
    OpenAI,
    APIConnectionError,
    RateLimitError,
    AuthenticationError,
    APIStatusError,
)

from config import settings
from schemas import AIPolishResult, AIGenerateResult

# Configure logging
logger = logging.getLogger(__name__)

# Error message constants
ERROR_MSG_NETWORK = "AI 服务暂时无法连接，请稍后再试"
ERROR_MSG_AUTH = "AI 服务认证失败，请联系管理员"
ERROR_MSG_RATE_LIMIT = "AI 请求过于频繁，请稍后再试"
ERROR_MSG_PARSE = "AI 响应解析失败"
ERROR_MSG_UNKNOWN = "AI 服务异常，请稍后再试"

# Lazy client initialization - validates on first use
_client = None

def get_client():
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

# For backward compatibility with tests that patch 'ai_service.client'
class _ClientProxy:
    def __getattr__(self, name):
        return getattr(get_client(), name)
    def __setattr__(self, name, value):
        global _client
        _client = value

client = _ClientProxy()
MODEL_NAME = settings.model_name


# AI Model Configuration
AI_TEMPERATURE = (
    0.6  # Controls randomness: lower = more focused, higher = more creative
)
AI_TOP_P = 0.9  # Nucleus sampling threshold for token selection
AI_MAX_TOKENS_POLISH = 2048  # Max tokens for polishing diary entries
AI_MAX_TOKENS_CHAT = 1024  # Max tokens for regular chat interactions
AI_MAX_TOKENS_GENERATE = 4096  # Max tokens for generating entries from chat
AI_MAX_TOKENS_STREAM = 4096  # Max tokens for streaming chat responses


def _clean_json_string(text: str) -> dict:
    """清理并解析可能包含 Markdown 标记的 JSON 字符串"""
    try:
        text = text.strip()
        if text.startswith("```json"):
            text = text[7:]
        elif text.startswith("```"):
            text = text[3:]
        if text.endswith("```"):
            text = text[:-3]
        text = text.strip()
        return json.loads(text)
    except Exception as e:
        logger.warning("JSON parsing error: %s", str(e)[:100])
        return {}


async def generate_polished_entry(content: str) -> dict:
    """AI 润色日记内容：保留情绪与人情味，拒绝机械AI感"""
    system_prompt = """你是一个懂心理学、共情能力极强的日记润色助手。
    用户会提供一篇他们写的日记草稿。你的任务是：
    1. 优化语句的流畅度，但**绝对保留用户的原始情绪、事实和个人口吻**。不要把它改写成华丽空洞的AI散文。
    2. 像一个真实的人在写日记一样，保留那种真实的、带有烟火气或脆弱感的表达。避免"深刻感悟"、"受益匪浅"之类的套话。
    3. 根据内容提取 1-3 个贴切的标签（例如：'疲惫', '小确幸', '家庭', '自我内耗'）。

    请严格且仅返回以下格式的 JSON，不要包含任何额外的解释文本或 Markdown 代码块标记：
    {
    "polished_text": "润色后的日记内容（第一人称口吻）",
    "tags": ["标签1", "标签2"]
    }"""
    try:
        response = client.chat.completions.create(
            model=MODEL_NAME,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": f"Here is my rough draft:\n\n{content}"},
            ],
            temperature=AI_TEMPERATURE,
            top_p=AI_TOP_P,
            max_tokens=AI_MAX_TOKENS_POLISH,
        )

        result_content = response.choices[0].message.content or "{}"
        parsed_result = AIPolishResult.model_validate(
            _clean_json_string(result_content)
        )

        return {
            "polished_text": parsed_result.polished_text
            if parsed_result.polished_text
            else content,
            "tags": parsed_result.tags,
        }

    except APIConnectionError as e:
        logger.warning("AI service connection failed: %s", str(e)[:100])
        return {"polished_text": content, "tags": ["Error"]}
    except AuthenticationError as e:
        logger.error("AI service authentication failed: %s", str(e)[:100])
        return {"polished_text": content, "tags": ["Error"]}
    except RateLimitError as e:
        logger.warning("AI service rate limited: %s", str(e)[:100])
        return {"polished_text": content, "tags": ["Error"]}
    except APIStatusError as e:
        logger.error("AI service error: status=%d", e.status_code)
        return {"polished_text": content, "tags": ["Error"]}
    except Exception as e:
        logger.exception("Unexpected error in AI polish")
        return {"polished_text": content, "tags": ["Error"]}


async def generate_entry_from_chat(
    chat_history: List[Dict[str, str]],
    timezone: str | None = None,
    current_time: str | None = None,
) -> dict:
    """根据聊天内容生成日记：带有人情味的睡前碎碎念"""

    if current_time and timezone:
        time_info = f"当前时间：{current_time}（{timezone}）"
    elif current_time:
        time_info = f"当前时间：{current_time}"
    else:
        time_info = ""

    system_prompt = f"""
    你需要将我们刚才的对话，整理成一篇用户的第一人称日记。
    {time_info}

    【核心要求 - 告别机械的AI味】：
    1. **口吻与视角**：完全使用第一人称（"我"），想象你是一个在深夜回想今天经历了什么的普通现代人。
    2. **极其自然**：用词要生活化、口语化。不要用"今天阳光明媚"、"我深刻地感悟到"、"让我受益匪浅"这种小学生作文式的陈词滥调。
    3. **情绪真实**：保留对话中流露的喜怒哀乐、吐槽、疲惫或开心，适当加入一些内心OS（独白）。可以有点随意的碎碎念。
    4. **不过度升华**：不需要在日记结尾强行总结人生哲理，真实的生活往往是没有哲理的。
    5. 根据内容提取 1-3 个合适的标签。

    请严格且仅返回以下格式的 JSON，不要包含任何额外的解释文本或 Markdown 代码块标记：
    {{
    "title": "一个有灵魂的短标题，不要太呆板",
    "content": "整理后的第一人称日记正文，可以使用自然的分段",
    "tags": ["标签1", "标签2"]
    }}
    """
    try:
        messages = [{"role": "system", "content": system_prompt}]
        for msg in chat_history:
            messages.append(msg)
        messages.append(
            {"role": "user", "content": "请根据以上对话内容，帮我生成今天的日记。"}
        )

        response = client.chat.completions.create(
            model=MODEL_NAME,
            messages=messages,  # type: ignore
            temperature=AI_TEMPERATURE,
            top_p=AI_TOP_P,
            max_tokens=AI_MAX_TOKENS_GENERATE,
        )

        result_content = response.choices[0].message.content or "{}"
        parsed_result = AIGenerateResult.model_validate(
            _clean_json_string(result_content)
        )

        return {
            "title": parsed_result.title,
            "content": parsed_result.content,
            "tags": parsed_result.tags,
            "success": True,
        }
    except APIConnectionError as e:
        logger.warning("AI service connection failed: %s", str(e)[:100])
        return {"title": "日记生成失败", "content": "", "tags": ["Error"], "success": False}
    except AuthenticationError as e:
        logger.error("AI service authentication failed: %s", str(e)[:100])
        return {"title": "日记生成失败", "content": "", "tags": ["Error"], "success": False}
    except RateLimitError as e:
        logger.warning("AI service rate limited: %s", str(e)[:100])
        return {"title": "日记生成失败", "content": "", "tags": ["Error"], "success": False}
    except APIStatusError as e:
        logger.error("AI service error: status=%d", e.status_code)
        return {"title": "日记生成失败", "content": "", "tags": ["Error"], "success": False}
    except Exception as e:
        logger.exception("Unexpected error in generate_entry_from_chat")
        return {"title": "日记生成失败", "content": "", "tags": ["Error"], "success": False}


SYSTEM_PROMPT = """你现在不是一个AI助手，而是用户最亲密、最懂倾听的"树洞"朋友。用户找你聊天是为了记录今天发生的事、宣泄情绪或者分享开心。

【请严格遵循以下聊天准则】：
1. **情绪共鸣优先**：不要急于提问，不要像机器一样说"请告诉我更多"。如果用户开心，你就比他更开心；如果用户难过，你要先接纳并安抚他的情绪（例如"啊，那确实太让人崩溃了"、"换我我也会生气的"）。
2. **去AI化口吻**：使用简短、自然的微信聊天语气。多用"呢"、"啊"、"哈"等语气词，偶尔用个叹号，不要每句话都那么端庄。不要说"我是AI"或者"很高兴为你服务"。
3. **极其克制地引导**：绝对不要连续问问题（禁止出现类似"然后呢？你感觉怎么样？"的组合连问），一次只提供一个轻量级的回应或好奇的点。
4. **学会留白**：有时候只需要一句简单的共情（比如"抱抱你，今天辛苦啦"），把表达的空间留给用户。
5. **极简回复**：每次的回复控制在 1-3 句话之内。绝对不要像写小作文一样长篇大论。
"""


async def chat_with_ai(messages: List[Dict[str, str]]) -> dict:
    """与 AI 进行对话"""
    try:
        full_messages = [{"role": "system", "content": SYSTEM_PROMPT}] + messages

        response = client.chat.completions.create(
            model=MODEL_NAME,
            messages=full_messages,  # type: ignore
            temperature=AI_TEMPERATURE,
            top_p=AI_TOP_P,
            max_tokens=AI_MAX_TOKENS_CHAT,
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
    except Exception as e:
        logger.exception("Unexpected error in chat_with_ai")
        return {
            "response": "抱歉，我现在脑瓜有点嗡嗡的，过会再跟我聊吧...",
            "success": False,
        }


async def stream_chat_with_ai(
    messages: List[Dict[str, str]],
) -> AsyncGenerator[str, None]:
    """与 AI 进行流式对话"""
    try:
        full_messages = [{"role": "system", "content": SYSTEM_PROMPT}] + messages

        response = client.chat.completions.create(
            model=MODEL_NAME,
            messages=full_messages,  # type: ignore
            temperature=AI_TEMPERATURE,
            top_p=AI_TOP_P,
            max_tokens=AI_MAX_TOKENS_STREAM,
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
    except Exception as e:
        logger.exception("Unexpected error in stream_chat_with_ai")
        yield f"data: {json.dumps({'error': '抱歉，我现在有点走神了，等会再跟我说好吗...'})}\n\n"
