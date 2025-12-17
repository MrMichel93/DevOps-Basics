# Module 04: CI/CD with GitHub Actions

## 🎯 Learning Objectives

By the end of this module, you will be able to:

- ✅ Understand CI/CD concepts and benefits
- ✅ Create GitHub Actions workflows
- ✅ Automate testing and linting
- ✅ Build and test Docker images automatically
- ✅ Implement deployment pipelines
- ✅ Use GitHub Actions secrets securely

**Time Required**: 6-8 hours

## 📚 What is CI/CD?

### Continuous Integration (CI)

**The Problem:**

- Multiple developers working on same codebase
- Changes conflict with each other
- Bugs discovered late in development
- "Integration hell" before releases

**The Solution:**

- Merge code frequently (multiple times per day)
- Automated tests run on every commit
- Catch bugs early
- Always maintain working codebase

### Continuous Delivery/Deployment (CD)

**Continuous Delivery:**

- Code is always in deployable state
- Manual approval required for production deploy
- Automated deployment to staging/test environments

**Continuous Deployment:**

- Every passing commit automatically deploys to production
- No manual intervention
- Requires high confidence in tests

### Why CI/CD Matters

**Before CI/CD:**

```
Write Code → Wait Days → Manual Testing → Find Bugs → 
Wait for Fix → Manual Deployment → More Bugs → Manual Hotfix
(Weeks to deploy a feature)
```

**With CI/CD:**

```
Write Code → Auto Test (5 min) → Auto Deploy to Staging → 
Review → Auto Deploy to Production
(Minutes to deploy a feature)
```

**Benefits:**

- 🚀 Faster time to market
- 🐛 Catch bugs earlier (cheaper to fix)
- 🔄 More frequent releases
- 📈 Higher quality code
- 😌 Less stressful deployments
- 🔁 Easy rollbacks

## 🎯 Real-World Scenario

**Without CI/CD:**
> Friday 5 PM: "Let's deploy the new feature!"  
> Friday 6 PM: Production is down, everyone working late  
> Friday 9 PM: Still debugging, ordering pizza  
> Saturday 2 AM: Finally fixed, exhausted team

**With CI/CD:**
> Tuesday 2 PM: Push commit  
> Tuesday 2:05 PM: Tests pass, deploys to staging  
> Tuesday 2:10 PM: QA approves, auto-deploys to production  
> Tuesday 2:11 PM: Feature live, grab coffee ☕

## 🌟 GitHub Actions

### What is GitHub Actions?

- **Native CI/CD** built into GitHub
- **Free for public repositories**
- **Generous free tier** for private repos
- **Marketplace** with thousands of pre-built actions
- **Runs on GitHub's infrastructure** (no servers to maintain)

### Key Concepts

**Workflow:**

- Automated process defined in YAML
- Triggered by events (push, pull request, schedule, etc.)
- Located in `.github/workflows/`

**Job:**

- Set of steps that run on same runner
- Multiple jobs run in parallel (by default)

**Step:**

- Individual task in a job
- Runs a command or action

**Action:**

- Reusable unit of code
- Can use actions from marketplace

**Runner:**

- Server that runs your workflows
- GitHub-hosted or self-hosted

### Workflow Anatomy

```yaml
name: CI                          # Workflow name

on: [push, pull_request]          # Triggers

jobs:                             # Jobs
  test:                           # Job ID
    runs-on: ubuntu-latest        # Runner
    steps:                        # Steps
      - uses: actions/checkout@v4 # Use an action
      - name: Run tests           # Step name
        run: npm test             # Run command
```

## 📖 Module Structure

### 1. [GitHub Actions Basics](./01-github-actions-basics.md)

Learn workflow syntax and fundamentals.

- Workflow structure
- Triggers and events
- Jobs and steps
- Using actions from marketplace

### 2. [Testing Automation](./02-testing-automation.md)

Automate tests on every commit.

- Unit tests
- Integration tests
- Linting
- Code coverage

### 3. [Docker Builds](./03-docker-builds.md)

Build and test Docker images automatically.

- Building images in CI
- Multi-platform builds
- Pushing to registries
- Scanning for vulnerabilities

### 4. [Deployment Strategies](./04-deployment-strategies.md)

Deploy applications safely.

- Deployment environments
- Blue-green deployments
- Canary releases
- Rollback strategies

## 🎯 Example Workflows

We provide complete, working workflows:

### [Test Workflow](./.github/workflows/test.yml)

Runs tests on every push and pull request.

### [Lint Workflow](./.github/workflows/lint.yml)

Checks code quality and style.

### [Docker Build Workflow](./.github/workflows/docker-build.yml)

Builds and tests Docker images.

### [Full Pipeline](./.github/workflows/full-pipeline.yml)

Complete CI/CD pipeline with all steps.

## 🚀 Quick Start

### Your First Workflow

