"""AI diary generation service."""

import json
import logging

from openai import APIConnectionError, APIStatusError, AuthenticationError, RateLimitError

import prompts
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
    """根据聊天内容生成日记"""
    import ai_service

    system_prompt = prompts.get_diary_system_prompt()
    if current_time:
        time_info = prompts.get_diary_time_info(current_time, timezone)
        system_prompt = f"{time_info}\n\n{system_prompt}"

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
        return _error_result()
    except AuthenticationError as e:
        logger.error("AI service authentication failed: %s", str(e)[:100])
        return _error_result()
    except RateLimitError as e:
        logger.warning("AI service rate limited: %s", str(e)[:100])
        return _error_result()
    except APIStatusError as e:
        logger.error("AI service error: status=%d", e.status_code)
        return _error_result()
    except Exception:
        logger.exception("Unexpected error in generate_entry_from_chat")
        return _error_result()


def _error_result() -> dict:
    return {
        "title": prompts.get_error_message("diary_failed_title"),
        "content": "",
        "tags": [prompts.get_error_message("diary_failed_tag")],
        "success": False,
    }
