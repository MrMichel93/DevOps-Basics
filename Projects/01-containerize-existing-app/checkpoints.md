# Project 1 Checkpoints

Break down the containerization project into manageable milestones. Complete each checkpoint before moving to the next.

## ✅ Checkpoint 1: Project Setup (15 minutes)

### Tasks
- [ ] Clone/fork the starter code
- [ ] Review the application structure
- [ ] Read package.json to understand dependencies
- [ ] Run application locally without Docker (optional but recommended)
- [ ] Create a new git branch for your work

### Verification
```bash
# Can you run these commands successfully?
cd starter-code
npm install
npm start
# App should be accessible at http://localhost:3000
```

### Common Issues
- **Node version mismatch**: Ensure you have Node 18+ installed
- **Port already in use**: Stop any other services on port 3000
- **Missing dependencies**: Run `npm install` from the correct directory

---

## ✅ Checkpoint 2: Basic Dockerfile (30 minutes)

### Tasks
- [ ] Create `Dockerfile` in the project root
- [ ] Choose appropriate Node.js base image
- [ ] Set working directory
- [ ] Copy package files and install dependencies
- [ ] Copy application code
- [ ] Expose the correct port
- [ ] Define CMD to start the application

### Verification
```bash
# Build the image
docker build -t my-app:v1 .

# Run the container
docker run -p 3000:3000 my-app:v1

# Test in browser
curl http://localhost:3000
```

### Expected Output
- Image builds without errors
- Container starts successfully
- Application responds on port 3000

### Common Issues
- **"COPY failed"**: Check file paths are relative to build context
- **Permission denied**: May need to run Docker commands with sudo (Linux)
- **Port binding error**: Stop existing containers on port 3000
- **Build too slow**: Make sure you're copying package.json before npm install

### Hints
- Use official Node.js images from Docker Hub
- Consider using `node:18-alpine` for smaller size
- Remember to COPY package*.json before running npm install

---

## ✅ Checkpoint 3: Multi-Stage Build (45 minutes)

### Tasks
- [ ] Add a build stage for dependencies
- [ ] Add a production stage with minimal runtime
- [ ] Copy only necessary files to final stage
- [ ] Remove development dependencies
- [ ] Verify image size reduction

### Verification
```bash
# Build with multi-stage
docker build -t my-app:multi-stage .

# Check image size
docker images | grep my-app

# Should see significant size reduction (aim for <150MB)
```

### Expected Results
- Production image is 50-70% smaller than single-stage
- Application still runs correctly
- No build tools in final image

### Common Issues
- **Image still large**: Make sure you're using Alpine base image and not copying node_modules
- **Missing files in production**: Ensure you copy all necessary runtime files
- **Application crashes**: Check that production dependencies are installed

### Hints
- Use `node:18-alpine` as base for smaller images
- Copy from build stage using `COPY --from=builder`
- Only copy `node_modules` from builder stage

---

## ✅ Checkpoint 4: Docker Compose Setup (30 minutes)

### Tasks
- [ ] Create `docker-compose.yml`
- [ ] Define application service
- [ ] Define PostgreSQL service
- [ ] Configure networking between services
- [ ] Set up environment variables
- [ ] Add named volumes for data persistence

### Verification
```bash
# Start all services
docker-compose up

# In another terminal, verify both containers running
docker-compose ps

# Test database connection
docker-compose exec app node -e "console.log(process.env.DATABASE_URL)"
```

### Expected Results
- Both app and database containers start
- App can connect to database
- Services can communicate via service names

### Common Issues
- **Connection refused**: Make sure services are on the same network
- **Database not ready**: Add `depends_on` with health checks
- **Environment variables not set**: Check .env file or environment section

### Hints
- Use service name (e.g., `postgres`) as hostname
- Set `POSTGRES_PASSWORD` for database service
- Use `depends_on` to ensure database starts first

---

## ✅ Checkpoint 5: Development Configuration (45 minutes)

### Tasks
- [ ] Add volume mount for source code
- [ ] Configure hot-reloading (nodemon)
- [ ] Create `.dockerignore` file
- [ ] Add development environment variables
- [ ] Optionally create `docker-compose.dev.yml`

