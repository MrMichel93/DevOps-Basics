# Docker Commands Cheatsheet

Quick reference for essential Docker commands.

## 🐳 Images

### List Images
```bash
docker images
docker image ls
docker images --all          # Include intermediate images
docker images --filter "dangling=true"  # Unused images
```

### Pull Images
```bash
docker pull ubuntu           # Latest tag
docker pull ubuntu:22.04     # Specific tag
docker pull nginx:alpine     # Alpine variant
```

### Build Images
```bash
docker build -t myapp .                    # Build from current directory
docker build -t myapp:v1.0 .              # With tag
docker build -f Dockerfile.prod -t myapp .  # Specific Dockerfile
docker build --no-cache -t myapp .        # Without cache
```

### Remove Images
```bash
docker rmi image-name        # Remove image
docker rmi $(docker images -q)  # Remove all images
docker image prune           # Remove unused images
docker image prune -a        # Remove all unused images
```

### Inspect Images
```bash
docker inspect image-name
docker history image-name    # Show layers
docker image inspect --format='{{.Size}}' image-name  # Get size
```

## 📦 Containers

### Run Containers
```bash
docker run ubuntu                    # Run and exit
docker run -it ubuntu bash           # Interactive with terminal
docker run -d nginx                  # Run in background (detached)
docker run --name mycontainer nginx  # With custom name
docker run -p 8080:80 nginx         # Map port 8080→80
docker run -e VAR=value myapp       # Set environment variable
docker run -v /host:/container myapp # Mount volume
docker run --rm myapp               # Remove container after exit
docker run --restart unless-stopped myapp  # Auto-restart policy
```

### List Containers
```bash
docker ps                    # Running containers
docker ps -a                 # All containers
docker ps -q                 # Only container IDs
docker ps --filter "status=exited"  # Exited containers
```

### Manage Containers
```bash
docker start container-name          # Start stopped container
docker stop container-name           # Stop container gracefully
docker restart container-name        # Restart container
docker pause container-name          # Pause container
docker unpause container-name        # Unpause container
docker kill container-name           # Force stop container
```

### Remove Containers
```bash
docker rm container-name             # Remove stopped container
docker rm -f container-name          # Force remove running container
docker rm $(docker ps -aq)          # Remove all stopped containers
docker container prune              # Remove all stopped containers
```

### Inspect Containers
```bash
docker logs container-name           # View logs
docker logs -f container-name        # Follow logs
docker logs --tail 100 container-name  # Last 100 lines
docker inspect container-name        # Detailed info
docker stats container-name          # Resource usage
docker top container-name            # Running processes
docker port container-name           # Port mappings
```

### Execute in Containers
```bash
docker exec container-name ls /app   # Run command
docker exec -it container-name bash  # Interactive shell
docker exec -u root container-name command  # As root user
```

### Copy Files
```bash
docker cp file.txt container:/path/  # Copy to container
docker cp container:/path/file.txt . # Copy from container
```

## 🔄 Docker Compose

### Basic Commands
```bash
docker compose up                    # Start services
docker compose up -d                 # Start in background
docker compose down                  # Stop and remove
docker compose down -v               # Also remove volumes
docker compose restart               # Restart services
docker compose stop                  # Stop without removing
docker compose start                 # Start stopped services
```

### View Status
```bash
docker compose ps                    # List services
docker compose logs                  # View logs
docker compose logs -f               # Follow logs
docker compose logs service-name     # Logs for specific service
docker compose top                   # Show processes
```

### Build and Execute
```bash
docker compose build                 # Build images
docker compose build --no-cache      # Build without cache
docker compose up --build            # Build and start
docker compose exec service-name sh  # Execute in service
docker compose run service-name command  # Run one-off command
```

### Scale Services
```bash
docker compose up --scale web=3      # Run 3 instances of web
```

## 🌐 Networks

