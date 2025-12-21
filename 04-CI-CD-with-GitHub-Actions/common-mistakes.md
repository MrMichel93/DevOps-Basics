# Common Mistakes in CI/CD with GitHub Actions

## Beginner Mistakes

### Mistake 1: Not Failing Pipeline on Test Failures

**What people do:**
Configure workflows that continue running and deploying even when tests fail, or don't check test exit codes properly.

**Why it's a problem:**
- Broken code gets deployed to production
- Tests become meaningless if failures are ignored
- Bugs reach users that should have been caught
- False sense of security from "passing" builds
- Difficult to track when bugs were introduced
- Wastes resources deploying broken code

**The right way:**
Ensure test failures stop the workflow:

```yaml
name: CI/CD Pipeline

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test  # Fails workflow if tests fail
      
      - name: Run linting
        run: npm run lint  # Also fails if linting fails
  
  deploy:
    runs-on: ubuntu-latest
    needs: test  # Won't run if test job fails
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Deploy to production
        run: ./deploy.sh
```

**How to fix if you've already done this:**
Review and fix test steps:

```yaml
# Bad ❌
- name: Run tests
  run: npm test || true  # Always succeeds!
  continue-on-error: true  # Ignores failures!

# Good ✅
- name: Run tests
  run: npm test  # Fails on test failure

# For optional checks, use separate job
optional-checks:
  runs-on: ubuntu-latest
  continue-on-error: true  # Only this job is optional
  steps:
    - name: Optional security scan
      run: npm audit
```

**Red flags to watch for:**
- Green checkmarks despite failing tests
- `|| true` after test commands
- `continue-on-error: true` on critical steps
- Deployment jobs without `needs:` dependencies
- No test failures visible in workflow history

---

### Mistake 2: Storing Secrets in Workflow Files

**What people do:**
Hardcode API keys, passwords, tokens, or credentials directly in workflow YAML files.

**Why it's a problem:**
- Secrets exposed in repository
- Anyone with read access sees secrets
- Secrets in git history forever
- Major security vulnerability
- Violates compliance requirements
- Requires rotating all exposed credentials

**The right way:**
Use GitHub Secrets for all sensitive data:

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      # Bad ❌
      # - name: Deploy
      #   env:
      #     API_KEY: "sk_live_123456789"  # NEVER DO THIS!
      
      # Good ✅
      - name: Deploy
        env:
          API_KEY: ${{ secrets.API_KEY }}
          AWS_ACCESS_KEY: ${{ secrets.AWS_ACCESS_KEY }}
          AWS_SECRET_KEY: ${{ secrets.AWS_SECRET_KEY }}
        run: ./deploy.sh
```

Set secrets in GitHub:

```bash
# Go to repository Settings > Secrets and variables > Actions
# Click "New repository secret"
# Name: API_KEY
# Value: your-secret-value

# Or use GitHub CLI
gh secret set API_KEY
# Paste secret value when prompted
```

**How to fix if you've already done this:**
Immediately rotate exposed secrets and update workflow:

```bash
# 1. Rotate all exposed credentials immediately
# 2. Add secrets to GitHub Secrets
# 3. Update workflow file:

# Before:
env:
  DB_PASSWORD: "mysecretpassword"

# After:
env:
  DB_PASSWORD: ${{ secrets.DB_PASSWORD }}

# 4. Commit and push changes
# 5. Verify secrets are not in repository
```

**Red flags to watch for:**
- API keys visible in workflow files
- Passwords in environment variables
- AWS credentials hardcoded
- Database connection strings with passwords
- Tokens in plain text
- Security alerts from GitHub

---

### Mistake 3: Not Caching Dependencies

**What people do:**
Download and install dependencies from scratch on every workflow run without using caching.

**Why it's a problem:**
- Workflows take 5-10x longer than necessary
- Wastes GitHub Actions minutes
- Wastes bandwidth downloading same packages
- Slower feedback for developers
- Increased costs for private repositories
- Reduces CI/CD efficiency

**The right way:**
Cache dependencies between runs:

```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      # Node.js caching
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'  # Automatic caching!
      
      - name: Install dependencies
        run: npm ci
      
      # Or manual caching for more control
      - name: Cache node modules
        uses: actions/cache@v3
        with:
          path: ~/.npm
          key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-
```

For other languages:

```yaml
# Python
- uses: actions/setup-python@v4
  with:
    python-version: '3.11'
    cache: 'pip'

- run: pip install -r requirements.txt

