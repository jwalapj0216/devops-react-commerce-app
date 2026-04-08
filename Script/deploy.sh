#!/bin/bash
set -e

echo "-------------------------------------------------"
echo "-------------deploy------------------------------"
echo "-------------------------------------------------"

IMAGE="$1"
PORT="$2"

echo "Received IMAGE=$IMAGE"
echo "Received PORT=$PORT"

if [ -z "$IMAGE" ] || [ -z "$PORT" ]; then
  echo " ERROR: IMAGE or PORT missing"
  exit 1
fi

export IMAGE
export PORT

echo " Logging into Docker..."
echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

echo " Pulling latest image..."
docker pull $IMAGE

# Detect compose
if command -v docker-compose &> /dev/null; then
    COMPOSE="docker-compose"
else
    COMPOSE="docker compose"
fi

echo "Using compose: $COMPOSE"

#  FORCE REMOVE OLD CONTAINER (CRITICAL FIX)
echo " Removing old container if exists..."
docker rm -f react-$PORT || true

echo " Stopping old compose..."
$COMPOSE down || true

echo " Starting new container..."
$COMPOSE up -d

echo " Health check..."
sleep 10

if curl -f http://localhost:$PORT; then
  echo " App running on port $PORT"
else
  echo " App failed"
  $COMPOSE logs
  exit 1
fi
