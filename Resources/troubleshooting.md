# Troubleshooting Guide

Common issues and solutions for DevOps tools and practices.

## 🐳 Docker Issues

### Issue: "Cannot connect to Docker daemon"

**Symptoms:**
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```

**Solutions:**

**1. Docker Desktop not running (Windows/Mac)**
- Open Docker Desktop application
- Wait for whale icon to become steady

**2. Docker service not started (Linux)**
```bash
sudo systemctl start docker
sudo systemctl enable docker  # Start on boot
```

**3. Permission denied (Linux)**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in
newgrp docker

# Verify
docker ps
```

---

### Issue: "Port already in use"

**Symptoms:**
```
Error: bind: address already in use
```

**Solutions:**

**1. Find what's using the port**
```bash
# Linux/Mac
lsof -i :8080

# Windows
netstat -ano | findstr :8080
```

**2. Stop the conflicting container**
```bash
docker ps
docker stop <container-id>
```

**3. Use a different port**
```bash
docker run -p 8081:80 nginx
```

---

### Issue: Docker build is very slow

**Solutions:**

**1. Use .dockerignore**
```
# .dockerignore
node_modules
.git
*.log
.env
```

**2. Order Dockerfile efficiently**
```dockerfile
# ✅ Good - static first
COPY package*.json ./
RUN npm install
COPY . .

# ❌ Bad - forces reinstall
COPY . .
RUN npm install
```

**3. Use BuildKit**
```bash
export DOCKER_BUILDKIT=1
docker build -t myapp .
```

---

### Issue: Container exits immediately

**Symptoms:**
Container appears in `docker ps -a` with status "Exited (0)"

**Solutions:**

**1. Check logs**
```bash
docker logs container-name
```

**2. Run interactively to debug**
```bash
docker run -it myapp sh
```

**3. Add proper CMD/ENTRYPOINT**
```dockerfile
# Make sure container has a long-running process
CMD ["node", "server.js"]
```

---

### Issue: "No space left on device"

**Solutions:**

**1. Clean up Docker resources**
```bash
docker system prune -a
docker volume prune
```

**2. Check disk usage**
```bash
docker system df
df -h  # System disk usage
```

**3. Increase Docker disk space (Docker Desktop)**
- Settings → Resources → Disk image size

## 🐙 Git/GitHub Issues

### Issue: "Permission denied (publickey)"

**Symptoms:**
```
Permission denied (publickey).
fatal: Could not read from remote repository.
```

**Solutions:**

**1. Use HTTPS instead of SSH**
```bash
git remote set-url origin https://github.com/user/repo.git
```

**2. Set up SSH keys**
```bash
# Generate key
ssh-keygen -t ed25519 -C "your@email.com"

# Add to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub

# Add to GitHub: Settings → SSH Keys
```

**3. Test SSH connection**
```bash
ssh -T git@github.com
```

---

### Issue: Merge conflicts

**Symptoms:**
```
CONFLICT (content): Merge conflict in file.txt
```

**Solutions:**

**1. View conflicted files**
```bash
git status
```

**2. Open file and resolve**
```
<<<<<<< HEAD
Your changes
=======
Their changes
>>>>>>> branch-name
```

**3. Mark as resolved**
```bash
git add file.txt
git commit
```

**4. Abort merge if needed**
```bash
git merge --abort
```

---

### Issue: Accidentally committed sensitive data

**Solutions:**

**1. Remove from last commit (not pushed)**
```bash
git rm --cached secret.txt
echo "secret.txt" >> .gitignore
git commit --amend --no-edit
```

**2. Remove from history (if pushed)**
```bash
# Use BFG Repo Cleaner
brew install bfg
bfg --delete-files secret.txt
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git push --force
```

**3. Rotate compromised secrets**
- Change passwords/API keys immediately
- Update in all environments

## 🔄 GitHub Actions Issues

### Issue: Workflow not triggering

**Solutions:**

**1. Check workflow file location**
```
Must be in: .github/workflows/name.yml
```

**2. Check syntax**
```bash
# Use VS Code YAML extension
# Or validate online: yamllint.com
```

**3. Check trigger configuration**
```yaml
on:
  push:
    branches: [ main ]  # Only triggers on main
```

**4. Check if Actions are enabled**
- Repository Settings → Actions → Allow actions

---

### Issue: Job failing with permissions error

**Solutions:**

