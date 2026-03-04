import uuid
from pathlib import Path

from fastapi import APIRouter, Depends, File, UploadFile

import models
from config import settings
from services.auth_service import get_current_user

router = APIRouter()
UPLOAD_DIR = Path(settings.upload_dir)


@router.post("/api/upload")
async def upload_image(
    file: UploadFile = File(...),
    current_user: models.User = Depends(get_current_user),
):
    filename = file.filename or "photo.jpg"
    ext = filename.split(".")[-1] if "." in filename else "jpg"
    unique_filename = f"{uuid.uuid4()}.{ext}"
    filepath = UPLOAD_DIR / unique_filename

    content = await file.read()
    with open(filepath, "wb") as f:
        f.write(content)

    return {
        "filename": f"uploads/{unique_filename}",
        "url": f"/static/uploads/{unique_filename}",
    }
