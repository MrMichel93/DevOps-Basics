# Module 13: Network Security Best Practices

## 🎯 Learning Objectives

- ✅ Implement comprehensive security measures
- ✅ Understand defense in depth
- ✅ Perform security testing
- ✅ Handle security incidents
- ✅ Maintain security posture

**Time Required**: 3-4 hours

## 🛡️ Defense in Depth

Security is not one tool - it's layers of protection:

```
┌─────────────────────────────────────┐
│     Physical Security               │
├─────────────────────────────────────┤
│     Network Security                │
├─────────────────────────────────────┤
│     Application Security            │
├─────────────────────────────────────┤
│     Data Security                   │
├─────────────────────────────────────┤
│     User Security                   │
└─────────────────────────────────────┘
```

**Principle**: If one layer fails, others still protect you.

## 🔒 Network Level Security

### 1. Firewalls

Block unwanted traffic:

```bash
# UFW (Uncomplicated Firewall) - Linux
sudo ufw enable
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw deny 3306/tcp   # Block MySQL from outside
```

### 2. Network Segmentation

Separate networks:

```
DMZ (Public servers) → Firewall → Internal Network → Firewall → Database
```

### 3. VPN (Virtual Private Network)

Encrypt connections to your network:

```
Remote Worker → VPN → Company Network
         (Encrypted tunnel)
```

### 4. DDoS Protection

Prevent Distributed Denial of Service:
- Rate limiting
- Traffic filtering
- CDN (Cloudflare, AWS CloudFront)
- Load balancers

## 🔐 Application Security

### 1. Input Validation

**Always validate everything**:

```python
def create_user(data):
    # Validate email
    if not is_valid_email(data['email']):
        return error("Invalid email")
    
    # Validate length
    if len(data['username']) < 3 or len(data['username']) > 50:
        return error("Username must be 3-50 characters")
    
    # Validate type
    if not isinstance(data['age'], int) or data['age'] < 0:
        return error("Invalid age")
    
    # Whitelist check
    if data['role'] not in ['user', 'admin']:
        return error("Invalid role")
```

### 2. Output Encoding

**Prevent XSS**:

```python
from html import escape

# Escape HTML
safe_content = escape(user_input)

# In templates (Jinja2)
{{ user_content | escape }}
```

### 3. Authentication & Authorization

```python
# Strong password requirements
MIN_PASSWORD_LENGTH = 12
require_uppercase = True
require_lowercase = True
require_digit = True
require_special = True

# Hash passwords
import bcrypt
hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())

# Check authorization before actions
def delete_post(user, post_id):
    post = get_post(post_id)
    if not post:
        return error("Post not found", 404)
    if post.author_id != user.id and not user.is_admin:
        return error("Forbidden", 403)
    post.delete()
```

### 4. Secure Headers

```python
@app.after_request
def set_security_headers(response):
    # Prevent clickjacking
    response.headers['X-Frame-Options'] = 'DENY'
    
    # Prevent MIME sniffing
    response.headers['X-Content-Type-Options'] = 'nosniff'
    
    # Enable XSS protection
    response.headers['X-XSS-Protection'] = '1; mode=block'
    
    # HSTS (force HTTPS)
    response.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
    
    # Content Security Policy
    response.headers['Content-Security-Policy'] = "default-src 'self'"
    
    return response
```

## 🔑 Secrets Management

### 1. Never Commit Secrets

```bash
# .gitignore
.env
.env.local
secrets.json
*.key
*.pem
config/secrets.yml
```

### 2. Use Environment Variables

```python
import os

# Bad
API_KEY = "sk_live_abc123def456"

# Good
API_KEY = os.environ.get('API_KEY')
if not API_KEY:
    raise ValueError("API_KEY environment variable not set")
```

### 3. Use Secret Management Tools

**Local Development**:
- `.env` files (with .gitignore)
- direnv
- dotenv

**Production**:
- AWS Secrets Manager
- HashiCorp Vault
- Azure Key Vault
- Google Secret Manager

### 4. Rotate Secrets Regularly

