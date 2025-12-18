# DevOps Glossary

A comprehensive reference of DevOps terminology.

## A

**Alpine Linux**  
Lightweight Linux distribution often used as a base for Docker images. Security-oriented and minimal.

**API (Application Programming Interface)**  
Set of rules and protocols for building and interacting with software applications.

**Artifact**  
Output of a build process (compiled code, Docker image, package, etc.).

**Automated Testing**  
Running tests automatically as part of CI/CD pipeline.

## B

**Base Image**  
Starting point for building Docker images. Defined with `FROM` in Dockerfile.

**Bash**  
Unix shell and command language for scripting automation tasks.

**Blue-Green Deployment**  
Deployment strategy with two identical environments (blue and green). Traffic switches between them for zero-downtime deployments.

**Branch**  
Independent line of development in version control.

**Build**  
Process of converting source code into executable artifacts.

## C

**CI/CD (Continuous Integration/Continuous Delivery)**  
Practice of automating integration, testing, and delivery of software.

**CLI (Command Line Interface)**  
Text-based interface for interacting with software.

**Clone**  
Creating a local copy of a remote Git repository.

**Commit**  
Snapshot of changes in version control.

**Container**  
Lightweight, standalone, executable package of software.

**Container Image**  
Template for creating containers. Immutable blueprint.

**Container Orchestration**  
Managing lifecycles of containers (deployment, scaling, networking). Tools: Kubernetes, Docker Swarm.

**Container Registry**  
Repository for storing and distributing container images (Docker Hub, GitHub Container Registry).

## D

**Deployment**  
Process of making software available for use.

**DevOps**  
Culture and practices combining software development and IT operations.

**DevSecOps**  
Integration of security practices into DevOps workflow.

**Docker**  
Platform for building, shipping, and running containers.

**Docker Compose**  
Tool for defining and running multi-container Docker applications.

**Dockerfile**  
Text file with instructions for building Docker images.

**Docker Hub**  
Public registry for Docker images.

## E

**Environment Variables**  
Configuration values stored outside code. Used for different deployment environments.

**Ephemeral**  
Short-lived, temporary. Containers are ephemeral by design.

## F

**Fork**  
Personal copy of another user's repository.

**Git**  
Distributed version control system.

**GitHub Actions**  
CI/CD platform integrated with GitHub.

## H

**Health Check**  
Automated test to verify system/application is functioning correctly.

**Host**  
Physical or virtual machine running containers or VMs.

## I

**IaC (Infrastructure as Code)**  
Managing infrastructure through code and version control.

**Image**  
Read-only template for creating containers.

**Immutable Infrastructure**  
Infrastructure that's replaced rather than modified.

## J

**Job**  
Set of steps in a CI/CD pipeline.

**JSON (JavaScript Object Notation)**  
Lightweight data-interchange format.

## K

**Kubernetes (K8s)**  
Container orchestration platform for automating deployment, scaling, and management.

## L

**Layer**  
Instruction in Dockerfile creates a layer in image. Layers are cached and reused.

**Linting**  
Automated checking of code for errors and style issues.

## M

**Merge**  
Combining changes from different branches.

**Microservices**  
Architectural approach where application is collection of small, independent services.

**Multi-Stage Build**  
Dockerfile with multiple FROM statements to optimize final image size.

## N

**Namespace**  
Isolated environment within a system. Docker uses namespaces for container isolation.

**Network**  
Virtual network allowing containers to communicate.

## O

**Orchestration**  
Automated configuration, management, and coordination of systems.

## P

**Pipeline**  
Automated sequence of steps from code commit to production deployment.

**Pod**  
Smallest deployable unit in Kubernetes. Can contain one or more containers.

**Port Mapping**  
Exposing container port to host system.

**Pull Request (PR)**  
Proposed changes to repository. Enables code review before merging.

**Push**  
Uploading local changes to remote repository.

## R

**Registry**  
Repository for storing and distributing container images or packages.

**Repository (Repo)**  
Storage location for code and version history.

**Rollback**  
Reverting to previous version of software.

**Rolling Update**  
Gradual replacement of application instances with new version.

**Runner**  
Machine that executes CI/CD jobs.

## S

**Secrets Management**  
Secure handling of sensitive data (passwords, API keys, certificates).

**Shell**  
Command-line interpreter (bash, zsh, sh).

**SSH (Secure Shell)**  
Protocol for secure remote access to systems.

**Stage**  
Phase in build or deployment process.

**Stateless**  
Application that doesn't store data between sessions. Each request is independent.

**Stateful**  
Application that maintains state/data between sessions.

## T

**Tag**  
Label for specific version (Git tag) or image version (Docker tag).

**Testing**  

- **Unit Testing:** Testing individual components
- **Integration Testing:** Testing component interactions
- **End-to-End Testing:** Testing complete workflows

**Twelve-Factor App**  
Methodology for building modern, scalable applications.

## V

**Version Control**  
System for tracking changes to code over time.

**Virtual Machine (VM)**  
Emulation of computer system. Heavier than containers.

**Volume**  
Persistent storage for containers. Data survives container restarts.

## W

**Webhook**  
HTTP callback triggered by events. Used to trigger CI/CD pipelines.

**Workflow**  
Automated process defined in CI/CD system.

## Y

**YAML (YAML Ain't Markup Language)**  
Human-readable data serialization format. Used for configuration files (Docker Compose, GitHub Actions, Kubernetes).

## Common Commands Quick Reference

### Git

```bash
git clone, git add, git commit, git push, git pull
git branch, git checkout, git merge
```

### Docker

```bash
docker build, docker run, docker ps, docker stop
docker compose up, docker compose down
```

### Linux

```bash
ls, cd, pwd, mkdir, rm
grep, find, cat, less, tail
ps, top, kill
```

## Acronyms

- **API:** Application Programming Interface
- **CD:** Continuous Delivery/Deployment
- **CI:** Continuous Integration
- **CLI:** Command Line Interface
- **DNS:** Domain Name System
- **IaC:** Infrastructure as Code
- **JSON:** JavaScript Object Notation
- **K8s:** Kubernetes
- **PR:** Pull Request
- **SSH:** Secure Shell
- **VM:** Virtual Machine
- **YAML:** YAML Ain't Markup Language

---

**Note:** This glossary is a living document. Contribute additions via pull request!
