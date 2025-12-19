# Module 00: Setup - Diagrams

This document contains visual diagrams to help understand the setup process and development environment architecture.

## 1. Development Environment Architecture

This diagram shows the key tools on your computer and how they connect to GitHub:

```text
┌─────────────────────────────────────────┐
│          Your Computer                  │
│  ┌──────────┐ ┌──────────┐ ┌────────┐  │
│  │ Terminal │ │ VS Code  │ │ Docker │  │
│  └────┬─────┘ └────┬─────┘ └───┬────┘  │
│       │            │            │       │
│       └────────────┴────────────┘       │
│                    │                    │
└────────────────────┼────────────────────┘
                     │
                ┌────▼────┐
                │ GitHub  │
                └─────────┘
```

**Components:**

- **Terminal**: Command-line interface for running Git commands and scripts
- **VS Code**: Integrated development environment for writing and editing code
- **Docker**: Platform for running containerized applications
- **GitHub**: Remote repository hosting service for version control and collaboration

## 2. Setup Verification Flowchart

This flowchart helps you verify that all required tools are properly installed:

```text
                    ┌─────────┐
                    │  Start  │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │  Git    │
                    │Installed?│
                    └────┬────┘
                         │
                    ┌────┴────┐
                    │         │
               ┌────▼───┐ ┌───▼────┐
               │  Yes   │ │   No   │
               └────┬───┘ └───┬────┘
                    │         │
                    │    ┌────▼─────┐
                    │    │ Install  │
                    │    │   Git    │
                    │    └────┬─────┘
                    │         │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │ Docker  │
                    │Installed?│
                    └────┬────┘
                         │
                    ┌────┴────┐
                    │         │
               ┌────▼───┐ ┌───▼────┐
               │  Yes   │ │   No   │
               └────┬───┘ └───┬────┘
                    │         │
                    │    ┌────▼─────┐
                    │    │ Install  │
                    │    │  Docker  │
                    │    └────┬─────┘
                    │         │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │ VS Code │
                    │Installed?│
                    └────┬────┘
                         │
                    ┌────┴────┐
                    │         │
               ┌────▼───┐ ┌───▼────┐
               │  Yes   │ │   No   │
               └────┬───┘ └───┬────┘
                    │         │
                    │    ┌────▼─────┐
                    │    │ Install  │
                    │    │ VS Code  │
                    │    └────┬─────┘
                    │         │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │  Test   │
                    │Commands │
                    └────┬────┘
                         │
                    ┌────┴────┐
                    │         │
               ┌────▼───┐ ┌───▼────┐
               │  All   │ │  Some  │
               │  Pass  │ │  Fail  │
               └────┬───┘ └───┬────┘
                    │         │
                    │    ┌────▼─────┐
                    │    │Troubleshoot│
                    │    └────┬─────┘
                    │         │
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │  Ready  │
                    │   to    │
                    │  Code!  │
                    └─────────┘
```

**Verification Commands:**

- `git --version` - Check Git installation
- `docker --version` - Check Docker installation
- `code --version` - Check VS Code installation

**Next Steps:**

Once all tools are verified, you're ready to proceed to Module 01: Git and GitHub!
