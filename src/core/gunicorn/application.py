from fastapi import FastAPI
from gunicorn.app.base import BaseApplication


class Application(BaseApplication):
    def __init__(self, application: FastAPI, options: dict | None = None):
        self.application = application
        self.options = options or {}
        super().__init__()

    def load_config(self):
        for k, v in self.options.items():
            if k in self.cfg.settings and v is not None:
                self.cfg.set(k.lower(), v)

    def load(self):
        return self.application
