from typing import Literal
from pydantic import BaseModel
from pydantic_settings import BaseSettings


class Service(BaseModel):
    host: str = '0.0.0.0'
    port: int = 8000
    workers: int = 1
    timeout: int = 900
    accesslog: str = '-'
    errorlog: str = '-'


class Logging(BaseModel):
    level: Literal[
        'debug',
        'info',
        'warning',
        'error',
        'critical',
    ] = 'info'
    format: str = '%(asctime)s %(levelname)s: %(message)s'


class Settings(BaseSettings):
    service: Service = Service()
    logging: Logging = Logging()


settings = Settings()
