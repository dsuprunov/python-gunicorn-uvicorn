ARG PYTHON_VERSION=3.12-slim
ARG POETRY_VERSION=1.8.4

FROM python:${PYTHON_VERSION}

ENV PATH="/root/.local/bin:${PATH}" \
    #
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH="/home/app/src"

RUN pip install --no-cache-dir --timeout=100 poetry

RUN addgroup --system nonroot                   && \
    adduser  --system --ingroup nonroot nonroot && \
    mkdir -p /home/app                          && \
    chown -R nonroot:nonroot /home/app/

WORKDIR /home/app

COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.in-project true && \
    poetry install --no-interaction --no-ansi --no-root --with dev

COPY . .

RUN poetry run pytest -v --color=no --tb=line

WORKDIR /home/app/src

USER nonroot

CMD ["poetry", "run", "python", "main.py"]