# CI/CD with GitHub Actions Troubleshooting Guide

## Issue Categories

### Workflow Won't Trigger

**Symptoms:**

- Workflow doesn't run after push/PR
- No workflow runs visible in Actions tab
- Expected workflow missing from runs list

**Diagnostic Steps:**

1. **Check workflow file location**
   ```bash
   ls -la .github/workflows/
   ```
   Files must be in `.github/workflows/` directory

2. **Validate YAML syntax**
   ```bash
   # Use a YAML validator
   yamllint .github/workflows/ci.yml
   # Or check in GitHub UI - it will show syntax errors
   ```

3. **Check workflow triggers**
   Look at the `on:` section of your workflow

4. **Verify branch name**
   Ensure you're on the correct branch specified in triggers

**Common Causes & Solutions:**

#### Cause 1: YAML syntax error

**Error message:**
```
Invalid workflow file
The workflow is not valid
```

**Solution:**

Common YAML mistakes:
```yaml
# Wrong - missing colon
on
  push:
    branches: [ main ]

# Correct
on:
  push:
    branches: [ main ]

# Wrong - incorrect indentation
jobs:
build:
  runs-on: ubuntu-latest

# Correct - consistent 2-space indentation
jobs:
  build:
    runs-on: ubuntu-latest
```

Use online YAML validators or VSCode with YAML extension.

#### Cause 2: Incorrect trigger configuration

**Solution:**

```yaml
# Only runs on main branch pushes
on:
  push:
    branches: [ main ]

# Runs on all branches
on:
  push:
    branches: [ '*' ]

# Runs on push and PRs
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

# Runs on specific paths
on:
  push:
    paths:
      - 'src/**'
      - 'tests/**'
```

#### Cause 3: Workflow disabled

**Solution:**

1. Check Actions tab for disabled workflows
2. Enable the workflow in GitHub UI:
   - Go to Actions tab
   - Select workflow from left sidebar
   - Click "Enable workflow" if disabled

#### Cause 4: File in wrong location

**Solution:**
```bash
# Correct location
.github/workflows/ci.yml

# Wrong locations (won't work)
.github/workflow/ci.yml  # Missing 's'
github/workflows/ci.yml  # Missing '.'
workflows/ci.yml         # Wrong path
```

---

### Workflow Fails to Start

**Symptoms:**

- Workflow is queued but never starts
- "Waiting for a runner" message
- Workflow stuck in pending state

**Diagnostic Steps:**

1. **Check runner availability**
   - Settings → Actions → Runners
   - Verify runners are online

2. **Check billing/limits**
   - May have hit usage limits for private repos
   - Check Actions usage in billing

3. **Review runner labels**
   - Ensure `runs-on` matches available runners

**Common Causes & Solutions:**

#### Cause 1: No available runners

**Solution:**

```yaml
# Use GitHub-hosted runners
jobs:
  build:
    runs-on: ubuntu-latest  # or windows-latest, macos-latest

# If using self-hosted runners, verify they're online
jobs:
  build:
    runs-on: self-hosted
```

#### Cause 2: Usage limits exceeded

**Solution:**

1. Check Actions usage in Settings → Billing
2. For private repos, consider:
   - Upgrade plan
   - Use self-hosted runners (free)
   - Optimize workflow to use fewer minutes

#### Cause 3: Matrix combinations too large

**Solution:**

```yaml
# This creates 12 jobs (3 * 4)
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
    node: [14, 16, 18, 20]

# Reduce combinations
strategy:
  matrix:
    os: [ubuntu-latest]
    node: [18, 20]
```

---

### Build Failures

**Symptoms:**

- Workflow starts but fails at specific step
- Red X on commit/PR
- Error messages in job logs

**Diagnostic Steps:**

1. **Check job logs**
   - Click on failed workflow run
   - Expand failed step to see error

2. **Look for error messages**
   - Exit codes
   - Exception stack traces
   - Failed test names

3. **Compare with successful runs**
   - What changed between success and failure?

**Common Causes & Solutions:**

#### Cause 1: Dependency installation fails

