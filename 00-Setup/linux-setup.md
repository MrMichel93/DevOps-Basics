# Linux Setup Guide

## 🐧 Prerequisites

- Modern Linux distribution (Ubuntu 20.04+, Debian 11+, Fedora 35+, etc.)
- Root/sudo access
- Stable internet connection
- At least 20GB free disk space

This guide covers Ubuntu/Debian (apt), Fedora (dnf), and Arch (pacman). Adjust commands for your distribution.

## 📋 Setup Steps

### Step 1: Update Your System

Always start with an updated system:

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt upgrade -y
```

**Fedora:**
```bash
sudo dnf update -y
```

**Arch:**
```bash
sudo pacman -Syu
```

### Step 2: Install Git

**Ubuntu/Debian:**
```bash
sudo apt install -y git
```

**Fedora:**
```bash
sudo dnf install -y git
```

**Arch:**
```bash
sudo pacman -S git
```

**Configure Git:**
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify
git --version
```

### Step 3: Install Docker

#### Ubuntu/Debian

1. **Remove old versions (if any)**
   ```bash
   sudo apt remove docker docker-engine docker.io containerd runc
   ```

2. **Install prerequisites**
   ```bash
   sudo apt update
   sudo apt install -y ca-certificates curl gnupg lsb-release
   ```

3. **Add Docker's official GPG key**
   ```bash
   sudo mkdir -p /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   ```

4. **Set up repository**
   ```bash
   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

5. **Install Docker Engine**
   ```bash
   sudo apt update
   sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
   ```

#### Fedora

```bash
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
```

#### Arch

```bash
sudo pacman -S docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker
```

#### Post-Installation Steps (All Distributions)

1. **Add your user to docker group**
   ```bash
   sudo usermod -aG docker $USER
   ```

2. **Log out and back in** (or run):
   ```bash
   newgrp docker
   ```

3. **Verify installation**
   ```bash
   docker --version
   docker run hello-world
   ```

**Expected output:**
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

### Step 4: Install VS Code

#### Method 1: Official Package (Recommended)

**Ubuntu/Debian:**
```bash
# Import Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

# Add repository
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

# Install
sudo apt update
sudo apt install -y code
```

**Fedora:**
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
sudo dnf check-update
sudo dnf install -y code
```

**Arch:**
```bash
# VS Code is in AUR
yay -S visual-studio-code-bin
# or
paru -S visual-studio-code-bin
```

#### Method 2: Snap (Universal)

```bash
sudo snap install --classic code
```

**Verify:**
```bash
code --version
```

### Step 5: Install Additional Tools

**Ubuntu/Debian:**
```bash
sudo apt install -y \
  curl \
  wget \
  git \
  build-essential \
  tree \
  jq \
  htop \
  net-tools
```

**Fedora:**
```bash
sudo dnf install -y \
  curl \
  wget \
  git \
  @development-tools \
  tree \
  jq \
  htop \
  net-tools
```

**Arch:**
```bash
sudo pacman -S \
  curl \
  wget \
  git \
  base-devel \
  tree \
  jq \
  htop \
  net-tools
```

## ✅ Verification Checklist

```bash
# Git check
git --version

# Docker check
docker --version
docker compose version
docker run hello-world

# VS Code check
code --version

# Check Docker service
sudo systemctl status docker

# Check current user is in docker group
groups | grep docker
```

## 🎨 Recommended Configuration

### Configure Git

```bash
# Set VS Code as default editor
git config --global core.editor "code --wait"

# Better diff viewer
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'

# Useful aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
```

### Configure Your Shell

Add to `~/.bashrc` (or `~/.zshrc` if using Zsh):

```bash
# Open in editor
nano ~/.bashrc

# Add these lines at the end:

# Docker aliases
alias dc='docker compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dclean='docker system prune -af'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Better ls
alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Docker Compose shortcuts
alias dcup='docker compose up -d'
alias dcdown='docker compose down'
alias dclogs='docker compose logs -f'

# Reload bashrc
alias reload='source ~/.bashrc'
```

**Apply changes:**
```bash
source ~/.bashrc
```

### Configure Docker (Optional)

Create Docker daemon configuration:

```bash
sudo mkdir -p /etc/docker

# Create daemon.json
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# Restart Docker
sudo systemctl restart docker
```

### Configure VS Code

Install essential extensions:

```bash
# Docker extension
code --install-extension ms-azuretools.vscode-docker

# GitLens
code --install-extension eamodio.gitlens

# YAML (for Docker Compose and GitHub Actions)
code --install-extension redhat.vscode-yaml

# Remote containers
code --install-extension ms-vscode-remote.remote-containers

# Markdown
code --install-extension yzhang.markdown-all-in-one
```

