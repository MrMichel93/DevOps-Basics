# Common Mistakes in Docker

## Beginner Mistakes

### Mistake 1: Running Containers as Root

**What people do:**
Run applications inside containers as the root user (UID 0), which is often the default.

**Why it's a problem:**
- Major security risk if container is compromised
- Attacker gains root access inside container
- Can potentially escape to host system
- Violates principle of least privilege
- Makes containers vulnerable to privilege escalation
- Fails security audits and compliance checks

**The right way:**
Create and use a non-root user in your Dockerfile:

```dockerfile
FROM node:18-alpine

# Create app user
RUN addgroup -g 1001 -S appuser && \
    adduser -S appuser -u 1001 -G appuser

# Set working directory and ownership
WORKDIR /app
COPY --chown=appuser:appuser . .

# Install dependencies
RUN npm ci --only=production

# Switch to non-root user
USER appuser

EXPOSE 3000
CMD ["node", "server.js"]
```

**How to fix if you've already done this:**
Add user creation and switching to existing Dockerfile:

```dockerfile
# Add before CMD instruction
RUN addgroup -g 1001 -S appuser && \
    adduser -S appuser -u 1001 -G appuser
RUN chown -R appuser:appuser /app
USER appuser
```

Check running containers:

```bash
# See what user container runs as
docker exec <container> whoami

# If it shows 'root', rebuild with USER directive
```

**Red flags to watch for:**
- Security scanners flag root user
- Container runs with full privileges
- `docker exec` shows UID 0
- No USER directive in Dockerfile
- Files created by container owned by root

---

### Mistake 2: Using 'latest' Tag in Production

**What people do:**
Use `docker pull nginx:latest` or reference `FROM ubuntu:latest` in production Dockerfiles.

**Why it's a problem:**
- 'latest' tag changes without warning
- Deployments become non-reproducible
- Updates can break your application
- Difficult to rollback to previous version
- Can't track what version is actually running
- Makes debugging harder when issues arise

**The right way:**
Always use specific version tags:

```dockerfile
# Bad ❌
FROM node:latest
FROM nginx:latest
FROM ubuntu:latest

# Good ✅
FROM node:18.17.0-alpine3.18
FROM nginx:1.25.2-alpine
FROM ubuntu:22.04

# Also acceptable - major version
FROM node:18-alpine
FROM nginx:1.25-alpine
```

For images you pull:

```bash
# Bad ❌
docker pull redis:latest

# Good ✅
docker pull redis:7.2.1-alpine
```

**How to fix if you've already done this:**
Update all Dockerfiles and image references:

```bash
# Find current exact version
docker image inspect node:latest | grep -i version

# Update Dockerfile with specific version
sed -i 's/node:latest/node:18.17.0-alpine/g' Dockerfile

# Update docker-compose.yml
sed -i 's/:latest/:1.25.2-alpine/g' docker-compose.yml

# Rebuild with pinned versions
docker build -t myapp:1.0.0 .
```

**Red flags to watch for:**
- `:latest` tags in Dockerfiles
- Builds produce different results over time
- "It works on my machine" with same Dockerfile
- Can't reproduce production issues locally
- Unexpected behavior after pulling images

---

### Mistake 3: Not Using .dockerignore

**What people do:**
Build Docker images without a `.dockerignore` file, copying all files including `node_modules`, `.git`, build artifacts, and test files.

**Why it's a problem:**
- Creates huge Docker images (GBs instead of MBs)
- Slow build times due to large build context
- Wastes bandwidth transferring unnecessary files
- May include sensitive files (.env, secrets)
- Breaks builds (conflicting dependencies)
- Unnecessary layers increase attack surface

**The right way:**
Create a `.dockerignore` file in your project root:

```dockerignore
# .dockerignore file
# Dependencies
node_modules/
npm-debug.log
venv/
__pycache__/

# Git
.git
.gitignore
.github/

# Development files
.env
.env.*
*.log
*.md
Dockerfile*
docker-compose*

# Build artifacts
dist/
build/
target/
*.exe

# IDE
.vscode/
.idea/
*.swp

# Tests
tests/
*.test.js
coverage/

# Documentation
docs/
README.md
```

**How to fix if you've already done this:**
Create `.dockerignore` and rebuild:

