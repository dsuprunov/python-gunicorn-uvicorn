ARG PYTHON_VERSION=3.12-slim
ARG POETRY_VERSION=1.8.4

FROM python:${PYTHON_VERSION}

ARG POETRY_VERSION

ENV PATH="/root/.local/bin:${PATH}" \
    #
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH="/app/src"

RUN pip install --no-cache-dir --timeout=100 poetry

WORKDIR /app

COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.in-project true && \
    poetry install --no-interaction --no-ansi --no-root --with dev

COPY . .

RUN poetry run pytest -v --color=no --tb=line

WORKDIR /app/src

CMD ["poetry", "run", "python", "main.py"]