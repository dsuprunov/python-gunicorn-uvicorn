import pytest
from httpx import AsyncClient
from httpx import ASGITransport

from src.main import app


@pytest.mark.asyncio
async def test_index():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        response = await client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert "timestamp" in data
