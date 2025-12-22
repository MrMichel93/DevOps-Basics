# Docker Troubleshooting Guide

## Issue Categories

### Container Won't Start

**Symptoms:**

- Container exits immediately after starting
- Container status shows "Exited (1)" or other non-zero exit code
- `docker ps` doesn't show the container (it's not running)
- Error messages appear when running `docker run` or `docker start`

**Diagnostic Steps:**

1. **Check logs first**
   ```bash
   docker logs <container-id>
   docker logs --tail 100 <container-id>
   docker logs -f <container-id>  # Follow logs in real-time
   ```

2. **Inspect container configuration**
   ```bash
   docker inspect <container-id>
   docker inspect <container-id> | jq '.[0].State'  # Check exit code
   ```

3. **See real-time events**
   ```bash
   docker events --filter container=<container-id>
   docker events --since 30m  # Events from last 30 minutes
   ```

4. **Check container exit code**
   ```bash
   docker ps -a  # Look at exit codes
   ```
   Common exit codes:
   - Exit 0: Success (intentional exit)
   - Exit 1: Application error
   - Exit 126: Command cannot be invoked
   - Exit 127: Command not found
   - Exit 137: Container killed (OOM or manual kill -9)
   - Exit 143: Graceful termination (SIGTERM)

**Common Causes & Solutions:**

#### Cause 1: Command not found

**Error message:**
```
Error: Container command not found
exec: "ngnix": executable file not found
```

**Solution:**
```dockerfile
# Wrong
CMD ["ngnix", "-g", "daemon off;"]

# Correct
CMD ["nginx", "-g", "daemon off;"]
```

Check the command exists in the container:
```bash
docker run --rm <image> which nginx
docker run --rm <image> ls -la /usr/sbin/nginx
```

#### Cause 2: Missing dependencies

**Error message:**
```
Error loading shared libraries: libssl.so.1.1: cannot open shared object file
```

**Solution:**
Install missing dependencies in Dockerfile:
```dockerfile
# Alpine
RUN apk add --no-cache openssl

# Debian/Ubuntu
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*
```

#### Cause 3: Port already in use

**Error message:**
```
Error starting userland proxy: listen tcp 0.0.0.0:8080: bind: address already in use
```

**Solution:**

1. Find what's using the port:
   ```bash
   # Linux
   sudo lsof -i :8080
   sudo netstat -tulpn | grep 8080
   
   # Find and stop conflicting container
   docker ps | grep 8080
   docker stop <conflicting-container>
   ```

2. Use a different port:
   ```bash
   docker run -p 8081:8080 <image>
   ```

#### Cause 4: Volume mount issues

**Error message:**
```
Error response from daemon: invalid mount config for type "bind": bind source path does not exist
```

**Solution:**

1. Verify source path exists:
   ```bash
   ls -la /path/on/host
   ```

2. Create directory if needed:
   ```bash
   mkdir -p /path/on/host
   ```

3. Check permissions:
   ```bash
   # Make sure Docker has access
   chmod 755 /path/on/host
   ```

4. Fix the mount:
   ```bash
   # Absolute paths only
   docker run -v /absolute/path:/container/path <image>
   
   # Or use $(pwd) for current directory
   docker run -v $(pwd)/data:/app/data <image>
   ```

#### Cause 5: Insufficient permissions

**Error message:**
```
Permission denied
Cannot write to /var/log/app.log
```

**Solution:**

1. Run as correct user in Dockerfile:
   ```dockerfile
   RUN chown -R appuser:appuser /var/log
   USER appuser
   ```

2. Or fix volume permissions:
   ```bash
   # On host
   sudo chown -R 1000:1000 ./logs
   
   # Or in container
   docker run --user 1000:1000 <image>
   ```

#### Cause 6: Application crashes on startup

**Error message:**
```
Segmentation fault
Uncaught exception
```

**Solution:**

1. Run container interactively to debug:
   ```bash
   docker run -it --entrypoint /bin/sh <image>
   # Or
   docker run -it --entrypoint /bin/bash <image>
   ```

2. Override command to keep container running:
   ```bash
   docker run -it <image> sleep infinity
   docker exec -it <container-id> /bin/sh
   ```

