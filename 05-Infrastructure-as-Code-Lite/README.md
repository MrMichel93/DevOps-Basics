# Module 05: Infrastructure as Code (Lite)

## 🎯 Learning Objectives

- ✅ Understand Infrastructure as Code (IaC) concepts
- ✅ Use Docker Compose as IaC
- ✅ Automate tasks with Makefiles
- ✅ Create reproducible environments
- ✅ Version control infrastructure

**Time Required**: 4-6 hours

## 📚 What is Infrastructure as Code?

### The Traditional Way (Bad)

**Manual Infrastructure:**
1. SSH into server
2. Install packages manually
3. Edit configuration files
4. Restart services
5. Hope you remember what you did
6. Repeat on next server...

**Problems:**
- ❌ Not reproducible
- ❌ Prone to errors
- ❌ No version control
- ❌ Can't easily rollback
- ❌ "Snowflake servers"

### The IaC Way (Good)

**Declarative Infrastructure:**
```yaml
# docker-compose.yml
services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
  database:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
```

Run: `docker compose up`

**Benefits:**
- ✅ Reproducible
- ✅ Version controlled
- ✅ Self-documenting
- ✅ Easy to rollback
- ✅ Consistent environments

## 🎯 Why IaC Matters

**Scenario: New Team Member**

**Without IaC:**
> "Install Node 18, PostgreSQL 15, Redis, configure nginx...  
> Oh, and there's this specific setting in `/etc/postgres/...`  
> Good luck! It took me 3 days to set up."

**With IaC:**
> "Run `docker compose up`  
> Done! Grab coffee ☕"

## 📖 Module Content

### Docker Compose as IaC

Docker Compose files define entire application stacks:

```yaml
version: '3.8'

services:
  # Frontend
  web:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - API_URL=http://api:8080
    depends_on:
      - api

  # Backend API
  api:
    build: ./backend
    ports:
      - "8080:8080"
    environment:
      - DB_HOST=database
      - DB_PASSWORD=${DB_PASSWORD}
    depends_on:
      - database

  # Database
  database:
    image: postgres:15-alpine
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=${DB_PASSWORD}

volumes:
  db-data:
```

**This file IS your infrastructure!**

### Makefile Automation

Makefiles provide consistent commands:

```makefile
.PHONY: build test deploy clean

build:
	docker compose build

test:
	docker compose run --rm api npm test

deploy:
	docker compose up -d

clean:
	docker compose down -v
	docker system prune -f

dev:
	docker compose -f docker-compose.dev.yml up

prod:
	docker compose -f docker-compose.prod.yml up -d
```

Usage:
```bash
make build
make test
make deploy
```

## 🏗️ Environment-Specific Configs

### Development Environment

```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  web:
    build:
      context: ./frontend
      target: development
    volumes:
      - ./frontend:/app          # Live reload
      - /app/node_modules
    environment:
      - NODE_ENV=development
```

### Production Environment

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  web:
    build:
      context: ./frontend
      target: production
    restart: unless-stopped
    environment:
      - NODE_ENV=production
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
```

## 🎯 Real-World Example

Complete application infrastructure in one file:

```yaml
version: '3.8'

services:
  # Nginx reverse proxy
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - frontend
      - backend

  # React frontend
  frontend:
    build: ./frontend
    environment:
      - REACT_APP_API_URL=/api

  # Node.js backend
  backend:
    build: ./backend
    environment:
      - DB_HOST=postgres
      - REDIS_HOST=redis
    depends_on:
      - postgres
      - redis

  # PostgreSQL database
  postgres:
    image: postgres:15-alpine
    volumes:
      - postgres-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s

  # Redis cache
  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data

volumes:
  postgres-data:
  redis-data:
```

**To deploy:** `docker compose up -d`  
**To scale backend:** `docker compose up -d --scale backend=3`  
**To update:** `docker compose pull && docker compose up -d`

## 💡 Best Practices

### 1. Version Control Everything

```bash
git add docker-compose.yml
git add Makefile
git add .env.example
git commit -m "feat: Add infrastructure definition"
```

### 2. Use Environment Variables

```yaml
# docker-compose.yml
environment:
  - DB_PASSWORD=${DB_PASSWORD}
  - API_KEY=${API_KEY}
```

```bash
# .env
DB_PASSWORD=secret123
API_KEY=abc-def-ghi
```

**Never commit `.env` - only `.env.example`!**

### 3. Document Your Infrastructure

```markdown
# Infrastructure

## Quick Start
docker compose up

## Architecture
- Frontend: React on port 3000
- Backend: Node.js API on port 8080
- Database: PostgreSQL on port 5432

## Environment Variables
See `.env.example`
```

### 4. Health Checks

```yaml
services:
  api:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 3s
      retries: 3
```

## 🚀 Practical Examples

See [examples/](./examples/) for:
- Complete Makefile with common tasks
- Development vs Production compose files
- Multi-service application setup
- Environment variable management

## 📝 Exercises

See [exercises.md](./exercises.md) for hands-on practice.

## 🎓 Key Takeaways

1. **Infrastructure should be code** - Version controlled, reproducible
2. **Docker Compose is IaC** - For local and small-scale deployments
3. **Makefiles simplify commands** - Consistent interface
4. **Environment-specific configs** - Development vs Production
5. **Document everything** - README is part of IaC

## 🚀 Next Steps

1. Read module content
2. Work through examples
3. Complete exercises
4. Apply to your projects

**Next Module:** [06-Monitoring-and-Logging](../06-Monitoring-and-Logging/)

---

**Note:** For larger-scale infrastructure, you'd use tools like Terraform, Ansible, or CloudFormation. Docker Compose is perfect for learning IaC concepts and local development!