**Error message:**
```
npm ERR! code ENOTFOUND
npm ERR! network request to https://registry.npmjs.org/package failed
```

**Solution:**

1. Add retries:
```yaml
- name: Install dependencies
  run: npm ci || npm ci || npm ci
```

2. Use caching:
```yaml
- name: Cache dependencies
  uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-

- name: Install dependencies
  run: npm ci
```

3. Specify registry:
```yaml
- name: Install dependencies
  run: npm ci --registry=https://registry.npmjs.org/
```

#### Cause 2: Tests fail

**Error message:**
```
FAIL src/app.test.js
  ✕ should return 200 (5 ms)

Test Suites: 1 failed, 1 total
Tests:       1 failed, 1 total
```

**Solution:**

1. Run tests locally to debug:
```bash
npm test
```

2. Check for environment differences:
```yaml
- name: Run tests
  run: npm test
  env:
    NODE_ENV: test
    CI: true
```

3. Add debugging output:
```yaml
- name: Run tests
  run: npm test -- --verbose
```

#### Cause 3: Missing environment variables

**Error message:**
```
Error: Environment variable 'API_KEY' is not defined
```

**Solution:**

1. Add secrets in GitHub:
   - Settings → Secrets and variables → Actions
   - New repository secret

2. Use in workflow:
```yaml
- name: Run application
  run: npm start
  env:
    API_KEY: ${{ secrets.API_KEY }}
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

3. For non-sensitive variables:
```yaml
env:
  NODE_ENV: production
  LOG_LEVEL: info

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Build
        run: npm run build
```

#### Cause 4: Build artifacts from previous step missing

**Solution:**

Share artifacts between steps using `upload-artifact` and `download-artifact`:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build
        run: npm run build
      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build
          path: dist/

  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Download build artifacts
        uses: actions/download-artifact@v3
        with:
          name: build
          path: dist/
      - name: Test
        run: npm test
```

#### Cause 5: Wrong Node/Python/etc. version

**Solution:**

```yaml
# Specify exact version
- name: Setup Node.js
  uses: actions/setup-node@v3
  with:
    node-version: '18.17.0'  # Exact version

# Or use version from file
- name: Setup Node.js
  uses: actions/setup-node@v3
  with:
    node-version-file: '.nvmrc'

# Multiple versions (matrix)
strategy:
  matrix:
    node-version: [16, 18, 20]
steps:
  - name: Setup Node.js
    uses: actions/setup-node@v3
    with:
      node-version: ${{ matrix.node-version }}
```

---

### Permission Issues

**Symptoms:**

- "Permission denied" errors
- Cannot write to repository
- Cannot create releases or comments

**Diagnostic Steps:**

1. **Check workflow permissions**
   ```yaml
   permissions:
     contents: read
     pull-requests: write
   ```

2. **Verify GITHUB_TOKEN permissions**
   - Settings → Actions → General → Workflow permissions

**Common Causes & Solutions:**

#### Cause 1: Insufficient GITHUB_TOKEN permissions

**Error message:**
```
Resource not accessible by integration
```

**Solution:**

Add permissions to workflow:
```yaml
name: CI
on: [push]

permissions:
  contents: write      # For pushing to repo
  pull-requests: write # For commenting on PRs
  issues: write        # For creating issues

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      # ...
```

Or at job level:
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      # ...
```

#### Cause 2: Cannot push to protected branch

**Solution:**

1. Exclude workflow from branch protection:
   - Settings → Branches → Branch protection rules
   - Allow specific actors (like GitHub Actions)

2. Or use a different approach (create PR instead of direct push)

#### Cause 3: File permission issues in container

**Solution:**

```yaml
- name: Fix permissions
  run: |
    sudo chown -R $USER:$USER .
    chmod +x ./scripts/deploy.sh
