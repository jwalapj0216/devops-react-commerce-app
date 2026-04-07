#!/bin/bash
set -e

IMAGE=$1
PORT=$2
CONTAINER_NAME="react-container"

if [ -z "$IMAGE" ] || [ -z "$PORT" ]; then
  echo "❌ ERROR: IMAGE or PORT not provided"
  exit 1
fi

echo "--------------------------------------"
echo "Deploying Image: $IMAGE on Port: $PORT"
echo "--------------------------------------"

echo "📥 Pulling latest image..."
docker pull $IMAGE

echo "🛑 Stopping existing container..."
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

echo "🚀 Running new container..."
docker run -d -p $PORT:3000 --name $CONTAINER_NAME $IMAGE

echo "✅ Deployment successful!"
echo "--------------------------------------"
