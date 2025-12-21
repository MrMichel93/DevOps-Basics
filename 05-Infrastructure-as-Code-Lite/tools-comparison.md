# Infrastructure as Code Tool Comparison

## This Course Uses: Docker Compose

## Why We Chose Docker Compose for This Course

- Simple and beginner-friendly
- Perfect for local development environments
- Works on any machine with Docker installed
- YAML-based declarative configuration
- No cloud provider required
- Immediate feedback and testing
- Great for learning IaC concepts without complexity

## Alternative IaC Tools

### Terraform

**When to Consider:**

- Managing cloud infrastructure (AWS, Azure, GCP)
- Need multi-cloud deployments
- Provisioning VMs, networks, databases
- Require state management for infrastructure
- Building production cloud environments

**Pros:**

- Industry standard for cloud infrastructure
- Supports multiple cloud providers (AWS, Azure, GCP, etc.)
- Declarative HCL syntax
- Strong state management
- Massive provider ecosystem
- Plan/Apply workflow (preview changes)
- Great for production infrastructure

**Cons:**

- Not designed for application orchestration
- Requires cloud provider account
- Steeper learning curve
- State file management complexity
- Overkill for local development
- Costs money (cloud resources)

**Comparison:**

```yaml
# Docker Compose - Application focus
version: '3.8'
services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
  database:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secret
```

```hcl
# Terraform - Infrastructure focus
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

resource "aws_rds_instance" "database" {
  engine         = "postgres"
  instance_class = "db.t2.micro"
}
```

**Different Use Cases:**

- Docker Compose: "Run my application locally/small deployments"
- Terraform: "Provision cloud infrastructure for my application"

### Ansible

**When to Consider:**

- Configuring existing servers (configuration management)
- Managing multiple servers at scale
- Need automation across diverse systems
- Require agentless automation
- Legacy systems without container support

**Pros:**

- Agentless (just needs SSH)
- Simple YAML playbooks
- Excellent for configuration management
- Works with any system (Linux, Windows, network devices)
- Large module library
- Good for both provisioning and configuration
- Idempotent by design

**Cons:**

- More complex for simple tasks
- Slower than other tools (SSH overhead)
- Mutable infrastructure model
- Not primarily for cloud provisioning
- Procedural (vs. declarative in some cases)

**Comparison:**

```yaml
# Docker Compose - Containers
services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
```

```yaml
# Ansible - Server Configuration
- name: Install and configure nginx
  hosts: webservers
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
    - name: Start nginx
      service:
        name: nginx
        state: started
```

**Different Use Cases:**

- Docker Compose: "Define my application stack"
- Ansible: "Configure servers and install software"

### Kubernetes (with Helm)

**When to Consider:**

- Production container orchestration at scale
- Need auto-scaling and self-healing
- Running hundreds/thousands of containers
- Require advanced networking and service discovery
- Multi-node cluster deployments

**Pros:**

- Production-grade container orchestration
- Auto-scaling and self-healing
- Service discovery and load balancing
- Declarative configuration
- Industry standard for production containers
- Multi-node cluster support

**Cons:**

- Extremely complex for beginners
- Overkill for small projects
- Requires cluster infrastructure
- Steep learning curve
- Resource-intensive
- Not for local development (typically)

**Comparison:**

```yaml
# Docker Compose - Simple multi-container
services:
  web:
    image: nginx
    replicas: 3
    ports:
      - "80:80"
```

```yaml
# Kubernetes - Production orchestration
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: nginx
        image: nginx
---
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  type: LoadBalancer
  ports:
  - port: 80
```

**Different Use Cases:**

- Docker Compose: "Local development and small deployments"
- Kubernetes: "Production container orchestration at scale"

### Pulumi

**When to Consider:**

- Want to use programming languages (TypeScript, Python, Go)
- Need complex logic in infrastructure code
- Require type safety and IDE support
- Modern cloud-native development

**Pros:**

- Use real programming languages
- Better IDE support (autocomplete, refactoring)
- Reusable components and libraries
- Type safety
- Familiar for developers

**Cons:**

- Less mature than Terraform
- Smaller community
- More complex for simple tasks
- Not as widely adopted

**Comparison:**

```yaml
# Docker Compose
services:
  web:
    image: nginx:alpine
```

```typescript
// Pulumi
import * as docker from "@pulumi/docker";

const web = new docker.Container("web", {
    image: "nginx:alpine",
    ports: [{ internal: 80, external: 80 }],
});
```

## Skills Transfer

| Concept | Docker Compose | Terraform | Ansible | Kubernetes |
|---------|---------------|-----------|---------|------------|
| **Format** | YAML | HCL | YAML | YAML |
| **Scope** | Containers | Cloud Infra | Config Mgmt | Containers |
| **State** | No state | State file | No state | etcd |
| **Declarative** | Yes | Yes | Mostly | Yes |
| **Local Dev** | ✅ Perfect | ❌ No | ⚠️ Can work | ⚠️ Too complex |
| **Production** | ⚠️ Limited | ✅ Excellent | ✅ Good | ✅ Best |

**Note:** Pulumi is excluded from this comparison table as it uses programming languages (TypeScript, Python, Go) rather than configuration languages (YAML, HCL), making direct feature comparison less relevant. Pulumi is similar to Terraform in scope but with a fundamentally different approach.

