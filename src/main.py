from fastapi import FastAPI
import pendulum
import uvicorn

from core import settings
from core.gunicorn import Application

app = FastAPI()


@app.get("/")
async def index():
    return {
        "timestamp": pendulum.now(tz='UTC').format('YYYY-MM-DD HH:mm:ss z'),
    }


def run_with_uvicorn():
    uvicorn.run(
        "main:app",
        host=settings.service.host,
        port=settings.service.port,
        reload=True
    )


def run_with_gunicorn():
    Application(
        application=app,
        options={
            'bind': f'{settings.service.host}:{settings.service.port}',
            'workers': settings.service.workers,
            'timeout': settings.service.timeout,
            'worker_class': 'uvicorn.workers.UvicornWorker',
        }
    ).run()


if __name__ == "__main__":
    # run_with_uvicorn()

    run_with_gunicorn()
