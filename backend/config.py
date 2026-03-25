"""
应用配置模块

使用 pydantic-settings 从环境变量加载配置。
支持 .env 文件自动加载，环境变量优先级高于 .env 文件。

配置优先级：环境变量 > .env 文件 > 默认值
"""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """应用配置类

    所有配置项均可通过环境变量覆盖，环境变量名与字段名相同（不区分大小写）。

    Attributes:
        port: 服务器监听端口
        api_key: AI API 密钥（OpenAI 兼容格式）
        base_url: AI API 基础 URL
        model_name: AI 模型名称
        google_api_key: Google API 密钥（用于 Mem0 记忆提取）
        secret_key: JWT 签名密钥（必须设置）
        database_url: PostgreSQL 连接 URL
        mem0_api_url: Mem0 记忆服务地址
        upload_dir: 文件上传目录
        cors_origins: 允许的 CORS 来源列表
        log_level: 日志级别
    """

    # ============================================================
    # Server Configuration
    # ============================================================
    port: int = 8000  # 服务器端口，可通过 PORT 环境变量覆盖

    # ============================================================
    # AI API Configuration
    # ============================================================
    api_key: str = ""  # OpenAI/NVIDIA/Google Gemini API 密钥
    base_url: str = "https://integrate.api.nvidia.com/v1"  # API 基础 URL
    model_name: str = "glm-4.5-flash"  # AI 模型名称

    # ============================================================
    # Google API (for Mem0 memory extraction)
    # ============================================================
    google_api_key: str = ""  # Google Gemini API 密钥

    # ============================================================
    # Application Security
    # ============================================================
    secret_key: str = ""  # JWT 签名密钥，生产环境必须设置

    # ============================================================
    # JWT Configuration
    # ============================================================
    access_token_expire_minutes: int = 60  # 访问令牌过期时间（分钟）
    refresh_token_expire_days: int = 7  # 刷新令牌过期时间（天）

    # ============================================================
    # Database Configuration
    # ============================================================
    database_url: str = "postgresql://postgres:postgres@localhost:5432/postgres"

    # ============================================================
    # Mem0 Memory Service
    # ============================================================
    mem0_api_url: str = "http://localhost:8888"  # Mem0 服务地址

    # ============================================================
    # File Upload
    # ============================================================
    upload_dir: str = "./static/uploads"  # 上传文件存储目录

    # ============================================================
    # CORS Configuration
    # ============================================================
    cors_origins: list[str] = [
        "http://localhost:8081",
        "http://127.0.0.1:8081",
        "http://localhost:8085",
        "http://127.0.0.1:8085",
    ]

    # ============================================================
    # Logging
    # ============================================================
    log_level: str = "INFO"  # 日志级别: DEBUG, INFO, WARNING, ERROR

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )


# 全局配置实例
settings = Settings()
