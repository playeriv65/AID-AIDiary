# Re-export layer for backward compatibility
from config import settings
from services.auth_service import (
    ALGORITHM,
    SECRET_KEY,
    SECURITY_ALGORITHM,
    create_access_token,
    create_refresh_token,
    get_current_user,
    hash_password,
    verify_password,
)

# Backward compatibility: export token expiration time
ACCESS_TOKEN_EXPIRE_MINUTES = settings.access_token_expire_minutes

security = __import__("services.auth_service", fromlist=["security"]).security

__all__ = [
    "ACCESS_TOKEN_EXPIRE_MINUTES",
    "ALGORITHM",
    "SECRET_KEY",
    "SECURITY_ALGORITHM",
    "create_access_token",
    "create_refresh_token",
    "get_current_user",
    "hash_password",
    "security",
    "verify_password",
]