```bash
# Create .dockerignore
cat > .dockerignore << EOF
node_modules/
.git/
.env
tests/
*.md
EOF

# Check build context size before
docker build --no-cache -t myapp:test .
# Note: "Sending build context" size

# After .dockerignore, size should be much smaller
```

**Red flags to watch for:**
- "Sending build context" shows hundreds of MBs
- Build takes minutes just to send context
- Final image is over 1GB for simple app
- `node_modules/` visible in image
- `.git` directory inside container

---

### Mistake 4: Installing Unnecessary Packages

**What people do:**
Install full package suites, build tools, debugging utilities, and development dependencies in production images.

**Why it's a problem:**
- Bloated image size (GB instead of MB)
- Larger attack surface with more packages
- Slower deployments and pulls
- Wastes storage and bandwidth
- More dependencies to maintain and patch
- Increases vulnerability count

**The right way:**
Use minimal base images and multi-stage builds:

```dockerfile
# Bad ❌
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    gcc \
    build-essential \
    curl \
    vim \
    git \
    && pip install -r requirements.txt

# Good ✅ - Multi-stage build
FROM python:3.11-slim as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
CMD ["python", "app.py"]

# Even better ✅ - Alpine for minimal size
FROM python:3.11-alpine as builder
WORKDIR /app
COPY requirements.txt .
RUN apk add --no-cache gcc musl-dev && \
    pip install --user --no-cache-dir -r requirements.txt

FROM python:3.11-alpine
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
CMD ["python", "app.py"]
```

**How to fix if you've already done this:**
Refactor to multi-stage build:

```bash
# Before: 500MB image
# After multi-stage: 50MB image

# Use alpine base images
# Remove build dependencies after use
# Use --no-cache-dir for pip
# Remove package manager cache
```

**Red flags to watch for:**
- Image size over 500MB for simple app
- gcc, make, git inside production image
- Development dependencies in production
- Full Python/Node instead of slim/alpine
- "apt-get install" without cleanup

---

### Mistake 5: Storing Data Inside Containers

**What people do:**
Store application data, databases, logs, or uploads directly in the container filesystem without using volumes.

**Why it's a problem:**
- All data lost when container is deleted
- Can't backup data separately from container
- No data persistence across deployments
- Container size grows uncontrollably
- Performance issues with container layers
- Makes horizontal scaling impossible

**The right way:**
Use Docker volumes or bind mounts for persistent data:

```bash
# Named volume (managed by Docker)
docker run -d \
  --name myapp \
  -v app-data:/app/data \
  myapp:1.0

# Bind mount (host path)
docker run -d \
  --name myapp \
  -v /host/path/data:/app/data \
  myapp:1.0
```

In docker-compose.yml:

```yaml
version: '3.8'
services:
  db:
    image: postgres:15-alpine
    volumes:
      - db-data:/var/lib/postgresql/data
    
  app:
    image: myapp:1.0
    volumes:
      - app-uploads:/app/uploads
      - app-logs:/app/logs

volumes:
  db-data:
  app-uploads:
  app-logs:
```

**How to fix if you've already done this:**
Migrate data to volumes:

```bash
# Copy data from container to volume
docker run --rm \
  --volumes-from old-container \
  -v new-volume:/backup \
  alpine \
  cp -a /app/data/. /backup

# Start new container with volume
docker run -d \
  --name new-container \
  -v new-volume:/app/data \
  myapp:1.0
```

**Red flags to watch for:**
- Lost data after container restart
- Container size keeps growing
- No volumes in `docker inspect`
- Database resets after deployment
- User uploads disappear

---

### Mistake 6: Not Setting Resource Limits

**What people do:**
Run containers without memory or CPU limits, allowing them to consume all host resources.

**Why it's a problem:**
- One container can crash entire host
- Out-of-memory kills random containers
- No fair resource sharing
- Difficult to plan capacity
- Performance issues cascade
- Makes debugging resource issues hard

**The right way:**
Always set resource limits:

```bash
# Using docker run
docker run -d \
  --name myapp \
  --memory="512m" \
  --memory-swap="512m" \
  --cpus="1.0" \
  --pids-limit=100 \
  myapp:1.0
```

In docker-compose.yml:

