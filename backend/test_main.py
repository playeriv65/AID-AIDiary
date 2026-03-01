import pytest
import uuid
import json
import os
from pathlib import Path
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

os.environ["OPENAI_API_KEY"] = "test-key"
os.environ["SECRET_KEY"] = "test-secret"

from main import app, UPLOAD_DIR
from database import Base, get_db
from models import JournalEntry, User

SQLALCHEMY_DATABASE_URL = "sqlite:///:memory:"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def override_get_db():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()


app.dependency_overrides[get_db] = override_get_db


@pytest.fixture(scope="function")
def db():
    Base.metadata.create_all(bind=engine)
    db = TestingSessionLocal()
    yield db
    db.close()
    Base.metadata.drop_all(bind=engine)


@pytest.fixture(scope="function")
def client():
    Base.metadata.create_all(bind=engine)
    with TestClient(app) as c:
        yield c
    Base.metadata.drop_all(bind=engine)


@pytest.fixture
def auth_headers(client):
    response = client.post(
        "/api/auth/register",
        json={
            "username": "testuser",
            "email": "test@example.com",
            "password": "testpass123",
        },
    )
    token = response.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture
def sample_entry_data():
    return {
        "id": str(uuid.uuid4()),
        "title": "测试日记",
        "content": "这是测试内容",
        "category": "life",
        "weather": "sunny",
        "location": "测试地点",
        "tags": ["测试", "日记"],
    }


class TestRootEndpoint:
    def test_root(self, client):
        response = client.get("/")
        assert response.status_code == 200
        assert response.json() == {"message": "Welcome to the AID-AIDiary API"}


class TestJournalEntries:
    def test_create_entry(self, client, sample_entry_data, auth_headers):
        response = client.post(
            "/api/entries", json=sample_entry_data, headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["title"] == "测试日记"
        assert data["content"] == "这是测试内容"
        assert "id" in data

    def test_get_entries(self, client, sample_entry_data, auth_headers):
        client.post("/api/entries", json=sample_entry_data, headers=auth_headers)
        response = client.get("/api/entries", headers=auth_headers)
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        assert data[0]["title"] == "测试日记"

    def test_get_entry_by_id(self, client, sample_entry_data, auth_headers):
        create_resp = client.post(
            "/api/entries", json=sample_entry_data, headers=auth_headers
        )
        entry_id = create_resp.json()["id"]

        response = client.get(f"/api/entries/{entry_id}", headers=auth_headers)
        assert response.status_code == 200
        assert response.json()["title"] == "测试日记"

    def test_update_entry(self, client, sample_entry_data, auth_headers):
        create_resp = client.post(
            "/api/entries", json=sample_entry_data, headers=auth_headers
        )
        entry_id = create_resp.json()["id"]

        update_data = {"title": "更新后的标题"}
        response = client.put(
            f"/api/entries/{entry_id}", json=update_data, headers=auth_headers
        )
        assert response.status_code == 200
        assert response.json()["title"] == "更新后的标题"

    def test_update_entry_multiple_fields(
        self, client, sample_entry_data, auth_headers
    ):
        """测试更新多个字段"""
        create_resp = client.post(
            "/api/entries", json=sample_entry_data, headers=auth_headers
        )
        entry_id = create_resp.json()["id"]

        update_data = {
            "category": "work",
            "weather": "sunny",
            "location": "Beijing",
            "tags": ["tag1", "tag2"],
        }
        response = client.put(
            f"/api/entries/{entry_id}", json=update_data, headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert data["category"] == "work"
        assert data["weather"] == "sunny"
        assert data["location"] == "Beijing"

    def test_update_nonexistent_entry(self, client, auth_headers):
        """测试更新不存在的日记"""
        response = client.put(
            "/api/entries/99999", json={"title": "Test"}, headers=auth_headers
        )
        assert response.status_code == 404

    def test_delete_nonexistent_entry(self, client, auth_headers):
        """测试删除不存在的日记"""
        response = client.delete("/api/entries/99999", headers=auth_headers)
        assert response.status_code == 404

    def test_delete_entry(self, client, sample_entry_data, auth_headers):
        create_resp = client.post(
            "/api/entries", json=sample_entry_data, headers=auth_headers
        )
        entry_id = create_resp.json()["id"]

        response = client.delete(f"/api/entries/{entry_id}", headers=auth_headers)
        assert response.status_code == 200

        get_resp = client.get(f"/api/entries/{entry_id}", headers=auth_headers)
        assert get_resp.status_code == 404

    def test_entry_with_image(self, client, sample_entry_data, auth_headers):
        data = sample_entry_data.copy()
        data["image"] = "uploads/test.jpg"

        response = client.post("/api/entries", json=data, headers=auth_headers)
        assert response.status_code == 200
        assert response.json()["image"] == "uploads/test.jpg"


class TestImageUpload:
    def test_upload_image_returns_correct_path(self, client, tmp_path, auth_headers):
        test_file = tmp_path / "test.jpg"
        test_file.write_bytes(b"fake image content")

        with open(test_file, "rb") as f:
            response = client.post(
                "/api/upload",
                files={"file": ("test.jpg", f, "image/jpeg")},
                headers=auth_headers,
            )

        assert response.status_code == 200
        data = response.json()

        assert "filename" in data
        assert "url" in data
        assert data["filename"].startswith("uploads/")
        assert data["url"].startswith("/static/uploads/")

    def test_upload_image_saves_to_uploads_directory(
        self, client, tmp_path, auth_headers
    ):
        test_file = tmp_path / "test.jpg"
        test_file.write_bytes(b"fake image content")

        with open(test_file, "rb") as f:
            response = client.post(
                "/api/upload",
                files={"file": ("test.jpg", f, "image/jpeg")},
                headers=auth_headers,
            )

        filename = response.json()["filename"]
        file_path = UPLOAD_DIR / filename.replace("uploads/", "", 1)
        assert file_path.exists()


class TestAIPolish:
    def test_ai_polish_returns_polished_text(self, client, auth_headers):
        response = client.post(
            "/api/ai/polish", json={"content": "i am happy today"}, headers=auth_headers
        )
        assert response.status_code == 200
        data = response.json()
        assert "polished_text" in data
        assert "tags" in data


class TestAuth:
    def test_register_user(self, client):
        response = client.post(
            "/api/auth/register",
            json={
                "username": "testuser",
                "email": "test@example.com",
                "password": "testpass123",
            },
        )
        assert response.status_code == 200
        data = response.json()
        assert "access_token" in data
        assert data["user"]["username"] == "testuser"

    def test_login_user(self, client):
        client.post(
            "/api/auth/register",
            json={
                "username": "testuser",
                "email": "test@example.com",
                "password": "testpass123",
            },
        )

        response = client.post(
            "/api/auth/login", json={"username": "testuser", "password": "testpass123"}
        )
        assert response.status_code == 200
        assert "access_token" in response.json()
