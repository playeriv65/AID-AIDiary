from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import Optional


class Settings(BaseSettings):
    """应用配置，从环境变量加载"""

    # API Keys - 从环境变量加载，运行时必须设置
    openai_api_key: str = ""
    secret_key: str = ""

    # Optional with defaults
    openai_base_url: str = "https://open.bigmodel.cn/api/paas/v4/"
    model_name: str = "glm-4.5-flash"

    database_url: str = "sqlite:///./aidiary.db"

    upload_dir: str = "./static/uploads"
    log_level: str = "INFO"

    cors_origins: list[str] = [
        "http://localhost:8081",
        "http://127.0.0.1:8081",
        "http://localhost:8085",
        "http://127.0.0.1:8085",
    ]

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )


# 全局配置实例
settings = Settings()
