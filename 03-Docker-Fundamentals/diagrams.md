# Module 03: Docker Fundamentals - Diagrams

This document contains visual diagrams to help understand Docker architecture, containerization, and related concepts.

## 1. Docker Architecture

This diagram shows the core components of Docker and how they interact:

```text
┌─────────────────────────────────────────────────────────────┐
│                       Docker Host                           │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │              Docker Daemon (dockerd)                  │ │
│  │                                                       │ │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │ │
│  │  │   Images    │  │  Containers │  │   Networks  │  │ │
│  │  │ Management  │  │ Management  │  │ Management  │  │ │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │ │
│  └───────────────────────────────────────────────────────┘ │
│                          ▲                                  │
│                          │                                  │
│  ┌───────────────────────┴───────────────────────────────┐ │
│  │              Docker CLI (docker command)              │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │               Running Containers                    │   │
│  │                                                     │   │
│  │  ┌─────────────┐      ┌─────────────┐             │   │
│  │  │ Container 1 │      │ Container 2 │             │   │
│  │  │             │      │             │             │   │
│  │  │   App 1     │      │   App 2     │             │   │
│  │  │   Libs      │      │   Libs      │             │   │
│  │  └─────────────┘      └─────────────┘             │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                  Image Storage                      │   │
│  │                                                     │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐         │   │
│  │  │  Image   │  │  Image   │  │  Image   │         │   │
│  │  │  Layer1  │  │  Layer2  │  │  Layer3  │         │   │
│  │  └──────────┘  └──────────┘  └──────────┘         │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                          ▲
                          │
                          │ docker pull/push
                          │
                   ┌──────▼──────┐
                   │   Docker    │
                   │  Registry   │
                   │ (Docker Hub)│
                   └─────────────┘
```

**Components Explained:**

- **Docker CLI**: Command-line tool for interacting with Docker
- **Docker Daemon**: Background service managing containers, images, and networks
- **Containers**: Isolated runtime environments for applications
- **Images**: Read-only templates for creating containers
- **Registry**: Repository for storing and distributing images (e.g., Docker Hub)

## 2. Container vs VM

Side-by-side comparison of containers and virtual machines:

```text
┌───────────────────────────┐  ┌───────────────────────────┐
│      CONTAINERS           │  │    VIRTUAL MACHINES       │
├───────────────────────────┤  ├───────────────────────────┤
│                           │  │                           │
│  ┌─────┐  ┌─────┐  ┌─────┐│  │  ┌─────┐  ┌─────┐  ┌─────┐│
│  │App A│  │App B│  │App C││  │  │App A│  │App B│  │App C││
│  ├─────┤  ├─────┤  ├─────┤│  │  ├─────┤  ├─────┤  ├─────┤│
│  │Libs │  │Libs │  │Libs ││  │  │Libs │  │Libs │  │Libs ││
│  └──┬──┘  └──┬──┘  └──┬──┘│  │  ├─────┤  ├─────┤  ├─────┤│
│     └────────┴────────┘   │  │  │Guest│  │Guest│  │Guest││
│                           │  │  │ OS  │  │ OS  │  │ OS  ││
│  ┌───────────────────────┐│  │  └──┬──┘  └──┬──┘  └──┬──┘│
│  │   Docker Engine       ││  │     └────────┴────────┘   │
│  └───────────────────────┘│  │                           │
│                           │  │  ┌───────────────────────┐│
│  ┌───────────────────────┐│  │  │    Hypervisor         ││
│  │     Host OS           ││  │  └───────────────────────┘│
│  └───────────────────────┘│  │                           │
│                           │  │  ┌───────────────────────┐│
│  ┌───────────────────────┐│  │  │     Host OS           ││
│  │    Infrastructure     ││  │  └───────────────────────┘│
│  └───────────────────────┘│  │                           │
│                           │  │  ┌───────────────────────┐│
└───────────────────────────┘  │  │    Infrastructure     ││
                               │  └───────────────────────┘│
                               └───────────────────────────┘
```

**Key Differences:**

| Aspect | Containers | Virtual Machines |
| ------ | ---------- | ---------------- |
| **Size** | Lightweight (MBs) | Heavy (GBs) |
| **Startup** | Seconds | Minutes |
| **OS** | Share host OS kernel | Each has full OS |
| **Isolation** | Process-level | Hardware-level |
| **Resource** | More efficient | More overhead |
| **Portability** | Highly portable | Less portable |

## 3. Dockerfile Build Process

This diagram shows how each Dockerfile instruction creates a layer:

```text
Dockerfile                      Image Layers                 Final Image

FROM ubuntu:20.04     ────────> ┌──────────────────┐
                                │ Ubuntu Base      │
                                │ Layer            │
                                └────────┬─────────┘
                                         │
RUN apt-get update    ────────>          │
                                ┌────────▼─────────┐
                                │ Package Updates  │
                                │ Layer            │
                                └────────┬─────────┘
                                         │
RUN apt-get install   ────────>          │
    python3                     ┌────────▼─────────┐
                                │ Python Install   │
                                │ Layer            │
                                └────────┬─────────┘
                                         │
COPY app.py /app/     ────────>          │
                                ┌────────▼─────────┐
                                │ Application Code │
                                │ Layer            │
                                └────────┬─────────┘
                                         │
WORKDIR /app          ────────>          │
                                ┌────────▼─────────┐
                                │ Working Dir      │
                                │ Layer            │
                                └────────┬─────────┘
                                         │
CMD ["python3",       ────────>          │
     "app.py"]                  ┌────────▼─────────┐
                                │ Container Config │
                                │ (not a layer)    │
                                └────────┬─────────┘
                                         │
                                         ▼
                                ┌──────────────────┐
                                │  Final Image     │
                                │  with all layers │
                                └──────────────────┘
```

