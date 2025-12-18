# macOS Setup Guide

## 🍎 Prerequisites

- macOS 10.15 (Catalina) or higher
- Administrator access
- Stable internet connection
- At least 20GB free disk space

## 📋 Setup Steps

### Step 1: Install Homebrew (Package Manager)

Homebrew makes installing development tools much easier on macOS.

1. **Open Terminal**
   - Press `Cmd + Space`, type "Terminal", press Enter
   - Or find it in Applications → Utilities → Terminal

2. **Install Homebrew**

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **Follow the prompts**
   - Enter your password when asked
   - Press Enter to continue

4. **Add Homebrew to PATH (Apple Silicon Macs only)**
   If you have an M1/M2/M3 Mac, run:

   ```bash
   echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
   eval "$(/opt/homebrew/bin/brew shellenv)"
   ```

5. **Verify installation**

   ```bash
   brew --version
   # Should output: Homebrew 4.x.x
   ```

### Step 2: Install Git

macOS comes with Git, but it's better to install the latest version via Homebrew.

1. **Install Git**

   ```bash
   brew install git
   ```

2. **Configure Git**

   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

3. **Verify installation**

   ```bash
   git --version
   # Should output: git version 2.x.x

   which git
   # Should output: /opt/homebrew/bin/git (Apple Silicon) or /usr/local/bin/git (Intel)
   ```

**Note:** If it shows `/usr/bin/git`, restart your terminal to pick up the Homebrew version.

### Step 3: Install Docker Desktop

1. **Download Docker Desktop for Mac**
   - Visit: <https://www.docker.com/products/docker-desktop>
   - Choose the right version:
     - **Apple Silicon** (M1/M2/M3): "Mac with Apple chip"
     - **Intel**: "Mac with Intel chip"

2. **Install Docker Desktop**
   - Open the downloaded `.dmg` file
   - Drag Docker icon to Applications folder
   - Open Docker from Applications
   - Grant necessary permissions when prompted

3. **Start Docker Desktop**
   - Docker whale icon appears in menu bar
   - Wait for it to show "Docker Desktop is running"
   - May take 1-2 minutes on first start

4. **Configure Docker (optional but recommended)**
   - Click Docker icon in menu bar → Settings
   - **Resources**:
     - CPUs: 4 (or half of your total)
     - Memory: 8GB (or more if available)
     - Swap: 2GB
   - Click "Apply & Restart"

5. **Verify installation**

   ```bash
   docker --version
   # Should output: Docker version 20.x.x or higher

   docker run hello-world
   ```

**Expected output:**

```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

### Step 4: Install VS Code

1. **Install via Homebrew**

   ```bash
   brew install --cask visual-studio-code
   ```

   **Or download manually:**
   - Visit: <https://code.visualstudio.com/>
   - Download for macOS
   - Move to Applications folder

2. **Install 'code' command**
   - Open VS Code
   - Press `Cmd+Shift+P`
   - Type "shell command"
   - Select "Shell Command: Install 'code' command in PATH"

3. **Verify installation**

   ```bash
   code --version
   # Should output version number

   # Test opening VS Code
   code .
   ```

### Step 5: Install Essential Command-Line Tools

1. **Install useful tools**

   ```bash
   # Better file searching
   brew install ripgrep fd

   # Better terminal experience
   brew install tree watch wget curl

   # JSON processor (useful for Docker/API work)
   brew install jq
   ```

2. **Install Oh My Zsh (optional but recommended)**

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

   This adds:
   - Git status in your prompt
   - Useful aliases
   - Better autocompletion

## ✅ Verification Checklist

Run these commands to verify everything works:

```bash
# Homebrew check
brew --version

# Git check
git --version

# Docker check
docker --version
docker run hello-world

# VS Code check
code --version

# Test Docker Compose
docker compose version
```

## 🎨 Recommended Configuration

### Configure Git

```bash
# Set VS Code as default editor
git config --global core.editor "code --wait"

# Better diff viewer
git config --global diff.tool vscode
git config --global difftool.vscode.cmd "code --wait --diff \$LOCAL \$REMOTE"

# Useful aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'
```

### Configure Your Shell (Zsh)

Add to `~/.zshrc`:

```bash
# Open in your editor
code ~/.zshrc

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
alias ll='ls -la'
alias la='ls -A'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'

# Reload shell configuration
alias reload='source ~/.zshrc'