3. Check configuration files:
   ```bash
   docker run --rm <image> cat /etc/app/config.yml
   ```

---

### Container Running but Not Accessible

**Symptoms:**

- Container is running (`docker ps` shows it)
- Cannot connect to application on published port
- Timeout or connection refused errors
- Browser shows "This site can't be reached"

**Diagnostic Steps:**

1. **Verify container is actually running**
   ```bash
   docker ps
   docker stats <container-id>  # Check if it's doing anything
   ```

2. **Check port mappings**
   ```bash
   docker port <container-id>
   docker inspect <container-id> | jq '.[0].NetworkSettings.Ports'
   ```

3. **Test from inside container**
   ```bash
   docker exec <container-id> curl localhost:8080
   docker exec <container-id> netstat -tulpn
   ```

4. **Check container logs for errors**
   ```bash
   docker logs <container-id>
   ```

**Common Causes & Solutions:**

#### Cause 1: Application not listening on 0.0.0.0

**Problem:**
Application listens on 127.0.0.1 (localhost only), not accessible from outside container.

**Solution:**
Configure application to listen on 0.0.0.0:

```python
# Python Flask - Wrong
app.run(host='127.0.0.1', port=8080)

# Python Flask - Correct
app.run(host='0.0.0.0', port=8080)
```

```javascript
// Node.js - Wrong
app.listen(8080, 'localhost');

// Node.js - Correct
app.listen(8080, '0.0.0.0');
```

#### Cause 2: Wrong port mapping

**Problem:**
Port not published or mapped incorrectly.

**Solution:**
```bash
# Check current mapping
docker port <container-id>

# If wrong, recreate container with correct mapping
docker run -p 8080:8080 <image>  # host:container
```

#### Cause 3: Firewall blocking

**Problem:**
Host firewall blocking the port.

**Solution:**
```bash
# Check firewall rules
sudo iptables -L -n
sudo ufw status

# Allow port (ufw)
sudo ufw allow 8080

# Allow port (firewalld)
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
```

#### Cause 4: Container on different network

**Problem:**
Container not on expected network.

**Solution:**
```bash
# Check container's networks
docker inspect <container-id> | jq '.[0].NetworkSettings.Networks'

# Connect to network
docker network connect <network-name> <container-id>

# Or create container on specific network
docker run --network <network-name> <image>
```

---

### Image Build Failures

**Symptoms:**

- `docker build` command fails
- Build stops at specific step
- Error messages during build process

**Diagnostic Steps:**

1. **Run build with no cache**
   ```bash
   docker build --no-cache -t myimage .
   ```

2. **Build with progress output**
   ```bash
   docker build --progress=plain -t myimage .
   ```

3. **Check each layer**
   ```bash
   docker history <image>
   ```

**Common Causes & Solutions:**

#### Cause 1: Context too large

**Error message:**
```
Sending build context to Docker daemon  2.5GB
```

**Solution:**

1. Create `.dockerignore` file:
   ```
   node_modules
   .git
   .env
   *.log
   dist
   build
   ```

2. Only copy what you need:
   ```dockerfile
   # Bad - copies everything
   COPY . /app

   # Good - selective copying
   COPY package*.json /app/
   COPY src /app/src
   ```

#### Cause 2: Dependency installation fails

**Error message:**
```
npm ERR! network request failed
pip install failed
```

**Solution:**

1. Add retries:
   ```dockerfile
   RUN npm install || npm install || npm install
   ```

2. Use specific mirrors:
   ```dockerfile
   RUN pip install --index-url https://pypi.org/simple -r requirements.txt
   ```

3. Copy dependency files first (for caching):
   ```dockerfile
   COPY package.json package-lock.json /app/
   RUN npm ci
   COPY . /app/  # Copy rest after dependencies installed
   ```

#### Cause 3: Base image not found

**Error message:**
```
Error response from daemon: pull access denied for myimage, repository does not exist
```

**Solution:**

1. Check image name and tag:
   ```dockerfile
   # Wrong
   FROM node:latest-alpine

   # Correct
   FROM node:18-alpine
   ```

2. Use specific version tags:
   ```dockerfile
   FROM python:3.11-slim  # Not just "python"
   ```

