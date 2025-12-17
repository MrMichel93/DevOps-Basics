# Module 03: Docker Fundamentals

## 🎯 Learning Objectives

By the end of this module, you will be able to:
- ✅ Understand containerization and why it matters
- ✅ Build Docker images with Dockerfiles
- ✅ Run and manage containers
- ✅ Use Docker Compose for multi-container applications
- ✅ Implement Docker best practices
- ✅ Work with volumes and networks

**Time Required**: 8-10 hours

## 📚 Why Docker?

### The Problem Docker Solves

**"It works on my machine"** - The eternal curse of software development.

**Before Docker:**
- Developer: "Works perfectly on my laptop"
- QA: "Can't reproduce the bug on my test environment"
- Production: "Application crashes on startup"
- DevOps: "Spent 3 days setting up the server"

**After Docker:**
- Package application with ALL dependencies
- Run identically on any machine
- Deploy in seconds, not hours
- Isolated environments prevent conflicts

### Real-World Benefits

**For Developers:**
- 🚀 Quick setup - `docker compose up` and you're running
- 🔧 No dependency conflicts - each project in its own container
- 🧪 Test in production-like environment locally
- 🤝 Same environment for entire team

**For Operations:**
- 📦 Consistent deployments across all environments
- ⚡ Fast startup times (seconds, not minutes)
- 🔄 Easy rollbacks - just run previous image
- 💰 Better resource utilization than VMs

**For Organizations:**
- 🏃 Faster time to market
- 🐛 Fewer environment-related bugs
- 💵 Lower infrastructure costs
- 📈 Better scalability

## 🎓 What is Docker?

### Containers vs Virtual Machines

**Virtual Machine:**
```
┌─────────────────────────────────┐
│         Application A           │
├─────────────────────────────────┤
│          Guest OS               │
├─────────────────────────────────┤
│         Hypervisor              │
├─────────────────────────────────┤
│          Host OS                │
├─────────────────────────────────┤
│         Hardware                │
└─────────────────────────────────┘
Heavy (GBs), Slow Boot, Full OS
```

**Container:**
```
┌─────────────────────────────────┐
│         Application A           │
├─────────────────────────────────┤
│      Container Runtime          │
├─────────────────────────────────┤
│          Host OS                │
├─────────────────────────────────┤
│         Hardware                │
└─────────────────────────────────┘
Light (MBs), Fast Boot, Shared OS
```

### Key Concepts