## 🐛 Common Linux Issues

### Issue: "Permission denied" when running Docker

**Solution:**
```bash
# Ensure you're in docker group
sudo usermod -aG docker $USER

# Log out and back in, then verify
groups | grep docker

# If still not working
sudo chmod 666 /var/run/docker.sock
```

### Issue: Docker daemon won't start

**Solutions:**
```bash
# Check Docker status
sudo systemctl status docker

# Check logs
sudo journalctl -u docker -n 50

# Try restarting
sudo systemctl restart docker

# If failing, check for port conflicts
sudo netstat -tulpn | grep docker
```

### Issue: "Cannot connect to Docker daemon"

**Solution:**
```bash
# Start Docker service
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Check if running
sudo systemctl is-active docker
```

### Issue: VS Code won't start

**Solutions:**
```bash
# If installed via snap, check permissions
snap connections code

# Try running from terminal to see errors
code --verbose

# Reinstall if needed
sudo apt remove code
sudo apt install code
```

### Issue: Git credentials not being saved

**Solution:**
```bash
# Install credential helper
sudo apt install -y libsecret-1-0 libsecret-1-dev  # Ubuntu/Debian
sudo dnf install -y libsecret libsecret-devel      # Fedora

# Configure Git to use it
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret

# Or use cache for temporary storage
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'
```

## 🚀 Performance Tips

### 1. Enable Docker Buildkit
Add to `~/.bashrc`:
```bash
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
```

### 2. Clean Up Regularly
```bash
# Remove unused containers, images, volumes
docker system prune -af

# See disk usage
docker system df
```

### 3. Limit Journal Size
```bash
# Edit journald config
sudo nano /etc/systemd/journald.conf

# Set:
SystemMaxUse=100M

# Restart
sudo systemctl restart systemd-journald
```

### 4. Use Faster DNS
```bash
# Edit resolv.conf
sudo nano /etc/resolv.conf

# Add Google DNS
nameserver 8.8.8.8
nameserver 8.8.4.4
```

## 🌟 Linux-Specific Features

### 1. Oh My Zsh (Better Shell Experience)

```bash
# Install Zsh
sudo apt install zsh  # Ubuntu/Debian
sudo dnf install zsh  # Fedora
sudo pacman -S zsh    # Arch

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set as default shell
chsh -s $(which zsh)
```

### 2. Terminal Multiplexer (tmux)

```bash
# Install
sudo apt install tmux  # Ubuntu/Debian

# Basic usage
tmux                    # Start session
Ctrl+b then %          # Split vertically
Ctrl+b then "          # Split horizontally
Ctrl+b then arrow key  # Navigate panes
Ctrl+b then d          # Detach session
tmux attach            # Reattach to session
```

### 3. File Manager Integrations

**Open Terminal here:**
```bash
# Ubuntu/Debian (Nautilus)
sudo apt install nautilus-extension-gnome-terminal

# KDE (Dolphin) - already has this
```

**Open VS Code here:**
- Right-click in file manager → "Open in VS Code"
- Already works if VS Code is properly installed

### 4. Clipboard Tools

```bash
# Install xclip for clipboard access
sudo apt install xclip

# Copy command output to clipboard
docker ps | xclip -selection clipboard

# Paste from clipboard
xclip -selection clipboard -o
```

## 🎓 Next Steps

1. ✅ Verify all tools are working with the verification checklist above
2. 📝 Complete the [main setup verification](./README.md#verification-checklist)
3. 🐳 Test Docker with a simple example:
   ```bash
   docker run -d -p 8080:80 nginx
   curl http://localhost:8080
   docker stop $(docker ps -q)
   ```
4. 🎓 Proceed to [Module 01: Git and GitHub](../01-Git-and-GitHub/)

## 📚 Additional Resources

- [Docker on Linux](https://docs.docker.com/engine/install/)
- [VS Code on Linux](https://code.visualstudio.com/docs/setup/linux)
- [Git Documentation](https://git-scm.com/book/en/v2)
- [Linux Command Line Basics](https://ubuntu.com/tutorials/command-line-for-beginners)

## 💡 Pro Tips for Linux Users

1. **Use package manager** - Keep everything updated: `sudo apt update && sudo apt upgrade`
2. **Learn systemctl** - Manage services: `systemctl status/start/stop/restart/enable`
3. **Master journalctl** - View logs: `journalctl -u docker -f`
4. **Use aliases** - Save time with custom shortcuts in ~/.bashrc
5. **Explore /var/log** - System logs are your friend for troubleshooting
6. **Use tab completion** - Most shells support it, saves typing
7. **Learn basic troubleshooting** - Check logs, test network, verify permissions
