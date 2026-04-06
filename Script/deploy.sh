#!/bin/bash

IMAGE_NAME="jwalapj02/devops-build-dev:tagname"

echo "Pulling latest image..."
docker pull $IMAGE_NAME

echo "Stopping existing container..."
docker stop react-container || true
docker rm react-container || true

echo "Running new container..."
docker run -d -p 3000:3000 --name react-container $IMAGE_NAME

echo "Deployment successful!"