```
Database passwords: Every 90 days
API keys: Every 6 months
Certificates: Before expiry
```

## 🔍 Security Testing

### 1. Manual Testing

**Test authentication**:
```bash
# Try without auth
curl https://api.example.com/protected

# Try with invalid token
curl https://api.example.com/protected \
  -H "Authorization: Bearer invalid"

# Try accessing others' resources
curl https://api.example.com/users/123/posts
```

**Test authorization**:
```bash
# Can user delete someone else's post?
curl -X DELETE https://api.example.com/posts/456 \
  -H "Authorization: Bearer user1_token"
```

**Test input validation**:
```bash
# SQL injection attempt
curl "https://api.example.com/users?id=1' OR '1'='1"

# XSS attempt
curl -X POST https://api.example.com/posts \
  -d '{"content":"<script>alert(1)</script>"}'
```

### 2. Automated Security Scanning

**Dependency Scanning**:
```bash
# Python
pip install safety
safety check

# Node.js
npm audit
npm audit fix

# Ruby
bundle audit
```

**SAST (Static Analysis)**:
```bash
# Bandit (Python)
pip install bandit
bandit -r . -ll

# ESLint with security plugin (JavaScript)
npm install eslint-plugin-security
```

**DAST (Dynamic Analysis)**:
- OWASP ZAP
- Burp Suite
- Nikto

### 3. Penetration Testing

Hire professionals or:
- Use OWASP ZAP
- Follow OWASP Testing Guide
- Test in isolated environment
- Document findings

## 📊 Logging and Monitoring

### 1. What to Log

**Security Events**:
```python
# Failed login attempts
logger.warning(f"Failed login attempt for {username} from {ip}")

# Authorization failures
logger.warning(f"User {user_id} attempted unauthorized access to {resource}")

# Suspicious activity
logger.warning(f"Multiple failed requests from {ip}")

# Data access
logger.info(f"User {user_id} accessed sensitive data: {resource_id}")
```

### 2. What NOT to Log

```python
# Never log:
- Passwords (even hashed)
- API keys
- Tokens
- Credit card numbers
- Social security numbers
- Any PII (Personally Identifiable Information) if possible
```

### 3. Centralized Logging

```
Application → Log aggregator (ELK, Splunk) → Alerts
```

### 4. Set Up Alerts

```
Alert if:
- Multiple failed login attempts
- Unusual traffic patterns
- Error rate spike
- Unauthorized access attempts
- Certificate near expiry
```

## 🚨 Incident Response

### 1. Preparation

**Have a plan**:
1. Who to contact
2. How to contain breach
3. How to investigate
4. How to recover
5. How to prevent recurrence

### 2. Detection

Monitor for:
- Unusual login patterns
- Data exfiltration
- System changes
- New admin accounts
- Unexpected traffic

### 3. Containment

```
1. Isolate affected systems
2. Change all credentials
3. Block attacker access
4. Preserve evidence
```

### 4. Recovery

```
1. Remove malware/backdoors
2. Restore from clean backups
3. Patch vulnerabilities
4. Verify systems clean
5. Gradually restore service
```

### 5. Lessons Learned

```
1. Document what happened
2. How attacker got in
3. What was compromised
4. What worked/didn't work
5. How to prevent next time
```

## ✅ Security Checklist

### Infrastructure
- [ ] Firewall configured
- [ ] Only necessary ports open
- [ ] SSH key authentication (no passwords)
- [ ] Regular system updates
- [ ] DDoS protection enabled

### Application
- [ ] HTTPS everywhere
- [ ] HSTS header set
- [ ] Security headers configured
- [ ] Input validation implemented
- [ ] Output encoding implemented
- [ ] CSRF protection
- [ ] SQL injection prevention
- [ ] XSS prevention

### Authentication & Authorization
- [ ] Strong password requirements
- [ ] Password hashing (bcrypt/argon2)
- [ ] Rate limiting on login
- [ ] Multi-factor authentication
- [ ] Session management secure
- [ ] Authorization checks everywhere

