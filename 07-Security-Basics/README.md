# Module 07: Security Basics

## 🎯 Learning Objectives

- ✅ Understand DevSecOps principles
- ✅ Manage secrets securely
- ✅ Implement Docker security best practices
- ✅ Use dependency scanning
- ✅ Apply security in CI/CD
- ✅ Prevent common vulnerabilities

**Time Required**: 5-7 hours

## 📚 Why Security Matters

### The Cost of Security Breaches

**Real Examples:**

- **Equifax (2017):** 147 million records stolen. Cost: $1.4 billion
- **Target (2013):** 40 million credit cards compromised. Cost: $292 million
- **Capital One (2019):** 100 million customers affected. Cost: $80 million

**Common Causes:**

- ❌ Hardcoded credentials in code
- ❌ Unpatched dependencies
- ❌ Misconfigured containers
- ❌ Exposed secrets in repositories
- ❌ Running as root

**The Good News:** Most breaches are preventable with basic security practices!

## 🔒 DevSecOps Principles

### Shift Left Security

**Traditional:**

```
Develop → Test → Security Review → Deploy
                   ↑ Found issues here (expensive to fix)
```

**DevSecOps:**

```
Security → Develop → Security → Test → Security → Deploy
↑ Build security in from the start (cheaper to fix)
```

### Defense in Depth

Multiple layers of security:

1. **Code Level:** Secure coding practices
2. **Dependencies:** Scan for vulnerabilities
3. **Containers:** Minimal, hardened images
4. **Secrets:** Never in code
5. **Network:** Least privilege access
6. **Monitoring:** Detect threats

## 🔐 Secrets Management

### The Problem

**❌ NEVER do this:**

```javascript
// Hardcoded secret (BAD!)
const API_KEY = "sk_live_51HKj2KLm3N4O5P6Q7R8S9T";
const DB_PASSWORD = "SuperSecret123!";
```

**Why it's dangerous:**