# Java/Maven
- uses: actions/setup-java@v3
  with:
    java-version: '17'
    cache: 'maven'

- run: mvn install

# Go
- uses: actions/setup-go@v4
  with:
    go-version: '1.21'
    cache: true

- run: go build
```

**How to fix if you've already done this:**
Add caching to existing workflows:

```yaml
# Before: No caching (slow)
- name: Setup Node
  uses: actions/setup-node@v4
  with:
    node-version: '18'

- run: npm ci  # Downloads everything every time

# After: With caching (fast)
- name: Setup Node
  uses: actions/setup-node@v4
  with:
    node-version: '18'
    cache: 'npm'  # Add this line

- run: npm ci  # Uses cache when possible
```

**Red flags to watch for:**
- Workflows taking 10+ minutes for simple apps
- "Downloading packages" in every run
- High GitHub Actions minutes usage
- Same dependencies downloaded repeatedly
- No cache hits in workflow logs

---

### Mistake 4: Running Tests Only on Main Branch

**What people do:**
Configure CI to run only on main branch, not on feature branches or pull requests.

**Why it's a problem:**
- Bugs not caught before merging
- Main branch breaks frequently
- No quality gate before merge
- Team can't review test results
- Integration issues found too late
- Wastes time with broken main branch

**The right way:**
Run tests on all branches and pull requests:

```yaml
name: CI

# Run on pushes to all branches and all PRs
on:
  push:
    branches: ['**']  # All branches
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - run: npm ci
      - run: npm test
      - run: npm run lint
  
  # Deploy only from main
  deploy:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    steps:
      - name: Deploy to production
        run: ./deploy.sh
```

Require checks before merge:

```yaml
# In repository Settings > Branches > Branch protection rules
# Enable "Require status checks to pass before merging"
# Select: test, lint, build checks
```

**How to fix if you've already done this:**
Update workflow triggers:

```yaml
# Before: Only main
on:
  push:
    branches: [main]

# After: All branches and PRs
on:
  push:
    branches: ['**']
  pull_request:
    branches: [main, develop]

# Keep deployment conditional
jobs:
  deploy:
    if: github.ref == 'refs/heads/main'
```

**Red flags to watch for:**
- PRs merged without CI checks
- Main branch frequently broken
- Bugs found after merge
- No test status on PRs
- Workflow only triggers on main

---

### Mistake 5: No Rollback Strategy

**What people do:**
Deploy to production without any rollback mechanism or previous version backup.

**Why it's a problem:**
- Can't quickly recover from bad deployments
- Downtime while fixing and redeploying
- Pressure to fix issues quickly in production
- No way to revert to known good state
- Customer impact extends unnecessarily
- Panic-driven debugging in production

**The right way:**
Implement rollback capabilities:

```yaml
name: Deploy with Rollback

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      # Tag current deployment
      - name: Tag current version
        run: |
          VERSION=$(date +%Y%m%d-%H%M%S)
          echo "DEPLOYMENT_VERSION=$VERSION" >> $GITHUB_ENV
          git tag "deploy-$VERSION"
          git push origin "deploy-$VERSION"
      
      # Deploy new version
      - name: Deploy to production
        env:
          VERSION: ${{ env.DEPLOYMENT_VERSION }}
        run: |
          ./deploy.sh $VERSION
          # Keep previous version available
          ./keep-previous-version.sh
      
      # Health check
      - name: Verify deployment
        run: |
          sleep 30
          ./health-check.sh || exit 1
      
      # Automatic rollback on failure
      - name: Rollback on failure
        if: failure()
        run: |
          echo "Deployment failed, rolling back"
          ./rollback.sh

# Separate rollback workflow
  rollback:
    name: Manual Rollback
    runs-on: ubuntu-latest
    # Run manually when needed
    workflow_dispatch:
      inputs:
        version:
          description: 'Version to rollback to'
          required: true
    steps:
      - name: Rollback to version
        run: ./rollback.sh ${{ github.event.inputs.version }}
```

**How to fix if you've already done this:**
Add rollback capabilities:

```yaml
# Add manual rollback workflow
name: Rollback

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version tag to rollback to'
        required: true
        type: string

jobs:
  rollback:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.event.inputs.version }}
      
      - name: Deploy previous version
        run: ./deploy.sh
      
      - name: Verify rollback
        run: ./health-check.sh