#### Cause 4: File not found during COPY

**Error message:**
```
COPY failed: file not found in build context
```

**Solution:**

1. Verify file exists:
   ```bash
   ls -la relative/to/dockerfile
   ```

2. Use correct path relative to build context:
   ```dockerfile
   # Build context is current directory
   # docker build .
   COPY ./src /app/src  # Correct
   COPY /absolute/path /app/  # Won't work
   ```

---

### Networking Issues

**Symptoms:**

- Containers can't communicate with each other
- Cannot access external services from container
- DNS resolution failures

**Diagnostic Steps:**

1. **Check container networks**
   ```bash
   docker network ls
   docker network inspect <network-name>
   ```

2. **Test connectivity**
   ```bash
   docker exec <container> ping <other-container>
   docker exec <container> nslookup google.com
   docker exec <container> curl http://other-container:8080
   ```

3. **Check DNS**
   ```bash
   docker exec <container> cat /etc/resolv.conf
   ```

**Common Causes & Solutions:**

#### Cause 1: Containers on different networks

**Solution:**
```bash
# Create network
docker network create myapp-network

# Run containers on same network
docker run --network myapp-network --name db postgres
docker run --network myapp-network --name web myapp

# Or connect existing container
docker network connect myapp-network <container-id>
```

#### Cause 2: Using localhost instead of container name

**Wrong:**
```javascript
// In container, trying to connect to another container
mongoose.connect('mongodb://localhost:27017/mydb');
```

**Correct:**
```javascript
// Use container name or service name
mongoose.connect('mongodb://mongo:27017/mydb');
```

#### Cause 3: DNS resolution failure

**Solution:**

1. Use custom DNS:
   ```bash
   docker run --dns 8.8.8.8 --dns 8.8.4.4 <image>
   ```

2. Or in daemon config `/etc/docker/daemon.json`:
   ```json
   {
     "dns": ["8.8.8.8", "8.8.4.4"]
   }
   ```

---

### Performance Issues

**Symptoms:**

- Container running slowly
- High CPU or memory usage
- Application timeouts

**Diagnostic Steps:**

1. **Monitor resource usage**
   ```bash
   docker stats
   docker stats <container-id>
   ```

2. **Check container limits**
   ```bash
   docker inspect <container-id> | jq '.[0].HostConfig.Memory'
   docker inspect <container-id> | jq '.[0].HostConfig.CpuShares'
   ```

3. **Examine logs for performance issues**
   ```bash
   docker logs <container-id> | grep -i slow
   docker logs <container-id> | grep -i timeout
   ```

**Common Causes & Solutions:**

#### Cause 1: Container hitting memory limit

**Error message:**
```
Killed
Exit code 137
```

**Solution:**

1. Increase memory limit:
   ```bash
   docker run -m 512m <image>  # Set to 512MB
   docker run -m 2g <image>    # Set to 2GB
   ```

2. Find memory leaks in application

#### Cause 2: CPU throttling

**Solution:**
```bash
# Give container more CPU shares
docker run --cpus="2.0" <image>

# Or limit to specific cores
docker run --cpuset-cpus="0,1" <image>
```

#### Cause 3: Disk I/O issues

**Solution:**

1. Use volumes instead of bind mounts for better performance
2. Use volume drivers optimized for your use case
3. Check host disk performance

---

### Volume and Data Issues

**Symptoms:**

- Data not persisting after container restart
- Changes to files not reflected
- Permission denied errors accessing volumes

**Diagnostic Steps:**

1. **List volumes**
   ```bash
   docker volume ls
   docker volume inspect <volume-name>
   ```

2. **Check volume mounts**
   ```bash
   docker inspect <container> | jq '.[0].Mounts'
   ```

3. **Verify data in volume**
   ```bash
   docker run --rm -v <volume-name>:/data alpine ls -la /data
   ```

**Common Causes & Solutions:**

#### Cause 1: Anonymous volume created

**Problem:**
Data in volume but new container uses new anonymous volume.

**Solution:**
Use named volumes:
```bash
# Bad - anonymous volume
docker run -v /app/data <image>

# Good - named volume
docker run -v mydata:/app/data <image>
```

