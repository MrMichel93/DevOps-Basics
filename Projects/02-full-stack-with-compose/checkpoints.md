# Project 2 Checkpoints

## ✅ Checkpoint 1: Backend & Database (60 min)

### Tasks
- [ ] Set up Express backend with PostgreSQL
- [ ] Create docker-compose.yml with backend and db services
- [ ] Test API endpoints work
- [ ] Verify data persistence

### Verification
```bash
docker-compose up -d
curl http://localhost:3001/api/tasks
```

---

## ✅ Checkpoint 2: Frontend Setup (45 min)

### Tasks
- [ ] Create React application
- [ ] Add frontend service to docker-compose
- [ ] Configure API client
- [ ] Test frontend-backend communication

### Verification
```bash
docker-compose up --build
# Visit http://localhost:3000
```

---

## ✅ Checkpoint 3: Nginx Reverse Proxy (60 min)

### Tasks
- [ ] Add Nginx service
- [ ] Configure proxy for API
- [ ] Serve frontend through Nginx
- [ ] Test routing works

### Verification
```bash
curl http://localhost/api/tasks
curl http://localhost/
```

---

## ✅ Checkpoint 4: Networking & Integration (45 min)

### Tasks
- [ ] Create custom networks
- [ ] Ensure proper service isolation
- [ ] Configure service dependencies
- [ ] Add health checks

---

## ✅ Checkpoint 5: Development Workflow (30 min)

### Tasks
- [ ] Enable hot-reload for frontend
- [ ] Enable nodemon for backend
- [ ] Volume mounts for source code
- [ ] Separate dev configuration

---

## ✅ Checkpoint 6: Production Optimization (45 min)

### Tasks
- [ ] Multi-stage builds for frontend
- [ ] Optimize Nginx configuration
- [ ] Environment variable management
- [ ] Security hardening

---

## 🎯 Final Validation

- [ ] All services start with one command
- [ ] Frontend loads at http://localhost
- [ ] API accessible through Nginx
- [ ] CRUD operations work
- [ ] Data persists across restarts
- [ ] Hot-reload works in dev mode
