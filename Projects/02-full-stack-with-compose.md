# Project 2: Full-Stack Application with Docker Compose

## 🎯 Overview

**Time:** 6-8 hours  
**Prerequisites:** Modules 00-03, Project 1 completed  
**Skills:** Multi-container orchestration, networking, environment management, full-stack development

Build a complete three-tier application with React frontend, Node.js/Express backend, PostgreSQL database, and Nginx reverse proxy—all orchestrated with Docker Compose.

## 📋 Learning Objectives

- Orchestrate multi-container applications
- Configure container networking
- Manage environment variables across services
- Set up reverse proxies with Nginx
- Implement data persistence strategies
- Handle inter-service communication
- Build production-ready full-stack applications

## 🚀 Project Description

Create a full-stack task management application with:

### Architecture
```
┌─────────────┐
│   Browser   │
└──────┬──────┘
       │
┌──────▼──────┐
│    Nginx    │  (Reverse Proxy)
│   Port 80   │
└──────┬──────┘
       │
   ┌───┴────┐
   │        │
┌──▼──┐  ┌─▼────┐
│React│  │ API  │
│ SPA │  │Express│
└─────┘  └──┬───┘
            │
        ┌───▼────┐
        │Postgres│
        │   DB   │
        └────────┘
```

### Services

1. **Frontend (React)**
   - Modern React SPA
   - Communicates with backend API
   - Development mode with hot-reload
   - Production build served by Nginx

2. **Backend (Node.js/Express)**
   - RESTful API
   - Database integration
   - Authentication middleware
   - Input validation

3. **Database (PostgreSQL)**
   - Persistent data storage
   - Initialization scripts
   - Health monitoring

4. **Reverse Proxy (Nginx)**
   - Routes requests to appropriate services
   - Serves static frontend files
   - API proxy to backend
   - Basic security headers

## 📝 Requirements

### 1. Docker Compose Configuration

- [ ] Define all four services
- [ ] Configure custom networks
- [ ] Set up named volumes for persistence
- [ ] Use environment variables
- [ ] Implement service dependencies
- [ ] Add health checks to all services

### 2. Frontend Service

- [ ] React application with Vite or Create React App
- [ ] API client to communicate with backend
- [ ] Environment-based API URL configuration
- [ ] Production build optimization
- [ ] Development mode with hot-reload

### 3. Backend Service

- [ ] Express.js REST API
- [ ] CRUD operations for tasks
- [ ] Database connection pooling
- [ ] Error handling middleware
- [ ] CORS configuration
- [ ] Input validation

### 4. Database Service

- [ ] PostgreSQL with persistent volumes
- [ ] Database initialization script
- [ ] Sample data seeding
- [ ] Health check endpoint

### 5. Nginx Service

- [ ] Reverse proxy configuration
- [ ] Route `/api/*` to backend
- [ ] Serve React app for other routes
- [ ] Security headers
- [ ] Proper MIME types

### 6. Networking

- [ ] Frontend and backend can communicate
- [ ] Backend can access database
- [ ] Frontend isolated from direct database access
- [ ] Proper service discovery using service names

## 🎓 Getting Started

1. Review the starter code in `starter-code/`
2. Follow checkpoints in `checkpoints.md`
3. Reference `rubric.md` for grading criteria
4. Build incrementally, testing each service

## 📚 Resources

- [Docker Compose Networking](https://docs.docker.com/compose/networking/)
- [Nginx Configuration](https://nginx.org/en/docs/)
- [React Environment Variables](https://create-react-app.dev/docs/adding-custom-environment-variables/)
- Module 03: Docker Fundamentals

## 🏆 Bonus Challenges

1. **Redis Caching**: Add Redis for API response caching
2. **WebSockets**: Implement real-time updates
3. **Multiple Environments**: Separate dev/staging/prod configs
4. **Load Balancing**: Scale backend to multiple instances
5. **SSL/TLS**: Add HTTPS with self-signed certificates

## 💡 Tips

- Start with backend and database, then add frontend
- Test each service independently before integration
- Use Docker Compose logs to debug issues
- Keep nginx.conf simple initially
- Use service names for inter-service communication

## 📦 Deliverables

1. `docker-compose.yml`
2. Frontend code with Dockerfile
3. Backend code with Dockerfile
4. Nginx configuration
5. Database initialization scripts
6. Comprehensive README
7. Environment variable templates

## 🔍 Acceptance Criteria

- [ ] All services start with single command
- [ ] Frontend accessible at http://localhost
- [ ] Backend API accessible via Nginx
- [ ] CRUD operations work end-to-end
- [ ] Data persists across restarts
- [ ] Development workflow supports hot-reload
- [ ] Production build optimized for size and performance
- [ ] No hardcoded secrets or configuration

---

**Ready to build?** Start with the backend and database, then layer in the frontend and proxy!