# Show PATH in readable format
alias path='echo $PATH | tr ":" "\n"'
```

After editing, reload:

```bash
source ~/.zshrc
```

### Configure VS Code Settings

Create `~/Library/Application Support/Code/User/settings.json` with recommended settings:

```json
{
    "editor.fontSize": 14,
    "editor.tabSize": 2,
    "editor.insertSpaces": true,
    "editor.formatOnSave": true,
    "files.autoSave": "onFocusChange",
    "terminal.integrated.fontSize": 13,
    "terminal.integrated.fontFamily": "Monaco",
    "git.enableSmartCommit": true,
    "git.confirmSync": false,
    "docker.showStartPage": false
}
```

Or use VS Code UI:

- Press `Cmd+,` to open settings
- Search for each setting and configure

## 🐛 Common macOS Issues

### Issue: "Cannot verify developer" for Docker

**Solution:**

1. Open System Preferences → Security & Privacy
2. Click "Open Anyway" for Docker
3. Restart Docker Desktop

### Issue: Docker daemon not running

**Solutions:**

1. Quit Docker completely (Cmd+Q from menu bar icon)
2. Restart Docker Desktop from Applications
3. If still failing, restart your Mac

### Issue: "Permission denied" when running Docker commands

**Solution:**

```bash
# Check if Docker is running
docker ps

# If error persists, verify Docker Desktop is running and you're logged in
```

### Issue: Homebrew installation fails

**Solutions:**

1. Ensure Xcode Command Line Tools are installed:

   ```bash
   xcode-select --install
   ```

2. Check for macOS updates in System Preferences
3. Try installation again

### Issue: Git still using old version

**Solution:**

```bash
# Close and reopen terminal, then check
which git
# Should NOT be /usr/bin/git

# If it is, add to ~/.zshrc:
export PATH="/opt/homebrew/bin:$PATH"  # Apple Silicon
# or
export PATH="/usr/local/bin:$PATH"     # Intel

# Reload shell
source ~/.zshrc
```

### Issue: VS Code 'code' command not found

**Solution:**

1. Open VS Code
2. `Cmd+Shift+P`
3. "Shell Command: Install 'code' command in PATH"
4. Restart terminal

### Issue: Docker Desktop using too much resources

**Solutions:**

1. Click Docker icon → Settings → Resources
2. Reduce CPU count (e.g., from 8 to 4)
3. Reduce Memory (e.g., from 12GB to 8GB)
4. Apply & Restart

## 🚀 Performance Tips

### 1. Use Docker Desktop Resource Limits

Don't give Docker all your RAM/CPU. Leave resources for other applications.

### 2. Clean Up Regularly

```bash
# Remove unused images, containers, volumes
docker system prune -af

# Remove everything including volumes (careful!)
docker system prune -af --volumes
```

### 3. Enable Buildkit for Faster Builds

Add to `~/.zshrc`:

```bash
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
```

### 4. Use Docker Desktop's Built-in Kubernetes (optional)

For learning Kubernetes later:

- Docker icon → Settings → Kubernetes
- Check "Enable Kubernetes"
- Apply & Restart (will take 5-10 minutes)

## 🌟 Useful macOS-Specific Tips

### 1. Spotlight Search

- `Cmd + Space` to quickly open Terminal or VS Code

### 2. Multiple Desktops

- Create separate desktops for different tasks:
  - Desktop 1: VS Code
  - Desktop 2: Terminal
  - Desktop 3: Browser with docs
- Swipe with 3 fingers or `Ctrl + Left/Right Arrow`

### 3. Rectangle (Window Management)

```bash
brew install --cask rectangle

# Snap windows like in Windows
# Cmd+Option+Left = left half
# Cmd+Option+Right = right half
```

### 4. iTerm2 (Better Terminal)

```bash
brew install --cask iterm2

# More features than default Terminal
# Better customization, split panes, search
```

## 🎓 Next Steps

1. ✅ Verify all tools are working
2. 📝 Complete the [main setup verification](./README.md#verification-checklist)
3. 🐳 Test Docker with a simple example:

   ```bash
   docker run -d -p 8080:80 nginx
   # Open http://localhost:8080 in browser
   # Stop container: docker stop $(docker ps -q)
   ```

4. 🎓 Proceed to [Module 01: Git and GitHub](../01-Git-and-GitHub/)

## 📚 Additional Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [Docker Desktop for Mac](https://docs.docker.com/desktop/mac/)
- [VS Code on macOS](https://code.visualstudio.com/docs/setup/mac)
- [Oh My Zsh](https://ohmyz.sh/)

## 💡 Pro Tips for Mac Users

1. **Learn keyboard shortcuts** - macOS has excellent keyboard navigation
2. **Use Homebrew for everything** - Easy to update all tools: `brew upgrade`
3. **Enable Touch ID for sudo** - Makes terminal work smoother
4. **Use Split View** - Drag VS Code to one side, Terminal/Browser to other
5. **Customize iTerm2** - Themes, profiles, and hotkey window for quick access