```yaml
version: '3.8'
services:
  web:
    image: nginx:1.25-alpine
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 256M
        reservations:
          cpus: '0.25'
          memory: 128M
    
  app:
    image: myapp:1.0
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 1G
        reservations:
          cpus: '1.0'
          memory: 512M
```

**How to fix if you've already done this:**
Add limits to running containers:

```bash
# Update existing container (requires restart)
docker update \
  --memory="512m" \
  --cpus="1.0" \
  myapp

# Or recreate with limits
docker stop myapp
docker rm myapp
docker run -d \
  --name myapp \
  --memory="512m" \
  --cpus="1.0" \
  myapp:1.0
```

**Red flags to watch for:**
- Host runs out of memory frequently
- Containers killed by OOM killer
- Uneven resource usage across containers
- No resource limits in `docker stats`
- System becomes unresponsive

---

### Mistake 7: Exposing Unnecessary Ports

**What people do:**
Expose all application ports, debug ports, database ports to the host or internet without considering security.

**Why it's a problem:**
- Increases attack surface
- Exposes internal services to internet
- Database ports accessible externally
- Debug ports exploitable
- Violates defense in depth
- Fails security compliance

**The right way:**
Only expose necessary ports and use networks:

```dockerfile
# Dockerfile - only declare needed ports
EXPOSE 8080
# Don't expose database, cache, or debug ports
```

```bash
# Publish only what's needed
docker run -d \
  --name web \
  -p 80:8080 \
  myapp:1.0
# Note: Container port 8080 mapped to host port 80
```

Use Docker networks for inter-container communication:

```yaml
version: '3.8'
services:
  web:
    image: nginx:1.25-alpine
    ports:
      - "80:80"  # Only web traffic exposed
    networks:
      - frontend
    
  app:
    image: myapp:1.0
    # No ports exposed to host!
    networks:
      - frontend
      - backend
    
  db:
    image: postgres:15-alpine
    # No ports exposed to host!
    networks:
      - backend
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}

networks:
  frontend:
  backend:
```

**How to fix if you've already done this:**
Reconfigure port exposure:

```bash
# Check what's exposed
docker ps
docker port myapp

# Recreate without unnecessary ports
docker stop myapp
docker rm myapp
docker run -d \
  --name myapp \
  -p 80:8080 \
  # Remove -p 5432:5432, -p 6379:6379, etc.
  myapp:1.0
```

**Red flags to watch for:**
- Database accessible from internet
- Port 5432 (Postgres) or 3306 (MySQL) exposed
- Debug port 9229 (Node) or 5678 (Python) open
- All ports published with `-p`
- Security scans find open ports

---

### Mistake 8: Committing Secrets in Docker Images

**What people do:**
Hardcode API keys, passwords, certificates, or tokens directly in Dockerfiles or build secrets into images.

**Why it's a problem:**
- Secrets permanently stored in image layers
- Anyone with image access can extract secrets
- Can't rotate secrets without rebuilding
- Violates security best practices
- Compliance violations
- Secrets exposed in Docker Hub/registries

**The right way:**
Use environment variables or Docker secrets:

```dockerfile
# Bad ❌
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN echo "API_KEY=sk_live_123456789" > .env
RUN npm install
CMD ["node", "server.js"]

# Good ✅
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
# No secrets in image!
CMD ["node", "server.js"]
```

Pass secrets at runtime:

```bash
# Using environment variables
docker run -d \
  --name myapp \
  -e API_KEY=${API_KEY} \
  -e DB_PASSWORD=${DB_PASSWORD} \
  myapp:1.0

# Using env file
docker run -d \
  --name myapp \
  --env-file .env \
  myapp:1.0

# Using Docker secrets (Swarm)
echo "my_secret_password" | docker secret create db_password -
docker service create \
  --name myapp \
  --secret db_password \
  myapp:1.0
```

In docker-compose.yml:

```yaml
version: '3.8'
services:
  app:
    image: myapp:1.0
    environment:
      - API_KEY=${API_KEY}
      - DB_PASSWORD=${DB_PASSWORD}
    # Or use env_file
    env_file:
      - .env
```

**How to fix if you've already done this:**
Remove secrets from image and rebuild:

