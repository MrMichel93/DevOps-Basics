# DevOps Best Practices

Industry-standard patterns and practices for modern software delivery.

## 🎯 The Twelve-Factor App

Methodology for building modern, scalable applications:

### 1. Codebase
✅ One codebase tracked in version control  
✅ Multiple deploys from same codebase  
❌ Multiple codebases for same app

**Practice:** Use Git, one repo per application.

### 2. Dependencies
✅ Explicitly declare all dependencies  
✅ Use package managers (npm, pip, Maven)  
❌ Rely on system-wide packages

**Practice:** `package.json`, `requirements.txt`, `Gemfile`

### 3. Config
✅ Store config in environment variables  
✅ Strict separation of config from code  
❌ Hardcode config in source files

**Practice:**
```bash
# Bad
const DB_HOST = "prod-db.example.com"

# Good
const DB_HOST = process.env.DB_HOST
```

### 4. Backing Services
✅ Treat backing services as attached resources  
✅ Swappable via config change only  
❌ Distinguish between local and third-party services

**Practice:** Database, cache, queue should be interchangeable.

### 5. Build, Release, Run
✅ Strictly separate build and run stages  
✅ Releases are immutable  
❌ Modify code at runtime

**Practice:** Build once, deploy many times.

### 6. Processes
✅ Execute app as stateless processes  
✅ Store state in backing services  
❌ Rely on sticky sessions or local storage

**Practice:** Use Redis, databases for state.

### 7. Port Binding
✅ Export services via port binding  
✅ Self-contained apps  
❌ Rely on runtime injection of webserver

**Practice:** App includes web server, binds to port.

### 8. Concurrency
✅ Scale out via process model  
✅ Processes are first-class citizens  
❌ Scale up (bigger machines)

**Practice:** Run multiple container instances.

### 9. Disposability
✅ Fast startup and graceful shutdown  
✅ Processes are disposable  
❌ Long startup times

**Practice:** Handle SIGTERM, cleanup on exit.

### 10. Dev/Prod Parity
✅ Keep development and production similar  
✅ Same backing services  
❌ Different tools in dev vs prod

**Practice:** Use Docker for consistency.

### 11. Logs
✅ Treat logs as event streams  
✅ Write to stdout/stderr  
❌ Manage log files locally

**Practice:** Let container orchestrator handle logs.

### 12. Admin Processes
✅ Run admin tasks as one-off processes  
✅ Use same codebase and environment  
❌ SSH in and run commands

**Practice:** `docker exec` or Kubernetes jobs.

## 🐳 Docker Best Practices

### Image Building

**1. Use Official Base Images**
```dockerfile
# ✅ Good
FROM node:18-alpine

# ❌ Avoid
FROM some-random-node-image
```

**2. Use Specific Tags**
```dockerfile
# ✅ Good
FROM python:3.11-slim

# ❌ Avoid (breaks when updated)
FROM python:latest
```

**3. Minimize Layers**
```dockerfile
# ✅ Good - 1 layer
RUN apt-get update && \
    apt-get install -y package1 package2 && \
    rm -rf /var/lib/apt/lists/*

# ❌ Inefficient - 3 layers
RUN apt-get update
RUN apt-get install -y package1
RUN apt-get install -y package2
```

**4. Order Instructions by Change Frequency**
```dockerfile
# ✅ Good - static first, changes last
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./    # Changes rarely
RUN npm install          # Changes rarely
COPY . .                 # Changes often

# ❌ Bad - forces rebuild of npm install
FROM node:18-alpine
WORKDIR /app
COPY . .                 # Changes often
RUN npm install          # Rebuilds every time
```

**5. Use Multi-Stage Builds**
```dockerfile
# Build stage
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
CMD ["node", "dist/server.js"]
```

**6. Use .dockerignore**
```
node_modules
*.log
.git
.env
```

**7. Don't Run as Root**
```dockerfile
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001
USER nodejs
```

### Container Runtime

**1. Limit Resources**
```bash
docker run --memory="512m" --cpus="1.0" myapp
```

**2. Use Health Checks**
```dockerfile
HEALTHCHECK --interval=30s CMD curl -f http://localhost/health || exit 1
```

**3. Handle Signals Properly**
```javascript
process.on('SIGTERM', () => {
    console.log('SIGTERM received');
    server.close(() => {
        process.exit(0);
    });
});
```

## 🔄 Git Best Practices

### Commit Messages

**Format:**
```
<type>: <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Tests
- `chore`: Maintenance

**Example:**
```
feat: Add user authentication

Implements JWT-based authentication with refresh tokens.
Users can now register, login, and maintain sessions.

