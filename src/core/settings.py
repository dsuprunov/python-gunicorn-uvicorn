from typing import Literal
from pydantic import BaseModel
from pydantic_settings import BaseSettings


class Service(BaseModel):
    host: str = '0.0.0.0'
    port: int = 8000
    workers: int = 1
    timeout: int = 900


class Settings(BaseSettings):
    service: Service = Service()


settings = Settings()
