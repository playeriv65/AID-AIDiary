"""AI diary generation service."""

import json
import logging

from openai import APIConnectionError, APIStatusError, AuthenticationError, RateLimitError

from schemas import AIGenerateResult

logger = logging.getLogger(__name__)


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


async def generate_entry_from_chat(
    chat_history: list[dict[str, str]],
    timezone: str | None = None,
    current_time: str | None = None,
) -> dict:
    """根据聊天内容生成日记：带有人情味的睡前碎碎念"""

    # Import at runtime to allow test patching
    import ai_service

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
        messages.append({"role": "user", "content": "请根据以上对话内容，帮我生成今天的日记。"})

        response = ai_service.client.chat.completions.create(
            model=ai_service.MODEL_NAME,
            messages=messages,  # type: ignore
            temperature=ai_service.AI_TEMPERATURE,
            top_p=ai_service.AI_TOP_P,
            max_tokens=ai_service.AI_MAX_TOKENS_GENERATE,
        )

        result_content = response.choices[0].message.content or "{}"
        parsed_result = AIGenerateResult.model_validate(_clean_json_string(result_content))

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
    except Exception:
        logger.exception("Unexpected error in generate_entry_from_chat")
        return {"title": "日记生成失败", "content": "", "tags": ["Error"], "success": False}
