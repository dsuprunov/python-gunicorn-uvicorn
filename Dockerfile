ARG PYTHON_VERSION=3.12-slim
ARG POETRY_VERSION=1.8.4

FROM python:${PYTHON_VERSION} AS builder

ARG POETRY_VERSION

ENV PYTHONPATH="/home/app/src" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=off

RUN python -m pip install --upgrade pip && \
    python -m pip install poetry==${POETRY_VERSION}

WORKDIR /home/app

COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.in-project true && \
    poetry install --no-interaction --no-ansi --no-root --with dev

COPY . .

RUN poetry run pytest -v --color=no --tb=line

RUN poetry export --only main --without-hashes -f requirements.txt --output requirements.txt

FROM python:${PYTHON_VERSION}

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=off

WORKDIR /home/app/

COPY --from=builder /home/app/requirements.txt .

RUN python -m pip install --upgrade pip && \
    python -m pip install -r requirements.txt

COPY ./src ./src

CMD ["python", "src/main.py"]