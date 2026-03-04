import logging

from fastapi import APIRouter, HTTPException

from mem0_client import get_mem0_client

logger = logging.getLogger(__name__)
router = APIRouter()


@router.get("/health")
async def health_check():
    """基本健康检查端点"""
    return {"status": "healthy", "service": "AID-AIDiary Backend"}


@router.get("/health/mem0")
async def check_mem0_health():
    """检查 mem0 服务健康状态"""
    try:
        mem0_client = get_mem0_client()
        await mem0_client.get_all_memories("health_check")
    except Exception as e:
        logger.warning("mem0 health check failed: %s", str(e)[:100])
        raise HTTPException(status_code=503, detail="mem0 service unavailable")