```

---

### Timeout Issues

**Symptoms:**

- Job cancelled after 6 hours (default timeout)
- Step times out
- "Operation timeout" errors

**Diagnostic Steps:**

1. **Check job duration**
   - Default is 360 minutes (6 hours)

2. **Identify slow steps**
   - Review step timing in logs

**Common Causes & Solutions:**

#### Cause 1: Job exceeds time limit

**Solution:**

Increase timeout:
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 60  # Default is 360
    steps:
      - name: Long running task
        run: npm run build
        timeout-minutes: 30  # Per-step timeout
```

#### Cause 2: Waiting for external resource

**Solution:**

Add timeout with retry:
```yaml
- name: Wait for deployment
  run: |
    timeout 300 bash -c 'until curl -f http://example.com/health; do sleep 5; done'
```

#### Cause 3: Infinite loop or hang

**Solution:**

1. Add debugging:
```yaml
- name: Debug step
  run: |
    set -x  # Print commands
    npm test
```

2. Run locally to identify issue
3. Add step timeout to prevent hanging:
```yaml
- name: Tests
  timeout-minutes: 10
  run: npm test
```

---

### Caching Issues

**Symptoms:**

- Cache not restoring
- Cache not saving
- Slow builds despite caching

**Diagnostic Steps:**

1. **Check cache hit/miss**
   Look for "Cache restored" or "Cache not found" in logs

2. **Verify cache key**
   Ensure key matches across runs

**Common Causes & Solutions:**

#### Cause 1: Cache key changes every run

**Solution:**

Use stable cache keys:
```yaml
# Bad - always different
- uses: actions/cache@v3
  with:
    path: ~/.npm
    key: npm-cache-${{ github.run_id }}  # Changes every run!

# Good - stable based on lock file
- uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-npm-
```

#### Cause 2: Cache paths incorrect

**Solution:**

```yaml
- uses: actions/cache@v3
  with:
    path: |
      ~/.npm
      ~/.cache
      node_modules
    key: ${{ runner.os }}-deps-${{ hashFiles('**/package-lock.json') }}
```

Common cache paths:
- npm: `~/.npm`
- pip: `~/.cache/pip`
- maven: `~/.m2/repository`
- gradle: `~/.gradle/caches`

#### Cause 3: Cache size limit exceeded

**Solution:**

GitHub has cache size limits (10 GB total per repo). Clean up old caches:

```yaml
- name: Clear old caches
  run: |
    gh cache list
    gh cache delete <cache-key>
  env:
    GH_TOKEN: ${{ github.token }}
```

---

### Docker Issues in CI

**Symptoms:**

- Docker commands fail
- Cannot build images
- Cannot push to registry

**Diagnostic Steps:**

1. **Check Docker availability**
```yaml
- name: Check Docker
  run: |
    docker --version
    docker info
```

2. **Verify registry login**
```yaml
- name: Test registry access
  run: docker login --username ${{ secrets.DOCKER_USERNAME }} --password ${{ secrets.DOCKER_PASSWORD }}
```

**Common Causes & Solutions:**

#### Cause 1: Docker not available on runner

**Solution:**

GitHub-hosted Ubuntu and Windows runners have Docker. macOS runners need Docker Desktop:

```yaml
# Ubuntu - Docker available
runs-on: ubuntu-latest

# macOS - need to install Docker
runs-on: macos-latest
steps:
  - name: Install Docker
    run: |
      brew install --cask docker
      open /Applications/Docker.app
```

#### Cause 2: Not logged into registry

**Solution:**

```yaml
- name: Login to Docker Hub
  uses: docker/login-action@v2
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}

# Or for GitHub Container Registry
- name: Login to GHCR
  uses: docker/login-action@v2
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
```

#### Cause 3: Image build fails

**Solution:**

```yaml
# Use Docker buildx for better caching
- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v2

- name: Build and push
  uses: docker/build-push-action@v4
  with:
    context: .
    push: true
    tags: user/app:latest
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

---

### Secrets and Security Issues

**Symptoms:**

- Secrets not accessible
- Credentials exposed in logs
- Security scanning failures

**Diagnostic Steps:**

1. **Verify secrets exist**
   - Settings → Secrets and variables → Actions

2. **Check secret names**
   - Must match exactly (case-sensitive)

3. **Review logs for exposed secrets**
   - GitHub masks secrets but not always perfectly

**Common Causes & Solutions:**

#### Cause 1: Secret name mismatch

**Solution:**

```yaml
# Secret name: 'API_KEY' (in GitHub settings)

