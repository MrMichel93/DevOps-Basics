# CI/CD Tool Comparison

## This Course Uses: GitHub Actions

## Why We Chose GitHub Actions for This Course

- Native GitHub integration (no separate service)
- Free for public repositories
- Generous free tier for private repos (2,000 minutes/month)
- Easy to learn with YAML syntax
- Large marketplace of pre-built actions
- No infrastructure to manage
- Best for learning alongside Git/GitHub

## Alternative CI/CD Tools

### GitLab CI/CD

**When to Consider:**

- Using GitLab for version control
- Need self-hosted CI/CD solution
- Want all-in-one DevOps platform
- Require advanced pipeline features (DAG, parent-child pipelines)
- Need built-in container registry

**Pros:**

- Integrated with GitLab (seamless experience)
- Powerful pipeline syntax (YAML-based)
- Can self-host runners (unlimited minutes)
- Built-in Docker registry and security scanning
- Advanced features (multi-project pipelines, review apps)
- Excellent for Kubernetes deployments

**Cons:**

- Requires GitLab (can't use with GitHub)
- Self-hosted version requires maintenance
- Steeper learning curve for advanced features
- Resource-intensive for self-hosted setup

**Migration from GitHub Actions:**

```yaml
# GitHub Actions
name: CI
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm test
```

```yaml
# GitLab CI
test:
  image: node:18
  script:
    - npm test
  rules:
    - if: '$CI_PIPELINE_SOURCE == "push"'
```

### Jenkins

**When to Consider:**

- Enterprise with existing Jenkins infrastructure
- Need highly customizable pipelines
- Want complete control over CI/CD server
- Have complex legacy build processes
- Require plugin ecosystem for specific tools

**Pros:**

- Extremely flexible and customizable
- Massive plugin ecosystem (1,800+ plugins)
- Self-hosted (full control)
- Free and open source
- Industry standard for many years
- Supports complex workflows

**Cons:**

- Requires server setup and maintenance
- Steeper learning curve (Groovy/Jenkinsfile)
- UI feels dated compared to modern tools
- Plugin compatibility issues
- More complex to scale
- Security vulnerabilities in plugins

**Migration from GitHub Actions:**

```yaml
# GitHub Actions
name: CI
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm install
      - run: npm test
```

```groovy
// Jenkins (Declarative Pipeline)
pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Install') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
    }
}
```

### CircleCI

**When to Consider:**

- Need cloud-based CI/CD with good performance
- Want excellent Docker support
- Require advanced caching strategies
- Building mobile applications (iOS/Android)

**Pros:**

- Fast build times with advanced caching
- Excellent Docker support
- Cloud-hosted (no maintenance)
- Great for mobile development
- Good free tier (6,000 build minutes/month)

**Cons:**

- Not as tightly integrated with GitHub
- Pricing can get expensive at scale
- Smaller community than Jenkins/GitHub Actions
- Requires separate service

**Migration:**

```yaml
# GitHub Actions
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm test
```

```yaml
# CircleCI
version: 2.1
jobs:
  test:
    docker:
      - image: cimg/node:18.0
    steps:
      - checkout
      - run: npm test
workflows:
  test-workflow:
    jobs:
      - test
```

### Travis CI

**When to Consider:**

- Open source projects (was free, now limited)
- Simple build requirements
- Already have existing Travis configuration

**Pros:**

- Simple YAML configuration
- Good for open source projects
- Easy to get started

**Cons:**

- Free tier very limited now
- Losing market share to GitHub Actions
- Fewer features than competitors
- Less active development

**Note:** Many projects are migrating from Travis CI to GitHub Actions.

## Skills Transfer

Core CI/CD concepts apply across all tools:

| Feature | GitHub Actions | GitLab CI | Jenkins | CircleCI |
|---------|---------------|-----------|---------|----------|
| Config File | `.github/workflows/*.yml` | `.gitlab-ci.yml` | `Jenkinsfile` | `.circleci/config.yml` |
| Syntax | YAML | YAML | Groovy | YAML |
| Triggers | Events | Rules | Triggers | Workflows |
| Jobs | Jobs | Jobs | Stages | Jobs |
| Parallel Execution | Matrix | Parallel | Parallel | Workflows |
| Secrets | GitHub Secrets | CI/CD Variables | Credentials | Context/Secrets |
| Artifacts | Upload/Download | Artifacts | Archive | Persist/Attach |

**Transferable CI/CD Concepts:**

- Pipeline stages (build, test, deploy)
- Automated testing principles
- Environment variables and secrets
- Artifact management
- Caching strategies
- Deployment strategies (blue-green, canary)
- Integration testing

**Tool-Specific Knowledge:**

- Configuration syntax and structure
- Marketplace/plugins ecosystem
- Runner/agent setup
- Pricing and limitations
- UI and monitoring

## Practical Exercise

Implement the same pipeline on different platforms:

1. **GitHub Actions** (this course)
   ```yaml
   name: CI Pipeline
   on: [push, pull_request]
   
   jobs:
     build-and-test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Setup Node
           uses: actions/setup-node@v4
           with:
             node-version: '18'
         - run: npm install
         - run: npm test
         - run: npm run build
   ```

2. **Try on GitLab CI** (if you have GitLab account)
   ```yaml
   test:
     image: node:18
     script:
       - npm install
       - npm test
       - npm run build
   ```

3. **Compare the experience**
   - Note YAML structure similarities
   - Compare trigger mechanisms
   - Observe execution speed
   - Check logging and debugging tools

**Learning Goal:** Understand that CI/CD principles are universal, syntax is tool-specific.

## Choosing the Right Tool

**For Learning CI/CD:**

- ✅ GitHub Actions - Best for this course, easy to start

**For Personal/Open Source Projects:**

- GitHub Actions - Free for public repos, integrated with GitHub
- GitLab CI - If using GitLab, good free tier

**For Startups/Small Teams:**

- GitHub Actions - Easy, no infrastructure
- GitLab CI - All-in-one platform
- CircleCI - If need advanced features

**For Enterprise:**

- Jenkins - Already have infrastructure, need customization
- GitLab CI - Want DevOps platform, can self-host
- GitHub Actions - Using GitHub Enterprise
- Cloud Provider CI/CD - AWS CodePipeline, Azure Pipelines, GCP Cloud Build

## Modern CI/CD Trends

**Current Industry Movement:**

```
Jenkins (Legacy) → Cloud-Native CI/CD
                → GitHub Actions
                → GitLab CI
                → Cloud Provider Services
```

**Why the shift?**

- No infrastructure to manage
- Better integration with version control
- Faster setup and iteration
- Pay-per-use pricing
- Modern YAML configuration

## Advanced Comparison

### Performance

- **Fastest:** GitLab CI (self-hosted), CircleCI (optimized caching)
- **Good:** GitHub Actions, Cloud providers
- **Variable:** Jenkins (depends on setup)

### Scalability

- **Best:** Kubernetes-based (GitLab, Cloud providers)
- **Good:** GitHub Actions (managed scaling)
- **Manual:** Jenkins (requires setup)

### Cost (for private repos/large teams)

- **Free Option:** Jenkins (self-host), GitLab CE (self-host)
- **Pay-per-use:** GitHub Actions, CircleCI, Cloud providers
- **Enterprise:** All offer enterprise tiers

### Ecosystem

- **Largest:** Jenkins (plugins), GitHub (Actions marketplace)
- **Growing:** GitLab (integrations)
- **Specialized:** CircleCI (mobile)

## Migration Strategies

**Moving from Jenkins to GitHub Actions:**

1. Start with simple pipelines
2. Convert Jenkinsfile stages to Actions jobs
3. Replace Jenkins plugins with Actions from marketplace
4. Migrate secrets to GitHub Secrets
5. Test thoroughly before full migration

**Moving from Travis CI to GitHub Actions:**

1. GitHub provides automatic migration tool
2. Very similar YAML syntax
3. Usually quick migration (hours, not days)

**Moving from GitLab CI to GitHub Actions:**

1. Conceptually similar (both YAML)
2. Adjust syntax differences
3. Replace GitLab-specific features
4. May need different approach for some features

## Key Takeaways

1. **GitHub Actions is modern and integrated** - Perfect for GitHub projects
2. **GitLab CI is powerful** - Especially for self-hosted needs
3. **Jenkins is customizable** - But requires more maintenance
4. **Core concepts transfer** - Learn principles, not just syntax
5. **Choose based on needs** - Integration, cost, and existing infrastructure

## When to Use What

**Use GitHub Actions when:**

- Projects hosted on GitHub
- Want easy setup with no infrastructure
- Building modern cloud-native applications
- Learning CI/CD fundamentals

**Use GitLab CI when:**

- Using GitLab for version control
- Need self-hosted solution
- Want integrated DevOps platform
- Deploying to Kubernetes frequently

**Use Jenkins when:**

- Have existing Jenkins infrastructure
- Need highly customized workflows
- Working with legacy systems
- Require specific plugins

**Use CircleCI when:**

- Building mobile applications
- Need excellent Docker support
- Want fast build times
- Willing to pay for premium features

## Real-World Usage Statistics

**Market Share (approximate):**

- Jenkins: ~40% (but declining for new projects)
- GitHub Actions: ~30% (rapidly growing)
- GitLab CI: ~15%
- Others (CircleCI, Travis, etc.): ~15%

**For New Projects:**

- GitHub Actions and GitLab CI are most popular
- Cloud provider CI/CD growing (AWS, Azure, GCP)
- Jenkins mostly for legacy/enterprise

---

**Next Steps:**

- Master GitHub Actions in this module
- Understand CI/CD principles deeply
- Experiment with GitLab CI if curious
- Focus on transferable pipeline concepts
- Learn one well, then others become easy
