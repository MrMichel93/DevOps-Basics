# Node.js App - Docker Example

A production-ready Express.js application demonstrating Docker best practices including multi-stage builds, security hardening, and health checks.

## 📁 Files

- `Dockerfile` - Multi-stage build with security best practices
- `server.js` - Express application
- `package.json` - Node.js dependencies
- `docker-compose.yml` - Compose configuration
- `.dockerignore` - Files to exclude from build

## 🚀 Running the Application

### Option 1: Using Docker

```bash
# Build the image
docker build -t nodejs-app .

# Run the container
docker run -p 3000:3000 nodejs-app

# Run with custom environment
docker run -p 3000:3000 -e NODE_ENV=production nodejs-app

# Run in background
docker run -d -p 3000:3000 --name my-nodejs-app nodejs-app
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

- **Homepage:** <http://localhost:3000>
- **Health Check:** <http://localhost:3000/health>
- **Info API:** <http://localhost:3000/api/info>
- **Users API:** <http://localhost:3000/api/users>

## 🧪 Testing the API

```bash
# Health check
curl http://localhost:3000/health

# Get container info
curl http://localhost:3000/api/info

# Get sample users
curl http://localhost:3000/api/users

# Echo API
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"message":"Hello from Docker!"}' \
  http://localhost:3000/api/echo
```

## 📖 Learning Points

### Multi-Stage Build

The Dockerfile uses two stages:

1. **Builder stage:** Installs all dependencies (including dev)
2. **Production stage:** Only copies production dependencies

This results in a smaller, more secure final image.

### Security Best Practices

1. **Non-root user:**

   ```dockerfile
   RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
   USER nodejs
   ```

2. **Minimal base image:**

   ```dockerfile
   FROM node:18-alpine
   ```

3. **Health check:**

   ```dockerfile
   HEALTHCHECK --interval=30s CMD node -e "..."
   ```

### Optimization Techniques

1. **Layer caching:**

   ```dockerfile
   COPY package*.json ./
   RUN npm ci
   COPY . .
   ```

2. **Clean npm cache:**

   ```dockerfile
   RUN npm ci --only=production && npm cache clean --force
   ```

## 🔧 Development Mode

For development with live reload:

```bash
# Use docker-compose with volume mounts
docker compose -f docker-compose.dev.yml up
```

Or run with mounted volume:

```bash
docker run -p 3000:3000 \
  -v $(pwd):/app \
  -v /app/node_modules \
  -e NODE_ENV=development \
  nodejs-app npm run dev
```

## 🧪 Testing the Build

```bash
# Build
docker build -t nodejs-app .

# Check image size
docker images nodejs-app

# Inspect layers
docker history nodejs-app

# Run security scan (if you have Docker Scout)
docker scout cves nodejs-app
```

## 🏗️ Build Stages Explained

**Stage 1 - Builder:**

- Uses full Node.js image
- Installs all dependencies (including devDependencies)
- Builds application if needed

**Stage 2 - Production:**

- Uses minimal alpine image
- Creates non-root user
- Copies only production dependencies
- Runs as non-root user
- Includes health check

## 📊 Container Stats

```bash
# View resource usage
docker stats my-nodejs-app

# View logs
docker logs -f my-nodejs-app

# Execute commands in running container
docker exec -it my-nodejs-app sh

# Inspect container
docker inspect my-nodejs-app
```

## 🧹 Cleanup

```bash
# Stop and remove container
docker stop my-nodejs-app
docker rm my-nodejs-app

# Remove image
docker rmi nodejs-app

# Clean up everything
docker system prune -a
```

## 🔒 Security Notes

- Container runs as non-root user (nodejs:nodejs)
- Uses official Node.js base image
- Minimal attack surface (alpine variant)
- No unnecessary packages
- Health checks for monitoring
- Graceful shutdown handling

## 📝 Environment Variables

- `NODE_ENV` - Environment (development/production)
- `PORT` - Server port (default: 3000)

## 🚀 Production Deployment

For production, consider:

1. **Use specific image tags:**

   ```dockerfile
   FROM node:18.17.0-alpine3.18
   ```

2. **Add logging:**

   ```javascript
   const morgan = require('morgan');
   app.use(morgan('combined'));
   ```

3. **Add monitoring:**

   ```javascript
   const prometheus = require('prom-client');
   ```

4. **Use secrets for sensitive data:**

   ```bash
   docker run --env-file .env nodejs-app
   ```
