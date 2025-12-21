# Interview Questions by Module

This document maps common interview questions to each course module, providing answer frameworks, follow-up questions, and red flags to avoid.

## Module 01: Git and GitHub

### Basic Questions

**Q1: What is the difference between Git and GitHub?**

**Answer Framework:**

- **Git**: Distributed version control system (software)
- **GitHub**: Cloud platform that hosts Git repositories (service)
- Git works locally; GitHub adds collaboration features
- Analogy: Git is like Word, GitHub is like Google Docs

**Follow-ups:**

- What are alternatives to GitHub? (GitLab, Bitbucket, Gitea)
- Can you use Git without GitHub? (Yes, Git is standalone)

**Red Flags:**

- "They're the same thing"
- Can't explain version control benefits
- Doesn't understand distributed vs. centralized VCS

---

**Q2: Explain the Git workflow (working directory, staging area, repository).**

**Answer Framework:**

- **Working Directory**: Where you edit files
- **Staging Area (Index)**: Where you prepare changes for commit
- **Repository**: Where committed changes are permanently stored
- Flow: Edit → Add to staging → Commit to repository

**Follow-ups:**

- Why have a staging area? (Selective commits, review before commit)
- What's the difference between `git add .` and `git add -A`?

**Red Flags:**

- Committing without reviewing changes
- Not understanding why staging exists
- Confusion about tracked vs. untracked files

---

**Q3: What's the difference between `git merge` and `git rebase`?**

**Answer Framework:**

- **Merge**: Combines branches with a merge commit, preserves history
- **Rebase**: Replays commits on top of another branch, creates linear history
- Merge is safer, rebase is cleaner but rewrites history
- Golden rule: Never rebase public/shared branches

**Follow-ups:**

- When would you use each?
- What are the risks of rebasing?
- How do you handle conflicts in each?

**Red Flags:**

- "Always rebase" or "always merge" without understanding context
- Rebasing shared branches
- Not understanding history implications

---

**Q4: How do you resolve a merge conflict?**

**Answer Framework:**

1. Git marks conflicts in files with `<<<<<<<`, `=======`, `>>>>>>>`
2. Edit files to resolve conflicts manually
3. Remove conflict markers
4. Stage resolved files with `git add`
5. Complete merge with `git commit` or `git rebase --continue`
6. Test to ensure functionality

**Follow-ups:**

- How do you prevent merge conflicts?
- What tools help with conflict resolution?
- How do you abort a merge?

**Red Flags:**