#### Cause 2: Volume permission issues

**Solution:**

1. Check volume ownership:
   ```bash
   docker run --rm -v mydata:/data alpine ls -la /data
   ```

2. Fix permissions in Dockerfile:
   ```dockerfile
   RUN mkdir -p /app/data && chown appuser:appuser /app/data
   VOLUME /app/data
   ```

#### Cause 3: Bind mount not updating

**Solution:**

1. On macOS, ensure file sharing is enabled in Docker Desktop
2. Try :cached or :delegated options:
   ```bash
   docker run -v $(pwd):/app:cached <image>
   ```

---

### Docker Compose Issues

**Symptoms:**

- Services won't start with docker-compose
- Services can't communicate
- Environment variables not working

**Diagnostic Steps:**

1. **Validate compose file**
   ```bash
   docker-compose config
   docker-compose config --services
   ```

2. **Check service logs**
   ```bash
   docker-compose logs
   docker-compose logs <service-name>
   docker-compose logs -f <service-name>  # Follow
   ```

3. **View running services**
   ```bash
   docker-compose ps
   ```

**Common Causes & Solutions:**

#### Cause 1: Invalid YAML syntax

**Solution:**

1. Validate YAML:
   ```bash
   docker-compose config
   ```

2. Common YAML mistakes:
   ```yaml
   # Wrong - incorrect indentation
   services:
   web:
     image: nginx
   
   # Correct
   services:
     web:
       image: nginx
   ```

#### Cause 2: Service dependency issues

**Solution:**
Use depends_on with health checks:
```yaml
services:
  web:
    depends_on:
      db:
        condition: service_healthy
  db:
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "postgres"]
      interval: 5s
      timeout: 5s
      retries: 5
```

#### Cause 3: Environment variables not loaded

**Solution:**

1. Use .env file in same directory as docker-compose.yml
2. Or specify env file:
   ```yaml
   services:
     web:
       env_file:
         - .env
         - .env.production
   ```

---

## Quick Reference Commands

### Debugging

```bash
# View logs
docker logs <container>
docker logs -f <container>  # Follow
docker logs --tail 100 <container>  # Last 100 lines

# Inspect container
docker inspect <container>
docker inspect <container> | jq '.[0].State'

# Execute commands in running container
docker exec -it <container> /bin/bash
docker exec <container> ps aux
docker exec <container> env

# Run one-off command in image
docker run --rm -it <image> /bin/sh

# View resource usage
docker stats
docker top <container>

# View events
docker events
docker events --since 30m
```

### Cleanup

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Remove everything unused
docker system prune -a --volumes

# View disk usage
docker system df
```

### Network debugging

```bash
# List networks
docker network ls

# Inspect network
docker network inspect <network>

# Connect container to network
docker network connect <network> <container>

# Disconnect
docker network disconnect <network> <container>
```

## Prevention Tips

1. **Use health checks**
   ```dockerfile
   HEALTHCHECK --interval=30s --timeout=3s \
     CMD curl -f http://localhost:8080/health || exit 1
   ```

2. **Set resource limits**
   ```yaml
   services:
     web:
       deploy:
         resources:
           limits:
             cpus: '0.5'
             memory: 512M
   ```

3. **Use specific image tags**
   ```dockerfile
   FROM node:18.17.0-alpine  # Not "latest"
   ```

4. **Implement proper logging**
   ```dockerfile
   # Log to stdout/stderr for Docker to capture
   CMD ["python", "-u", "app.py"]  # -u for unbuffered
   ```

5. **Use multi-stage builds**
   ```dockerfile
   # Build stage
   FROM node:18 AS builder
   WORKDIR /app
   COPY . .
   RUN npm ci && npm run build
   
   # Production stage
   FROM node:18-alpine
   WORKDIR /app
   COPY --from=builder /app/dist ./dist
   CMD ["node", "dist/server.js"]
   ```

## When to Ask for Help

If you've tried these steps and still stuck:

1. Check Docker documentation
2. Search Docker forums and Stack Overflow
3. Check GitHub issues for the image you're using
4. Ask in Docker community Slack or Discord
5. Provide: OS, Docker version, exact error messages, Dockerfile, and steps to reproduce