```bash
# 1. Remove secrets from Dockerfile
# 2. Add .env to .dockerignore
echo ".env" >> .dockerignore

# 3. Rebuild image
docker build -t myapp:1.1 .

# 4. Check layers don't contain secrets
docker history myapp:1.1

# 5. If old image had secrets, delete it
docker rmi myapp:1.0

# 6. Rotate all exposed secrets immediately
```

**Red flags to watch for:**
- Passwords visible in Dockerfile
- API keys in environment variables in Dockerfile
- .env files copied into image
- Certificates in image layers
- `docker history` shows secrets
- Security alerts from registry scans

---

## Intermediate Mistakes

### Mistake 9: Not Using Multi-Stage Builds

**What people do:**
Include build tools, source code, test files, and dependencies in the final production image.

**Why it's a problem:**
- Massive image sizes (1GB+ instead of 50MB)
- Build dependencies in production
- Source code exposed in image
- Slower deployments
- Higher security risks
- Unnecessary attack surface

**The right way:**
Use multi-stage builds to separate build and runtime:

```dockerfile
# Multi-stage build example
# Stage 1: Build
FROM node:18 as builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
RUN npm test

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
# Only copy necessary artifacts
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
RUN npm ci --only=production
USER node
CMD ["node", "dist/server.js"]

# Result: ~50MB instead of ~500MB
```

For compiled languages:

```dockerfile
# Go example
FROM golang:1.21 as builder
WORKDIR /app
COPY go.* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o server

FROM alpine:3.18
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=builder /app/server .
CMD ["./server"]

# Result: ~10MB instead of ~800MB
```

**How to fix if you've already done this:**
Refactor existing Dockerfile:

```bash
# Before: Single stage
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
CMD ["node", "dist/server.js"]
# Size: 500MB

# After: Multi-stage
# (See examples above)
# Size: 50MB
```

**Red flags to watch for:**
- Image over 500MB for simple app
- gcc, make, git in production image
- node_modules with dev dependencies
- Source .ts/.jsx files in image
- Build tools like webpack in final image

---

### Mistake 10: Inefficient Layer Caching

**What people do:**
Copy all files before installing dependencies, causing cache invalidation on every code change.

**Why it's a problem:**
- Reinstalls dependencies on every build
- Slow build times (minutes instead of seconds)
- Wastes bandwidth downloading packages
- CI/CD pipelines take forever
- Developer productivity suffers

**The right way:**
Order Dockerfile instructions for optimal caching:

```dockerfile
# Bad ❌ - Breaks cache on every code change
FROM node:18-alpine
WORKDIR /app
COPY . .                    # Copies everything including code
RUN npm install             # Reinstalls on every code change
CMD ["node", "server.js"]

# Good ✅ - Efficient layer caching
FROM node:18-alpine
WORKDIR /app
# Copy only dependency files first
COPY package*.json ./
RUN npm ci --only=production  # Cached unless package.json changes
# Copy application code last
COPY . .
CMD ["node", "server.js"]
```

For Python:

```dockerfile
# Efficient caching
FROM python:3.11-slim
WORKDIR /app
# Dependencies first
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Code last
COPY . .
CMD ["python", "app.py"]
```

**How to fix if you've already done this:**
Reorder Dockerfile instructions:

```dockerfile
# Principle: Least frequently changed items first
# 1. Base image (rarely changes)
FROM node:18-alpine

# 2. System dependencies (rarely change)
RUN apk add --no-cache dumb-init

# 3. Application dependencies (change occasionally)
COPY package*.json ./
RUN npm ci --only=production

# 4. Application code (changes frequently)
COPY . .

# 5. Runtime configuration
CMD ["dumb-init", "node", "server.js"]
```

**Red flags to watch for:**
- Every build downloads packages
- Build takes 5+ minutes for simple code change
- "Downloading..." in every build
- No cache hits in build output
- COPY . . before dependency installation

---

### Mistake 11: Running Multiple Processes in One Container

**What people do:**
Run web server, database, cache, worker processes, cron jobs all in a single container using supervisord or custom scripts.

**Why it's a problem:**
- Violates single-responsibility principle
- Can't scale components independently
- Difficult to debug which process failed
- Complex logging and monitoring
- Health checks become complicated
- Can't update one service without affecting others

