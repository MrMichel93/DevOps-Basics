# Windows Setup Guide

## 🪟 Prerequisites

- Windows 10 version 2004 or higher (Build 19041+) or Windows 11
- Administrator access
- Stable internet connection

## 📋 Setup Steps

### Step 1: Enable WSL2 (Windows Subsystem for Linux)

WSL2 is required for Docker Desktop and provides a better development experience.

1. **Open PowerShell as Administrator**
   - Press `Win + X`
   - Select "Windows PowerShell (Admin)" or "Terminal (Admin)"

2. **Enable WSL and Virtual Machine Platform**

   ```powershell
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```

3. **Restart your computer**

4. **Set WSL2 as default version**

   ```powershell
   wsl --set-default-version 2
   ```

5. **Install Ubuntu from Microsoft Store**
   - Open Microsoft Store
   - Search for "Ubuntu 22.04 LTS"
   - Click "Get" to install
   - Launch Ubuntu and create a username/password

**Verify WSL2 is working:**

```powershell
wsl --list --verbose
# Should show Ubuntu with VERSION 2
```

### Step 2: Install Git

1. **Download Git for Windows**
   - Visit: <https://git-scm.com/download/win>
   - Download the 64-bit installer

2. **Run the installer**
   - Use default options except:
     - **Default editor**: Choose VS Code (if you'll install it)
     - **PATH environment**: Select "Git from the command line and also from 3rd-party software"
     - **Line ending conversions**: Choose "Checkout Windows-style, commit Unix-style line endings"

3. **Configure Git**

   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   git config --global core.autocrlf true
   ```

4. **Verify installation**

   ```bash
   git --version
   # Should output: git version 2.x.x
   ```

### Step 3: Install Docker Desktop

1. **Download Docker Desktop for Windows**
   - Visit: <https://www.docker.com/products/docker-desktop>
   - Click "Download for Windows"

2. **Run the installer**
   - Ensure "Use WSL 2 instead of Hyper-V" is selected
   - Complete installation and restart if prompted

3. **Start Docker Desktop**
   - Open Docker Desktop from Start menu
   - Wait for it to fully start (whale icon in system tray)
   - Accept the Service Agreement

4. **Configure Docker to use WSL2**
   - Open Docker Desktop Settings
   - Go to "Resources" → "WSL Integration"
   - Enable integration with your Ubuntu distribution

5. **Verify installation**

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

1. **Download VS Code**
   - Visit: <https://code.visualstudio.com/>
   - Click "Download for Windows"

2. **Run the installer**
   - Accept default options
   - Important: Check "Add to PATH"

3. **Install WSL Extension**
   - Open VS Code
   - Press `Ctrl+Shift+X`
   - Search for "WSL"
   - Install "Remote - WSL" by Microsoft

4. **Verify installation**

   ```bash
   code --version
   ```

### Step 5: Install Windows Terminal (Recommended)

1. **Install from Microsoft Store**
   - Open Microsoft Store
   - Search for "Windows Terminal"
   - Click "Get"

2. **Or use winget (if available)**

   ```powershell
   winget install Microsoft.WindowsTerminal
   ```

3. **Configure Windows Terminal**
   - Open Windows Terminal
   - Press `Ctrl+,` for settings
   - Set Ubuntu as default profile (optional)
   - Customize appearance (optional)

### Step 6: Choose Your Development Environment

You have two options for where to work:

#### Option A: PowerShell/CMD (Windows-native)

- Use PowerShell or Command Prompt
- Files stored in Windows filesystem (C:\Users\YourName\)
- Good for: Windows-specific development

#### Option B: WSL Ubuntu (Recommended for DevOps)

- Use Ubuntu terminal via WSL
- Files stored in Linux filesystem
- Better performance with Docker
- More similar to production environments

**To open VS Code in WSL:**

```bash
# From Ubuntu terminal
cd ~
mkdir projects
cd projects
code .
```

## ✅ Verification Checklist

Run these commands in PowerShell or Ubuntu terminal:

```bash
# Git check
git --version

# Docker check
docker --version
docker run hello-world

# VS Code check
code --version

# WSL check (PowerShell)
wsl --list --verbose
```

## 🎨 Recommended Configuration

### Git Config for Windows

```bash
# Better handling of line endings
git config --global core.autocrlf true

# Use VS Code as default editor
git config --global core.editor "code --wait"

# Better diff tool
git config --global diff.tool vscode
git config --global difftool.vscode.cmd "code --wait --diff $LOCAL $REMOTE"
```

### Useful PowerShell Aliases

Add to your PowerShell profile (`$PROFILE`):

```powershell
# Create profile if it doesn't exist
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

# Edit profile
notepad $PROFILE

# Add these aliases:
function docker-clean { docker system prune -af }
function git-status { git status -sb }
Set-Alias -Name gs -Value git-status
Set-Alias -Name dc -Value docker-clean
```

### WSL Performance Optimization

Add to `~/.bashrc` in Ubuntu:

```bash
# Add to end of file
alias dc='docker compose'
alias dps='docker ps'
alias dcup='docker compose up -d'
alias dcdown='docker compose down'

# Better directory listing
alias ll='ls -la'
alias la='ls -A'
```

## 🐛 Common Windows Issues

### Issue: "WSL 2 requires an update to its kernel component"

**Solution:**

1. Download the WSL2 kernel update: <https://aka.ms/wsl2kernel>
2. Install the update
3. Restart Docker Desktop

### Issue: Docker Desktop won't start

**Solutions:**

1. Ensure virtualization is enabled in BIOS
2. Check Windows Features:

   ```powershell
   # Run as Administrator
   Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
   Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
   ```

3. Both should show "State: Enabled"

### Issue: Slow Docker performance

**Solutions:**

- Store project files in WSL filesystem (not `/mnt/c/`)
- Increase resources in Docker Desktop settings
- Disable antivirus scanning of WSL filesystem

### Issue: "Permission denied" when accessing Docker from WSL

**Solution:**

```bash
# Ensure Docker Desktop has WSL integration enabled
# Settings → Resources → WSL Integration → Enable for Ubuntu
```

### Issue: Git showing all files as modified (line endings)

**Solution:**

```bash
git config --global core.autocrlf true
git rm --cached -r .
git reset --hard
```

## 🚀 Next Steps

1. ✅ Verify all tools are working
2. 📝 Complete the [main setup verification](./README.md#verification-checklist)
3. 🎓 Proceed to [Module 01: Git and GitHub](../01-Git-and-GitHub/)

## 📚 Additional Resources

- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Docker Desktop for Windows](https://docs.docker.com/desktop/windows/)
- [VS Code on Windows](https://code.visualstudio.com/docs/setup/windows)
- [Windows Terminal Documentation](https://docs.microsoft.com/en-us/windows/terminal/)

## 💡 Pro Tips

1. **Use Windows Terminal** - Much better than CMD or old PowerShell
2. **Work in WSL** - Better Docker performance and more Linux-like experience
3. **Install VS Code WSL Extension** - Edit files in WSL seamlessly from VS Code
4. **Use Tab completion** - Press Tab to autocomplete commands and paths
5. **Pin Docker Desktop** - Keep it easily accessible in your taskbar
