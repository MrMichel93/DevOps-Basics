# Module 04: CI/CD with GitHub Actions - Diagrams

This document contains visual diagrams to help understand CI/CD pipelines, GitHub Actions workflows, and deployment strategies.

## 1. CI/CD Pipeline Flow

This diagram shows a complete CI/CD pipeline with testing, building, and deployment stages:

```text
┌──────────┐
│   Code   │
│   Push   │
└─────┬────┘
      │
      ▼
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  Tests   │────>│  Build   │────>│ Security │────>│  Deploy  │────>│ Monitor  │
│          │     │          │     │   Scan   │     │          │     │          │
└─────┬────┘     └─────┬────┘     └─────┬────┘     └─────┬────┘     └─────┬────┘
      │                │                │                │                │
      ▼                ▼                ▼                ▼                ▼
   ┌──────┐         ┌──────┐         ┌──────┐         ┌──────┐         ┌──────┐
   │Pass? │         │Pass? │         │Pass? │         │Pass? │         │ OK?  │
   └──┬───┘         └──┬───┘         └──┬───┘         └──┬───┘         └──┬───┘
      │                │                │                │                │
  ┌───┴───┐        ┌───┴───┐        ┌───┴───┐        ┌───┴───┐        ┌───┴───┐
  │       │        │       │        │       │        │       │        │       │
┌─▼──┐ ┌──▼─┐    ┌─▼──┐ ┌──▼─┐    ┌─▼──┐ ┌──▼─┐    ┌─▼──┐ ┌──▼─┐    ┌─▼──┐ ┌──▼─┐
│Yes │ │ No │    │Yes │ │ No │    │Yes │ │ No │    │Yes │ │ No │    │Yes │ │ No │
└─┬──┘ └─┬──┘    └─┬──┘ └─┬──┘    └─┬──┘ └─┬──┘    └─┬──┘ └─┬──┘    └─┬──┘ └─┬──┘
  │      │         │      │         │      │         │      │         │      │
  │   ┌──▼──┐      │   ┌──▼──┐      │   ┌──▼──┐      │   ┌──▼──┐      │   ┌──▼──┐
  │   │STOP │      │   │STOP │      │   │STOP │      │   │STOP │      │   │Alert│
  │   │Fail │      │   │Fail │      │   │Fail │      │   │Fail │      │   │Team │
  │   └─────┘      │   └─────┘      │   └─────┘      │   └─────┘      │   └──┬──┘
  │                │                │                │                │      │
  └────────────────┘                │                │                └──────┘
                   │                │                │
                   └────────────────┘                │
                                    │                │
                                    └────────────────┘
                                                     │
                                                     ▼
                                              ┌─────────────┐
                                              │  Success!   │
                                              │  Pipeline   │
                                              │  Complete   │
                                              └─────────────┘
```

**Pipeline Stages Explained:**

1. **Tests**: Run unit tests, integration tests, and linting
2. **Build**: Compile code and create artifacts (Docker images, binaries)
3. **Security Scan**: Check for vulnerabilities in code and dependencies
4. **Deploy**: Deploy to staging or production environment
5. **Monitor**: Continuous monitoring and health checks

**Pipeline Benefits:**

- Early bug detection
- Consistent builds
- Automated testing
- Faster deployment
- Reduced human error

## 2. GitHub Actions Workflow Architecture

This diagram shows how GitHub Actions components work together:

```text
┌────────────────────────────────────────────────────────────────┐
│                         GitHub Events                          │
├────────────────────────────────────────────────────────────────┤
│  push │ pull_request │ schedule │ workflow_dispatch │ release  │
└───┬────────────┬──────────┬──────────────┬──────────────┬──────┘
    │            │          │              │              │
    └────────────┴──────────┴──────────────┴──────────────┘
                             │
                             ▼
┌────────────────────────────────────────────────────────────────┐
│                    Workflow File (.yml)                        │
│                   .github/workflows/ci.yml                     │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  name: CI Pipeline                                             │
│  on: [push, pull_request]                                      │
│                                                                │
│  jobs:                                                         │
│    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│    │    Job 1    │    │    Job 2    │    │    Job 3    │     │
│    │   (Test)    │───>│   (Build)   │───>│   (Deploy)  │     │
│    └─────────────┘    └─────────────┘    └─────────────┘     │
└────────────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   Runner OS     │  │   Runner OS     │  │   Runner OS     │
│   ubuntu-latest │  │   ubuntu-latest │  │   ubuntu-latest │
└─────────────────┘  └─────────────────┘  └─────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│     Steps       │  │     Steps       │  │     Steps       │
├─────────────────┤  ├─────────────────┤  ├─────────────────┤
│ 1. Checkout     │  │ 1. Checkout     │  │ 1. Checkout     │
│ 2. Setup Node   │  │ 2. Setup Node   │  │ 2. Configure    │
│ 3. Install deps │  │ 3. Build app    │  │ 3. Deploy       │
│ 4. Run tests    │  │ 4. Upload       │  │ 4. Verify       │
│ 5. Report       │  │    artifact     │  │ 5. Notify       │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

**Workflow Components:**

1. **Events**: Triggers that start workflows (push, PR, schedule, etc.)
2. **Workflows**: Automated processes defined in YAML files
3. **Jobs**: Groups of steps that run on the same runner
4. **Steps**: Individual tasks like checking out code or running commands
5. **Runners**: Virtual machines that execute jobs

**Example Workflow Structure:**

```yaml
Event (push)
  └── Workflow (ci.yml)
      └── Job (test)
          ├── Step 1: Checkout code
          ├── Step 2: Setup environment
          ├── Step 3: Run tests
          └── Step 4: Upload results
```

## 3. Deployment Strategies

Visual comparison of three common deployment strategies:

### Rolling Deployment

```text
Initial State:       Step 1:          Step 2:          Step 3:
┌────────────────┐  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐
│ ┌────┐ ┌────┐ │  │ ┌────┐ ┌────┐ │  │ ┌────┐ ┌────┐ │  │ ┌────┐ ┌────┐ │
│ │ v1 │ │ v1 │ │  │ │ v2 │ │ v1 │ │  │ │ v2 │ │ v2 │ │  │ │ v2 │ │ v2 │ │
│ └────┘ └────┘ │  │ └────┘ └────┘ │  │ └────┘ └────┘ │  │ └────┘ └────┘ │
│ ┌────┐ ┌────┐ │  │ ┌────┐ ┌────┐ │  │ ┌────┐ ┌────┐ │  │ ┌────┐ ┌────┐ │
│ │ v1 │ │ v1 │ │  │ │ v1 │ │ v1 │ │  │ │ v2 │ │ v1 │ │  │ │ v2 │ │ v2 │ │
│ └────┘ └────┘ │  │ └────┘ └────┘ │  │ └────┘ └────┘ │  │ └────┘ └────┘ │
└────────────────┘  └────────────────┘  └────────────────┘  └────────────────┘

Pros: Simple, gradual rollout, no extra infrastructure
Cons: Mixed versions running simultaneously, slower deployment
```

### Blue-Green Deployment

```text
Step 1: Both environments running
┌─────────────────────────────────┐
│       Load Balancer             │
│         (100% → Blue)           │
└────────────┬────────────────────┘
             │
        ┌────┴────┐
        │         │
   ┌────▼───┐ ┌──▼──────┐
   │  Blue  │ │  Green  │
   │  (v1)  │ │  (v2)   │
   │        │ │         │
   │ Active │ │  Idle   │
   └────────┘ └─────────┘

Step 2: Switch traffic to Green
┌─────────────────────────────────┐
│       Load Balancer             │
│         (100% → Green)          │
└────────────┬────────────────────┘
             │
        ┌────┴────┐
        │         │
   ┌────▼───┐ ┌──▼──────┐
   │  Blue  │ │  Green  │
   │  (v1)  │ │  (v2)   │
   │        │ │         │
   │  Idle  │ │ Active  │
   └────────┘ └─────────┘

Pros: Instant rollback, zero downtime
Cons: Requires double infrastructure, database sync challenges
```

### Canary Deployment

```text
Step 1: 10% traffic to new version
┌─────────────────────────────────┐
│       Load Balancer             │
│     (90% v1, 10% v2)            │
└────────────┬────────────────────┘
             │
        ┌────┴─────────┐
        │              │
   ┌────▼───┐     ┌────▼───┐
   │   v1   │     │   v2   │
   │        │     │ Canary │
   │90%     │     │  10%   │
   └────────┘     └────────┘