**The right way:**
One process per container, orchestrate with Docker Compose:

```yaml
# Good ✅ - Separate containers
version: '3.8'
services:
  web:
    image: myapp-web:1.0
    command: ["node", "server.js"]
    ports:
      - "80:8080"
    depends_on:
      - db
      - redis
    
  worker:
    image: myapp-worker:1.0
    command: ["node", "worker.js"]
    depends_on:
      - db
      - redis
    
  scheduler:
    image: myapp-scheduler:1.0
    command: ["node", "scheduler.js"]
    depends_on:
      - db
      - redis
    
  db:
    image: postgres:15-alpine
    volumes:
      - db-data:/var/lib/postgresql/data
    
  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data

volumes:
  db-data:
  redis-data:
```

**How to fix if you've already done this:**
Split monolithic container into services:

```bash
# Before: One container running everything
# supervisord.conf managing nginx + app + worker

# After: Separate Dockerfiles
# Dockerfile.web
FROM node:18-alpine
COPY . .
CMD ["node", "server.js"]

# Dockerfile.worker
FROM node:18-alpine
COPY . .
CMD ["node", "worker.js"]

# docker-compose.yml orchestrates both
```

**Red flags to watch for:**
- supervisord or systemd in container
- Multiple CMD or ENTRYPOINT processes
- Complex startup scripts managing processes
- Can't determine why container is unhealthy
- Need to restart everything for one service update

---

### Mistake 12: Ignoring Container Health Checks

**What people do:**
Deploy containers without HEALTHCHECK instructions, relying only on process running status.

**Why it's a problem:**
- Container appears "running" but app is dead
- Load balancers route to unhealthy instances
- No automatic recovery from failures
- Difficult to detect app crashes vs hangs
- Manual intervention required
- Poor user experience with failed requests

**The right way:**
Add health checks to Dockerfile and compose:

```dockerfile
# Dockerfile with health check
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD node healthcheck.js || exit 1

EXPOSE 8080
CMD ["node", "server.js"]
```

Health check script:

```javascript
// healthcheck.js
const http = require('http');

const options = {
  host: 'localhost',
  port: 8080,
  path: '/health',
  timeout: 2000
};

const req = http.request(options, (res) => {
  if (res.statusCode === 200) {
    process.exit(0);
  } else {
    process.exit(1);
  }
});

req.on('error', () => process.exit(1));
req.end();
```

In docker-compose.yml:

```yaml
version: '3.8'
services:
  app:
    image: myapp:1.0
    healthcheck:
      test: ["CMD", "node", "healthcheck.js"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 40s
    
  db:
    image: postgres:15-alpine
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
```

**How to fix if you've already done this:**
Add health checks to existing containers:

```bash
# Add to Dockerfile and rebuild
# Or add in docker-compose.yml

# Check health status
docker ps  # Shows (healthy) or (unhealthy)
docker inspect --format='{{.State.Health.Status}}' myapp
```

**Red flags to watch for:**
- Containers run but don't respond
- Manual restarts needed frequently
- "Connection refused" despite container running
- No health status in `docker ps`
- Load balancer routing to dead instances

---

### Mistake 13: Not Cleaning Up Build Artifacts

**What people do:**
Leave package manager cache, temporary files, build artifacts in image layers.

**Why it's a problem:**
- Inflated image sizes
- Wasted storage and bandwidth
- Longer push/pull times
- Higher costs (storage, network)
- Slower container startup
- Security risks from cached data

**The right way:**
Clean up in the same layer as installation:

```dockerfile
# Bad ❌ - Cache left in layer
FROM ubuntu:22.04
RUN apt-get update
RUN apt-get install -y python3 python3-pip
RUN pip install flask
# Cache remains in layers

# Good ✅ - Cleanup in same layer
FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      python3 \
      python3-pip && \
    pip install --no-cache-dir flask && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
```

For different package managers:

```dockerfile
# Node.js
RUN npm ci --only=production && \
    npm cache clean --force

# Python
RUN pip install --no-cache-dir -r requirements.txt

# Alpine Linux
RUN apk add --no-cache python3 py3-pip

# Debian/Ubuntu
RUN apt-get update && \
    apt-get install -y --no-install-recommends package && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

**How to fix if you've already done this:**
Combine RUN commands and add cleanup:

```dockerfile
# Before: Multiple layers with cache
RUN apt-get update
RUN apt-get install -y package
RUN some-command

