ARG PYTHON_VERSION=3.12-slim
ARG POETRY_VERSION=1.8.4

FROM python:${PYTHON_VERSION} AS builder

ARG POETRY_VERSION

ENV PATH="/root/.local/bin:${PATH}"

RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes pipx

RUN pipx install poetry

WORKDIR /app

COPY pyproject.toml poetry.lock ./

RUN poetry export --without-hashes --no-interaction --no-ansi -f requirements.txt -o requirements.txt

COPY . .

FROM python:${PYTHON_VERSION}

WORKDIR /app

COPY --from=builder /app/requirements.txt ./

RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY --from=builder /app ./

WORKDIR /app/src

CMD ["gunicorn", "main:app", "--workers", "3", "--worker-class", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000"]