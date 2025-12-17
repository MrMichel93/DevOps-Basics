# Module 00: Setup Your DevOps Environment

## 🎯 Learning Objectives

By the end of this module, you will have:

- ✅ Git installed and configured
- ✅ Docker Desktop running on your machine
- ✅ VS Code set up with useful extensions
- ✅ A properly configured terminal
- ✅ Verified all tools work correctly

**Time Required**: 30-60 minutes

## 📚 Why This Matters

Having the right tools properly configured is essential for a smooth learning experience. These tools are industry-standard and you'll use them throughout your career:

- **Git**: The de-facto standard for version control (used by 99% of professional teams)
- **Docker**: Run applications consistently across any environment
- **VS Code**: Free, powerful, and the most popular code editor
- **Terminal**: DevOps engineers spend significant time in the command line

## 🖥️ System Requirements

**Minimum Requirements:**

- **OS**: Windows 10/11, macOS 10.15+, or modern Linux distribution
- **RAM**: 8GB (16GB recommended for Docker)
- **Disk**: 20GB free space
- **CPU**: 64-bit processor with virtualization support

**Check Your System:**

```bash
# On macOS/Linux
uname -m  # Should show x86_64 or arm64

# On Windows (PowerShell)
systeminfo | findstr /C:"System Type"  # Should show x64-based PC
```

## 🚀 Quick Setup Guide

Choose your operating system and follow the detailed guide:

### 📘 [Windows Setup Guide](./windows-setup.md)

Complete setup instructions for Windows 10/11 including WSL2 configuration.

### 📗 [macOS Setup Guide](./mac-setup.md)

Setup guide for Intel and Apple Silicon Macs.

### 📕 [Linux Setup Guide](./linux-setup.md)

Instructions for Ubuntu, Debian, Fedora, and other distributions.

## 🔧 What You'll Install

### 1. Git (Version Control)

Git tracks changes to your code and enables collaboration with others.

**What it does**:

- Saves snapshots of your code (commits)
- Lets you work on features without breaking the main code (branches)
- Enables team collaboration (merge, pull requests)

**Why it matters**: Every professional software team uses Git. It's not optional.

### 2. Docker Desktop (Containerization)

Docker packages applications with all their dependencies so they run identically everywhere.

**What it does**:

- Eliminates "works on my machine" problems
- Provides isolated environments for applications
- Makes it easy to run databases, services, and tools locally

**Why it matters**: Containers are the foundation of modern application deployment.

### 3. VS Code (Code Editor)

A free, extensible code editor with excellent Git and Docker integration.

**What it does**:

- Edit code with syntax highlighting and autocompletion
- Integrated terminal for running commands
- Extensions for any language or framework

**Why it matters**: Industry-standard editor with great DevOps tooling support.

### 4. Terminal Configuration

A well-configured terminal makes command-line work enjoyable.

**What we'll set up**:

- Readable color scheme
- Useful aliases and shortcuts
- Proper PATH configuration

**Why it matters**: You'll spend a lot of time in the terminal. Make it pleasant!

## ✅ Verification Checklist

After following your OS-specific guide, verify everything works:

### Git Verification

```bash
git --version
# Expected: git version 2.30.0 or higher

git config --global user.name
git config --global user.email
# Expected: Your name and email
```

### Docker Verification

```bash
docker --version
# Expected: Docker version 20.10.0 or higher

docker run hello-world
# Expected: "Hello from Docker!" message
```

### VS Code Verification

```bash
code --version
# Expected: Version number displayed

code .
# Expected: VS Code opens in current directory
```

### Terminal Verification

```bash
# Can you see colors in output?
ls --color=auto  # Linux/macOS
ls  # Windows (PowerShell)

# Can you copy/paste easily?
echo "test" | pbcopy  # macOS
echo "test" | clip.exe  # Windows
echo "test" | xclip -selection clipboard  # Linux (may need to install xclip)
```

## 🛠️ Recommended VS Code Extensions

Install these extensions for the best DevOps experience:

### Essential Extensions

```
1. Docker (ms-azuretools.vscode-docker)
   - Manage containers, images, and Dockerfiles

2. GitLens (eamodio.gitlens)
   - Supercharge Git capabilities

3. YAML (redhat.vscode-yaml)
   - For Docker Compose and GitHub Actions files

4. Remote - Containers (ms-vscode-remote.remote-containers)
   - Develop inside containers

5. Markdown All in One (yzhang.markdown-all-in-one)
   - Edit documentation
```

### Install from VS Code

1. Press `Ctrl+Shift+X` (Windows/Linux) or `Cmd+Shift+X` (macOS)
2. Search for extension name
3. Click "Install"

Or use the command line:

```bash
code --install-extension ms-azuretools.vscode-docker
code --install-extension eamodio.gitlens
code --install-extension redhat.vscode-yaml
code --install-extension ms-vscode-remote.remote-containers
code --install-extension yzhang.markdown-all-in-one
```

## 🎨 Terminal Customization (Optional but Recommended)

### For macOS/Linux: Oh My Zsh

```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Adds useful aliases and themes to your terminal
```

### For Windows: Windows Terminal

```powershell
# Install from Microsoft Store (free)
# Search for "Windows Terminal"

# Or via winget:
winget install Microsoft.WindowsTerminal
```

## 🐛 Common Issues and Solutions

### Issue: "Docker daemon not running"

**Solution**: Start Docker Desktop application. Wait for it to fully start (whale icon in system tray should be steady, not animated).

### Issue: "git: command not found"

**Solution**:

- Windows: Reinstall Git and ensure "Git from command line" option is selected
- macOS: Install Xcode Command Line Tools: `xcode-select --install`
- Linux: Install git package: `sudo apt install git` or `sudo yum install git`

### Issue: "Permission denied" when running Docker

**Solution**:

- Windows/macOS: Ensure Docker Desktop is running
- Linux: Add user to docker group: `sudo usermod -aG docker $USER`, then log out and back in

### Issue: VS Code "code" command not working

**Solution**:

- Open VS Code
- Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux)
- Type "shell command" and select "Install 'code' command in PATH"

## 📖 Next Steps

Once everything is installed and verified:

1. ✅ Complete the verification checklist above
2. 📝 Create a test Git repository
3. 🐳 Run your first Docker container
4. 💻 Open a project in VS Code

**Ready?** Proceed to [Module 01: Git and GitHub](../01-Git-and-GitHub/) to start learning version control!

## 🤔 Need Help?

- **Docker Issues**: [Docker Desktop Documentation](https://docs.docker.com/desktop/)
- **Git Issues**: [Git Book](https://git-scm.com/book/en/v2)
- **VS Code Issues**: [VS Code Documentation](https://code.visualstudio.com/docs)

Remember: Every professional developer has wrestled with setup issues. Don't give up! The initial setup is the hardest part.