### Verification
```bash
# Start in development mode
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# Edit a source file
echo "console.log('test change')" >> src/index.js

# Verify automatic restart
docker-compose logs -f app
# Should see nodemon restarting
```

### Expected Results
- Code changes trigger automatic reload
- No need to rebuild image for code changes
- Fast iteration cycle

### Common Issues
- **No hot reload**: Check volume mount path matches container path
- **Permission errors**: May need to adjust file permissions on Linux
- **Changes not detected**: Ensure nodemon is watching correct directory

### Hints
- Use bind mounts: `./src:/app/src`
- Install nodemon in development dependencies
- Exclude node_modules from volume mounts

---

## ✅ Checkpoint 6: Health Checks (30 minutes)

### Tasks
- [ ] Add health check endpoint to application (`/health`)
- [ ] Implement HEALTHCHECK in Dockerfile
- [ ] Add healthcheck to docker-compose services
- [ ] Test health check functionality

### Verification
```bash
# Check health status
docker-compose ps

# Should show "(healthy)" status after a few seconds

# Manually test health endpoint
curl http://localhost:3000/health
# Should return: {"status":"ok"}

# Inspect health check details
docker inspect <container-id> | grep -A 10 Health
```

### Expected Results
- Container shows as healthy after startup
- Health endpoint returns 200 OK
- Unhealthy containers restart automatically

### Common Issues
- **Always unhealthy**: Check health endpoint is responding correctly
- **No health status shown**: Verify healthcheck is defined in both Dockerfile and compose
- **Timeout errors**: Increase interval or timeout values

### Hints
- Health check command: `curl -f http://localhost:3000/health || exit 1`
- Set appropriate interval (30s) and timeout (10s)
- Install curl in Dockerfile if using Alpine

---

## ✅ Checkpoint 7: Security & Optimization (45 minutes)

### Tasks
- [ ] Run application as non-root user
- [ ] Scan image for vulnerabilities
- [ ] Review and minimize image layers
- [ ] Set appropriate file permissions
- [ ] Remove unnecessary packages

### Verification
```bash
# Check user
docker-compose exec app whoami
# Should NOT be root

# Scan for vulnerabilities (using Docker Scout or Trivy)
docker scout cves my-app:multi-stage

# Check image history
docker history my-app:multi-stage
```

### Expected Results
- Application runs as non-root user
- No critical vulnerabilities
- Minimal number of layers
- Image size under 150MB

### Common Issues
- **Permission denied as non-root**: Ensure app files have correct ownership
- **Vulnerabilities found**: Update base image and dependencies
- **Image still large**: Review what files are being copied

### Hints
- Create user with: `RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001`
- Use `USER nodejs` before CMD
- Keep .dockerignore comprehensive

---

## ✅ Checkpoint 8: Documentation & Testing (30 minutes)

### Tasks
- [ ] Write comprehensive README.md
- [ ] Document all environment variables
- [ ] Create setup instructions
- [ ] Add troubleshooting section
- [ ] Test entire setup on fresh clone

### Verification
```bash
# Clean everything
docker-compose down -v
docker rmi my-app:multi-stage

# Follow your own README from scratch
# Can someone else set up your project?
```

### Expected Results
- Complete setup works following README only
- All configuration options documented
- Common issues addressed

### Common Issues
- **Missing steps**: Test with someone who hasn't seen the project
- **Undocumented env vars**: List all required variables
- **Platform-specific issues**: Note any OS-specific steps

---

## 🎯 Final Checklist

Before considering the project complete:

- [ ] All containers start successfully
- [ ] Application is accessible and functional
- [ ] Database data persists across restarts
- [ ] Hot-reload works in development mode
- [ ] Health checks pass
- [ ] No critical security vulnerabilities
- [ ] Image size is optimized (<150MB)
- [ ] Documentation is complete
- [ ] Project runs on a fresh clone
- [ ] Git repository is clean and organized

## 📈 Progress Tracking

Keep track of your progress:

- Checkpoint 1: ⬜
- Checkpoint 2: ⬜
- Checkpoint 3: ⬜
- Checkpoint 4: ⬜
- Checkpoint 5: ⬜
- Checkpoint 6: ⬜
- Checkpoint 7: ⬜
- Checkpoint 8: ⬜

Once all checkpoints are complete, proceed to self-assessment using `rubric.md`!