```

**Red flags to watch for:**
- No version tags in git
- Can't identify what's deployed
- No rollback documentation
- Manual fixes in production
- Long recovery time from failures
- Previous versions not accessible

---

### Mistake 6: Overly Permissive Workflow Permissions

**What people do:**
Use `write-all` permissions or default permissions when workflows only need limited access.

**Why it's a problem:**
- Security risk if workflow is compromised
- Malicious code could modify repository
- Could leak secrets or sensitive data
- Violates principle of least privilege
- Increases attack surface
- Makes security audits harder

**The right way:**
Use minimal required permissions:

```yaml
name: CI

on: [push, pull_request]

# Minimal permissions
permissions:
  contents: read  # Read code
  pull-requests: write  # Comment on PRs
  
jobs:
  test:
    runs-on: ubuntu-latest
    # Override if this job needs different permissions
    permissions:
      contents: read
      checks: write  # Report test results
    
    steps:
      - uses: actions/checkout@v4
      - run: npm test
```

For different scenarios:

```yaml
# Read-only workflow
permissions:
  contents: read

# Deploy workflow
permissions:
  contents: read
  packages: write  # Push Docker images
  deployments: write  # Create deployments

# Release workflow
permissions:
  contents: write  # Create tags and releases
  pull-requests: write  # Close PRs
```

**How to fix if you've already done this:**
Audit and restrict permissions:

```yaml
# Before: Overly permissive
permissions: write-all  # ❌ Too broad

# After: Specific permissions
permissions:
  contents: read
  issues: write
  pull-requests: write
  # Only what's needed
```

**Red flags to watch for:**
- `permissions: write-all` in workflows
- No explicit permissions set
- Workflows can modify protected branches
- Third-party actions with write permissions
- Security alerts about workflow permissions

---

### Mistake 7: Not Validating External Inputs

**What people do:**
Use user inputs, PR titles, branch names directly in commands without validation.

**Why it's a problem:**
- Command injection vulnerabilities
- Can execute arbitrary code
- Security risk from malicious PRs
- Can modify or delete files
- Potential secret leakage
- Repository compromise

**The right way:**
Validate and sanitize all inputs:

```yaml
name: Process PR

on:
  pull_request:
    types: [opened]

jobs:
  label-pr:
    runs-on: ubuntu-latest
    steps:
      - name: Validate PR title
        env:
          PR_TITLE: ${{ github.event.pull_request.title }}
        run: |
          # Use environment variable, not direct substitution
          echo "PR title: $PR_TITLE"
          
          # Bad ❌ - Command injection risk
          # gh pr edit --title "${{ github.event.pull_request.title }}"
          
          # Good ✅ - Use environment variable
          if [[ "$PR_TITLE" =~ ^(feat|fix|docs|chore): ]]; then
            echo "Valid PR title format"
          else
            echo "Invalid PR title. Must start with feat:|fix:|docs:|chore:"
            exit 1
          fi
      
      - name: Safe command execution
        env:
          BRANCH_NAME: ${{ github.head_ref }}
        run: |
          # Validate branch name format
          if [[ "$BRANCH_NAME" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
            echo "Processing branch: $BRANCH_NAME"
          else
            echo "Invalid branch name"
            exit 1
          fi
```

For workflow_dispatch inputs:

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Deployment environment'
        required: true
        type: choice  # Restrict to allowed values
        options:
          - development
          - staging
          - production
      
      version:
        description: 'Version to deploy'
        required: true
        type: string

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Validate inputs
        env:
          ENVIRONMENT: ${{ github.event.inputs.environment }}
          VERSION: ${{ github.event.inputs.version }}
        run: |
          # Validate version format
          if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "Invalid version format. Expected: v1.2.3"
            exit 1
          fi
          
          # Safe to use now
          echo "Deploying $VERSION to $ENVIRONMENT"
```

**How to fix if you've already done this:**
Refactor to use environment variables:

```yaml
# Before: Direct substitution (vulnerable)
- run: echo "${{ github.event.issue.title }}"

# After: Environment variable (safe)
- env:
    ISSUE_TITLE: ${{ github.event.issue.title }}
  run: echo "$ISSUE_TITLE"
```

**Red flags to watch for:**
- `${{ }}` expressions in shell commands
- No input validation
- User inputs in run commands
- PR titles/bodies in commands
- Branch names directly in scripts

---

## Intermediate Mistakes

### Mistake 8: Not Using Matrix Builds for Multiple Environments

**What people do:**
Duplicate jobs for different Node/Python/OS versions instead of using matrix strategy.

**Why it's a problem:**
- Lots of duplicate workflow code
- Difficult to maintain multiple versions
- Easy to miss updating all versions
- Harder to add new test environments
- More prone to errors and inconsistencies

**The right way:**
Use matrix strategy:

```yaml
name: Cross-platform Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: [16, 18, 20]
        # Creates 9 jobs (3 OS × 3 versions)
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      
      - run: npm ci
      - run: npm test
```

With exclusions and includes:

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
    node-version: [16, 18, 20]
    exclude:
      # Don't test Node 16 on macOS
      - os: macos-latest
        node-version: 16
    include:
      # Add specific configuration
      - os: ubuntu-latest
        node-version: 20
        experimental: true
```

**How to fix if you've already done this:**
Convert duplicated jobs to matrix:

```yaml
# Before: Duplicated jobs
jobs:
  test-node-16:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: 16
      - run: npm test
  
  test-node-18:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: 18
      - run: npm test

# After: Matrix strategy
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [16, 18, 20]
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm test
```

**Red flags to watch for:**
- Multiple similar jobs with slight variations
- Copying workflow files for different versions
- Forgetting to update all job variants
- Long workflow files with repetition

---

### Mistake 9: Not Using Reusable Workflows

**What people do:**
Copy and paste the same workflow configuration across multiple repositories.

**Why it's a problem:**
- Difficult to maintain consistency
- Changes require updating every repository
- Prone to drift and inconsistencies
- No single source of truth
- Wastes time on repetitive updates

**The right way:**
Create reusable workflows:

```yaml
# .github/workflows/reusable-test.yml
name: Reusable Test Workflow

on:
  workflow_call:
    inputs:
      node-version:
        required: true
        type: string
      working-directory:
        required: false
        type: string
        default: '.'
    secrets:
      NPM_TOKEN:
        required: true

jobs:
  test:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ${{ inputs.working-directory }}
    
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ inputs.node-version }}
          cache: 'npm'
      
      - name: Configure npm
        env:
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
        run: echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > .npmrc
      
      - run: npm ci
      - run: npm test
      - run: npm run lint