Step 2: 50% traffic to new version
┌─────────────────────────────────┐
│       Load Balancer             │
│     (50% v1, 50% v2)            │
└────────────┬────────────────────┘
             │
        ┌────┴─────────┐
        │              │
   ┌────▼───┐     ┌────▼───┐
   │   v1   │     │   v2   │
   │        │     │        │
   │  50%   │     │  50%   │
   └────────┘     └────────┘

Step 3: 100% traffic to new version
┌─────────────────────────────────┐
│       Load Balancer             │
│       (100% → v2)               │
└────────────┬────────────────────┘
             │
             │
        ┌────▼───┐
        │   v2   │
        │        │
        │  100%  │
        └────────┘

Pros: Gradual rollout, early issue detection, limited blast radius
Cons: Complex routing logic, requires monitoring
```

## 4. Failed Pipeline Troubleshooting Tree

This decision tree helps diagnose and fix pipeline failures:

```text
                      ┌─────────────┐
                      │  Pipeline   │
                      │   Failed    │
                      └──────┬──────┘
                             │
                    ┌────────▼────────┐
                    │  Which Stage    │
                    │    Failed?      │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
   ┌────▼────┐         ┌─────▼─────┐       ┌─────▼─────┐
   │  Test   │         │   Build   │       │  Deploy   │
   │  Stage  │         │   Stage   │       │   Stage   │
   └────┬────┘         └─────┬─────┘       └─────┬─────┘
        │                    │                    │
        ▼                    ▼                    ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│Check test logs│    │Check build log│    │Check deploy   │
└───────┬───────┘    └───────┬───────┘    │     logs      │
        │                    │            └───────┬───────┘
        ▼                    ▼                    │
┌───────────────┐    ┌───────────────┐           ▼
│ Tests failing?│    │ Dependencies? │    ┌───────────────┐
└───────┬───────┘    └───────┬───────┘    │ Credentials?  │
        │                    │            └───────┬───────┘
   ┌────┴────┐          ┌────┴────┐              │
   │         │          │         │         ┌────┴────┐
┌──▼──┐  ┌───▼───┐  ┌──▼──┐  ┌───▼───┐  ┌──▼──┐  ┌───▼───┐
│Unit │  │Integra│  │Cache│  │Missing│  │ Yes │  │  No   │
│Test │  │ tion  │  │Issue│  │ Deps  │  └──┬──┘  └───┬───┘
└──┬──┘  └───┬───┘  └──┬──┘  └───┬───┘     │         │
   │         │         │         │         │         ▼
   ▼         ▼         ▼         ▼         │   ┌─────────┐
┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐       │   │Network? │
│ Fix  │ │Check │ │Clear │ │Update│       │   └────┬────┘
│ Code │ │Env/  │ │Cache │ │Lock  │       │        │
│      │ │Setup │ │      │ │File  │       │   ┌────┴────┐
└──────┘ └──────┘ └──────┘ └──────┘       │   │         │
                                           │ ┌─▼──┐  ┌───▼───┐
                                           │ │Yes │  │  No   │
                                           │ └─┬──┘  └───┬───┘
                                           │   │         │
                                           │   ▼         ▼
                                           │┌──────┐ ┌──────┐
                                           ││Retry │ │Check │
                                           ││Later │ │Config│
                                           │└──────┘ └──────┘
                                           │
                                           ▼
                                    ┌───────────────┐
                                    │ Update Secrets│
                                    │  in Settings  │
                                    └───────────────┘
                                           │
                                           ▼
                                    ┌───────────────┐
                                    │    Rerun      │
                                    │   Pipeline    │
                                    └───────────────┘
```

**Common Issues and Solutions:**

1. **Test Failures**
   - Check test logs for specific failures
   - Verify test data and fixtures
   - Ensure correct environment setup

2. **Build Failures**
   - Clear cache and rebuild
   - Update dependencies
   - Check for version conflicts

3. **Deployment Failures**
   - Verify credentials and permissions
   - Check network connectivity
   - Review deployment configuration

4. **General Debugging**
   - Enable debug logging
   - Check runner environment
   - Verify secrets and variables
   - Review recent changes

**Useful Commands:**

- Re-run failed jobs in GitHub Actions UI
- Add debug steps with `- run: echo "Debug info"`
- Use `act` tool to test workflows locally
- Check GitHub Actions status page for platform issues
