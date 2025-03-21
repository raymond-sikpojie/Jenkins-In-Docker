#!/bin/bash
echo "Cleaning up Docker resources..."

# Get the ID of the Jenkins container to protect it
JENKINS_ID=$(docker ps -q --filter "name=jenkins")
echo "Protecting Jenkins container: $JENKINS_ID"

# Stop all running containers EXCEPT Jenkins
CONTAINERS_TO_STOP=$(docker ps -q | grep -v $JENKINS_ID)
if [ ! -z "$CONTAINERS_TO_STOP" ]; then
    docker stop $CONTAINERS_TO_STOP
fi

# Remove stopped containers, unused networks, dangling images and build cache
# But don't remove used volumes or networks
docker system prune -f

# Be careful with volume pruning - don't remove jenkins_home
# List volumes that would be removed
echo "Listing volumes that would be removed (NOT removing them):"
docker volume ls -f dangling=true | grep -v jenkins_home

# Remove dangling volumes except jenkins_home
docker volume ls -f dangling=true -q | grep -v jenkins_home | xargs -r docker volume rm

# Remove unused images, but not the ones used by Jenkins
echo "Removing unused images..."
docker image prune -f

echo "Docker cleanup complete"