```

Use reusable workflow:

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  call-test-workflow:
    uses: ./.github/workflows/reusable-test.yml
    with:
      node-version: '18'
      working-directory: './app'
    secrets:
      NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

**How to fix if you've already done this:**
Extract common workflow:

```yaml
# 1. Create reusable workflow in one repo
# 2. Reference it from other repos

# In org-name/.github repository
jobs:
  test:
    uses: org-name/.github/.github/workflows/reusable-test.yml@main
    with:
      node-version: '18'
```

**Red flags to watch for:**
- Identical workflows in multiple repos
- Updating same workflow configuration repeatedly
- Inconsistent workflow versions
- Copy-paste workflow maintenance

---

### Mistake 10: Ignoring Workflow Run Failures

**What people do:**
Don't monitor or respond to workflow failures, especially on scheduled runs.

**Why it's a problem:**
- Builds broken for extended periods
- Dependency updates breaking silently
- Security scans failing unnoticed
- Tests becoming unreliable
- Team loses trust in CI/CD

**The right way:**
Set up notifications and monitoring:

```yaml
name: Nightly Tests

on:
  schedule:
    - cron: '0 2 * * *'  # 2 AM daily

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm test
  
  notify:
    needs: test
    runs-on: ubuntu-latest
    if: failure()
    steps:
      - name: Notify on failure
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: 'Nightly tests failed!'
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}
      
      - name: Create issue
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: 'Nightly tests failed',
              body: 'Workflow failed: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}'
            })
```

**How to fix if you've already done this:**
Add monitoring:

```yaml
# Enable email notifications in GitHub settings
# Or add Slack/Teams notifications

- name: Notify team
  if: failure()
  run: |
    curl -X POST ${{ secrets.WEBHOOK_URL }} \
      -H 'Content-Type: application/json' \
      -d '{"text": "CI failed on main branch!"}'
```

**Red flags to watch for:**
- Weeks of failed workflow runs
- No one notices broken builds
- Scheduled workflows failing silently
- Team unaware of CI/CD status

---

## Advanced Pitfalls

### Mistake 11: Not Using Environments and Protection Rules

**What people do:**
Deploy to production without approval gates or environment-specific protections.

**Why it's a problem:**
- Accidental production deployments
- No review before critical changes
- Can't enforce deployment windows
- No audit trail of deployments
- Risky deployments without oversight

**The right way:**
Use GitHub Environments with protection:

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy-staging:
    runs-on: ubuntu-latest
    environment:
      name: staging
      url: https://staging.example.com
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to staging
        run: ./deploy-staging.sh
  
  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://example.com
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to production
        env:
          PROD_KEY: ${{ secrets.PROD_DEPLOY_KEY }}
        run: ./deploy-production.sh
```

