#!/bin/bash
set -e
cd /root/task

echo "[INFO] Starting containers with docker-compose..."
docker-compose up -d

echo "[INFO] Waiting for PostgreSQL service to be ready..."
RETRIES=30
until docker exec ecommerce_db pg_isready -U ecommerce; do
  sleep 2
  RETRIES=$((RETRIES-1))
  if [ $RETRIES -le 0 ]; then
    echo "[ERROR] PostgreSQL service did not become available in time."
    docker-compose logs db
    exit 1
  fi
done

echo "[INFO] Checking FastAPI health..."
API_STATUS=1
RETRIES=30
while [ $RETRIES -gt 0 ]; do
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/healthz || true)
  if [ "$HTTP_CODE" == "200" ]; then
    API_STATUS=0
    break
  fi
  sleep 2
  RETRIES=$((RETRIES-1))
done
if [ $API_STATUS -ne 0 ]; then
  echo "[ERROR] FastAPI service is not healthy!"
  docker-compose logs fastapi
  exit 2
fi

echo "[SUCCESS] FastAPI and PostgreSQL are up and running, and the application is ready."