### List Networks
```bash
docker network ls
docker network ls --filter "driver=bridge"
```

### Create Network
```bash
docker network create mynetwork
docker network create --driver bridge mynetwork
```

### Connect Containers
```bash
docker network connect mynetwork container
docker network disconnect mynetwork container
```

### Inspect Network
```bash
docker network inspect mynetwork
```

### Remove Network
```bash
docker network rm mynetwork
docker network prune  # Remove unused networks
```

## 💾 Volumes

### List Volumes
```bash
docker volume ls
docker volume ls --filter "dangling=true"
```

### Create Volume
```bash
docker volume create myvolume
```

### Inspect Volume
```bash
docker volume inspect myvolume
```

### Remove Volume
```bash
docker volume rm myvolume
docker volume prune  # Remove unused volumes
```

### Use Volumes
```bash
docker run -v myvolume:/data myapp        # Named volume
docker run -v /host/path:/container myapp # Bind mount
docker run -v /container myapp            # Anonymous volume
```

## 🧹 Cleanup

### Remove Everything
```bash
docker system prune              # Remove unused data
docker system prune -a           # Remove all unused images too
docker system prune -a --volumes # Include volumes
```

### Specific Cleanup
```bash
docker container prune  # Remove stopped containers
docker image prune      # Remove unused images
docker volume prune     # Remove unused volumes
docker network prune    # Remove unused networks
```

### Check Disk Usage
```bash
docker system df        # Show disk usage
docker system df -v     # Verbose disk usage
```

## 🔍 Debugging

### Container Logs
```bash
docker logs container-name
docker logs -f container-name           # Follow
docker logs --tail 50 container-name    # Last 50 lines
docker logs --since 30m container-name  # Last 30 minutes
```

### Inspect
```bash
docker inspect container-name
docker inspect --format='{{.State.Status}}' container
docker inspect --format='{{.NetworkSettings.IPAddress}}' container
```

### Resource Usage
```bash
docker stats                 # All containers
docker stats container-name  # Specific container
docker top container-name    # Processes in container
```

### Enter Container
```bash
docker exec -it container-name sh
docker exec -it container-name bash
docker attach container-name  # Attach to running process
```

## 🏷️ Tagging

### Tag Images
```bash
docker tag myapp myapp:v1.0
docker tag myapp:v1.0 registry.example.com/myapp:v1.0
```

### Push to Registry
```bash
docker login                          # Login to Docker Hub
docker push username/myapp:v1.0       # Push to Docker Hub
docker logout                         # Logout
```

## 📊 Advanced

### Build with BuildKit
```bash
DOCKER_BUILDKIT=1 docker build -t myapp .
```

### Multi-Platform Build
```bash
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 -t myapp .
```

### Save/Load Images
```bash
docker save -o myapp.tar myapp        # Save image to file
docker load -i myapp.tar              # Load image from file
docker export container > backup.tar  # Export container filesystem
docker import backup.tar myapp:backup # Import as image
```

### Events
```bash
docker events                 # Stream events
docker events --since 1h      # Events from last hour
```

## 🔑 Security

### Scan Images
```bash
docker scan myapp:latest
```

### Run Security Best Practices
```bash
# Don't run as root
docker run -u 1000:1000 myapp

# Read-only filesystem
docker run --read-only myapp

# Limit resources
docker run --memory="512m" --cpus="1.0" myapp

# Drop capabilities
docker run --cap-drop=ALL myapp
```

## 💡 Tips

1. **Use .dockerignore** - Exclude unnecessary files from build
2. **Tag your images** - Never rely on `latest`
3. **Clean regularly** - Use `docker system prune`
4. **Check logs** - Always check logs when debugging
5. **Use health checks** - Add HEALTHCHECK to Dockerfiles

## 📚 Related

- [Docker Official Docs](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Compose File Reference](https://docs.docker.com/compose/compose-file/)

---

Save this file for quick reference! 🚀
