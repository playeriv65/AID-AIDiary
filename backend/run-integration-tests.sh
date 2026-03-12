#!/bin/bash
# Script to run backend integration tests with docker compose setup

set -e  # Exit immediately if a command exits with a non-zero status

# Cleanup function to tear down docker services
cleanup() {
    echo "Stopping and cleaning up docker services..."
    if [ -f docker-compose.test.yml ]; then
        docker compose -f docker-compose.test.yml down -v --remove-orphans || true
    fi
    echo "Cleanup completed."
}

# Set trap to run cleanup on exit
trap cleanup EXIT

# Start services with test composition
echo "Starting services for integration tests..."
docker compose -f docker-compose.test.yml --env-file .env.test up -d --wait

# Install dev dependencies for testing
echo "Installing test dependencies..."
docker compose -f docker-compose.test.yml exec -T backend uv sync --dev

# Run integration tests
echo "Running integration tests..."
docker compose -f docker-compose.test.yml exec -T backend uv run pytest -v

echo "Integration tests completed successfully!"