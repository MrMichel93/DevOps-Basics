# Beginner Solution - Project 2

## docker-compose.yml

```yaml
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:3001
    depends_on:
      - backend

  backend:
    build: ./backend
    ports:
      - "3001:3001"
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/taskapp
      - NODE_ENV=development
    depends_on:
      - db

  db:
    image: postgres:14-alpine
    environment:
      - POSTGRES_DB=taskapp
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    volumes:
      - postgres-data:/var/lib/postgresql/data

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - frontend
      - backend

volumes:
  postgres-data:
```

## Frontend Dockerfile

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

## Backend Dockerfile

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3001
CMD ["npm", "start"]
```

## nginx.conf

```nginx
events {
    worker_connections 1024;
}

http {
    upstream frontend {
        server frontend:3000;
    }
    
    upstream backend {
        server backend:3001;
    }
    
    server {
        listen 80;
        
        location /api {
            proxy_pass http://backend;
        }
        
        location / {
            proxy_pass http://frontend;
        }
    }
}
```

## Usage

```bash
docker-compose up --build
```

Access at http://localhost

## Key Features

✅ All services orchestrated  
✅ Basic networking  
✅ Data persistence  
✅ Reverse proxy configured  

This solution provides a working foundation. See intermediate and advanced solutions for optimizations!
