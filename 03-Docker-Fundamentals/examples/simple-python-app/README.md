# Simple Python App - Docker Example

A simple Flask web application demonstrating Docker containerization with best practices.

## 📁 Files

- `Dockerfile` - Container build instructions
- `app.py` - Flask application
- `requirements.txt` - Python dependencies
- `.dockerignore` - Files to exclude from build

## 🚀 Running the Application

### Option 1: Using Docker

```bash
# Build the image
docker build -t python-app .

# Run the container
docker run -p 5000:5000 python-app

# Run in background
docker run -d -p 5000:5000 --name my-python-app python-app

# View logs
docker logs my-python-app

# Stop container
docker stop my-python-app
docker rm my-python-app
```

### Option 2: Using Docker Compose

```bash
# Start the application
docker compose up

# Start in background
docker compose up -d

# View logs
docker compose logs -f

# Stop the application
docker compose down
```

## 🌐 Accessing the Application

Once running, visit:
- **Homepage:** http://localhost:5000
- **Health Check:** http://localhost:5000/health
- **Info:** http://localhost:5000/info

## 🧪 Testing the API

```bash
# Health check
curl http://localhost:5000/health

# Get info
curl http://localhost:5000/info

# Greet API
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"name":"DevOps Engineer"}' \
  http://localhost:5000/api/greet
```

## 📖 Learning Points

### Dockerfile Best Practices Demonstrated

1. **Use official base images**
   ```dockerfile
   FROM python:3.11-slim
   ```

2. **Copy requirements first for caching**
   ```dockerfile
   COPY requirements.txt .
   RUN pip install --no-cache-dir -r requirements.txt
   COPY . .
   ```

3. **Set working directory**
   ```dockerfile
   WORKDIR /app
   ```

4. **Expose ports**
   ```dockerfile
   EXPOSE 5000
   ```

5. **Use CMD for runtime commands**
   ```dockerfile
   CMD ["flask", "run"]
   ```

## 🔧 Development Mode

Run with mounted volume for live code reloading:

```bash
docker run -p 5000:5000 \
  -v $(pwd):/app \
  -e FLASK_DEBUG=1 \
  python-app
```

## 🏗️ Multi-Stage Build (Advanced)

For production, use multi-stage builds:

```dockerfile
# Build stage
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Production stage
FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY app.py .
CMD ["python", "app.py"]
```

## 🧹 Cleanup

```bash
# Stop and remove container
docker stop my-python-app
docker rm my-python-app

# Remove image
docker rmi python-app

# Clean up everything
docker system prune -a
```

## 📝 Notes

- The application runs on port 5000 inside the container
- We map it to port 5000 on host with `-p 5000:5000`
- The container is isolated from the host system
- Each container run creates a new, independent instance
