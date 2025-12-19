# Module 05: Infrastructure as Code Lite - Diagrams

This document contains visual diagrams to help understand Infrastructure as Code concepts, Docker Compose configurations, and configuration management.

## 1. IaC Concept - Manual Process vs Automated IaC

This comparison shows the difference between manual infrastructure setup and automated IaC:

### Manual Infrastructure Setup

```text
┌──────────────────────────────────────────────────────────────┐
│                    Manual Process                            │
└──────────────────────────────────────────────────────────────┘

Developer                     Operations Team
    │                              │
    │  1. Request Server           │
    ├─────────────────────────────>│
    │                              │
    │                         2. Manually:
    │                              ├─ Provision VM
    │                              ├─ Install OS
    │                              ├─ Configure network
    │                              ├─ Install software
    │                              ├─ Set up security
    │                              └─ Configure services
    │                              │
    │  3. Server Ready (Days)      │
    │<─────────────────────────────┤
    │                              │
    │  4. Deploy Application       │
    ├─────────────────────────────>│
    │                              │
    │                         5. Manually:
    │                              ├─ Copy files
    │                              ├─ Configure app
    │                              └─ Start services
    │                              │
    │  6. Done (More Days)         │
    │<─────────────────────────────┤

Problems:
❌ Time-consuming (days/weeks)
❌ Error-prone
❌ Inconsistent across environments
❌ Hard to replicate
❌ No version control
❌ Manual documentation required
```

### Infrastructure as Code (IaC)

```text
┌──────────────────────────────────────────────────────────────┐
│              Infrastructure as Code (IaC)                    │
└──────────────────────────────────────────────────────────────┘

Developer                     IaC Tools
    │                              │
    │  1. Write IaC Config         │
    │     (docker-compose.yml)     │
    │                              │
    │  2. Commit to Git            │
    │                              │
    │  3. Run: docker-compose up   │
    ├─────────────────────────────>│
    │                              │
    │                         Automatically:
    │                              ├─ Pull images
    │                              ├─ Create network
    │                              ├─ Start containers
    │                              ├─ Configure services
    │                              └─ Set up volumes
    │                              │
    │  4. Infrastructure Ready     │
    │     (Minutes)                │
    │<─────────────────────────────┤

Benefits:
✅ Fast deployment (minutes)
✅ Consistent and repeatable
✅ Version controlled
✅ Easy to replicate
✅ Self-documenting
✅ Testable
```

### Side-by-Side Comparison

```text
┌───────────────────┬─────────────────┬─────────────────┐
│     Aspect        │     Manual      │       IaC       │
├───────────────────┼─────────────────┼─────────────────┤
│ Deployment Time   │  Days/Weeks     │    Minutes      │
│ Consistency       │    Variable     │   Guaranteed    │
│ Documentation     │    Manual       │   Automatic     │
│ Version Control   │      No         │      Yes        │
│ Reproducibility   │     Hard        │      Easy       │
│ Error Rate        │     High        │      Low        │
│ Scalability       │     Poor        │    Excellent    │
│ Rollback          │   Difficult     │      Easy       │
└───────────────────┴─────────────────┴─────────────────┘
```

## 2. Docker Compose Stack

This diagram shows how services in a Docker Compose stack relate to each other:

```text
┌──────────────────────────────────────────────────────────────┐
│                  docker-compose.yml                          │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                      Frontend Tier                           │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌────────────────────────────────────────┐                │
│   │        nginx (Web Server)              │                │
│   │     Port: 80:80, 443:443               │                │
│   │     Serves: Static files + Proxy       │                │
│   └────────────────┬───────────────────────┘                │
└────────────────────┼──────────────────────────────────────────┘
                     │
                     │ HTTP Requests
                     │
┌────────────────────▼─────────────────────────────────────────┐
│                   Application Tier                           │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌──────────────────────┐    ┌──────────────────────┐      │
│   │   api-service-1      │    │   api-service-2      │      │
│   │   Port: 3000         │    │   Port: 3001         │      │
│   │   Language: Node.js  │    │   Language: Python   │      │
│   │   Replicas: 3        │    │   Replicas: 2        │      │
│   └──────────┬───────────┘    └──────────┬───────────┘      │
└──────────────┼────────────────────────────┼──────────────────┘
               │                            │
               │ SQL Queries                │
               │                            │
┌──────────────▼────────────────────────────▼──────────────────┐
│                      Data Tier                               │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌──────────────────────┐    ┌──────────────────────┐      │
│   │   postgres           │    │   redis              │      │
│   │   Port: 5432         │    │   Port: 6379         │      │
│   │   Volume: db-data    │    │   Volume: cache-data │      │
│   │   Persistent Storage │    │   Cache Layer        │      │
│   └──────────────────────┘    └──────────────────────┘      │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                    Supporting Services                       │
├──────────────────────────────────────────────────────────────┤
│   ┌──────────────────────┐    ┌──────────────────────┐      │
│   │   monitoring         │    │   logging            │      │
│   │   (Prometheus)       │    │   (ELK Stack)        │      │
│   │   Port: 9090         │    │   Port: 5601         │      │
│   └──────────────────────┘    └──────────────────────┘      │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                      Shared Resources                        │
├──────────────────────────────────────────────────────────────┤
│  Networks:                                                   │
│    ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│    │  frontend   │  │   backend   │  │  monitoring │        │
│    │   network   │  │   network   │  │   network   │        │
│    └─────────────┘  └─────────────┘  └─────────────┘        │
│                                                              │
│  Volumes:                                                    │
│    ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│    │   db-data   │  │ cache-data  │  │  app-logs   │        │
│    └─────────────┘  └─────────────┘  └─────────────┘        │
└──────────────────────────────────────────────────────────────┘
```

