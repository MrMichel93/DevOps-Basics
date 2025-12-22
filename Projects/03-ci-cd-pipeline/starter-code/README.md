# Project 3 Starter Code

## 📋 Overview

This directory provides templates and examples for building your CI/CD pipeline.

## 🎯 What's Provided

Since CI/CD is primarily about workflows and configuration, this starter code includes:

- Example GitHub Actions workflow templates
- Sample test configurations
- Docker build examples
- Deployment script templates

## 🚀 Getting Started

1. **Set Up Repository**
   - Use your app from Project 1 or 2
   - Or create a new simple application
   - Ensure it has tests

2. **Configure GitHub Actions**
   - Create `.github/workflows/` directory
   - Start with basic CI workflow
   - Add complexity incrementally

3. **Set Up Secrets**
   - Go to repository Settings → Secrets
   - Add required secrets (Docker Hub, deployment keys)

4. **Follow Checkpoints**
   - See `checkpoints.md` for guided implementation
   - Test each stage before moving forward

## 📁 Workflow Templates

### Basic CI Workflow
```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node
        uses: actions/setup-node@v3
      - run: npm ci
      - run: npm test
```

### Docker Build Workflow
```yaml
# .github/workflows/docker.yml
name: Docker Build
on:
  push:
    branches: [main]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: docker/setup-buildx-action@v2
      - uses: docker/build-push-action@v4
        with:
          push: true
          tags: user/app:latest
```

## 💡 Tips

- Start with a simple CI workflow
- Test locally with `act` (GitHub Actions simulator)
- Use workflow visualization in GitHub
- Check Actions marketplace for helpful actions
- Monitor workflow execution times

## 📚 Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [Actions Marketplace](https://github.com/marketplace?type=actions)

## ⚠️ Important

- Never commit secrets to code
- Use GitHub Secrets for sensitive data
- Test workflows on feature branches first
- Monitor workflow usage and costs

---

**Ready to automate?** Start with checkpoints.md and build your pipeline step by step!