Create `.github/workflows/hello.yml`:

```yaml
name: Hello World

on: [push]

jobs:
  greet:
    runs-on: ubuntu-latest
    steps:
      - name: Say hello
        run: echo "Hello, DevOps!"
```

Push to GitHub and check the "Actions" tab!

### Test a Python App

```yaml
name: Python Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install pytest
      
      - name: Run tests
        run: pytest
```

### Build Docker Image

```yaml
name: Docker Build

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Build Docker image
        run: docker build -t myapp .
      
      - name: Test image
        run: |
          docker run -d -p 8080:80 myapp
          sleep 5
          curl http://localhost:8080
```

## 🎨 Workflow Triggers

### Common Triggers

```yaml
# On push to any branch
on: push

# On push to specific branches
on:
  push:
    branches: [ main, develop ]

# On pull request
on: pull_request

# Multiple events
on: [push, pull_request]

# On schedule (cron)
on:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight

# Manual trigger
on: workflow_dispatch

# On release
on:
  release:
    types: [published]
```

### Path Filters

```yaml
on:
  push:
    paths:
      - 'src/**'        # Only if src/ changes
      - '!docs/**'      # Ignore docs/ changes
```

## 💡 Best Practices

### 1. Use Specific Action Versions

```yaml
# ✅ Good - pinned version
- uses: actions/checkout@v4

# ❌ Bad - unpinned
- uses: actions/checkout@main
```

### 2. Cache Dependencies

```yaml
- name: Cache dependencies
  uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
```

### 3. Fail Fast

```yaml
jobs:
  test:
    strategy:
      fail-fast: true  # Stop all if one fails
```

### 4. Use Secrets for Sensitive Data

```yaml
- name: Deploy
  env:
    API_KEY: ${{ secrets.API_KEY }}
  run: ./deploy.sh
```

Never hardcode secrets in workflows!

### 5. Matrix Builds

Test multiple versions:

```yaml
jobs:
  test:
    strategy:
      matrix:
        node-version: [16, 18, 20]
        os: [ubuntu-latest, windows-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
```

## 🐛 Debugging Workflows

### View Logs

1. Go to repository on GitHub
2. Click "Actions" tab
3. Click on workflow run
4. Click on job
5. Expand steps to see logs

### Enable Debug Logging

Add repository secrets:

- `ACTIONS_STEP_DEBUG` = `true`
- `ACTIONS_RUNNER_DEBUG` = `true`

### Test Locally

Use [act](https://github.com/nektos/act):

```bash
# Install act
brew install act  # macOS
# or
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Run workflow locally
act
```

## 🎯 Common Patterns

### Build and Test

```yaml
jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: npm run build
      - name: Test
        run: npm test
```

### Conditional Steps

```yaml
- name: Deploy to production
  if: github.ref == 'refs/heads/main'
  run: ./deploy-prod.sh
```

### Dependent Jobs

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: make build
  
  test:
    needs: build  # Waits for build to complete
    runs-on: ubuntu-latest
    steps:
      - run: make test
  
  deploy:
    needs: [build, test]  # Waits for both
    runs-on: ubuntu-latest
    steps:
      - run: make deploy
```

## 📊 Monitoring Workflows

### Status Badges

Add to README:

```markdown
![CI](https://github.com/username/repo/workflows/CI/badge.svg)
```

### Notifications

Configure notifications in GitHub settings:

- Settings → Notifications → Actions
- Choose email, web, or mobile notifications

## 🚀 Advanced Topics

### Reusable Workflows

```yaml
# .github/workflows/reusable-test.yml
on:
  workflow_call:
    inputs:
      node-version:
        required: true
        type: string

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ inputs.node-version }}
```

Use it:

```yaml
jobs:
  test:
    uses: ./.github/workflows/reusable-test.yml
    with:
      node-version: '18'
```

### Custom Actions

Create your own actions:

```yaml
# action.yml
name: 'My Action'
description: 'Does something useful'
inputs:
  name:
    description: 'Name to greet'
    required: true
runs:
  using: 'node16'
  main: 'index.js'
```

### Environments

Use environments for approvals:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production  # Requires approval
    steps:
      - run: ./deploy.sh
```

## 📝 Exercises

See [exercises.md](./exercises.md) for hands-on practice.

## 📖 Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
- [Awesome Actions](https://github.com/sdras/awesome-actions)
- [act - Run Actions Locally](https://github.com/nektos/act)

## 🎓 Next Steps

1. Read [01: GitHub Actions Basics](./01-github-actions-basics.md)
2. Create your first workflow
3. Work through all examples
4. Implement CI/CD for your projects

**Remember:** Start simple and iterate. You don't need a perfect pipeline on day one!

---

**Pro Tip:** GitHub Actions is free for public repositories. Use it for all your open source projects to build your portfolio and showcase your DevOps skills!
