#!/bin/sh
set -e

if [ "$TEST_MODE" = "true" ]; then
    uv run python seed_data.py
fi

exec uv run uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}