- Deleting one side blindly without understanding
- Not testing after resolution
- Fear of conflicts (they're normal!)

---

**Q5: Explain Git branching strategies you've used.**

**Answer Framework:**

- **Git Flow**: Feature branches, develop, release, hotfix, master/main
- **GitHub Flow**: Simple - feature branches off main, PR, merge
- **Trunk-Based**: Short-lived branches, frequent integration to main
- Choice depends on team size, release cycle, deployment frequency

**Follow-ups:**

- What's your preferred strategy and why?
- How do you handle hotfixes?
- How does branching relate to deployment?

**Red Flags:**

- Only knowing one strategy without understanding others
- Not considering team context
- Overly complex branching for small teams

---

### Intermediate Questions

**Q6: What are Git hooks and how would you use them?**

**Answer Framework:**

- Scripts that run automatically at certain Git events
- Examples: pre-commit (linting), pre-push (tests), commit-msg (validation)
- Located in `.git/hooks/` or managed by tools like Husky
- Use cases: Code quality enforcement, automated checks, preventing bad commits

**Follow-ups:**

- Client-side vs. server-side hooks?
- How do you share hooks across a team?
- Can hooks be bypassed?

**Red Flags:**

- Not knowing hooks exist
- Using hooks to enforce what CI/CD should handle
- Creating hooks that are too slow

---

**Q7: How do you revert a commit that's already been pushed?**

**Answer Framework:**

- **Option 1**: `git revert <commit>` - Creates new commit that undoes changes (safe)
- **Option 2**: `git reset --hard <commit>` + force push (dangerous, avoid on shared branches)
- Prefer revert for public history
- For private branches, reset is acceptable

**Follow-ups:**

- What's the difference between reset, revert, and checkout?
- When would you use force push?
- How do you revert multiple commits?

**Red Flags:**

- Force pushing to main/shared branches
- Not understanding git history is public
- Deleting commits instead of reverting

---

**Q8: Explain `git stash` and when you'd use it.**

**Answer Framework:**

- Temporarily saves uncommitted changes
- Use cases: Switch branches with dirty working directory, pull latest changes, interrupt current work
- Commands: `git stash`, `git stash pop`, `git stash list`, `git stash apply`
- Stashes are local only

**Follow-ups:**

- Difference between `pop` and `apply`?
- Can you stash untracked files?
- How do you apply a specific stash?

**Red Flags:**

- Committing just to switch branches
- Not knowing stash exists
- Leaving many unnamed stashes

---

**Q9: What's the difference between `git pull` and `git fetch`?**

**Answer Framework:**

- **Fetch**: Downloads changes from remote, doesn't modify working directory
- **Pull**: Fetch + merge (or rebase with `--rebase`)
- Fetch is safer - lets you review before merging
- `git pull = git fetch + git merge`

**Follow-ups:**

- When would you use fetch over pull?
- How do you see what changed after fetch?
- What's `git pull --rebase`?

**Red Flags:**

- Always pulling without reviewing changes
- Not understanding pull can create merge commits
- Blindly pulling into dirty working directory

---

**Q10: How would you find which commit introduced a bug?**

**Answer Framework:**

- **Binary search**: `git bisect` - Marks commits good/bad, finds problematic commit
- **Manual**: `git log`, check diffs, test specific commits
- **Blame**: `git blame <file>` - See who last modified each line
- Process: Start bisect, mark known good/bad, test each commit, find culprit

**Follow-ups:**

- Can you automate git bisect?
- How many steps does bisect take?
- What if the bug is in multiple commits?

**Red Flags:**

- Checking commits one by one linearly
- Not knowing bisect exists
- Not writing good commit messages to help debugging

---

### Advanced Questions

**Q11: Explain Git's internal object model (blobs, trees, commits).**

**Answer Framework:**

- **Blob**: File contents (just data)
- **Tree**: Directory structure, references blobs and other trees
- **Commit**: Points to tree, parent commits, metadata (author, message)
- All objects addressed by SHA-1 hash
- This enables deduplication and integrity

**Follow-ups:**

- How does Git detect file renames?
- Why is Git so fast?
- What's a detached HEAD state?

**Red Flags:**

- Not needed for junior roles, but good to know for senior
- Shows deep understanding vs. surface knowledge

---

**Q12: How would you clean up repository history before merging?**

**Answer Framework:**

- **Interactive rebase**: `git rebase -i` to squash, reword, reorder commits
- **Fixup commits**: Clean up as you go with `git commit --fixup`
- **Force push**: To update feature branch after cleaning
- **Why**: Clean history, meaningful commit messages, easier code review

**Follow-ups:**

- When is clean history important?
- What's the risk of rewriting history?
- How do you squash commits?

**Red Flags:**

- Never cleaning up commits
- Squashing everything into one commit (losing granularity)
- Rewriting shared branch history

---

**Q13: Describe a complex Git problem you solved.**

**Answer Framework:**

Use STAR method:

- **Situation**: Team had divergent history after force push
- **Task**: Recover lost commits, reconcile histories
- **Action**: Used reflog to find lost commits, created recovery branch, cherry-picked changes
- **Result**: Recovered all work, established force-push guidelines

**Follow-ups:**

- How do you prevent similar issues?
- What did you learn?
- How would you handle differently?

**Red Flags:**

- Not having examples of problem-solving
- Blaming tools instead of learning from mistakes
- No retrospective or improvement

---

## Module 03: Docker Fundamentals

### Basic Questions

**Q1: What is a container and how is it different from a VM?**

**Answer Framework:**

- **Container**: OS-level virtualization, shares host kernel, packages app + dependencies
- **VM**: Hardware-level virtualization, full OS, hypervisor
- Containers are lighter, faster startup, less isolation
- VMs are more isolated, can run different OS kernels

**Follow-ups:**

- When would you use VMs instead of containers?
- How does the kernel sharing work?
- What's the security implication of shared kernel?

**Red Flags:**

- "They're exactly the same"
- Can't explain isolation levels
- Don't mention orchestration at scale

---

**Q2: What is a Docker image vs. a Docker container?**

**Answer Framework:**

- **Image**: Read-only template, blueprint for containers (like a class)
- **Container**: Running instance of an image (like an object)
- Images are built in layers
- Containers add writable layer on top
- One image can create many containers

**Follow-ups:**

- How do you create an image?
- Where are images stored?
- What's an image layer?

**Red Flags:**

- Confusing images and containers
- Not understanding immutability of images
- Thinking containers persist by default

---

**Q3: Explain the Dockerfile and its main instructions.**

**Answer Framework:**

- **FROM**: Base image
- **RUN**: Execute commands during build (install packages)
- **COPY/ADD**: Copy files from host to image
- **WORKDIR**: Set working directory
- **ENV**: Environment variables
- **EXPOSE**: Document ports
- **CMD/ENTRYPOINT**: Default command to run

**Follow-ups:**

- What's the difference between CMD and ENTRYPOINT?
- What's the difference between COPY and ADD?
- How do layers affect build time?

**Red Flags:**

- Using ADD when COPY is appropriate
- Not understanding layer caching
- Running as root user

---

**Q4: How do you optimize a Dockerfile for production?**

**Answer Framework:**

- **Multi-stage builds**: Separate build and runtime dependencies
- **Minimize layers**: Combine RUN commands
- **Order instructions**: Put changing parts last (leverage cache)
- **Use specific tags**: Not `latest`, pin versions
- **.dockerignore**: Exclude unnecessary files
- **Don't run as root**: Create non-root user
- **Scan for vulnerabilities**: Use `docker scan` or Trivy

**Follow-ups:**

- Show an example of multi-stage build
- How do you handle secrets?
- What's the impact of layer order?

**Red Flags:**

- Using `latest` tag in production
- Including source code and build tools in final image
- Copying entire context without .dockerignore
- Running everything as root

---

**Q5: What are Docker volumes and why use them?**

**Answer Framework:**

- Persistent data storage outside container lifecycle
- **Types**: Named volumes (managed by Docker), bind mounts (host path), tmpfs
- **Use cases**: Databases, logs, shared data between containers
- **Benefits**: Data persists after container deletion, share between containers, better performance than writing to container layer

**Follow-ups:**

- When would you use bind mounts vs. named volumes?
- How do you backup volume data?
- What's the security concern with volumes?

**Red Flags:**

- Storing data in container layer
- Not understanding data persistence
- Exposing host filesystem unnecessarily

---

### Intermediate Questions

**Q6: Explain Docker networking modes.**

**Answer Framework:**

- **Bridge** (default): Private network, containers communicate via IP
- **Host**: Share host's network, no isolation
- **None**: No networking
- **Overlay**: Multi-host networking for Swarm
- **Custom networks**: User-defined bridge networks with DNS resolution

**Follow-ups:**

- When would you use host network?
- How do containers communicate across hosts?
- What's Docker DNS?

**Red Flags:**

- Only knowing default networking
- Using host network without understanding security implications
- Not understanding container DNS

---

**Q7: How would you troubleshoot a container that keeps restarting?**

**Answer Framework:**

1. **Check logs**: `docker logs <container>`
2. **Check exit code**: `docker inspect <container>` (exit code 137 = OOM)
3. **Run interactively**: `docker run -it <image> /bin/bash`
4. **Check resource limits**: Memory, CPU constraints
5. **Verify dependencies**: Database, external services available?
6. **Check entrypoint**: Is the main process exiting?

**Follow-ups:**

- What does exit code 0 mean? 1? 137?
- How do you keep a container running for debugging?
- What tools do you use for debugging?

**Red Flags:**

- Not checking logs first
- Not understanding exit codes
- Giving up instead of systematically debugging

---

**Q8: What's the difference between `CMD` and `ENTRYPOINT`?**

**Answer Framework:**

- **CMD**: Default command, easily overridden at runtime
- **ENTRYPOINT**: Main command, container runs as executable
- **Together**: ENTRYPOINT is command, CMD is default arguments
- **Exec form vs. shell form**: JSON array vs. string

**Follow-ups:**

- Show an example using both
- What's the difference between exec and shell form?
- How do you override ENTRYPOINT?

**Red Flags:**

- Not knowing there's a difference
- Using shell form without understanding process implications
- Not understanding PID 1 problem

---

**Q9: How do you handle secrets in Docker?**

**Answer Framework:**

- **Don't**: Store in image, commit to version control, use plain environment variables
- **Do**: Use Docker secrets (Swarm), Kubernetes secrets, external secret managers (Vault, AWS Secrets Manager)
- **Build time**: Use build arguments sparingly, use multi-stage builds
- **Runtime**: Mount secrets as files, use environment variables from secret store

**Follow-ups:**

- What's wrong with ENV for secrets?
- How does Docker secrets work?
- What about secrets during build?

**Red Flags:**

- Hardcoding secrets in Dockerfile
- Committing .env files with secrets
- Not understanding secret exposure in image layers

---

**Q10: Explain Docker Compose and when you'd use it.**

**Answer Framework:**

- Tool for defining multi-container applications
- YAML file defines services, networks, volumes
- Single command to start entire stack: `docker-compose up`
- **Use cases**: Local development, testing, simple deployments
- **Not for**: Production orchestration at scale (use Kubernetes)

**Follow-ups:**

- What's in a docker-compose.yml?
- How do services communicate?
- What's the difference between `up` and `run`?

**Red Flags:**

- Using Compose for production clustering
- Not knowing when to graduate to orchestration
- Confusing Compose with Swarm

---

### Advanced Questions

**Q11: How would you implement health checks for a containerized application?**

**Answer Framework:**

- **HEALTHCHECK** instruction in Dockerfile
- Runs command periodically to check app health
- Container marked unhealthy if check fails
- Orchestrators can restart unhealthy containers

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

**Follow-ups:**

- What should a health check endpoint verify?
- What's the difference between liveness and readiness probes?
- How do orchestrators use health checks?

**Red Flags:**

- No health checks
- Health check that's too expensive
- Not understanding orchestrator integration

---

**Q12: Explain your approach to container security.**

**Answer Framework:**

- **Image security**: Scan for vulnerabilities, use minimal base images (Alpine, distroless), pin versions
- **Runtime security**: Read-only filesystems, drop capabilities, don't run as root, limit resources
- **Network security**: Minimal exposed ports, network policies, encrypted communication
- **Secrets management**: External secret stores, not in images
- **Regular updates**: Rebuild images with security patches
- **Monitoring**: Security scanning in CI/CD

**Follow-ups:**

- What tools do you use for scanning?
- How do you handle vulnerability findings?
- What's the principle of least privilege in containers?

**Red Flags:**

- Running as root by default
- Not scanning images
- Using `latest` tag
- Exposing unnecessary ports

---

**Q13: How does Docker layer caching work and how do you optimize it?**

**Answer Framework:**

- Each instruction creates a layer
- Docker caches layers; reuses if instruction unchanged
- Cache invalidated if instruction or any parent changes
- **Optimization**: Order from least to most frequently changing
  - Base image → system packages → app dependencies → app code

**Follow-ups:**

- What invalidates cache?
- How do you force rebuild without cache?
- What's the BuildKit cache backend?

**Red Flags:**

- Copying code before installing dependencies
- Not understanding cache invalidation
- Ignoring build optimization

---

## Module 04: CI/CD with GitHub Actions

### Basic Questions

**Q1: What is CI/CD and why is it important?**

**Answer Framework:**

- **CI (Continuous Integration)**: Automatically build and test code changes frequently
- **CD (Continuous Delivery/Deployment)**: Automatically deploy to environments
- **Benefits**: Faster feedback, catch bugs early, consistent deployments, reduce manual work
- **Culture shift**: Small changes, frequent integration, automated testing

**Follow-ups:**

- What's the difference between Continuous Delivery and Continuous Deployment?
- What are prerequisites for CI/CD?
- How does CI/CD relate to DevOps?

**Red Flags:**

- "CI/CD is just automation"
- Not understanding the cultural/process changes required
- Thinking tools alone solve problems

---

**Q2: Explain the stages of a typical CI/CD pipeline.**

**Answer Framework:**

1. **Source**: Code commit triggers pipeline
2. **Build**: Compile code, create artifacts (Docker image, binaries)
3. **Test**: Unit tests, integration tests, linting
4. **Security**: Vulnerability scanning, SAST/DAST
5. **Deploy to staging**: Automatic deployment to test environment
6. **Deploy to production**: Manual approval or automatic
7. **Monitor**: Track deployment health

**Follow-ups:**

- What tests run in each stage?
- Where do you do security scanning?
- How do you handle failed stages?

**Red Flags:**

- No testing in pipeline
- Deploying without verification
- Not having staging environment

---

**Q3: What is a GitHub Actions workflow?**

**Answer Framework:**

- Automated process defined in YAML
- Located in `.github/workflows/`
- Triggered by events (push, PR, schedule, manual)
- Contains jobs with steps
- Runs on GitHub-hosted or self-hosted runners

**Follow-ups:**

- What triggers can you use?
- How do jobs run (parallel/sequential)?
- What's a runner?

**Red Flags:**

- Not knowing YAML syntax
- Confusing workflow, job, and step
- Not understanding event triggers

---

**Q4: How do you handle secrets in GitHub Actions?**

**Answer Framework:**

- Store in GitHub repository/organization secrets
- Access via `${{ secrets.SECRET_NAME }}`
- Never echo or log secrets
- Secrets are encrypted at rest
- Can limit secrets to specific environments
- Use OIDC for cloud provider authentication (no long-lived credentials)

**Follow-ups:**

- How do you use secrets for different environments?
- What's the difference between repository and organization secrets?
- What's OIDC and why use it?

**Red Flags:**

- Hardcoding secrets in workflow
- Logging secrets accidentally
- Not rotating secrets
- Committing secrets to repository

---

**Q5: What are GitHub Actions artifacts and when would you use them?**

**Answer Framework:**

- Files generated during workflow (build outputs, test reports, logs)
- Persist between jobs in a workflow
- Available for download after workflow completes
- Use cases: Build artifacts, test results, debug logs, deployment packages
- Expire after configurable period (default 90 days)

**Follow-ups:**

- How do you pass artifacts between jobs?
- What's the storage limit?
- Alternative to artifacts for job data sharing?

**Red Flags:**

- Rebuilding instead of using artifacts
- Not cleaning up old artifacts
- Storing secrets in artifacts

---

### Intermediate Questions

**Q6: Explain deployment strategies (blue/green, canary, rolling).**

**Answer Framework:**

- **Blue/Green**: Two identical environments, switch traffic instantly, easy rollback
- **Canary**: Gradual rollout to small percentage, monitor, then full rollout
- **Rolling**: Replace instances incrementally
- **Choice depends on**: Risk tolerance, rollback speed, infrastructure complexity

**Follow-ups:**

- How do you implement each in GitHub Actions?
- What monitoring is needed for canary?
- When would you use each strategy?

**Red Flags:**

- Only knowing one strategy
- Not having rollback plan
- Not monitoring during deployment

---

**Q7: How would you optimize a slow CI/CD pipeline?**

**Answer Framework:**

1. **Parallelize**: Run independent jobs concurrently
2. **Cache dependencies**: Cache npm/pip/maven packages
3. **Use matrix builds**: Test multiple versions in parallel
4. **Optimize tests**: Run fast tests first, parallelize slow tests
5. **Docker layer caching**: Reuse image layers
6. **Reduce checkout time**: Shallow clone, sparse checkout
7. **Use faster runners**: Self-hosted or larger GitHub-hosted

**Follow-ups:**

- Show an example of caching
- How do you identify bottlenecks?
- What's the trade-off of parallelization?

**Red Flags:**

- Running everything sequentially
- Not caching dependencies
- Not measuring pipeline duration
- Removing tests to speed up pipeline

---

**Q8: How do you handle environment-specific configurations in CI/CD?**

**Answer Framework:**

- **Environment variables**: Different per environment
- **GitHub environments**: Separate secrets/vars for dev/staging/prod
- **Configuration files**: Template with placeholders, substitute at deploy time
- **Secret managers**: Pull config from Vault, AWS Secrets Manager
- **Approval gates**: Require approval for production deployments

**Follow-ups:**

- How do you ensure prod config doesn't leak to dev?
- What's in your config files?
- How do you test environment configs?

**Red Flags:**

- Same config for all environments
- Committing environment-specific secrets
- No separation between environments

---

**Q9: What's the difference between GitHub-hosted and self-hosted runners?**

**Answer Framework:**

- **GitHub-hosted**: Managed by GitHub, fresh VM per job, free tier limits, limited customization
- **Self-hosted**: You manage, persistent, unlimited minutes, full control, more setup
- **Use GitHub-hosted for**: Standard builds, public repos, simplicity
- **Use self-hosted for**: Special hardware/software, private repos at scale, cost optimization, compliance

**Follow-ups:**

- What are security considerations for self-hosted?
- How do you scale self-hosted runners?
- What's the cost difference?

**Red Flags:**

- Not considering security of self-hosted runners
- Using self-hosted for public repos (security risk)
- Not understanding implications of persistent runners

---

**Q10: How do you test infrastructure changes in CI/CD?**

**Answer Framework:**

- **Validation**: Terraform validate, CloudFormation validate-template
- **Linting**: tflint, cfn-lint
- **Security scanning**: Checkov, tfsec for IaC
- **Plan review**: Run plan in CI, review changes
- **Test environments**: Apply to dev/test before prod
- **Integration tests**: Verify deployed infrastructure works

**Follow-ups:**

- What tools do you use?
- How do you handle state in CI?
- Do you auto-apply or require approval?

**Red Flags:**

- Applying infrastructure changes without review
- No testing of IaC
- Not using plan step
- Storing state insecurely

---

### Advanced Questions

**Q11: Design a CI/CD pipeline for a microservices application.**

**Answer Framework:**

- **Mono-repo vs. multi-repo**: Consider path filters for mono-repo
- **Service-specific pipelines**: Build/test/deploy each service independently
- **Shared workflows**: Reusable workflows for common steps
- **Integration tests**: Test service interactions
- **Deployment order**: Handle dependencies between services
- **Rollback strategy**: Per-service rollback capability
- **Observability**: Track deployments in monitoring

**Follow-ups:**

- How do you handle shared libraries?
- How do you version microservices?
- What's your integration testing strategy?

**Red Flags:**

- Deploying all services together (tight coupling)
- No integration testing
- No service dependency management
- Can't deploy services independently

---

**Q12: How do you implement proper testing in CI/CD?**

**Answer Framework:**

- **Unit tests**: Fast, isolated, run on every commit
- **Integration tests**: Test component interactions, run on PR
- **E2E tests**: Full system tests, run before deployment
- **Performance tests**: Baseline performance, catch regressions
- **Security tests**: SAST, DAST, dependency scanning
- **Test pyramid**: Many unit, fewer integration, few E2E
- **Fail fast**: Run fast tests first

**Follow-ups:**

- How do you balance speed vs. coverage?
- What's your flaky test strategy?
- How do you test deployments themselves?

**Red Flags:**

- Only manual testing
- Skipping tests to speed up pipeline
- Inverted test pyramid (too many E2E)
- No security testing

---

**Q13: Describe a complex CI/CD problem you solved.**

**Answer Framework:**

Use STAR method:

- **Situation**: Deployments failing intermittently, no clear cause
- **Task**: Identify root cause, implement reliable deployments
- **Action**: Added detailed logging, discovered race condition in deployment script, added proper health checks and retry logic
- **Result**: Zero deployment failures in 3 months, improved rollback time

**Follow-ups:**

- How did you debug?
- What would you do differently?
- What did the team learn?

**Red Flags:**

- No concrete examples
- Not learning from failures
- Blaming tools/others

---

## Module 05: Infrastructure as Code Lite

### Basic Questions

**Q1: What is Infrastructure as Code and why use it?**

**Answer Framework:**

- Define infrastructure in code files (version controlled)
- **Benefits**: Reproducible, version controlled, documented, automated, consistent
- **vs. Manual**: Clicking in console is error-prone, not repeatable, not tracked
- **Tools**: Terraform, CloudFormation, Pulumi, Ansible

**Follow-ups:**

- What's declarative vs. imperative IaC?
- How does IaC relate to DevOps?
- What are challenges with IaC?

**Red Flags:**

- "Just use the console, it's faster"
- Not version controlling infrastructure
- Not understanding drift

---

**Q2: What's the difference between declarative and imperative IaC?**

**Answer Framework:**

- **Declarative**: Define desired state, tool figures out how (Terraform, CloudFormation)
- **Imperative**: Define steps to reach state (scripts, Ansible to some extent)
- **Declarative benefits**: Idempotent, handles drift, clearer intent
- **Imperative benefits**: More control, easier for complex logic

**Follow-ups:**

- Which approach do you prefer?
- Can tools be both?
- What's idempotency?

**Red Flags:**

- Not knowing the difference
- Claiming one is always better
- Not understanding idempotency

---

**Q3: What is idempotency and why does it matter?**

**Answer Framework:**

- Running operation multiple times has same result as running once
- **Example**: `create resource "X"` should work even if X exists
- **Benefits**: Safe to re-run, recover from failures, predictable
- **In IaC**: Applying same config multiple times doesn't create duplicates

**Follow-ups:**

- Give example of non-idempotent operation
- How do IaC tools achieve idempotency?
- What about API calls?

**Red Flags:**

- Scripts that create duplicates when re-run
- Not testing idempotency
- Not understanding state management

---

**Q4: Explain infrastructure state and why it's important.**

**Answer Framework:**

- Record of current infrastructure
- **Purpose**: Track what exists, detect drift, plan changes
- **Tools**: Terraform state file, CloudFormation stack
- **Challenges**: Must be shared, must be backed up, must be locked during changes
- **Best practices**: Remote state, state locking, encryption

**Follow-ups:**

- Where do you store state?
- What happens if state is lost?
- How do you handle state in teams?

**Red Flags:**

- Storing state locally in Git
- Not backing up state
- No state locking (concurrent modification risk)

---

**Q5: How do you manage multiple environments (dev, staging, prod) with IaC?**

**Answer Framework:**

- **Workspaces**: Terraform workspaces, separate state per environment
- **Separate configs**: Different folders/repos per environment
- **Variables/Parameters**: Same code, different variable values
- **Modules**: Reusable components, instantiated per environment
- **Recommendation**: Balance DRY principle with environment isolation

**Follow-ups:**

- What's your preferred approach?
- How do you prevent cross-environment changes?
- How do you test changes?

**Red Flags:**

- No separation between environments
- Applying to prod without testing
- Copy-paste instead of using variables/modules

---

### Intermediate Questions

**Q6: What are modules in IaC and when would you use them?**

**Answer Framework:**

- Reusable, composable infrastructure components
- **Benefits**: DRY principle, standardization, encapsulation, testing
- **Use cases**: VPC setup, database configuration, common patterns
- **Structure**: Inputs (variables), outputs, resources
- **Best practices**: Single responsibility, versioning, documentation

**Follow-ups:**

- How do you version modules?
- Public modules vs. private?
- How do you test modules?

**Red Flags:**

- Mega-modules that do everything
- Not versioning modules
- No input validation

---

**Q7: How do you handle secrets in Infrastructure as Code?**

**Answer Framework:**

- **Don't**: Commit secrets to version control
- **Do**: Reference secret stores (AWS Secrets Manager, Vault, Azure Key Vault)
- **Build time**: Use environment variables, CI/CD secrets
- **Runtime**: Application reads from secret store
- **IaC**: Create secret resources, but values come from secure input

**Follow-ups:**

- How do you handle secret rotation?
- What about initial secrets bootstrap?
- How do you audit secret access?

**Red Flags:**

- Secrets in Git
- Hardcoded credentials
- Not rotating secrets
- No secret audit trail

---

**Q8: Explain infrastructure drift and how to handle it.**

**Answer Framework:**

- Difference between actual infrastructure and IaC definition
- **Causes**: Manual changes, external automation, deleted resources
- **Detection**: Regular plan/detect operations, drift detection tools
- **Resolution**: Update IaC to match reality, or revert infrastructure to match IaC
- **Prevention**: Restrict manual changes, use IaC for all changes, automated detection

**Follow-ups:**

- How often do you check for drift?
- Have you encountered drift? How did you handle it?
- What tools detect drift?

**Red Flags:**

- Accepting drift as normal
- No drift detection
- Manually changing production without updating IaC

---

**Q9: How do you test Infrastructure as Code?**

**Answer Framework:**

- **Static analysis**: Linting (tflint), security scanning (tfsec, Checkov)
- **Validation**: Syntax validation, plan review
- **Unit tests**: Test modules in isolation (Terratest)
- **Integration tests**: Deploy to test environment, verify functionality
- **Policy testing**: OPA, Sentinel for compliance
- **Cost estimation**: Infracost for cost impact

**Follow-ups:**

- What's your testing strategy?
- How do you automate testing?
- What tools do you use?

**Red Flags:**

- No testing of IaC
- Applying directly to production
- No validation in CI/CD

---

**Q10: How do you organize a large IaC codebase?**

**Answer Framework:**

- **By environment**: Separate folders/workspaces for dev/staging/prod
- **By layer**: Network, compute, data, application
- **By team**: Team ownership of specific infrastructure
- **By component**: Microservice-specific infrastructure
- **Modules**: Shared, reusable components
- **Recommendation**: Hybrid approach based on organization

**Follow-ups:**

- How do you handle shared resources?
- How do you manage dependencies?
- What's your repository structure?

**Red Flags:**

- Everything in one giant file
- No logical organization
- Tight coupling between components
- No clear ownership

---

### Advanced Questions

**Q11: How do you handle blue/green or canary deployments with IaC?**

**Answer Framework:**

- **Blue/Green**: Create new environment, switch traffic, destroy old
- **Canary**: Create new instances, gradually shift traffic
- **Challenges**: State management, traffic routing, resource costs
- **Techniques**: Load balancer target groups, DNS weighting, feature flags
- **IaC role**: Define both environments, manage traffic routing

**Follow-ups:**

- How do you minimize downtime?
- How do you handle database migrations?
- What's the rollback strategy?

**Red Flags:**

- No deployment strategy
- Downtime for every deployment
- Not considering database state

---

**Q12: Design an IaC strategy for a multi-cloud application.**

**Answer Framework:**

- **Challenges**: Different APIs, different constructs, vendor lock-in
- **Approaches**:
  - Cloud-agnostic tool (Terraform, Pulumi)
  - Per-cloud native tools (separate codebases)
  - Abstraction layer
- **Considerations**: Commonality vs. cloud-specific features, team expertise, operational complexity
- **Recommendation**: Use cloud-agnostic tool but don't over-abstract

**Follow-ups:**

- How do you share modules across clouds?
- What's the testing strategy?
- How do you handle cloud-specific features?

**Red Flags:**

- Trying to make everything identical across clouds
- Not leveraging cloud-specific strengths
- Over-abstraction that limits capabilities

---

**Q13: How do you handle complex dependencies in IaC?**

**Answer Framework:**

- **Explicit dependencies**: `depends_on` in Terraform
- **Implicit dependencies**: Reference outputs (creates dependency graph)
- **Order of operations**: Layers of infrastructure (network → compute → app)
- **Challenges**: Circular dependencies, long deployment times
- **Solutions**: Break into modules, use data sources, careful design

**Follow-ups:**

- How do you debug dependency issues?
- What causes circular dependencies?
- How do you visualize dependencies?

**Red Flags:**

- Not understanding dependency graph
- Circular dependencies
- No consideration of deployment order

---

## Module 06: Monitoring and Logging

### Basic Questions

**Q1: What's the difference between metrics, logs, and traces?**

**Answer Framework:**

- **Metrics**: Numeric data over time (CPU %, request count) - aggregatable
- **Logs**: Discrete events with context (error messages, requests) - searchable
- **Traces**: Request flow through system (distributed tracing) - end-to-end visibility
- **Together**: The three pillars of observability

**Follow-ups:**

- When would you use each?
- How do they complement each other?
- What's observability vs. monitoring?

**Red Flags:**

- Only using one type
- Not understanding the difference
- Confusing logs with metrics

---

**Q2: What metrics would you monitor for a web application?**

**Answer Framework:**

**RED Method (for request-driven services):**

- **Rate**: Requests per second
- **Errors**: Failed requests per second
- **Duration**: Response time (latency)

**USE Method (for resources):**

- **Utilization**: CPU, memory, disk %
- **Saturation**: Queue depth, load average
- **Errors**: Failed operations

**Plus**: Status codes, database query time, external API latency

**Follow-ups:**

- What alerts would you set?
- What's your SLO/SLA?
- How do you prioritize metrics?

**Red Flags:**

- Only monitoring infrastructure, not application
- No error tracking
- Monitoring everything without prioritization

---

**Q3: Explain log levels and when to use each.**

**Answer Framework:**

- **ERROR**: Errors that need attention, affect functionality
- **WARN**: Potential issues, degraded functionality, deprecated usage
- **INFO**: Important events, startup, shutdown, major operations
- **DEBUG**: Detailed info for debugging, not in production usually
- **TRACE**: Very detailed, expensive, only for local debugging

**Follow-ups:**

- What level in production?
- How do you search logs?
- What should you log?

**Red Flags:**

- Everything at INFO level
- Logging sensitive data (passwords, PII)
- Not structured logging
- Too verbose in production

---

**Q4: What is structured logging and why use it?**

**Answer Framework:**

- Logs in consistent format (JSON) with fields
- **vs. Unstructured**: Plain text, hard to parse
- **Benefits**: Easy to search/filter, aggregate, correlate, analyze
- **Fields**: timestamp, level, message, request_id, user_id, etc.

**Example:**

```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "ERROR",
  "message": "Database connection failed",
  "error": "timeout",
  "duration_ms": 5000,
  "request_id": "abc123"
}
```

**Follow-ups:**

- What fields do you include?
- How do you correlate logs across services?
- What format do you use?

**Red Flags:**

- Only string concatenation logging
- Inconsistent log formats
- Not including context (request_id, etc.)

---

**Q5: What are SLIs, SLOs, and SLAs?**

**Answer Framework:**

- **SLI (Service Level Indicator)**: Metric that matters (uptime %, latency)
- **SLO (Service Level Objective)**: Target for SLI (99.9% uptime)
- **SLA (Service Level Agreement)**: Contract with consequences (99.9% or refund)
- **Relationship**: SLI is measurement, SLO is goal, SLA is promise

**Follow-ups:**

- What SLOs would you set?
- How do you calculate error budget?
- What happens if you miss SLO?

**Red Flags:**

- Setting unrealistic SLOs (100%)
- No SLOs defined
- SLAs without SLOs
- Not tracking SLIs

---

### Intermediate Questions

**Q6: How do you design effective alerts?**

**Answer Framework:**

- **Actionable**: Alert requires human action
- **Precise**: Clear what's wrong and where
- **Timely**: Early warning, not after major impact
- **Avoid fatigue**: Not too frequent, not too sensitive
- **Severity levels**: Critical (wake me up), warning (investigate soon), info
- **Context**: Include relevant data, runbooks

**Follow-ups:**

- What makes a good alert message?
- How do you handle alert fatigue?
- What's your on-call rotation?

**Red Flags:**

- Alerts that don't require action
- No alert documentation/runbooks
- Crying wolf (too many false positives)
- Alerting on symptoms, not problems

---

**Q7: Explain distributed tracing and when you need it.**

**Answer Framework:**

- Track requests across multiple services
- **Components**: Trace (end-to-end request), spans (operations), trace ID
- **Tools**: Jaeger, Zipkin, AWS X-Ray
- **Use cases**: Microservices, debugging latency, understanding dependencies
- **Challenges**: Overhead, sampling, propagating trace context

**Follow-ups:**

- How do you implement tracing?
- What's trace sampling?
- How do you propagate trace context?

**Red Flags:**

- No tracing in microservices
- Not understanding overhead
- Tracing without purpose

---

**Q8: How would you debug a production performance issue?**

**Answer Framework:**

1. **Define the problem**: What's slow? For whom? When?
2. **Check metrics**: Look for anomalies (CPU spike, slow DB queries)
3. **Review logs**: Errors, timeouts, slow operations
4. **Use traces**: Find slow spans in request path
5. **Profile**: CPU/memory profiling if needed
6. **Compare**: Current vs. normal behavior
7. **Recent changes**: Deployments, traffic changes
8. **External deps**: Check third-party services

**Follow-ups:**

- What tools do you use?
- How do you minimize impact while debugging?
- What's your communication strategy?

**Red Flags:**

- Random changes without diagnosis
- No systematic approach
- Ignoring monitoring data
- Not communicating with stakeholders

---

**Q9: What's the difference between monitoring and observability?**

**Answer Framework:**

- **Monitoring**: Known issues, predefined metrics/alerts, "is it broken?"
- **Observability**: Unknown issues, explore and understand, "why is it broken?"
- **Monitoring**: Dashboards, alerts, uptime checks
- **Observability**: Logs, traces, metrics combined for exploration
- **Shift**: From "did we think of this?" to "let's investigate"

**Follow-ups:**

- How do you achieve observability?
- What tools help with observability?
- Is monitoring enough?

**Red Flags:**

- Thinking they're the same
- Only reactive monitoring
- Can't debug unknown issues

---

**Q10: How do you handle log aggregation at scale?**

**Answer Framework:**

- **Centralized logging**: ELK stack, Loki, CloudWatch Logs
- **Collection**: Agents on each host/container (Fluentd, Filebeat)
- **Challenges**: Volume, cost, retention, search performance
- **Solutions**: Sampling, filtering, retention policies, cold storage
- **Best practices**: Structured logs, indexes, partitioning

**Follow-ups:**

- What's your log retention policy?
- How do you control costs?
- How do you search efficiently?

**Red Flags:**

- No centralized logging
- Logs only on individual hosts
- No retention policy (infinite storage)
- Not considering costs

---

### Advanced Questions

**Q11: Design a monitoring strategy for a microservices architecture.**

**Answer Framework:**

- **Service-level metrics**: Each service exposes /metrics endpoint
- **Infrastructure metrics**: Host/container metrics
- **Application metrics**: Business metrics (orders/sec)
- **Distributed tracing**: Request flow across services
- **Centralized logging**: Aggregate from all services
- **Alerting**: Per-service and system-wide
- **Dashboards**: Service-specific and overview
- **SLOs**: Per-service objectives

**Follow-ups:**

- How do you correlate across services?
- What about service dependencies?
- How do you track SLOs?

**Red Flags:**

- Monitoring services in isolation
- No end-to-end visibility
- Can't track requests across services

---

**Q12: How do you implement progressive delivery with monitoring?**

**Answer Framework:**

- **Canary metrics**: Compare new vs. old version
- **Automated rollback**: Roll back if metrics degrade
- **Feature flags**: Enable for subset, monitor
- **Metrics to watch**: Error rate, latency, resource usage
- **Decision criteria**: Statistical significance, threshold breaches
- **Tools**: Flagger, Argo Rollouts, custom automation

**Follow-ups:**

- What metrics trigger rollback?
- How long do you monitor canary?
- What's your rollback strategy?

**Red Flags:**

- Deploying without comparing metrics
- No automated rollback
- Not monitoring during deployment

---

**Q13: Describe your approach to incident response and post-mortems.**

**Answer Framework:**

**During incident:**

1. **Detect**: Alerts, user reports
2. **Triage**: Severity, impact
3. **Communicate**: Status page, stakeholders
4. **Mitigate**: Quick fix to restore service
5. **Monitor**: Verify resolution

**After incident:**

1. **Timeline**: What happened when
2. **Root cause**: Why it happened (5 whys)
3. **Impact**: Users affected, duration
4. **Response**: What went well/poorly
5. **Action items**: Prevent recurrence
6. **Blameless**: Focus on systems, not people

**Follow-ups:**

- How do you practice incident response?
- What's in your runbooks?
- How do you track action items?

**Red Flags:**

- Blaming individuals
- No post-mortem process
- Not learning from incidents
- No runbooks

---

## Module 07: Security Basics

### Basic Questions

**Q1: What is the principle of least privilege?**

**Answer Framework:**

- Users/systems have minimum permissions needed
- **Benefits**: Limit blast radius of compromise, reduce accident risk
- **Apply to**: User accounts, service accounts, IAM roles, file permissions
- **Example**: Read-only DB access for reporting service

**Follow-ups:**

- How do you implement in practice?
- What about temporary elevated access?
- How do you audit permissions?

**Red Flags:**

- Everyone has admin access
- Services running as root
- No permission reviews

---

**Q2: Explain common web vulnerabilities: XSS, CSRF, SQL Injection.**

**Answer Framework:**

**XSS (Cross-Site Scripting):**

- Injecting malicious scripts into web pages
- Prevention: Output encoding, CSP headers, sanitize input

**CSRF (Cross-Site Request Forgery):**

- Trick user into unwanted actions on authenticated site
- Prevention: CSRF tokens, SameSite cookies

**SQL Injection:**

- Inject SQL commands via input
- Prevention: Parameterized queries, ORM, input validation

**Follow-ups:**

- Show an example attack and prevention
- What other common vulnerabilities exist?
- How do you test for vulnerabilities?

**Red Flags:**

- Not knowing these exist
- Trusting client-side validation only
- Not understanding prevention methods

---

**Q3: What is a security group vs. network ACL?**

**Answer Framework:**

**Security Group (AWS):**

- Stateful firewall for instances
- Allow rules only
- Applies to instances

**Network ACL:**

- Stateless firewall for subnets
- Allow and deny rules
- Applies to subnet boundary

**Stateful vs. Stateless:** Security groups track connections; NACLs don't

**Follow-ups:**

- When would you use each?
- What's the difference between stateful and stateless?
- How do you troubleshoot connectivity issues?

**Red Flags:**

- Opening all ports (0.0.0.0/0)
- Not understanding stateful vs. stateless
- No layered security

---

**Q4: How do you secure API endpoints?**

**Answer Framework:**

- **Authentication**: Verify who the client is (API keys, JWT, OAuth)
- **Authorization**: Verify what they can do (RBAC)
- **Encryption**: HTTPS/TLS for data in transit
- **Rate limiting**: Prevent abuse
- **Input validation**: Prevent injection attacks
- **CORS**: Control cross-origin access
- **Logging/Monitoring**: Track access, detect anomalies

**Follow-ups:**

- What authentication method do you prefer?
- How do you handle API versioning?
- What's your rate limiting strategy?

**Red Flags:**

- HTTP instead of HTTPS
- No authentication
- No rate limiting
- Trusting client input

---

**Q5: What is encryption at rest vs. encryption in transit?**

**Answer Framework:**

**At Rest:**

- Data stored on disk (databases, files, backups)
- Tools: Disk encryption, database encryption, KMS

**In Transit:**

- Data moving over network
- Tools: TLS/SSL, VPN, IPSec

**Both needed:** Protect against different threat vectors

**Follow-ups:**

- What's the difference between encryption and hashing?
- How do you manage encryption keys?
- What compliance requires encryption?

**Red Flags:**

- Only one type of encryption
- Storing keys with data
- Not understanding key management

---

### Intermediate Questions

**Q6: How do you implement secrets management in applications?**

**Answer Framework:**

- **Don't**: Hardcode, commit to Git, use plain environment variables
- **Do**: Use secret managers (Vault, AWS Secrets Manager, Azure Key Vault)
- **Rotation**: Automatic secret rotation
- **Access control**: IAM policies for who can read secrets
- **Audit**: Log secret access
- **Runtime**: App fetches secrets at startup or on-demand

**Follow-ups:**

- How do you handle local development?
- What about secret rotation?
- How do you bootstrap secret access?

**Red Flags:**

- Secrets in version control
- .env files in Git
- No secret rotation
- Everyone can access all secrets

---

**Q7: Explain defense in depth.**

**Answer Framework:**

- Multiple layers of security controls
- **Layers**: Network (firewall), host (hardening), application (auth), data (encryption)
- **Principle**: If one layer fails, others provide protection
- **Example**: VPN + MFA + RBAC + encryption + audit logging

**Follow-ups:**

- What layers do you implement?
- How deep is enough?
- What's the trade-off?

**Red Flags:**

- Single point of security
- Only perimeter security
- No layered approach

---

**Q8: How do you handle security vulnerabilities in dependencies?**

**Answer Framework:**

1. **Detection**: Scan dependencies (Dependabot, Snyk, OWASP Dependency-Check)
2. **Assessment**: Severity, exploitability, affected versions
3. **Remediation**: Update to patched version, apply workaround, or accept risk
4. **Automation**: Auto-create PRs for updates
5. **Policy**: SLA for patching by severity
6. **Prevention**: Pin versions, use lock files

**Follow-ups:**

- What tools do you use?
- How do you prioritize vulnerabilities?
- What's your patching SLA?

**Red Flags:**

- Not scanning dependencies
- Ignoring security updates
- Always using latest without testing
- No update strategy

---

**Q9: What is zero trust security?**

**Answer Framework:**

- "Never trust, always verify"
- **vs. Perimeter**: Not trust inside network, verify everything
- **Principles**: Verify identity, least privilege, assume breach
- **Implementation**: MFA, microsegmentation, continuous verification
- **Benefits**: Better for cloud, remote work, insider threats

**Follow-ups:**

- How is it different from traditional security?
- How do you implement zero trust?
- What are the challenges?

**Red Flags:**

- "Inside the network is trusted"
- No identity verification
- Flat network with full internal access

---

**Q10: How do you secure a CI/CD pipeline?**

**Answer Framework:**

- **Code**: Source repo access control, branch protection
- **Build**: Isolated build environments, dependency scanning
- **Secrets**: Use secret managers, not in code
- **Artifacts**: Sign and scan artifacts
- **Deployment**: Approval gates, audit logs
- **Infrastructure**: Secure runners, least privilege IAM
- **Monitoring**: Alert on unusual pipeline activity

**Follow-ups:**

- What specific tools do you use?
- How do you prevent supply chain attacks?
- What's your approval process?

**Red Flags:**

- Secrets in pipeline code
- No approval for prod deployments
- Public runners for sensitive code
- No audit trail

---

### Advanced Questions

**Q11: Design a security strategy for a cloud-native application.**

**Answer Framework:**

**Identity & Access:**

- IAM roles, service accounts (not long-lived keys)
- MFA for humans
- OIDC for CI/CD

**Network:**

- Private subnets, security groups
- Network policies (Kubernetes)
- WAF for public endpoints

**Data:**

- Encryption at rest and in transit
- Secret managers for credentials
- Key rotation

**Application:**

- Input validation, output encoding
- OWASP Top 10 prevention
- Security scanning in CI/CD

**Monitoring:**

- Security event logging
- Anomaly detection
- Incident response plan

**Follow-ups:**

- How do you handle compliance?
- What's your threat model?
- How do you test security?

**Red Flags:**

- Security as afterthought
- No threat modeling
- No security testing

---

**Q12: How do you implement secure multi-tenancy?**

**Answer Framework:**

- **Isolation levels**: Separate infrastructure, shared with isolation, shared resources
- **Data isolation**: Tenant ID in all queries, row-level security
- **Resource limits**: Prevent one tenant from exhausting resources
- **Network isolation**: Separate VPCs/namespaces if needed
- **Authentication**: Tenant context in all requests
- **Monitoring**: Per-tenant metrics and alerts
- **Security**: Can't access other tenant's data

**Follow-ups:**

- What's your isolation strategy?
- How do you test isolation?
- What about shared secrets?

**Red Flags:**

- No tenant isolation
- Trusting tenant ID from client
- No resource limits
- Can query across tenants

---

**Q13: Describe your approach to security incident response.**

**Answer Framework:**

**Preparation:**

- Incident response plan
- Runbooks for common scenarios
- Team roles and contacts
- Tools and access

**Detection:**

- Security monitoring and alerts
- Log analysis
- Anomaly detection

**Response:**

1. **Contain**: Isolate affected systems
2. **Investigate**: Determine scope and cause
3. **Eradicate**: Remove threat
4. **Recover**: Restore services safely
5. **Post-mortem**: Learn and improve

**Communication:**

- Internal stakeholders
- Customers (if affected)
- Regulators (if required)

**Follow-ups:**

- How do you practice incident response?
- What's your communication plan?
- How do you handle compliance reporting?

**Red Flags:**

- No incident response plan
- No practice/drills
- Poor communication
- No learning from incidents

---

## Additional Tips

### For All Modules

**Practice explaining to different audiences:**

- **Technical**: Deep dive with technical details
- **Non-technical**: Business value and analogies
- **Peer**: Trade-offs and alternatives

**Prepare stories:**

- Success stories showing your skills
- Failure stories showing learning
- Problem-solving examples
- Collaboration examples

**Stay current:**

- Follow industry trends
- Try new tools
- Read documentation
- Understand pros/cons

**Build confidence:**

- Practice out loud
- Do mock interviews
- Get feedback
- Iterate and improve

**Remember:**

- It's okay to say "I don't know, but here's how I'd find out"
- Think aloud - show your process
- Ask clarifying questions
- Relate to your experience when possible

Good luck! 🚀
