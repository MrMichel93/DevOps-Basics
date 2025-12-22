# Project 1: Containerize an Existing App

## 🎯 Overview

**Time:** 4-6 hours  
**Prerequisites:** Modules 00-03 (Git, Command Line, Docker Fundamentals)  
**Skills:** Docker, Dockerfile best practices, docker-compose

In this project, you'll take a simple web application and containerize it properly using Docker best practices. You'll learn how to write optimized Dockerfiles, create development and production configurations, and implement health checks.

## 📋 Learning Objectives

By completing this project, you will be able to:

- Write production-ready Dockerfiles with multi-stage builds
- Optimize Docker images for size and security
- Configure docker-compose for local development
- Implement health checks and monitoring
- Set up volume mounts for hot-reloading during development
- Understand Docker networking and port mapping
- Follow Docker security best practices

## 🚀 Project Description

You'll containerize a Node.js web application (provided in starter-code) that includes:

- A simple Express.js backend API
- Static file serving
- Environment-based configuration
- Database connection (PostgreSQL)

### Requirements

1. **Dockerfile**
   - Use multi-stage builds to minimize image size
   - Start from appropriate base images
   - Copy only necessary files
   - Run application as non-root user
   - Implement proper layer caching

2. **docker-compose.yml**
   - Define services for app and database
   - Configure networking between services
   - Set up volume mounts for development
   - Use environment variables properly
   - Implement health checks

3. **Development Setup**
   - Enable hot-reloading for code changes
   - Mount source code as volumes
   - Provide database seed data
   - Include development utilities

4. **Production Configuration**
   - Optimized image size
   - Security hardening
   - Health monitoring
   - Proper logging configuration

## 📝 Acceptance Criteria

Your solution must:

- [ ] Build successfully with `docker build`
- [ ] Start with `docker-compose up`
- [ ] Application accessible at http://localhost:3000
- [ ] Database persists data between restarts
- [ ] Code changes reflect immediately (hot-reload)
- [ ] Health check endpoint returns 200 OK
- [ ] Image size under 150MB (production)
- [ ] No critical security vulnerabilities
- [ ] Includes comprehensive README with setup instructions

## 🎓 Getting Started

1. Navigate to the `starter-code/` directory
2. Review the existing application code
3. Read the setup instructions in `starter-code/README.md`
4. Follow the checkpoints in `checkpoints.md`
5. Refer to `rubric.md` to understand grading criteria

## 📚 Resources

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- Module 03: Docker Fundamentals

## 🏆 Bonus Challenges

Once you complete the basic requirements, try these advanced challenges:

1. **Multi-environment Support**: Create separate docker-compose files for dev/staging/prod
2. **CI/CD Integration**: Add GitHub Actions workflow to build and test Docker image
3. **Monitoring**: Integrate Prometheus metrics endpoint
4. **Logging**: Configure structured logging with JSON format
5. **Security Scanning**: Use Docker Scout or Trivy to scan for vulnerabilities

## 💡 Tips

- Start simple and iterate
- Test each change with `docker-compose down && docker-compose up --build`
- Use `.dockerignore` to exclude unnecessary files
- Check image size with `docker images`
- Review logs with `docker-compose logs -f`

## 📦 Deliverables

Submit a GitHub repository containing:

1. `Dockerfile` (and optional `Dockerfile.dev`)
2. `docker-compose.yml` (and optional `docker-compose.prod.yml`)
3. `.dockerignore`
4. `README.md` with setup and usage instructions
5. Any configuration files
6. Screenshots showing running application

## 🔍 Self-Assessment

Use the rubric in `rubric.md` to evaluate your work before submission. Ensure you meet at least 80% of the criteria for a passing grade.

---

Need help? Check:
- `checkpoints.md` for milestone guidance
- `solutions/` for reference implementations (try solving first!)
- `extensions.md` for ideas to expand the project
