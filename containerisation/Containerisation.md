Presentation

https://tinyurl.com/darey-containerisation


Create an account on https://hub.docker.com/ (Official Docker registry)

Other docker registries

    - Docker Hub
    - Google Container Registry
    - Amazon Elastic Container Registry
    - Microsoft Azure Container Registry
    - Quay.io
    - Harbor
    - JFrog Container Registry
    - GitLab Container Registry
    - Artifactory Container Registry
    - IBM Cloud Container Registry


# Getting started with Docker
To get started with Docker, you'll need to install Docker Desktop on your computer. Docker Desktop is available for Windows, macOS, and Linux, and can be downloaded from the Docker website.

Once you have Docker installed, you can open a terminal window and run the following command to verify that Docker is working:

```
docker run hello-world
```
Another example

```
docker pull nginx
```

### Now lets run the container 

```
docker run -p 3000:80 nginx
```

The -p option specifies the port mapping between the container and the host system. In this case, it's mapping port 80 of the container to port 3000 on the host system. This means that when you access port 3000 on your host system, the traffic will be forwarded to port 80 inside the container.

Access the website from the browser.

## Other docker commands

docker build - Builds an image from a Dockerfile
docker run - Runs a container from an image
docker ps - Lists running containers
docker images - Lists available images on the system
docker pull - Pulls an image from a registry
docker login - Login to a docker registry
docker push - Pushes an image to a registry
docker exec - Executes a command in a running container --> docker exec -it <container-name-or-id> /bin/bash
docker stop - Stops a running container
docker rm - Removes a container
docker rmi - Removes an image
docker network - Manages Docker networks
docker volume - Manages Docker volumes
docker logs - Displays logs for a container
docker inspect - Displays detailed information about a container or image
docker-compose - Manages multi-container Docker applications using a YAML file.

Get more hands on with Project 20 --> https://www.darey.io/docs/migration-to-the-%d1%81loud-with-containerization-part-1-docker-docker-compose/


# Why do we need orchestration?

Running Docker containers on a single machine can become challenging as the number of containers and applications increases. Some of the challenges include:

Scalability: Running multiple containers and managing their resources on a single machine can become difficult. As the number of containers grows, managing them manually becomes inefficient.

High availability: Ensuring high availability and resiliency of containers running on a single machine requires complex configuration and management.

Load balancing: Distributing traffic evenly among containers and managing it efficiently can become difficult as the number of containers increases.

Security: Managing security in a multi-container environment can be complex, and a security breach can affect all containers on a machine.

Maintenance and updates: Managing updates, patches, and maintenance for each container can become difficult as the number of containers and applications increases.

Orchestration technologies like Kubernetes address these challenges by automating the management of containers and applications, allowing them to run across multiple machines and clusters, providing scalability, high availability, and load balancing out of the box. It also provides advanced features for monitoring, scaling, and updating containers and applications, making it easier to manage and maintain containerized applications.

Project 21 --> https://www.darey.io/docs/orchestrating-containers-across-multiple-virtual-servers-with-kubernetes-part-1/