**1. Add necessary permissions**
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
```

**2. Use GitHub token**
```yaml
- name: Checkout
  uses: actions/checkout@v4
  with:
    token: ${{ secrets.GITHUB_TOKEN }}
```

---

### Issue: Secret not available in workflow

**Solutions:**

**1. Verify secret is set**
- Repository Settings → Secrets → Actions

**2. Use correct syntax**
```yaml
env:
  API_KEY: ${{ secrets.API_KEY }}  # ✅ Correct
  API_KEY: $secrets.API_KEY        # ❌ Wrong
```

**3. Check scope (repo vs environment)**
- Environment secrets only available in environment jobs

## 🖥️ Command Line Issues

### Issue: "Command not found"

**Solutions:**

**1. Check if installed**
```bash
which command-name
```

**2. Install if missing**
```bash
# Ubuntu/Debian
sudo apt install package-name

# macOS
brew install package-name
```

**3. Check PATH**
```bash
echo $PATH
# Add to PATH if needed
export PATH=$PATH:/new/path
```

---

### Issue: Permission denied

**Solutions:**

**1. Check file permissions**
```bash
ls -la file.txt
```

**2. Make executable**
```bash
chmod +x script.sh
```

**3. Use sudo if needed**
```bash
sudo command
```

---

### Issue: Cannot delete file/directory

**Solutions:**

**1. Check if file is in use**
```bash
lsof /path/to/file  # Linux/Mac
```

**2. Force deletion**
```bash
rm -rf directory/
```

**3. Check permissions**
```bash
ls -la
sudo rm file.txt  # If owned by root
```

## 🌐 Networking Issues

### Issue: Cannot reach service in container

**Solutions:**

**1. Check if container is running**
```bash
docker ps
```

**2. Check port mapping**
```bash
docker port container-name
```

**3. Check container logs**
```bash
docker logs container-name
```

**4. Try from inside container**
```bash
docker exec -it container-name curl localhost:8080
```

**5. Check firewall**
```bash
# Linux
sudo ufw status

# macOS
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
```

---

### Issue: Containers cannot communicate

**Solutions:**

**1. Check if on same network**
```bash
docker network inspect bridge
```

**2. Use container names (not localhost)**
```yaml
# docker-compose.yml
services:
  backend:
    # ...
  frontend:
    environment:
      - API_URL=http://backend:3000  # Use service name
```

**3. Create custom network**
```bash
docker network create mynetwork
docker run --network mynetwork backend
docker run --network mynetwork frontend
```

## 📦 Dependency Issues

### Issue: npm install fails

**Solutions:**

**1. Clear npm cache**
```bash
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

**2. Try different registry**
```bash
npm config set registry https://registry.npmjs.org/
```

**3. Update npm**
```bash
npm install -g npm@latest
```

---

### Issue: pip install fails

**Solutions:**

**1. Upgrade pip**
```bash
python -m pip install --upgrade pip
```

**2. Use virtual environment**
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows
pip install -r requirements.txt
```

**3. Install specific version**
```bash
pip install package==1.2.3
```

## 🔍 Debugging Tips

### General Debugging Approach

1. **Read the error message** - It usually tells you what's wrong
2. **Check the logs** - `docker logs`, application logs
3. **Isolate the problem** - Test each component separately
4. **Google the error** - Someone else has likely solved it
5. **Check documentation** - Official docs are your friend
6. **Start simple** - Remove complexity until it works

### Useful Debug Commands

```bash
# Docker
docker logs -f container-name
docker exec -it container-name sh
docker inspect container-name

# System
df -h              # Disk space
free -h            # Memory
top                # Processes
netstat -tulpn     # Network connections

# Git
git status
git log --oneline
git diff

# General
tail -f /var/log/syslog    # System logs
journalctl -xe             # Systemd logs (Linux)
```

## 🆘 Getting Help

### Before Asking

1. Search Google with exact error message
2. Check Stack Overflow
3. Read official documentation
4. Check GitHub issues of the project

### When Asking for Help

Include:
1. **What you're trying to do**
2. **What you tried**
3. **Complete error message**
4. **Environment details** (OS, versions)
5. **Minimal reproducible example**

### Where to Ask

- Stack Overflow (general questions)
- GitHub Issues (project-specific)
- Docker Forums (Docker questions)
- Reddit r/devops (general DevOps)
- Discord servers (real-time help)

---

**Remember:** Everyone encounters these issues. Persistence and systematic debugging will get you through! 🚀
