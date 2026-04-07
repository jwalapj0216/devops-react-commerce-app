#!/bin/bash
set -e

IMAGE=$1
PORT=$2
CONTAINER_NAME="react-$PORT"

# 🔐 Docker login (IMPORTANT)
echo "🔐 Logging into Docker..."
echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

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