**Service Dependencies:**

```text
nginx
  ├─ depends_on: api-service-1, api-service-2
  └─ networks: frontend, backend

api-service-1
  ├─ depends_on: postgres, redis
  └─ networks: backend

api-service-2
  ├─ depends_on: postgres, redis
  └─ networks: backend

postgres
  ├─ volumes: db-data
  └─ networks: backend

redis
  ├─ volumes: cache-data
  └─ networks: backend
```

## 3. Configuration Management Flow

This diagram shows how configuration flows from environment variables to running containers:

```text
┌──────────────────────────────────────────────────────────────┐
│                   Configuration Sources                      │
└──────────────────────────────────────────────────────────────┘

┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  .env File   │  │ Environment  │  │docker-compose│  │   Secrets    │
│              │  │  Variables   │  │     .yml     │  │   (Vault)    │
├──────────────┤  ├──────────────┤  ├──────────────┤  ├──────────────┤
│DB_HOST=db    │  │ENVIRONMENT=  │  │services:     │  │DB_PASSWORD=  │
│DB_PORT=5432  │  │  production  │  │  web:        │  │  ********    │
│APP_PORT=3000 │  │              │  │    env_file: │  │API_KEY=      │
│DEBUG=false   │  │REGION=us-1   │  │      - .env  │  │  ********    │
└──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘
       │                 │                 │                 │
       └─────────────────┴─────────────────┴─────────────────┘
                                │
                                ▼
                 ┌──────────────────────────┐
                 │   Configuration Merge    │
                 │    (Priority Order)      │
                 └────────────┬─────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              Container Runtime Environment                  │
└─────────────────────────────────────────────────────────────┘

         ┌────────────────────────────────────┐
         │         Container 1                │
         ├────────────────────────────────────┤
         │ Environment Variables:             │
         │  ┌──────────────────────────────┐  │
         │  │ DB_HOST=db                   │  │
         │  │ DB_PORT=5432                 │  │
         │  │ DB_PASSWORD=********         │  │
         │  │ APP_PORT=3000                │  │
         │  │ DEBUG=false                  │  │
         │  │ ENVIRONMENT=production       │  │
         │  │ REGION=us-1                  │  │
         │  │ API_KEY=********             │  │
         │  └──────────────────────────────┘  │
         │            ▼                       │
         │  ┌──────────────────────────────┐  │
         │  │    Application Reads         │  │
         │  │    process.env.DB_HOST       │  │
         │  └──────────────────────────────┘  │
         └────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│              Configuration Flow Process                     │
└─────────────────────────────────────────────────────────────┘

┌─────────────┐
│  Load .env  │
│    File     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Override  │
│    with     │
│Environment  │
│  Variables  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Merge     │
│docker-compose│
│ env settings│
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Inject    │
│  Secrets    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Start     │
│  Container  │
│    with     │
│Final Config │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Application │
│   Reads     │
│   Config    │
└─────────────┘
```

**Configuration Priority (Highest to Lowest):**

1. Command-line arguments
2. Environment variables from shell
3. .env file values
4. docker-compose.yml defaults
5. Dockerfile ENV defaults

**Best Practices:**

```text
✅ DO:
├─ Use .env files for local development
├─ Store secrets in secure vaults
├─ Use environment-specific configs
├─ Document all configuration options
└─ Validate configuration at startup

❌ DON'T:
├─ Commit secrets to version control
├─ Hardcode configuration in code
├─ Use production values in examples
└─ Mix configuration layers unnecessarily
```

**Environment-Specific Configuration:**

```text
Development          Staging              Production
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ .env.dev     │    │ .env.staging │    │ .env.prod    │
├──────────────┤    ├──────────────┤    ├──────────────┤
│DEBUG=true    │    │DEBUG=false   │    │DEBUG=false   │
│LOG_LEVEL=    │    │LOG_LEVEL=    │    │LOG_LEVEL=    │
│  debug       │    │  info        │    │  warn        │
│CACHE=false   │    │CACHE=true    │    │CACHE=true    │
│DB_HOST=      │    │DB_HOST=      │    │DB_HOST=      │
│ localhost    │    │ staging-db   │    │ prod-db      │
└──────────────┘    └──────────────┘    └──────────────┘
```

**Configuration Validation Example:**

```text
┌─────────────────────────────────────────┐
│      Application Startup                │
└─────────────────────────────────────────┘

Start
  │
  ▼
Load Configuration
  │
  ▼
┌──────────────┐
│  Validate    │
│  Required    │
│  Variables   │
└──────┬───────┘
       │
  ┌────▼────┐
  │  Valid? │
  └────┬────┘
       │
  ┌────┴────┐
  │         │
┌─▼──┐  ┌───▼───┐
│Yes │  │  No   │
└─┬──┘  └───┬───┘
  │         │
  │    ┌────▼────┐
  │    │  Log    │
  │    │  Error  │
  │    │  Exit   │
  │    └─────────┘
  │
  ▼
Continue
Application
Startup
```

**Common Configuration Patterns:**

- Database connection strings
- API endpoints and URLs
- Feature flags
- Timeout values
- Resource limits
- Logging levels
- Security settings
