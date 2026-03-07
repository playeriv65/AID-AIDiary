import logging
from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from slowapi.middleware import SlowAPIMiddleware

import models
from config import settings
from database import engine
from mem0_client import cleanup_mem0_client
from routers import ai, auth, conversations, entries, health, upload
from routers.ai import limiter

logger = logging.getLogger(__name__)

UPLOAD_DIR = Path(settings.upload_dir)
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)

models.Base.metadata.create_all(bind=engine)


@asynccontextmanager
async def lifespan(app: FastAPI):
    # startup
    logger.info("Initializing application...")

    # 尝试初始化 mem0 客户端（如果配置了 Google API Key）
    if settings.google_api_key:
        try:
            from mem0_client import get_mem0_client

            get_mem0_client()
            logger.info("Mem0 client initialized successfully")
        except Exception as e:
            logger.warning(f"Failed to initialize Mem0 client: {e}")
            logger.info("Continuing without Mem0 functionality")
    else:
        logger.info("Google API Key not configured, skipping Mem0 initialization")

    yield
    # shutdown
    logger.info("Shutting down application...")
    await cleanup_mem0_client()
    logger.info("Cleanup complete")


app = FastAPI(title="AID-AIDiary Backend", lifespan=lifespan)

app.mount("/static", StaticFiles(directory=str(UPLOAD_DIR.parent)), name="static")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.state.limiter = limiter
app.add_middleware(SlowAPIMiddleware)


@app.get("/")
def read_root():
    return {"message": "Welcome to the AID-AIDiary API"}


app.include_router(health.router)
app.include_router(upload.router)
app.include_router(auth.router)
app.include_router(entries.router)
app.include_router(ai.router)
app.include_router(conversations.router)
