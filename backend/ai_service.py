import os
import json
import asyncio
from datetime import datetime
from openai import OpenAI
from dotenv import load_dotenv
from typing import List, Dict, AsyncGenerator, Any

load_dotenv()

client = OpenAI(
    api_key=os.getenv("OPENAI_API_KEY"),
    base_url="https://open.bigmodel.cn/api/paas/v4/",
)

MODEL_NAME = "glm-4.5-flash"


async def generate_polished_entry(content: str) -> dict:
    """AI 润色日记内容"""
    system_prompt = """
    You are an exquisite, empathetic journaling assistant. 
    The user is providing a rough draft of their diary entry. 
    Your job is to:
    1. Beautifully polish their text without changing the original meaning or facts. Fix grammar, enhance vocabulary slightly to make it flow better. Keep the tone intimate and personal.
    2. Suggest 1 to 3 relevant mood or topic tags based on the entry (e.g., 'Grateful', 'Anxious', 'Work', 'Family').

    Respond STRICTLY in JSON format as follows:
    {
        "polished_text": "The beautifully rewritten diary entry.",
        "tags": ["Tag1", "Tag2"]
    }
    """

    try:
        response = client.chat.completions.create(
            model=MODEL_NAME,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": f"Here is my rough draft:\n\n{content}"},
            ],
            response_format={"type": "json_object"},
        )

        result_content = response.choices[0].message.content

        parsed_result: dict = json.loads(result_content) if result_content else {}

        return {
            "polished_text": parsed_result.get("polished_text", content),
            "tags": parsed_result.get("tags", []),
        }

    except Exception as e:
        print(f"Error during AI generation: {e}")
        return {"polished_text": content, "tags": ["Error"]}


async def generate_entry_from_chat(
    chat_history: List[Dict[str, str]],
    timezone: str | None = None,
    current_time: str | None = None,
) -> dict:
    """根据聊天内容生成日记"""

    if current_time and timezone:
        time_info = f"当前时间：{current_time}（{timezone}）"
    elif current_time:
        time_info = f"当前时间：{current_time}"
    else:
        time_info = ""

    system_prompt = f"""
    用户希望通过我们之前的对话生成一篇日记。
    {time_info}
    
    请根据对话内容，整理成一篇完整、优美的日记。
    要求：
    1. 保留用户分享的主要内容和感受
    2. 语言要优美、流畅，符合日记的风格
    3. 可以适当补充连接句，使日记更加连贯
    4. 根据内容建议 1-3 个合适的标签

    请严格以 JSON 格式返回：
    {{
        "title": "日记标题",
        "content": "整理后的日记内容",
        "tags": ["标签1", "标签2"]
    }}
    """

    try:
        messages = [{"role": "system", "content": system_prompt}]
        for msg in chat_history:
            messages.append(msg)
        messages.append(
            {"role": "user", "content": "请根据以上对话内容，帮我生成今天的日记"}
        )

        response = client.chat.completions.create(
            model=MODEL_NAME,
            messages=messages,  # type: ignore
            response_format={"type": "json_object"},
        )

        result_content = response.choices[0].message.content or ""
        parsed_result: dict = json.loads(result_content) if result_content else {}

        return {
            "title": parsed_result.get("title", ""),
            "content": parsed_result.get("content", ""),
            "tags": parsed_result.get("tags", []),
            "success": True,
        }
    except Exception as e:
        print(f"Error generating entry from chat: {e}")
        return {"title": "", "content": "", "tags": [], "success": False}


SYSTEM_PROMPT = """你是一个温暖、耐心的日记助手 AI。你可以与用户进行友好的对话，了解他们今天的经历、感受和想法。
在对话过程中，请：
1. 友好地回应用户，询问他们的日常生活、心情、想法
2. 适当给出回应和建议，但不要过度
3. 保持对话自然、轻松
4. 当用户想要生成日记时，请帮助整理对话内容

记住：你是在帮助用户记录日记，所以要引导他们分享今天的经历。"""


async def chat_with_ai(messages: List[Dict[str, str]]) -> dict:
    """与 AI 进行对话"""
    try:
        full_messages = [{"role": "system", "content": SYSTEM_PROMPT}] + messages

        response = client.chat.completions.create(
            model=MODEL_NAME,
            messages=full_messages,  # type: ignore
        )

        return {"response": response.choices[0].message.content, "success": True}
    except Exception as e:
        print(f"Error during AI chat: {e}")
        return {"response": "抱歉，我现在无法回应你。请稍后再试。", "success": False}


async def stream_chat_with_ai(
    messages: List[Dict[str, str]],
) -> AsyncGenerator[str, None]:
    """与 AI 进行流式对话"""
    try:
        full_messages = [{"role": "system", "content": SYSTEM_PROMPT}] + messages

        response = client.chat.completions.create(
            model=MODEL_NAME,
            messages=full_messages,  # type: ignore
            stream=True,
        )

        for chunk in response:  # type: ignore[union-attr]
            if chunk.choices and len(chunk.choices) > 0:  # type: ignore[union-attr]
                delta = chunk.choices[0].delta  # type: ignore[union-attr]
                if delta and delta.content:
                    content = delta.content
                    yield f"data: {json.dumps({'content': content})}\n\n"
                    # 刷新输出缓冲，确保立即发送
                    await asyncio.sleep(0)

        yield f"data: {json.dumps({'done': True})}\n\n"
    except Exception as e:
        print(f"Error during AI chat stream: {e}")
        yield f"data: {json.dumps({'error': '抱歉，我现在无法回应你。请稍后再试。'})}\n\n"