**Layer Caching:**

- Each instruction creates a new layer
- Layers are cached and reused if unchanged
- Order matters: put frequently changing instructions last
- Combine commands with `&&` to reduce layers

**Optimization Tips:**

1. Use specific base image tags (not `latest`)
2. Combine RUN commands to reduce layers
3. Copy dependency files first (leverage cache)
4. Use `.dockerignore` to exclude unnecessary files

## 4. Docker Networking Modes

This diagram shows different network configurations:

```text
┌────────────────────────────────────────────────────────────┐
│                    BRIDGE NETWORK (Default)                │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Host: 172.17.0.1                                          │
│                                                            │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐│
│  │ Container A  │    │ Container B  │    │ Container C  ││
│  │ 172.17.0.2   │◄──►│ 172.17.0.3   │◄──►│ 172.17.0.4   ││
│  └──────────────┘    └──────────────┘    └──────────────┘│
│         │                   │                    │        │
│         └───────────────────┴────────────────────┘        │
│                             │                             │
│                      ┌──────▼──────┐                      │
│                      │Docker Bridge│                      │
│                      └──────┬──────┘                      │
└─────────────────────────────┼─────────────────────────────┘
                              │
                        ┌─────▼──────┐
                        │    NAT     │
                        └─────┬──────┘
                              │
                        External Network


┌────────────────────────────────────────────────────────────┐
│                      HOST NETWORK                          │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌──────────────────────────────────────┐                 │
│  │         Container                    │                 │
│  │  (shares host network namespace)     │                 │
│  │                                      │                 │
│  │  Uses host's IP directly             │                 │
│  │  No network isolation                │                 │
│  └──────────────────────────────────────┘                 │
└────────────────────────────────────────────────────────────┘


┌────────────────────────────────────────────────────────────┐
│                      OVERLAY NETWORK                       │
│                  (Multi-host networking)                   │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Host 1                          Host 2                    │
│  ┌──────────────┐                ┌──────────────┐         │
│  │ Container A  │◄──────────────►│ Container B  │         │
│  └──────────────┘    Overlay     └──────────────┘         │
│                      Network                               │
└────────────────────────────────────────────────────────────┘


┌────────────────────────────────────────────────────────────┐
│                      NONE NETWORK                          │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌──────────────────────────────────────┐                 │
│  │         Container                    │                 │
│  │    (completely isolated)             │                 │
│  │    No network access                 │                 │
│  └──────────────────────────────────────┘                 │
└────────────────────────────────────────────────────────────┘
```

**Network Modes:**

1. **Bridge** (default): Containers communicate through virtual bridge
2. **Host**: Container uses host's network directly (no isolation)
3. **Overlay**: Multi-host networking for Docker Swarm
4. **None**: No network access (completely isolated)

**Commands:**

- `docker network ls` - List networks
- `docker network create my-network` - Create custom network
- `docker run --network=host` - Use host network
- `docker network connect my-network container1` - Connect container to network

## 5. Docker Compose Multi-Container Setup

This diagram shows how services relate in a Docker Compose stack:

```text
┌─────────────────────────────────────────────────────────────┐
│              Docker Compose Application                     │
└─────────────────────────────────────────────────────────────┘

         docker-compose.yml
                │
    ┌───────────┼───────────┬────────────┐
    │           │           │            │
    ▼           ▼           ▼            ▼
┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐
│  nginx  │ │   app   │ │   api   │ │database │
│ (web)   │ │(service1)│ │(service2)│ │(postgres)│
│         │ │         │ │         │ │         │
│ Port:   │ │ Port:   │ │ Port:   │ │ Port:   │
│  80     │ │  3000   │ │  8000   │ │  5432   │
└────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘
     │           │           │           │
     │  HTTP     │  HTTP     │  SQL      │
     └───────────┼───────────┼───────────┘
                 │           │
            ┌────▼───────────▼────┐
            │   app-network       │
            │  (Bridge Network)   │
            └─────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                        Volumes                              │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  app-data    │  │  db-data     │  │  logs        │      │
│  │  (persistent)│  │  (persistent)│  │  (persistent)│      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

**Example docker-compose.yml structure:**

```yaml
version: '3.8'
services:
  web:
    - Depends on: app
    - Exposes: port 80
  app:
    - Depends on: api, database
    - Exposes: port 3000
  api:
    - Depends on: database
    - Exposes: port 8000
  database:
    - Persistent storage
    - Exposes: port 5432
```

**Service Communication:**

- Services communicate using service names as hostnames
- All services on same network by default
- Volumes persist data across container restarts
- Environment variables configure services

**Commands:**

- `docker-compose up` - Start all services
- `docker-compose down` - Stop and remove all services
- `docker-compose ps` - List running services
- `docker-compose logs -f service-name` - View logs
- `docker-compose exec service-name bash` - Access container shell