### Secrets
- [ ] No secrets in code
- [ ] Environment variables used
- [ ] .gitignore configured
- [ ] Secrets rotated regularly

### Monitoring
- [ ] Logging implemented
- [ ] Alerts configured
- [ ] Failed login monitoring
- [ ] Error rate monitoring
- [ ] Certificate expiry monitoring

### Testing
- [ ] Dependency scanning
- [ ] Security scanning in CI/CD
- [ ] Regular penetration testing
- [ ] Security updates applied quickly

### Compliance
- [ ] Data encryption at rest
- [ ] Data encryption in transit
- [ ] Regular backups
- [ ] Backup testing
- [ ] Incident response plan
- [ ] Privacy policy
- [ ] Terms of service

## 🎯 Security Principles

### 1. Principle of Least Privilege

Give minimum access needed:

```sql
-- Bad: Full access
GRANT ALL PRIVILEGES ON *.* TO 'app'@'localhost';

-- Good: Only what's needed
GRANT SELECT, INSERT, UPDATE ON mydb.users TO 'app'@'localhost';
```

### 2. Fail Secure

When something fails, default to secure:

```python
def check_permission(user, resource):
    try:
        return has_access(user, resource)
    except Exception:
        # Fail secure: deny access on error
        return False  # Not True!
```

### 3. Trust No One

Validate everything, everywhere:

```python
# Even internal APIs
def internal_api(data):
    # Still validate!
    if not is_valid(data):
        return error("Invalid data")
```

### 4. Defense in Depth

Multiple layers:

```
1. Firewall blocks port
2. Application requires auth
3. Database has permissions
4. Data is encrypted
5. Logs capture access
```

### 5. Security by Design

Think security from day one, not as afterthought.

## 🧪 Hands-On Exercise

### Security Audit Checklist

Audit your own application:

1. **Test authentication**:
   - Try accessing without login
   - Try weak passwords
   - Test password reset

2. **Test authorization**:
   - Can users access others' data?
   - Can users perform admin actions?
   - Test with different user roles

3. **Test input validation**:
   - Try SQL injection
   - Try XSS
   - Try very long inputs
   - Try special characters

4. **Check headers**:
   ```bash
   curl -I https://your-app.com
   ```
   Look for security headers

5. **Check dependencies**:
   ```bash
   npm audit
   # or
   pip install safety && safety check
   ```

6. **Review logs**:
   - Are security events logged?
   - Is sensitive data not logged?

## 🎯 Key Takeaways

1. **Defense in Depth**: Multiple security layers
2. **Validate Input**: Never trust user data
3. **Least Privilege**: Minimum access needed
4. **Secrets Management**: Never commit secrets
5. **HTTPS Everywhere**: Encrypt all traffic
6. **Monitor & Log**: Detect incidents quickly
7. **Incident Response**: Have a plan
8. **Regular Testing**: Find vulnerabilities before attackers do
9. **Keep Updated**: Patch vulnerabilities quickly
10. **Security is Ongoing**: Not one-time task

## 📖 Final Course Recommendations

### Continue Learning

1. **OWASP Top 10**: Study common vulnerabilities
2. **Security Certifications**: CEH, OSCP, Security+
3. **Bug Bounty Programs**: Practice ethically
4. **Security News**: Stay updated on threats

### Build Projects

1. Secure API with authentication
2. Implement rate limiting
3. Set up HTTPS
4. Build logging system
5. Create security scanner

### Join Community

- OWASP local chapter
- Security conferences
- CTF competitions
- Bug bounty platforms

## 🔗 Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP API Security Top 10](https://owasp.org/www-project-api-security/)
- [Security Headers](https://securityheaders.com/)
- [Have I Been Pwned](https://haveibeenpwned.com/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

---

## 🎓 Course Complete!

Congratulations on completing the Networking and APIs course! You now have a solid foundation in:

- How the Internet and web work
- HTTP and RESTful APIs
- Authentication and security
- Real-time communication
- Network protocols
- Security best practices

**Next Steps**: Apply these skills in real projects and keep learning! 🚀
