#!/bin/bash
# Update system and install Docker
apt update -y
apt install -y docker.io

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Pull and run the Docker image
docker pull tharvesh20/flask-docker-app1
docker run -d \
  -p 8000:8000 \
  -e FLASK_ENV=production \
  --restart unless-stopped \
  tharvesh20/flask-docker-app1

# Verify container is running
docker ps