# Wrong
env:
  API_KEY: ${{ secrets.api_key }}  # Wrong case

# Correct
env:
  API_KEY: ${{ secrets.API_KEY }}  # Exact match
```

#### Cause 2: Secret exposed in logs

**Solution:**

```yaml
# Bad - might expose secret
- name: Deploy
  run: echo "Deploying with key: ${{ secrets.API_KEY }}"

# Good - don't print secrets
- name: Deploy
  run: ./deploy.sh
  env:
    API_KEY: ${{ secrets.API_KEY }}

# If you must debug, mask it
- name: Debug
  run: |
    echo "::add-mask::${{ secrets.API_KEY }}"
    echo "Key is set"
```

#### Cause 3: Secrets not available in forks

**Note:** Secrets are not available in PRs from forks for security.

**Solution:**

For public repos accepting PRs from forks:
```yaml
# Use pull_request_target with caution
on:
  pull_request_target:
    types: [labeled]

jobs:
  build:
    if: contains(github.event.pull_request.labels.*.name, 'safe-to-test')
    # ...
```

Or run untrusted code without secrets:
```yaml
on: pull_request

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          ref: ${{ github.event.pull_request.head.sha }}
      - name: Run tests (no secrets)
        run: npm test
```

---

## Quick Reference Commands

### Debugging Workflows

```bash
# Run workflow locally with act
brew install act  # or other package manager
act -j build  # Run specific job
act -n        # Dry run

# Validate workflow syntax
yamllint .github/workflows/ci.yml

# Use GitHub CLI to view runs
gh run list
gh run view <run-id>
gh run watch
gh run rerun <run-id>
```

### Common Workflow Patterns

```yaml
# Basic CI workflow
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm test

# Matrix testing
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest, windows-latest]
    node: [16, 18, 20]
runs-on: ${{ matrix.os }}

# Conditional steps
- name: Deploy
  if: github.ref == 'refs/heads/main'
  run: ./deploy.sh

# Continue on error
- name: Lint
  continue-on-error: true
  run: npm run lint
```

## Prevention Tips

1. **Use workflow templates**
   ```bash
   # Start with community templates
   # .github/workflows/ → Choose a template
   ```

2. **Enable branch protection**
   - Require status checks before merge
   - Require up-to-date branches

3. **Use dependabot for actions**
   ```yaml
   # .github/dependabot.yml
   version: 2
   updates:
     - package-ecosystem: "github-actions"
       directory: "/"
       schedule:
         interval: "weekly"
   ```

4. **Pin action versions**
   ```yaml
   # Bad - can break unexpectedly
   - uses: actions/checkout@v3

   # Good - pinned to specific commit
   - uses: actions/checkout@8e5e7e5ab8b370d6c329ec480221332ada57f0ab  # v3.5.2
   ```

5. **Add workflow status badges**
   ```markdown
   ![CI](https://github.com/user/repo/workflows/CI/badge.svg)
   ```

6. **Use reusable workflows**
   ```yaml
   # .github/workflows/reusable-test.yml
   on:
     workflow_call:
       inputs:
         node-version:
           required: true
           type: string

   # .github/workflows/ci.yml
   jobs:
     test:
       uses: ./.github/workflows/reusable-test.yml
       with:
         node-version: '18'
   ```

## When to Ask for Help

If you've tried these steps and still stuck:

1. Check [GitHub Actions documentation](https://docs.github.com/en/actions)
2. Search [GitHub Community discussions](https://github.com/orgs/community/discussions/categories/actions)
3. Look for similar issues in [actions/runner](https://github.com/actions/runner/issues)
4. Check specific action's repository issues
5. Ask on Stack Overflow with tag `github-actions`

When asking, provide:
- Full workflow file (sanitized secrets)
- Error messages from logs
- Steps to reproduce
- What you've already tried
