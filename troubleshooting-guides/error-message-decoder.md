# Error Message Decoder

A plain English guide to common error messages across DevOps tools and technologies.

## Table of Contents

- [Docker Errors](#docker-errors)
- [Git Errors](#git-errors)
- [CI/CD Errors](#cicd-errors)
- [API/HTTP Errors](#apihttp-errors)
- [Command Line Errors](#command-line-errors)
- [Network Errors](#network-errors)
- [General Linux/System Errors](#general-linuxsystem-errors)

---

## Docker Errors

### `Cannot connect to the Docker daemon`

**Full error:**
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. 
Is the docker daemon running?
```

**What it means:**
Docker service is not running, or you don't have permission to access it.

**Solutions:**
```bash
# Start Docker service
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Add your user to docker group (then log out/in)
sudo usermod -aG docker $USER

# Check if Docker is running
systemctl status docker
```

**Prevention:**
Ensure Docker starts automatically and your user is in the docker group.

---

### `docker: Error response from daemon: OCI runtime create failed`

**What it means:**
The container runtime failed to start your container, usually due to:
- Invalid command
- Missing executable
- Permission issues
- Resource constraints

**Solutions:**
```bash
# Check logs for specific error
docker logs <container-id>

# Inspect the container
docker inspect <container-id>

# Try running interactively to debug
docker run -it --entrypoint /bin/sh <image>
```

**Common causes:**
- Command not found (typo in CMD)
- Binary not executable
- Missing libraries/dependencies

---

### `COPY failed: stat <file>: no such file or directory`

**What it means:**
During build, Docker can't find the file you're trying to COPY.

**Solutions:**
```bash
# Verify file exists relative to build context
ls -la path/to/file

# Check .dockerignore isn't excluding it
cat .dockerignore

# Ensure you're using relative paths
# Bad:  COPY /absolute/path /app
# Good: COPY ./relative/path /app
```

**Prevention:**
Always use paths relative to the Dockerfile location.

---

### `address already in use`

**Full error:**
```
Error starting userland proxy: listen tcp 0.0.0.0:8080: bind: address already in use
```

**What it means:**
Another process is already using that port on your host.

**Solutions:**
```bash
# Find what's using the port
sudo lsof -i :8080
# Or
sudo netstat -tulpn | grep 8080

# Stop the conflicting service
docker stop <container-using-port>
# Or
sudo kill <PID>

# Use a different port
docker run -p 8081:8080 <image>
```

**Prevention:**
Use unique ports for each service, or stop services before starting new ones.

---

### `exit code 137`

**What it means:**
Container was killed, usually due to out-of-memory (OOM).

**Solutions:**
```bash
# Increase memory limit
docker run -m 512m <image>  # 512MB
docker run -m 2g <image>    # 2GB

# Check container stats
docker stats <container-id>

# Review memory usage in code
# Look for memory leaks
```

**Prevention:**
Monitor memory usage and set appropriate limits. Fix memory leaks in application.

---

## Git Errors

### `fatal: not a git repository`

**What it means:**
You're not in a Git repository directory, or `.git` folder is missing.

**Solutions:**
```bash
# Initialize new repo
git init

# Or navigate to correct directory
cd /path/to/your/repo

# Verify you're in a Git repo
ls -la .git
```

**Prevention:**
Always check you're in the right directory before running Git commands.

---

### `error: failed to push some refs`

**What it means:**
Remote has commits you don't have locally. Your push was rejected.

**Solutions:**
```bash
# Pull changes first
git pull origin main

# If conflicts, resolve them
# Then push
git push origin main

# Or force push (DANGEROUS - only if you know what you're doing)
git push --force-with-lease origin main
```

**Prevention:**
Always pull before pushing, especially when collaborating.

---

### `CONFLICT (content): Merge conflict in <file>`

**What it means:**
Git can't automatically merge changes - both you and someone else modified the same lines.

**Solutions:**
```bash
# View conflicted files
git status

# Open files and look for conflict markers:
# <<<<<<< HEAD
# Your changes
# =======
# Their changes
# >>>>>>> branch-name

# Edit file to resolve conflict
# Remove conflict markers
# Keep the code you want

# Mark as resolved
git add <file>
git commit
```

**Prevention:**
- Pull frequently
- Communicate with team about who's working on what
- Use smaller, focused commits

---

### `Permission denied (publickey)`

**What it means:**
SSH authentication failed - Git can't verify your identity.

**Solutions:**
```bash
# Generate SSH key if you don't have one
ssh-keygen -t ed25519 -C "your@email.com"

# Add to SSH agent
ssh-add ~/.ssh/id_ed25519

# Copy public key and add to GitHub/GitLab
cat ~/.ssh/id_ed25519.pub

# Test connection
ssh -T git@github.com

# Or use HTTPS instead
git remote set-url origin https://github.com/user/repo.git
```

**Prevention:**
Set up SSH keys properly from the start.

---

## CI/CD Errors

### `Error: Process completed with exit code 1`

**What it means:**
A command in your workflow failed (returned non-zero exit code).

**Solutions:**
```bash
# Check the specific failing step in workflow logs
# The error is usually shown just before this message

# Common causes:
# - Tests failed → Fix failing tests
# - Build failed → Check build logs
# - Linting errors → Run linter locally and fix

# Debug locally:
npm test         # If tests failing
npm run build    # If build failing
npm run lint     # If linting failing
```

**Prevention:**
- Run tests/build locally before pushing
- Set up pre-commit hooks
- Use status checks on PRs

---

### `YAML syntax error`

**Full error:**
```
The workflow is not valid. .github/workflows/ci.yml: 
(Line: 10, Col: 3): Unexpected value 'run'
```

**What it means:**
Your workflow file has invalid YAML syntax.

**Solutions:**
```yaml
# Check indentation (must be consistent 2-space)
# Bad:
jobs:
build:
  runs-on: ubuntu-latest

# Good:
jobs:
  build:
    runs-on: ubuntu-latest

# Use YAML validator
yamllint .github/workflows/ci.yml

# Use VSCode with YAML extension for real-time validation
```

**Prevention:**
- Use a code editor with YAML support
- Enable YAML validation
- Copy from working examples

---

### `Resource not accessible by integration`

**What it means:**
GitHub Actions token doesn't have required permissions.

**Solutions:**
```yaml
# Add permissions to workflow
permissions:
  contents: write
  pull-requests: write

# Or at job level
jobs:
  deploy:
    permissions:
      contents: write
    steps:
      # ...
```

**Prevention:**
Always specify required permissions in workflow.

---

## API/HTTP Errors

### `401 Unauthorized`

**What it means:**
You didn't provide valid authentication credentials.

**Solutions:**
```bash
# Add authentication header
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.example.com/endpoint

# Or API key
curl -H "X-API-Key: YOUR_KEY" \
  https://api.example.com/endpoint

# Check token hasn't expired
# Verify credentials are correct
```

**Prevention:**
- Store tokens securely
- Implement token refresh logic
- Check expiration before requests

---

### `403 Forbidden`

**What it means:**
You're authenticated, but don't have permission for this resource.

**Solutions:**
- Check your account has the required role/permissions
- Request access from administrator
- Verify you're using the correct account
- Check API rate limits haven't been exceeded

**Prevention:**
Use accounts with appropriate permissions for the task.

---

### `404 Not Found`

**What it means:**
The resource doesn't exist at this URL.

**Solutions:**
```bash
# Verify URL is correct
# Check for typos

# Correct:
https://api.example.com/v1/users/123

# Wrong:
https://api.example.com/v1/user/123   # "user" not "users"
https://api.example.com/users/123     # missing /v1
```

**Prevention:**
- Read API documentation carefully
- Save commonly used URLs
- Use API client libraries

---

### `429 Too Many Requests`

**What it means:**
You've exceeded the API rate limit.

**Solutions:**
```javascript
// Implement exponential backoff
async function fetchWithRetry(url, retries = 3) {
  for (let i = 0; i < retries; i++) {
    const response = await fetch(url);
    
    if (response.status === 429) {
      const delay = Math.pow(2, i) * 1000;
      await new Promise(resolve => setTimeout(resolve, delay));
      continue;
    }
    
    return response;
  }
}
```

**Prevention:**
- Implement request throttling
- Cache responses when possible
- Use batch endpoints
- Check rate limit headers

---

### `500 Internal Server Error`

**What it means:**
Something went wrong on the server (not your fault, usually).

**Solutions:**
- Check server logs if you have access
- Wait and retry (may be temporary)
- Report to API provider if persists
- Check API status page

**Prevention:**
- Implement retry logic for 5xx errors
- Have fallback mechanisms
- Monitor API health

---

### `CORS policy: No 'Access-Control-Allow-Origin' header`

**What it means:**
Browser blocking request due to CORS policy (security feature).

**Solutions:**

Server-side (proper fix):
```javascript
// Express.js
app.use(cors({
  origin: 'https://yourfrontend.com'
}));
```

Client-side workaround (development only):
```javascript
// Use proxy in package.json (React)
"proxy": "http://localhost:5000"

// Or CORS proxy (dev only!)
fetch('https://cors-anywhere.herokuapp.com/' + apiUrl)
```

**Prevention:**
Configure CORS properly on the server from the start.

---

## Command Line Errors

### `command not found`

**What it means:**
The command you typed doesn't exist or isn't in your PATH.

**Solutions:**
```bash
# Check if command exists
which docker
which node

# Install if missing
sudo apt-get install docker.io  # Ubuntu/Debian
brew install node               # macOS

# Add to PATH if installed
export PATH=$PATH:/path/to/bin
# Add to ~/.bashrc or ~/.zshrc to make permanent

# Check for typos
# "ngnix" → "nginx"
# "pytohn" → "python"
```

**Prevention:**
- Install required tools before using them
- Add installation directories to PATH
- Use tab completion to avoid typos

---

### `Permission denied`

**What it means:**
You don't have permission to access a file or run a command.

**Solutions:**
```bash
# For files - check permissions
ls -la file.txt

# Add read permission
chmod +r file.txt

# Make executable
chmod +x script.sh

# For commands requiring root - use sudo
sudo systemctl restart nginx

# For Docker - add user to docker group
sudo usermod -aG docker $USER
# Log out and back in
```

**Prevention:**
- Set proper permissions on files
- Use sudo when necessary
- Configure user groups correctly

---

### `No such file or directory`

**What it means:**
File or directory doesn't exist at the specified path.

**Solutions:**
```bash
# Check if file exists
ls -la /path/to/file

# Verify current directory
pwd

# Use absolute path instead of relative
/home/user/script.sh  # Absolute
./script.sh           # Relative (current directory)

# Check for typos in filename
```

**Prevention:**
- Use tab completion for file paths
- Use absolute paths in scripts
- Verify files exist before referencing

---

## Network Errors

### `Connection refused`

**What it means:**
Nothing is listening on that port, or firewall is blocking it.

**Solutions:**
```bash
# Check if service is running
sudo systemctl status nginx

# Verify port is listening
sudo netstat -tulpn | grep 8080
sudo lsof -i :8080

# Check firewall
sudo ufw status
sudo iptables -L

# Start service if not running
sudo systemctl start nginx
```

**Prevention:**
Ensure services are running before trying to connect.

---

### `Connection timed out`

**What it means:**
Network request took too long, often due to firewall or no route.

**Solutions:**
```bash
# Test connectivity
ping example.com

# Check DNS resolution
nslookup example.com
dig example.com

# Test specific port
telnet example.com 80
nc -zv example.com 80

# Check firewall rules
sudo ufw status
```

**Prevention:**
- Configure timeouts appropriately
- Ensure network connectivity
- Check firewall rules

---

### `Name or service not known` / `Could not resolve host`

**What it means:**
DNS can't resolve the hostname to an IP address.

**Solutions:**
```bash
# Check DNS configuration
cat /etc/resolv.conf

# Test DNS resolution
nslookup google.com
dig google.com

# Try different DNS server
# Edit /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4

# Check spelling of hostname
# Check if domain exists
```

**Prevention:**
- Use reliable DNS servers
- Verify hostnames before using
- Consider using IP addresses for critical services

---

## General Linux/System Errors

### `No space left on device`

**What it means:**
Disk is full, can't write more data.

**Solutions:**
```bash
# Check disk usage
df -h

# Find large files
du -sh /* | sort -rh | head -10
du -sh /var/* | sort -rh | head -10

# Clean Docker
docker system prune -a --volumes

# Remove old logs
sudo journalctl --vacuum-time=7d

# Clean package cache
sudo apt-get clean  # Debian/Ubuntu
```

**Prevention:**
- Monitor disk usage
- Set up log rotation
- Regular cleanup of temp files
- Use volume mounts for data

---

### `Operation not permitted`

**What it means:**
System prevented the operation, usually security-related.

**Solutions:**
```bash
# Try with sudo
sudo command

# Check SELinux status (Red Hat/CentOS)
getenforce
# Temporarily disable (not recommended for production)
sudo setenforce 0

# Check AppArmor (Ubuntu)
sudo aa-status
```

**Prevention:**
- Understand which operations require elevated privileges
- Configure security policies correctly
- Use appropriate user permissions

---

### `Too many open files`

**What it means:**
Process exceeded maximum number of file descriptors.

**Solutions:**
```bash
# Check current limit
ulimit -n

# Increase limit temporarily
ulimit -n 4096

# Permanent fix - edit /etc/security/limits.conf
* soft nofile 4096
* hard nofile 8192

# Check what has files open
lsof | wc -l
lsof -p <PID>
```

**Prevention:**
- Close files when done
- Increase limits for high-concurrency applications
- Fix file descriptor leaks in code

---

## General Troubleshooting Tips

### When You See an Error:

1. **Read the full error message**
   - Don't just read the first line
   - Error messages contain clues

2. **Copy exact error and search**
   - Google the exact error message
   - Include context (tool name, version)

3. **Check recent changes**
   - What changed since it last worked?
   - New code, config, or dependencies?

4. **Verify basics**
   - Is service running?
   - Do files exist?
   - Are permissions correct?
   - Is network available?

5. **Increase verbosity**
   ```bash
   command -v      # Verbose
   command -vv     # Very verbose
   command --debug # Debug mode
   ```

6. **Check logs**
   ```bash
   # Application logs
   tail -f /var/log/app/error.log
   
   # System logs
   sudo journalctl -u service-name -f
   
   # Docker logs
   docker logs -f container-name
   ```

7. **Try minimal reproduction**
   - Strip away complexity
   - Isolate the problem
   - Test in simple environment

8. **Ask for help with context**
   - What you're trying to do
   - Exact error message
   - What you've already tried
   - Environment details (OS, versions)

---

## Quick Error Diagnosis Flowchart

```
Error occurred
    ├─ Is it a typo?
    │  └─ YES → Fix typo, retry
    │
    ├─ Does the resource exist?
    │  └─ NO → Create/install/configure it
    │
    ├─ Do you have permission?
    │  └─ NO → Add permissions or use sudo
    │
    ├─ Is the service running?
    │  └─ NO → Start the service
    │
    ├─ Are you connected?
    │  └─ NO → Check network/firewall
    │
    ├─ Is it rate limited?
    │  └─ YES → Wait and implement backoff
    │
    ├─ Are credentials valid?
    │  └─ NO → Update/refresh credentials
    │
    └─ Check logs and documentation
       └─ Search error message online
```

---

## Remember

- **Error messages are helpful** - Read them carefully
- **Most errors are fixable** - Don't panic
- **Document solutions** - Help future you
- **Learn from errors** - Each one teaches something
- **When stuck, ask** - Community is here to help

> "An error doesn't become a mistake until you refuse to learn from it." - DevOps Wisdom
