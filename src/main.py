import logging

from fastapi import FastAPI
import pendulum
import uvicorn

from core import settings
from core.gunicorn import (
    Application,
    Logger,
)


logging.basicConfig(
    level=logging.INFO,
    format=settings.logging.format
)
log = logging.getLogger(__name__)

app = FastAPI()


@app.get("/")
async def index():
    return {
        "timestamp": pendulum.now(tz='UTC').format('YYYY-MM-DD HH:mm:ss z'),
    }


def run_with_uvicorn():
    log.info("Running application via Uvicorn")
    uvicorn.run(
        "main:app",
        host=settings.service.host,
        port=settings.service.port,
        reload=True
    )


def run_with_gunicorn():
    log.info("Running application via Gunicorn")
    Application(
        application=app,
        options={
            'bind': f'{settings.service.host}:{settings.service.port}',
            'workers': settings.service.gunicorn_workers,
            'timeout': settings.service.gunicorn_timeout,
            'worker_class': 'uvicorn.workers.UvicornWorker',
            "accesslog": settings.service.gunicorn_accesslog,
            "errorlog": settings.service.gunicorn_errorlog,
            'loglevel': settings.logging.level,
            'logger_class': Logger,
        }
    ).run()


if __name__ == "__main__":
    # run_with_uvicorn()

    run_with_gunicorn()