Configure environment protection:

```bash
# In repository Settings > Environments > production
# Enable:
# - Required reviewers (select team members)
# - Wait timer (15 minutes)
# - Deployment branches (only main)
```

**How to fix if you've already done this:**
Add environment protection:

```yaml
# Add environment to deployment jobs
jobs:
  deploy:
    environment:
      name: production
      url: https://example.com
    # Configure protection in GitHub UI
```

**Red flags to watch for:**
- No approval needed for production
- Anyone can trigger deployments
- No environment-specific secrets
- Production and staging use same config

---

### Mistake 12: Not Managing Workflow Concurrency

**What people do:**
Allow multiple workflow runs simultaneously, causing race conditions and conflicts.

**Why it's a problem:**
- Concurrent deployments interfere
- Resource conflicts during builds
- Wasted runner minutes
- Deployment order issues
- Database migration conflicts

**The right way:**
Use concurrency controls:

```yaml
name: Deploy

on:
  push:
    branches: [main]

# Cancel in-progress runs of same workflow
concurrency:
  group: production-deployment
  cancel-in-progress: false  # Wait for current to finish

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./deploy.sh
```

For different scenarios:

```yaml
# Cancel old runs on same PR
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true  # Cancel old, run new

# Queue deployments
concurrency:
  group: deployment-${{ github.event.inputs.environment }}
  cancel-in-progress: false  # Queue up
```

**How to fix if you've already done this:**
Add concurrency control:

```yaml
name: Deploy
on:
  push:
    branches: [main]

concurrency:
  group: production
  cancel-in-progress: false

jobs:
  deploy:
    # deployment steps
```

**Red flags to watch for:**
- Multiple deployments running simultaneously
- Race conditions in deployments
- Failed deployments due to conflicts
- Wasted runner minutes on superseded runs

---

### Mistake 13: Hardcoding Version Numbers and URLs

**What people do:**
Hardcode action versions, URLs, and configuration that should be centrally managed.

**Why it's a problem:**
- Security updates require changing many files
- Inconsistent action versions
- Difficult to audit dependencies
- Can't easily update all workflows

**The right way:**
Use dependabot for action updates:

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
```

Pin actions to specific versions:

```yaml
# Bad ❌ - Mutable tag
- uses: actions/checkout@v4

# Better ✅ - Specific version with hash
- uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1
```

**How to fix if you've already done this:**
Set up dependabot and pin versions:

```bash
# Add dependabot.yml
# Dependabot will create PRs to update actions
```

**Red flags to watch for:**
- Actions using `@master` or `@main`
- No version pinning
- Mixed action versions across workflows
- Manual action updates

---

## Prevention Checklist

### Before Creating Workflow

- [ ] Define clear purpose and triggers
- [ ] Identify required permissions (least privilege)
- [ ] Plan caching strategy
- [ ] Consider matrix builds if testing multiple versions
- [ ] Plan secret management
- [ ] Define environment protection needs

### Workflow Configuration

- [ ] Tests fail the workflow on errors
- [ ] All secrets stored in GitHub Secrets
- [ ] Dependencies cached appropriately
- [ ] Runs on all branches and PRs (not just main)
- [ ] Appropriate permissions set
- [ ] External inputs validated
- [ ] Concurrency controls configured

### Deployment Workflows

- [ ] Rollback strategy implemented
- [ ] Health checks after deployment
- [ ] Environment protection configured
- [ ] Required approvals set up
- [ ] Deployment notifications enabled
- [ ] Version tagging implemented
- [ ] Deployment windows enforced

### Security Checklist

- [ ] No secrets in workflow files
- [ ] Minimal permissions used
- [ ] Third-party actions reviewed
- [ ] Actions pinned to specific versions
- [ ] Inputs validated and sanitized
- [ ] Dependabot enabled for actions
- [ ] Audit logs reviewed regularly

### Maintenance Checklist

- [ ] Workflow failures monitored
- [ ] Notifications configured
- [ ] Matrix builds for multi-version support
- [ ] Reusable workflows for common tasks
- [ ] Documentation for manual workflows
- [ ] Regular security audits
- [ ] Performance optimization reviewed