# After: Single layer with cleanup
RUN apt-get update && \
    apt-get install -y --no-install-recommends package && \
    some-command && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

**Red flags to watch for:**
- Image size much larger than expected
- `/var/lib/apt/lists/` in image
- npm cache in `/root/.npm`
- pip cache in `/root/.cache`
- Multiple RUN commands in Dockerfile

---

## Advanced Pitfalls

### Mistake 14: Not Using Build Arguments for Flexibility

**What people do:**
Hardcode values in Dockerfile that should be configurable (versions, URLs, build options).

**Why it's a problem:**
- Need different Dockerfiles for different environments
- Can't customize builds without editing Dockerfile
- Difficult to maintain multiple variants
- CI/CD becomes inflexible
- Code duplication across Dockerfiles

**The right way:**
Use build arguments (ARG) for build-time configuration:

```dockerfile
# Flexible Dockerfile
ARG NODE_VERSION=18
ARG ALPINE_VERSION=3.18

FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} as builder

ARG BUILD_ENV=production
ARG API_URL=https://api.production.com

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build:${BUILD_ENV}

FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION}
WORKDIR /app
COPY --from=builder /app/dist ./dist
CMD ["node", "dist/server.js"]
```

Build with different arguments:

```bash
# Production build
docker build \
  --build-arg NODE_VERSION=18 \
  --build-arg BUILD_ENV=production \
  --build-arg API_URL=https://api.prod.com \
  -t myapp:prod .

# Staging build
docker build \
  --build-arg BUILD_ENV=staging \
  --build-arg API_URL=https://api.staging.com \
  -t myapp:staging .

# Development build with different Node version
docker build \
  --build-arg NODE_VERSION=20 \
  --build-arg BUILD_ENV=development \
  -t myapp:dev .
```

**How to fix if you've already done this:**
Add ARG directives for configurable values:

```dockerfile
# Extract hardcoded values to ARGs
ARG PYTHON_VERSION=3.11
ARG APP_PORT=8080
ARG WORKER_PROCESSES=4

FROM python:${PYTHON_VERSION}-slim
EXPOSE ${APP_PORT}
ENV WORKERS=${WORKER_PROCESSES}
```

**Red flags to watch for:**
- Multiple similar Dockerfiles (Dockerfile.prod, Dockerfile.dev)
- Hardcoded version numbers
- Hardcoded URLs or configuration
- Can't test different base image versions
- Maintaining parallel Dockerfiles

---

### Mistake 15: Improper Signal Handling and Graceful Shutdown

**What people do:**
Use shell form of CMD/ENTRYPOINT or don't handle SIGTERM, causing containers to be forcefully killed.

**Why it's a problem:**
- Containers killed without cleanup
- Data loss or corruption
- Ongoing requests terminated abruptly
- Database connections not closed properly
- No graceful shutdown period
- Poor user experience with dropped connections

**The right way:**
Use exec form and handle signals properly:

```dockerfile
# Bad ❌ - Shell form doesn't pass signals
CMD node server.js

# Good ✅ - Exec form
CMD ["node", "server.js"]

# Better ✅ - With init system
RUN apk add --no-cache dumb-init
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "server.js"]
```

Handle signals in application:

```javascript
// Node.js example
const server = app.listen(3000);

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, closing server gracefully');
  server.close(() => {
    console.log('Server closed');
    // Close database connections
    db.close(() => {
      console.log('Database connections closed');
      process.exit(0);
    });
  });
  
  // Force shutdown after timeout
  setTimeout(() => {
    console.error('Forced shutdown');
    process.exit(1);
  }, 10000);
});
```

Python example:

```python
import signal
import sys

def signal_handler(sig, frame):
    print('SIGTERM received, shutting down gracefully')
    # Close connections, save state
    cleanup()
    sys.exit(0)

signal.signal(signal.SIGTERM, signal_handler)
signal.signal(signal.SIGINT, signal_handler)
```

**How to fix if you've already done this:**
Update CMD to exec form and add signal handling:

