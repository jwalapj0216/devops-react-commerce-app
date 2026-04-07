#!/bin/bash
set -e

# 1. Capture and validate arguments
IMAGE=$1
PORT=$2

if [ -z "$IMAGE" ] || [ -z "$PORT" ]; then
  echo "ERROR: IMAGE or PORT not provided"
  echo "Usage: ./deploy.sh <image_name> <port>"
  exit 1
fi

# 2. Export variables for Docker Compose to use
export DEPLOY_IMAGE=$IMAGE
export HOST_PORT=$PORT
export CONTAINER_NAME="react-$PORT"

echo "Logging into Docker..."
echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

echo "--------------------------------------"
echo "Deploying with Compose: $IMAGE on Port: $PORT"
echo "--------------------------------------"

# 3. Pull and Deploy using Compose
# --quiet-pull hides progress bars; --detach runs in background
docker compose pull
docker compose up -d --force-recreate

# 4. HEALTH CHECK
echo "Checking application health..."
sleep 10

if curl -f "http://localhost:$PORT" > /dev/null 2>&1; then
  echo "App is running successfully on port $PORT"
else
  echo "App failed to start"
  echo "Container logs:"
  docker compose logs react-app
  exit 1
fi

# 5. CLEANUP
echo "Cleaning up unused Docker images..."
docker image prune -f

echo "--------------------------------------"
echo "Deployment successful!"
echo "--------------------------------------"
