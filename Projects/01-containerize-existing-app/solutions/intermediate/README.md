# Intermediate Solution

This solution adds multi-stage builds, development configuration, and better practices.

## Dockerfile (Multi-stage)

```dockerfile
# Stage 1: Dependencies
FROM node:18-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Stage 2: Development
FROM node:18-alpine AS development
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
USER node
CMD ["npm", "run", "dev"]

# Stage 3: Production
FROM node:18-alpine AS production
WORKDIR /app

# Copy only production dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY package*.json ./
COPY src ./src
COPY public ./public

# Create and use non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /app

USER nodejs

EXPOSE 3000

# Install curl for health checks
USER root
RUN apk add --no-cache curl
USER nodejs

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

CMD ["node", "src/index.js"]
```

## docker-compose.yml (Production)

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://postgres:${DB_PASSWORD:-postgres}@db:5432/taskapp
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s

  db:
    image: postgres:14-alpine
    environment:
      - POSTGRES_DB=taskapp
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=${DB_PASSWORD:-postgres}
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres-data:
    driver: local
```

## docker-compose.dev.yml (Development Override)

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: development
    volumes:
      # Mount source code for hot-reload
      - ./src:/app/src:ro
      - ./public:/app/public:ro
    environment:
      - NODE_ENV=development
    ports:
      - "3000:3000"
      - "9229:9229"  # Node.js debugger
    command: npm run dev

  db:
    ports:
      - "5432:5432"  # Expose DB for local tools
```

## .dockerignore

```
# Dependencies
node_modules
npm-debug.log
yarn-error.log

# Environment
.env
.env.local
.env.*.local

# Git
.git
.gitignore

# Docker
Dockerfile
docker-compose*.yml
.dockerignore

# Documentation
README.md
*.md
docs/

# Tests
test/
tests/
*.test.js
*.spec.js

# Build output
dist/
build/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db
```

## db/init.sql

```sql
-- Initialize database with better schema
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    completed BOOLEAN DEFAULT FALSE,
    priority INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for better performance
CREATE INDEX idx_tasks_completed ON tasks(completed);
CREATE INDEX idx_tasks_created_at ON tasks(created_at DESC);

-- Insert sample data for development
INSERT INTO tasks (title, description, completed, priority) VALUES
    ('Setup Docker', 'Configure Docker environment', true, 1),
    ('Write Dockerfile', 'Create optimized multi-stage Dockerfile', true, 2),
    ('Test containers', 'Verify all services work correctly', false, 3);
```

## .env.example

```bash
# Application
NODE_ENV=development
PORT=3000

# Database
DB_PASSWORD=secure_password_here
DATABASE_URL=postgresql://postgres:postgres@db:5432/taskapp

# Optional: For local development
DB_HOST=localhost
DB_PORT=5432
DB_NAME=taskapp
DB_USER=postgres
```

## Usage

### Development:
```bash
# Start with hot-reload
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# Code changes in src/ will auto-reload
```

### Production:
```bash
# Build and start
docker-compose up -d

# View logs
docker-compose logs -f app

# Check health
curl http://localhost:3000/health
```

### Testing the Build:
```bash
# Check image size
docker images | grep task-app

# Should be around 80-100MB for production
```

## Key Features

✅ **Multi-stage build**: Separate dev/prod stages  
✅ **Development mode**: Hot-reload with volumes  
✅ **Non-root user**: Yes  
✅ **Health checks**: In both Dockerfile and Compose  
✅ **Small image**: ~90MB  
✅ **Data persistence**: Named volumes  
✅ **Database init**: Automatic schema creation  
✅ **Conditional depends**: Using health checks  
✅ **Environment variables**: Secure password handling

## Improvements Over Beginner

1. **Multi-stage builds** reduce production image size
2. **Separate dev/prod configs** improve developer experience  
3. **Health checks** in both services ensure reliability
4. **Database initialization** automates setup
5. **Better .dockerignore** reduces build context
6. **Volume mounts** enable hot-reload in development
7. **Debugger port** exposed for development

## What Could Still Be Improved

See the advanced solution for:
- Security hardening
- Performance optimization
- Monitoring integration
- CI/CD pipeline
- Advanced networking