**Image**: A blueprint (like a class in OOP)
- Contains application code
- Contains dependencies
- Contains configuration
- Immutable (doesn't change)

**Container**: A running instance (like an object in OOP)
- Created from an image
- Isolated process
- Has its own filesystem
- Can be started, stopped, deleted

**Dockerfile**: Instructions to build an image
- Text file with commands
- Defines base image, copies files, installs dependencies
- Like a recipe

**Docker Compose**: Run multiple containers
- YAML configuration file
- Defines services, networks, volumes
- Start entire application stack with one command

## 🗺️ Module Structure

### 1. [Docker Basics](./01-docker-basics.md)
Learn fundamental Docker commands and concepts.
- Installing Docker
- Images and containers
- Essential Docker commands
- Docker Hub

### 2. [Writing Dockerfiles](./02-dockerfile.md)
Build custom images with best practices.
- Dockerfile syntax
- Layer caching
- Multi-stage builds
- Optimization techniques

### 3. [Docker Compose](./03-docker-compose.md)
Orchestrate multi-container applications.
- Compose file structure
- Service definition
- Environment variables
- Dependencies between services

### 4. [Volumes and Networks](./04-volumes-and-networks.md)
Master data persistence and container communication.
- Volume types and usage
- Named vs anonymous volumes
- Network drivers
- Container networking

## 🎯 Practical Examples

We provide complete, working applications:

### [Simple Python App](./examples/simple-python-app/)
A Flask web application containerized with Docker.
- Dockerfile with best practices
- Requirements.txt management
- Port mapping
- **Start**: `cd examples/simple-python-app && docker build -t python-app . && docker run -p 5000:5000 python-app`

### [Node.js App](./examples/nodejs-app/)
Express.js server in a container.
- Node-specific optimizations
- Development vs production builds
- Environment variables
- **Start**: `cd examples/nodejs-app && docker build -t nodejs-app . && docker run -p 3000:3000 nodejs-app`

### [Full-Stack Application](./examples/full-stack-app/)
Complete application with frontend, backend, and database.
- React frontend
- Node.js API backend
- PostgreSQL database
- Nginx reverse proxy
- **Start**: `cd examples/full-stack-app && docker compose up`

### [Nginx Reverse Proxy](./examples/nginx-reverse-proxy/)
Load balancer with multiple backend servers.
- Nginx configuration
- Multiple service instances
- Health checks
- **Start**: `cd examples/nginx-reverse-proxy && docker compose up`

## 🚀 Quick Start

### Your First Container

```bash
# Run a simple web server
docker run -d -p 8080:80 nginx

# Visit http://localhost:8080 in your browser
# You should see "Welcome to nginx!"

# Stop the container
docker stop $(docker ps -q)
```

### Your First Dockerfile

```dockerfile
# Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```

```bash
# Build image
docker build -t myapp .

# Run container
docker run -p 5000:5000 myapp
```

### Your First Docker Compose

```yaml
# docker-compose.yml
version: '3.8'
services:
  web:
    image: nginx
    ports:
      - "8080:80"
  database:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secret
```

```bash
# Start all services
docker compose up

# Stop all services
docker compose down
```

## 📊 Docker Workflow

```
Write Code → Create Dockerfile → Build Image → Run Container → Test → Deploy
     ↓              ↓                  ↓             ↓           ↓        ↓
  Local        Instructions       Immutable     Isolated    Verify   Production
```

## 🎯 Best Practices

### 1. Use Official Images
```dockerfile
# ✅ Good
FROM node:18-alpine

# ❌ Avoid
FROM random-persons-node-image
```

### 2. Use Specific Tags
```dockerfile
# ✅ Good
FROM python:3.11-slim

# ❌ Avoid (breaks when updated)
FROM python:latest
```

### 3. Minimize Layers
```dockerfile
# ✅ Good - 1 layer
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
    && rm -rf /var/lib/apt/lists/*

# ❌ Inefficient - 3 layers
RUN apt-get update
RUN apt-get install -y package1
RUN apt-get install -y package2
```

### 4. Use .dockerignore
```
# .dockerignore
node_modules
*.log
.git
.env
```

### 5. Multi-Stage Builds
```dockerfile
# Build stage
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage
FROM node:18-slim
WORKDIR /app
COPY --from=builder /app/dist ./dist
CMD ["node", "dist/server.js"]
```

## 🐛 Common Issues and Solutions

### Issue: "Cannot connect to Docker daemon"

**Solution:**
```bash
# Ensure Docker Desktop is running
# On Linux, start Docker service
sudo systemctl start docker
```

### Issue: Port already in use

**Solution:**
```bash
# Find what's using the port
lsof -i :8080

# Stop the container using that port
docker stop <container-id>

# Or use a different port
docker run -p 8081:80 nginx
```

### Issue: Out of disk space

**Solution:**
```bash
# Remove unused images, containers, volumes
docker system prune -a

# See disk usage
docker system df
```

### Issue: Build is slow

**Solution:**
- Use `.dockerignore` to exclude unnecessary files
- Order Dockerfile commands (static first, changing last)
- Use multi-stage builds
- Enable BuildKit: `export DOCKER_BUILDKIT=1`

## 💡 Essential Commands

```bash
# Images
docker images                    # List images
docker build -t name .          # Build image
docker pull ubuntu              # Download image
docker rmi image-name           # Remove image

# Containers
docker ps                       # List running containers
docker ps -a                    # List all containers
docker run image-name           # Run container
docker run -d image-name        # Run in background
docker run -p 8080:80 image     # Map ports
docker stop container-id        # Stop container
docker rm container-id          # Remove container
docker logs container-id        # View logs
docker exec -it container bash  # Enter container

# Docker Compose
docker compose up               # Start services
docker compose up -d            # Start in background
docker compose down             # Stop services
docker compose logs -f          # Follow logs
docker compose ps               # List services

# Cleanup
docker system prune             # Remove unused data
docker volume prune             # Remove unused volumes
docker image prune              # Remove unused images
```

## 🎓 Learning Path

**Week 1: Basics**
- Install Docker
- Run existing images
- Basic commands
- Complete [Docker Basics](./01-docker-basics.md)

**Week 2: Building Images**
- Write Dockerfiles
- Build custom images
- Understand layers
- Complete [Dockerfile guide](./02-dockerfile.md)

**Week 3: Multi-Container**
- Learn Docker Compose
- Run multiple services
- Work with volumes and networks
- Complete [Compose guide](./03-docker-compose.md)

**Week 4: Real Applications**
- Containerize existing apps
- Work through all [examples](./examples/)
- Build your own Docker setup

## 📖 Resources

- [Official Docker Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Play with Docker](https://labs.play-with-docker.com/) - Free online Docker playground

## 🚀 Ready to Start?

1. Ensure Docker Desktop is installed and running
2. Start with [01: Docker Basics](./01-docker-basics.md)
3. Work through examples in order
4. Containerize your own applications!

**Remember:** Docker seems complex at first, but after building a few images and running some containers, it becomes second nature. The best way to learn is by doing!

---

**Pro Tip:** Use Docker for every project, even small ones. It's the best way to learn and ensures consistency across environments.
