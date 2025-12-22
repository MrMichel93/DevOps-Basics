# Beginner Solution

This is a straightforward, easy-to-understand solution that meets all basic requirements.

## Dockerfile

```dockerfile
# Use Node.js 18 Alpine for smaller image size
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Change ownership
RUN chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start application
CMD ["node", "src/index.js"]
```

## docker-compose.yml

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/taskapp
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: postgres:14-alpine
    environment:
      - POSTGRES_DB=taskapp
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  postgres-data:
```

## .dockerignore

```
node_modules
npm-debug.log
.env
.git
.gitignore
README.md
.dockerignore
Dockerfile
docker-compose.yml
```

## Usage

### Build and run:
```bash
docker-compose up --build
```

### Stop:
```bash
docker-compose down
```

### Remove volumes (data):
```bash
docker-compose down -v
```

## Key Features

✅ **Multi-stage build**: No, but optimized single-stage  
✅ **Non-root user**: Yes  
✅ **Health checks**: Yes  
✅ **Small image**: ~120MB  
✅ **Data persistence**: Yes  
✅ **Production dependencies only**: Yes

## What Could Be Improved

This beginner solution works well but could be enhanced with:

- Multi-stage builds for even smaller images
- Development configuration with hot-reload
- Better environment variable management
- More robust health checks
- Database initialization scripts

See intermediate and advanced solutions for these improvements!
