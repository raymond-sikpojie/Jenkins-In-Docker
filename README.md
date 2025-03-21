# Jenkins Docker Pipeline Setup


This repository contains scripts and configuration files to run Jenkins in a Docker container with the ability to build Docker images from within your Jenkins pipelines.

## Files in this Repository

- `docker-compose.yml` - Docker Compose configuration for Jenkins
- `setup-docker.sh` - Script to install Docker CLI inside the Jenkins container
- `docker-cleanup.sh` - Script to safely clean up Docker resources

## Prerequisites

- Docker installed on your machine
- Docker Compose installed on your machine
- Basic knowledge of Docker, Jenkins, and shell scripting

## Setup Instructions

### 1. Clone this Repository

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Make Scripts Executable

```bash
chmod +x install-docker.sh
chmod +x docker-cleanup.sh
```

### 3. Start Jenkins Container

```bash
docker-compose up -d
```

### 4. Install Docker CLI inside Jenkins Container

```bash
docker exec jenkins ./install-docker.sh
```

### 5. Access Jenkins

Open your browser and navigate to:

```
http://localhost:8080
```

### 6. Complete Jenkins Setup

- Get the initial admin password:
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

- Follow the setup wizard in your browser
- Install recommended plugins
- Create your admin user
- Configure Jenkins URL

## Using the Docker Cleanup Script

To safely clean up Docker resources without affecting your Jenkins container:

```bash
./docker-cleanup.sh
```

This script will:
- Identify and protect the Jenkins container
- Stop non-Jenkins containers
- Remove stopped containers and unused networks
- Clean up dangling images
- Selectively remove dangling volumes (preserving `jenkins_home`)

## Troubleshooting

### Permission Denied for Docker Socket

If you encounter permission issues with the Docker socket:

```bash
sudo chmod 666 /var/run/docker.sock
```

### Docker Command Not Found in Pipeline

If your Jenkins pipeline can't find the Docker command, ensure the Docker CLI is installed:

```bash
docker exec jenkins /install-docker.sh
```

### Certificate Issues with Docker

If you see errors about missing certificates (e.g., `ca.pem`), check that your environment variables are correctly set in `docker-compose.yml`:

```yaml
environment:
  - DOCKER_HOST=unix:///var/run/docker.sock
  - DOCKER_TLS_VERIFY=
  - DOCKER_CERT_PATH=
```

## Maintaining Your Setup

- Run the cleanup script periodically to prevent disk space issues
- Keep Jenkins and plugins updated
- Back up your Jenkins home directory regularly




