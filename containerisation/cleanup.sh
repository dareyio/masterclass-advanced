#!/bin/bash

# Stop all running containers
docker stop $(docker ps -a -q)

# Remove all containers
docker rm $(docker ps -a -q)

# Remove all Docker images
docker rmi -f $(docker images -q)

# Remove all volumes
docker volume rm $(docker volume ls -q)

# Remove all networks
docker network rm $(docker network ls -q)