Closes #123
```

### Branching

**Strategy: GitHub Flow**
1. `main` is always deployable
2. Create descriptive branches from `main`
3. Commit often to branch
4. Open PR when ready
5. Merge after review and tests
6. Deploy immediately

**Branch Names:**
```
feature/user-authentication
fix/login-button-alignment
docs/api-documentation
```

## 🚀 CI/CD Best Practices

### Pipeline Design

**1. Fast Feedback**
- Run fastest tests first
- Fail fast on critical issues
- Parallel execution when possible

**2. Consistent Environments**
```yaml
# Use same container image everywhere
jobs:
  test:
    container: node:18
  build:
    container: node:18
```

**3. Idempotent Builds**
- Same input = same output
- No side effects
- Reproducible builds

**4. Secure Secrets**
```yaml
# ✅ Good
env:
  API_KEY: ${{ secrets.API_KEY }}

# ❌ Never
env:
  API_KEY: "hardcoded-secret-123"
```

### Testing Pyramid

```
      /\      E2E Tests (Few)
     /  \     Integration Tests (Some)
    /    \    Unit Tests (Many)
```

**Unit Tests (70%):**
- Fast, isolated
- Test individual functions
- Run on every commit

**Integration Tests (20%):**
- Test component interactions
- Use test database
- Run on every commit

**E2E Tests (10%):**
- Test full workflows
- Slower, more fragile
- Run before deployment

## 🔒 Security Best Practices

### 1. Secrets Management
✅ Use environment variables  
✅ Use secrets managers (GitHub Secrets, Vault)  
❌ Commit secrets to repository  
❌ Hardcode credentials

### 2. Dependency Scanning
✅ Use Dependabot or similar  
✅ Regular updates  
✅ Monitor for vulnerabilities  
❌ Ignore security alerts

### 3. Image Scanning
```bash
# Scan Docker images
docker scan myapp:latest
trivy image myapp:latest
```

### 4. Least Privilege
✅ Run containers as non-root  
✅ Minimal base images  
✅ Restrict network access  
❌ Run everything as root

### 5. Keep Software Updated
✅ Automated updates (where safe)  
✅ Regular patching  
✅ Monitor CVEs  
❌ "If it works, don't touch it"

## 📊 Monitoring Best Practices

### 1. The Four Golden Signals

**Latency:** How long does it take?
```
Response time, request duration
```

**Traffic:** How much demand?
```
Requests per second, concurrent users
```

**Errors:** What's failing?
```
Error rate, failed requests
```

**Saturation:** How full are resources?
```
CPU, memory, disk usage
```

### 2. Logging

**Structure:**
```javascript
// ✅ Good - structured
logger.info('User login', { 
    userId: 123, 
    ip: '192.168.1.1',
    timestamp: new Date() 
});

// ❌ Bad - unstructured
console.log('User 123 logged in from 192.168.1.1');
```

**Levels:**
```
TRACE - Very detailed
DEBUG - Diagnostic info
INFO  - General info
WARN  - Warning
ERROR - Error occurred
FATAL - Critical failure
```

### 3. Alerts

✅ Alert on symptoms, not causes  
✅ Actionable alerts only  
✅ Clear severity levels  
❌ Alert fatigue (too many alerts)

## 🎯 Deployment Strategies

### 1. Blue-Green
Two identical environments. Switch traffic instantly.

**Pros:** Instant rollback, test in production  
**Cons:** Requires 2x resources

### 2. Canary
Gradually roll out to subset of users.

**Pros:** Risk mitigation, early detection  
**Cons:** Complex, requires monitoring

### 3. Rolling Update
Replace instances one at a time.

**Pros:** No downtime, gradual  
**Cons:** Mixed versions during rollout

## 📋 Documentation Best Practices

### README Essentials
1. **What** - Brief description
2. **Why** - Problem it solves
3. **How** - Installation and usage
4. **Examples** - Code samples
5. **Contributing** - How to contribute
6. **License** - Usage terms

### Code Comments
```python
# ✅ Good - explains WHY
# We retry 3 times because API is occasionally unreachable
retry_count = 3

# ❌ Bad - explains WHAT (code already does)
# Set retry count to 3
retry_count = 3
```

### Architecture Diagrams
✅ Include in documentation  
✅ Keep updated  
✅ Show data flow  
✅ Document decisions

## 🎓 Learning & Improvement

### 1. Blameless Postmortems
After incidents:
- What happened?
- Why did it happen?
- How do we prevent it?
- What did we learn?

### 2. Regular Reviews
- Code reviews (always)
- Architecture reviews (quarterly)
- Process reviews (quarterly)
- Tool evaluations (yearly)

### 3. Measure Everything
✅ Deployment frequency  
✅ Lead time for changes  
✅ Time to restore service  
✅ Change failure rate

## 🔗 Additional Resources

- [The Twelve-Factor App](https://12factor.net/)
- [DORA Metrics](https://www.devops-research.com/research.html)
- [Google SRE Book](https://sre.google/books/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---

**Remember:** Best practices are guidelines, not rules. Adapt them to your context!
