"""提示词配置加载模块"""

from pathlib import Path

import yaml

_PROMPTS_FILE = Path(__file__).parent / "prompts.yaml"
_prompts: dict = {}


def _load_prompts() -> dict:
    """加载提示词配置文件"""
    global _prompts
    if not _prompts:
        with open(_PROMPTS_FILE, encoding="utf-8") as f:
            _prompts = yaml.safe_load(f)
    return _prompts


def get_chat_system_prompt() -> str:
    """获取聊天系统提示词"""
    return _load_prompts()["chat"]["system_prompt"]


def get_chat_memory_template() -> str:
    """获取聊天记忆上下文模板"""
    return _load_prompts()["chat"]["memory_context_template"]


def get_diary_system_prompt() -> str:
    """获取日记生成系统提示词"""
    return _load_prompts()["diary"]["system_prompt"]


def get_diary_time_info(current_time: str, timezone: str | None = None) -> str:
    """获取日记时间信息字符串"""
    prompts = _load_prompts()
    if timezone:
        return prompts["diary"]["time_info_template"].format(
            current_time=current_time, timezone=timezone
        )
    return prompts["diary"]["time_info_simple_template"].format(current_time=current_time)


def get_error_message(key: str) -> str:
    """获取错误消息"""
    return _load_prompts()["errors"][key]


# 兼容旧代码的常量导出
SYSTEM_PROMPT = property(lambda self: get_chat_system_prompt())
