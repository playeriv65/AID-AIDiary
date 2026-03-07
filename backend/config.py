from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """应用配置，从环境变量加载"""

    # AI API Configuration
    api_key: str = ""  # OpenAI or NVIDIA API key
    base_url: str = "https://integrate.api.nvidia.com/v1"
    model_name: str = "glm-4.5-flash"

    # Google Gemini API Key (for Mem0 memory extraction)
    google_api_key: str = ""

    # App Security
    secret_key: str = ""

    # Database
    database_url: str = "sqlite:///./aidiary.db"

    # Mem0 Memory Service
    mem0_api_url: str = "http://localhost:8888"

    # File Upload
    upload_dir: str = "./static/uploads"

    # CORS
    cors_origins: list[str] = [
        "http://localhost:8081",
        "http://127.0.0.1:8081",
        "http://localhost:8085",
        "http://127.0.0.1:8085",
    ]

    # Logging
    log_level: str = "INFO"

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )


# 全局配置实例
settings = Settings()