**Transferable IaC Concepts:**

- Declarative configuration
- Infrastructure versioning
- Environment reproducibility
- Configuration as code
- Idempotency principles
- Environment variables and secrets

**Tool-Specific Knowledge:**

- Syntax and structure
- Scope and purpose
- Provider/module ecosystem
- State management (if applicable)

## The IaC Journey

Most developers follow this learning path:

```
1. Docker Compose (Local Dev)
        ↓
2. Terraform (Cloud Infrastructure)
        ↓
3. Kubernetes (Container Orchestration)
        ↓
4. Helm (Kubernetes Package Manager)
```

**Where you are now:** Step 1 (Docker Compose)

**This module teaches:** IaC fundamentals that apply to all tools

## Practical Exercise

Understand the different purposes:

**1. Local Development Stack (Docker Compose)**

```yaml
# docker-compose.yml
version: '3.8'
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
  backend:
    build: ./backend
    ports:
      - "8080:8080"
  database:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: dev_password
```

**Purpose:** Run entire application locally for development

**2. Cloud Infrastructure (Terraform)**

```hcl
# main.tf
resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.medium"
}

resource "aws_rds_instance" "database" {
  engine         = "postgres"
  instance_class = "db.t3.medium"
}
```

**Purpose:** Provision cloud resources (servers, databases, networks)

**3. Server Configuration (Ansible)**

```yaml
# playbook.yml
- name: Configure application server
  hosts: app_servers
  tasks:
    - name: Install Docker
      apt: name=docker.io state=present
    - name: Deploy application
      docker_container:
        name: app
        image: myapp:latest
```

**Purpose:** Configure servers and deploy applications

**Learning Goal:** Each tool solves different problems

## Choosing the Right Tool

**For This Course (Learning IaC):**

- ✅ Docker Compose - Perfect for learning fundamentals

**For Local Development:**

- Docker Compose - Best choice
- Kubernetes (Minikube/kind) - Only if learning K8s

**For Cloud Infrastructure:**

- Terraform - Industry standard
- Pulumi - If you prefer code
- CloudFormation - AWS only

**For Configuration Management:**

- Ansible - Most versatile
- Chef/Puppet - Enterprise legacy
- SaltStack - Large scale

**For Production Containers:**

- Kubernetes - Large scale
- Docker Swarm - Simpler (but less popular)
- Managed services - ECS, Cloud Run, etc.

## When to Use What

**Docker Compose:**

- ✅ Local development
- ✅ Testing environments
- ✅ Small deployments (1-5 servers)
- ❌ Large production deployments
- ❌ Auto-scaling requirements

**Terraform:**

- ✅ Cloud infrastructure provisioning
- ✅ Multi-cloud deployments
- ✅ Production environments
- ❌ Application orchestration
- ❌ Local development

**Ansible:**

- ✅ Server configuration
- ✅ Application deployment
- ✅ Legacy systems
- ❌ Cloud resource provisioning
- ❌ Container orchestration

**Kubernetes:**

- ✅ Production container orchestration
- ✅ Auto-scaling needs
- ✅ Large deployments (100+ containers)
- ❌ Local development (too complex)
- ❌ Small projects

## Real-World Combination

Most organizations use multiple tools:

```
Terraform → Provision cloud infrastructure (VMs, networks, databases)
     ↓
Ansible → Configure servers and install software
     ↓
Docker → Package applications
     ↓
Kubernetes → Orchestrate containers in production
     ↓
Helm → Package Kubernetes applications
```

**Example workflow:**

1. Terraform creates AWS EC2 instances
2. Ansible configures servers and installs Docker
3. Docker Compose defines application locally
4. Kubernetes runs containers in production
5. Helm manages Kubernetes deployments

## Common Misconceptions

**"Docker Compose vs. Terraform - which is better?"**

- Not comparable - different purposes
- Compose: Application orchestration
- Terraform: Infrastructure provisioning

**"Should I use Docker Compose or Kubernetes?"**

- Compose: Local dev, small deployments
- Kubernetes: Production scale, enterprise

**"Can Docker Compose replace Terraform?"**

- No - Docker Compose doesn't provision cloud resources
- Yes - For local development, Compose is sufficient

**"Ansible vs. Docker?"**

- Different tools: Ansible configures, Docker packages
- Often used together (Ansible deploys Docker containers)

## Key Takeaways

1. **Docker Compose is perfect for learning** - Start here
2. **Different tools, different purposes** - Not interchangeable
3. **Concepts transfer** - Declarative config applies everywhere
4. **Progressive learning** - Master one, then expand
5. **Real projects use multiple tools** - Each has its place

## The Bigger Picture

```
Infrastructure Layer (Terraform)
        ↓
    Servers/VMs
        ↓
Configuration Layer (Ansible)
        ↓
Container Runtime (Docker)
        ↓
Application Layer (Docker Compose or Kubernetes)
        ↓
    Your Application
```

**This module focuses on:** Application Layer (Docker Compose)

**Future modules might cover:** Other layers (Terraform, Kubernetes)

---

**Next Steps:**

- Master Docker Compose in this module
- Understand IaC principles
- Later, explore Terraform for cloud infrastructure
- Eventually, learn Kubernetes for production orchestration
- Remember: Each tool builds on concepts from this module
