#!/bin/bash
set -e

IMAGE=$1
PORT=$2
CONTAINER_NAME="react-$PORT"

if [ -z "$IMAGE" ] || [ -z "$PORT" ]; then
  echo "ERROR: IMAGE or PORT not provided"
  exit 1
fi

echo "Logging into Docker..."
echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

echo "--------------------------------------"
echo "Deploying Image: $IMAGE on Port: $PORT"
echo "--------------------------------------"

echo " Pulling latest image..."
docker pull $IMAGE

echo "Stopping existing container (if any)..."
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

echo " Running new container..."
docker run -d -p $PORT:3000 --name $CONTAINER_NAME $IMAGE

#  HEALTH CHECK
echo " Checking application health..."
sleep 10

if curl -f http://localhost:$PORT > /dev/null 2>&1; then
  echo " App is running successfully on port $PORT"
else
  echo " App failed to start"
  echo "Container logs:"
  docker logs $CONTAINER_NAME
  exit 1
fi

# CLEANUP OLD IMAGES
echo " Cleaning up unused Docker images..."
docker image prune -f

echo "--------------------------------------"
echo "Deployment successful!"
echo "--------------------------------------"