- Committed to Git (can't be removed from history)
- Visible to anyone with repo access
- Exposed in Docker images
- Leaked in logs

### The Solution

**✅ Use environment variables:**

```javascript
// Good!
const API_KEY = process.env.API_KEY;
const DB_PASSWORD = process.env.DB_PASSWORD;

if (!API_KEY || !DB_PASSWORD) {
    throw new Error('Missing required environment variables');
}
```

**Where to store secrets:**

**1. Local Development (.env file)**

```bash
# .env
API_KEY=sk_test_abc123
DB_PASSWORD=dev_password_123

# IMPORTANT: Add to .gitignore!
echo ".env" >> .gitignore
```

**2. GitHub Actions (Repository Secrets)**

```yaml
jobs:
  deploy:
    steps:
      - name: Deploy
        env:
          API_KEY: ${{ secrets.API_KEY }}
        run: ./deploy.sh
```

**3. Production (Environment Variables)**

```bash
docker run -e API_KEY="$API_KEY" myapp
```

### Provide Example Configs

```bash
# .env.example (commit this)
API_KEY=your_api_key_here
DB_PASSWORD=your_db_password_here
DB_HOST=localhost
DB_PORT=5432
```

## 🐳 Docker Security

### 1. Don't Run as Root

**❌ Bad (default):**

```dockerfile
FROM node:18
COPY . /app
WORKDIR /app
CMD ["node", "server.js"]
# Runs as root (dangerous!)
```

**✅ Good:**

```dockerfile
FROM node:18
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001
COPY --chown=nodejs:nodejs . /app
WORKDIR /app
USER nodejs
CMD ["node", "server.js"]
```

### 2. Use Minimal Base Images

```dockerfile
# ❌ Bad - Large, many packages
FROM ubuntu:latest

# ✅ Better - Smaller
FROM node:18

# ✅ Best - Minimal (alpine)
FROM node:18-alpine
```

### 3. Scan Images for Vulnerabilities

```bash
# Using Docker Scout (built-in)
docker scout cves myapp:latest

# Using Trivy
trivy image myapp:latest

# In CI/CD
- name: Scan image
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: myapp:latest
    severity: 'CRITICAL,HIGH'
```

### 4. Multi-Stage Builds

```dockerfile
# Build stage (includes dev dependencies)
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage (minimal, no dev dependencies)
FROM node:18-alpine
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001
WORKDIR /app
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
USER nodejs
CMD ["node", "dist/server.js"]
```

## 📦 Dependency Security

### GitHub Dependabot

**Enable Dependabot:**

1. Repository Settings → Security → Dependabot
2. Enable "Dependabot alerts"
3. Enable "Dependabot security updates"

**What it does:**

- Scans dependencies for known vulnerabilities
- Creates PRs to update vulnerable packages
- Keeps dependencies up-to-date

### Manual Dependency Scanning

```bash
# Node.js
npm audit
npm audit fix

# Python
pip install safety
safety check

# In CI/CD
- name: Audit dependencies
  run: npm audit --audit-level=high
```

## 🛡️ Secure Coding Practices

### 1. Input Validation

```javascript
// ❌ Bad - No validation
app.post('/user', (req, res) => {
    const user = new User(req.body);
    user.save();
});

// ✅ Good - Validate input
app.post('/user', (req, res) => {
    const { name, email } = req.body;
    
    if (!name || typeof name !== 'string' || name.length > 100) {
        return res.status(400).json({ error: 'Invalid name' });
    }
    
    if (!email || !isValidEmail(email)) {
        return res.status(400).json({ error: 'Invalid email' });
    }
    
    const user = new User({ name, email });
    user.save();
});
```

### 2. SQL Injection Prevention

```javascript
// ❌ VULNERABLE to SQL injection
db.query(`SELECT * FROM users WHERE id = ${userId}`);

// ✅ Safe - Use parameterized queries
db.query('SELECT * FROM users WHERE id = ?', [userId]);
```

### 3. XSS Prevention

```javascript
// ❌ Vulnerable to XSS
res.send(`<h1>Hello ${req.query.name}</h1>`);

// ✅ Safe - Escape output
const escapeHtml = (unsafe) => {
    return unsafe
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;");
};
res.send(`<h1>Hello ${escapeHtml(req.query.name)}</h1>`);
```

## 🔍 Security in CI/CD

### GitHub Actions Security

```yaml
name: Security Checks

on: [push, pull_request]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      # Scan dependencies
      - uses: actions/checkout@v4
      - name: Run dependency audit
        run: npm audit --audit-level=high
      
      # Scan Docker image
      - name: Build image
        run: docker build -t myapp .
      
      - name: Scan image
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: myapp:latest
          severity: 'CRITICAL,HIGH'
      
      # Secret scanning (already built into GitHub)
```

## 📋 Security Checklist

### Before Committing Code

- [ ] No hardcoded secrets
- [ ] `.env` in `.gitignore`
- [ ] Input validation implemented
- [ ] Secure queries (no SQL injection)
- [ ] Output escaping (no XSS)

### Docker Security

- [ ] Running as non-root user
- [ ] Using minimal base image
- [ ] Multi-stage build (if applicable)
- [ ] No secrets in image
- [ ] Health checks implemented

### Dependencies

- [ ] Dependencies up-to-date
- [ ] No known vulnerabilities
- [ ] Dependabot enabled
- [ ] Regular security audits

### CI/CD

- [ ] Secrets in GitHub Secrets (not code)
- [ ] Security scanning in pipeline
- [ ] Dependency scanning enabled
- [ ] Docker image scanning

## 🎯 Common Vulnerabilities

### OWASP Top 10 (Web Applications)

1. **Broken Access Control** - Users can access unauthorized resources
2. **Cryptographic Failures** - Weak encryption or exposed data
3. **Injection** - SQL, NoSQL, OS command injection
4. **Insecure Design** - Missing security controls
5. **Security Misconfiguration** - Default passwords, unnecessary features
6. **Vulnerable Components** - Outdated dependencies
7. **Authentication Failures** - Weak passwords, no MFA
8. **Software and Data Integrity** - Unsigned updates
9. **Logging Failures** - Inadequate monitoring
10. **SSRF** - Server-side request forgery

## 🚀 Examples

Security example configurations coming soon for:

- `.env.example` template
- Secure Dockerfile
- Security scanning workflow
- Input validation examples

## 📝 Exercises

Hands-on security exercises coming soon! For now, practice the security concepts covered above.

## 🎓 Key Takeaways

1. **Never commit secrets** - Use environment variables
2. **Don't run as root** - Use non-root users in containers
3. **Keep dependencies updated** - Enable Dependabot
4. **Scan for vulnerabilities** - In code, dependencies, and images
5. **Validate all input** - Never trust user input
6. **Security is everyone's job** - Build it in from the start

## 🚀 Next Steps

1. Review your projects for hardcoded secrets
2. Add security scanning to your CI/CD
3. Implement non-root users in Dockerfiles
4. Enable Dependabot on repositories

**Next:** Complete [Projects](../Projects/) to apply all your learning!

---

**Remember:** Security is not a one-time task. It's an ongoing practice. Start with these basics and continuously improve! 🔒