```dockerfile
# Change from shell form
CMD node server.js

# To exec form
CMD ["node", "server.js"]

# Or use tini/dumb-init
COPY --from=builder /usr/bin/dumb-init /usr/bin/dumb-init
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "server.js"]
```

**Red flags to watch for:**
- Containers take 10+ seconds to stop
- "Killing container" in logs
- Requests fail during deployments
- Database connection errors after restart
- Shell form CMD in Dockerfile
- No signal handlers in application code

---

### Mistake 16: Not Using .dockerignore Effectively

**What people do:**
Create basic .dockerignore but still include unnecessary files, or don't understand exclude/include patterns.

**Why it's a problem:**
- Build context still too large
- Secrets accidentally included
- Slow builds despite .dockerignore
- Cached files invalidate builds
- Test files and docs in production images

**The right way:**
Comprehensive .dockerignore with proper patterns:

```dockerignore
# .dockerignore - Production build

# Start by excluding everything
**

# Then include only what's needed
!package.json
!package-lock.json
!src/**
!public/**

# Always exclude these
.git
.github
.gitignore
.env*
!.env.example

# Build and test
node_modules
npm-debug.log
dist
build
coverage
.nyc_output

# Documentation
README.md
*.md
!README.production.md
docs

# Tests
tests
**/*.test.js
**/*.spec.js
*.test.ts
*.spec.ts

# IDE and OS
.vscode
.idea
*.swp
*.swo
.DS_Store
Thumbs.db

# Docker files
Dockerfile*
docker-compose*
.dockerignore

# CI/CD
.github
.gitlab-ci.yml
.travis.yml
Jenkinsfile

# Logs
logs
*.log
```

**How to fix if you've already done this:**
Review and optimize .dockerignore:

```bash
# Check what's being sent to Docker daemon
docker build --no-cache -t test . 2>&1 | grep "Sending build context"

# Optimize .dockerignore
# Add whitelist approach if needed

# Verify reduction
docker build --no-cache -t test . 2>&1 | grep "Sending build context"
```

**Red flags to watch for:**
- Build context still over 100MB
- git directory in build context
- node_modules sent despite being installed in container
- Test files included in production builds
- .env files accidentally included

---

## Prevention Checklist

### Before Building Images

- [ ] `.dockerignore` file is present and comprehensive
- [ ] Base image uses specific version tag (not `latest`)
- [ ] Multi-stage build used for compiled/built applications
- [ ] Non-root user created and switched to
- [ ] No secrets or credentials in Dockerfile
- [ ] Resource limits considered and documented
- [ ] Health check included

### During Dockerfile Creation

- [ ] Dependency installation before code copy (layer caching)
- [ ] Package manager cache cleaned in same RUN command
- [ ] Minimal base image used (alpine where possible)
- [ ] Only production dependencies installed
- [ ] EXPOSE only necessary ports
- [ ] Exec form used for CMD/ENTRYPOINT
- [ ] Build arguments used for configurable values

### Before Deploying Containers

- [ ] Image scanned for vulnerabilities
- [ ] Resource limits set (memory, CPU)
- [ ] Volumes configured for persistent data
- [ ] Environment variables used for secrets
- [ ] Health checks working properly
- [ ] Graceful shutdown tested
- [ ] Logs going to stdout/stderr
- [ ] Network configuration reviewed

### Security Checklist

- [ ] Running as non-root user
- [ ] No secrets in image layers
- [ ] Minimal attack surface (few packages)
- [ ] Regular base image updates
- [ ] Only necessary ports exposed
- [ ] Read-only filesystem where possible
- [ ] Security scanning integrated in CI/CD

### Performance Checklist

- [ ] Image size optimized (under 100MB if possible)
- [ ] Build caching optimized
- [ ] Multi-stage build for separation
- [ ] Unnecessary files excluded
- [ ] Layer count minimized
- [ ] Resource limits appropriate for workload

### Production Readiness

- [ ] Logging to stdout/stderr
- [ ] Health checks respond correctly
- [ ] Graceful shutdown on SIGTERM
- [ ] Prometheus metrics exposed (if applicable)
- [ ] Configuration via environment variables
- [ ] Documentation updated
- [ ] Rollback plan tested
