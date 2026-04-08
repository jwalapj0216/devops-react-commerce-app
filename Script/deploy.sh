#!/bin/bash
echo "-------------------------------------------------"
echo "-------------deploy------------------------------"
echo "-------------------------------------------------"

echo "Image: $IMAGE"
echo "Port: $PORT"

echo "Pulling latest image..."
docker pull $IMAGE_NAME

echo " Stopping old containers..."
docker-compose down || true

echo " Starting new containers..."
docker-compose up -d

sleep 15

if curl -f http://localhost:$PORT > /dev/null 2>&1; then
  echo " App is running successfully on port $PORT"
else
  echo " App failed to start"
  docker-compose logs
  exit 1
fi

#  CLEANUP
echo " Cleaning up unused images..."
docker image prune -f

echo "Deployment successful!"
echo "-------------------------------------------------"
