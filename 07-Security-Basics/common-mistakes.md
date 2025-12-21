# Common Mistakes in Security Basics

## Beginner Mistakes

### Mistake 1: Storing Secrets in Code or Version Control

**What people do:**
Commit API keys, passwords, private keys, and credentials directly in code or configuration files.

**Why it's a problem:**
- Secrets exposed to anyone with repository access
- Credentials in git history forever
- Major security vulnerability
- Compliance violations
- Must rotate all exposed credentials
- Potential data breach

**The right way:**
Use environment variables and secrets management:

```python
# Bad ❌
API_KEY = "sk_live_1234567890abcdef"
DB_PASSWORD = "super_secret_password"

# Good ✅
import os

API_KEY = os.getenv('API_KEY')
DB_PASSWORD = os.getenv('DB_PASSWORD')

# Use secrets manager
from aws_secretsmanager import get_secret
db_password = get_secret('prod/database/password')

# .env file (never commit!)
API_KEY=your_key_here
DB_PASSWORD=your_password

# .gitignore
.env
.env.*
secrets.yml
*.pem
*.key
```

**How to fix if you've already done this:**
Remove secrets and rotate:

```bash
# 1. IMMEDIATELY rotate all exposed credentials
# 2. Remove from git history
git filter-repo --path config/secrets.yml --invert-paths

# 3. Add to .gitignore
echo ".env" >> .gitignore
echo "*.pem" >> .gitignore

# 4. Use environment variables or secrets manager
# 5. Verify no secrets in repository
git log --all --full-history --source -- '*.env' '*.pem'
```

**Red flags to watch for:**
- API keys visible in GitHub
- Passwords in configuration files
- Private keys committed
- AWS credentials in code
- Database connection strings with passwords

---

### Mistake 2: Not Validating User Input

**What people do:**
Trust user input without validation or sanitization, directly using it in queries or commands.

**Why it's a problem:**
- SQL injection vulnerabilities
- Command injection attacks
- XSS (Cross-Site Scripting)
- Path traversal attacks
- Data corruption
- System compromise

**The right way:**
Always validate and sanitize input:

```python
# Bad ❌ - SQL Injection vulnerability
username = request.form['username']
query = f"SELECT * FROM users WHERE username = '{username}'"
db.execute(query)

# Good ✅ - Parameterized query
username = request.form['username']
query = "SELECT * FROM users WHERE username = ?"
db.execute(query, (username,))

# Input validation
from wtforms import StringField, validators

class UserForm(Form):
    username = StringField('Username', [
        validators.Length(min=3, max=25),
        validators.Regexp('^[a-zA-Z0-9_]+$', message="Only alphanumeric and underscore")
    ])
    email = StringField('Email', [
        validators.Email(message="Invalid email")
    ])

# Sanitize for XSS
from markupsafe import escape
user_content = escape(request.form['content'])
```

**How to fix if you've already done this:**
Implement validation everywhere:

```python
# Find all user inputs
# Add validation
# Use parameterized queries
# Escape output
# Add input length limits
# Whitelist allowed characters
```

**Red flags to watch for:**
- String concatenation in SQL queries
- User input in system commands
- No input validation
- Raw user content displayed
- eval() or exec() with user input

---

### Mistake 3: Using Default or Weak Passwords

**What people do:**
Use default passwords (admin/admin), weak passwords, or same password everywhere.

**Why it's a problem:**
- Easy for attackers to guess or crack
- Automated scanners find defaults
- One breach compromises everything
- Fails compliance requirements
- Account takeover
- Data breach

**The right way:**
Use strong, unique passwords:

```python
# Password requirements
- Minimum 12 characters
- Mix of uppercase, lowercase, numbers, symbols
- No dictionary words
- Not reused
- Stored as hashed values only

# Password hashing (never store plain text!)
from werkzeug.security import generate_password_hash, check_password_hash

# Store
hashed = generate_password_hash('user_password', method='pbkdf2:sha256')

# Verify
if check_password_hash(hashed, attempted_password):
    # Password correct

# Or use bcrypt
import bcrypt

# Hash
hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

# Verify
if bcrypt.checkpw(password.encode('utf-8'), hashed):
    # Password correct
```

**How to fix if you've already done this:**
Update passwords immediately:

```bash
# Change all default passwords
# Implement password policy
# Force password reset
# Use password manager
# Enable MFA
# Hash existing passwords properly
```

**Red flags to watch for:**
- Default admin credentials
- Passwords like "password123"
- Plain text passwords in database
- Same password for all systems
- No password complexity requirements

---

### Mistake 4: Not Using HTTPS Everywhere

**What people do:**
Use HTTP instead of HTTPS, or mix HTTP and HTTPS content.

**Why it's a problem:**
- Data transmitted in plain text
- Passwords captured by network sniffers
- Man-in-the-middle attacks
- Session hijacking
- Cookie theft
- Loss of user trust

**The right way:**
Use HTTPS for everything:

```nginx
# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name example.com;
    
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    # Modern SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    
    # HSTS header
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
}
```

```python
# Flask - Force HTTPS
from flask_talisman import Talisman

app = Flask(__name__)
Talisman(app, force_https=True)

# Set secure cookies
app.config['SESSION_COOKIE_SECURE'] = True
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
```

**How to fix if you've already done this:**
Implement HTTPS:

```bash
# Get SSL certificate (Let's Encrypt)
certbot --nginx -d example.com

# Configure redirect
# Test HTTPS configuration
# Update all links to HTTPS
# Enable HSTS
```

**Red flags to watch for:**
- HTTP URLs in production
- Mixed content warnings
- Login pages over HTTP
- No SSL certificate
- Insecure cookie warnings

---

### Mistake 5: Not Implementing Authentication Properly

**What people do:**
Roll custom authentication instead of using proven libraries, or implement it incorrectly.

**Why it's a problem:**
- Security vulnerabilities
- Timing attacks
- Session fixation
- Weak password storage
- Authentication bypass
- Account compromise

**The right way:**
Use established authentication libraries:

```python
# Use proven libraries
from flask_login import LoginManager, login_user, login_required

# Don't roll your own crypto
# Use libraries: Flask-Login, Django auth, Passport.js

# Secure session management
from flask import session
import secrets

app.config['SECRET_KEY'] = secrets.token_hex(32)
app.config['SESSION_COOKIE_SECURE'] = True
app.config['SESSION_COOKIE_HTTPONLY'] = True

# Implement MFA
from pyotp import TOTP

def verify_mfa(user, token):
    totp = TOTP(user.mfa_secret)
    return totp.verify(token)

# Rate limit login attempts
from flask_limiter import Limiter

limiter = Limiter(app, key_func=lambda: request.remote_addr)

@app.route('/login', methods=['POST'])
@limiter.limit("5 per minute")
def login():
    # Login logic
```

**How to fix if you've already done this:**
Replace custom auth:

```bash
# Audit current authentication
# Migrate to proven library
# Add MFA
# Implement rate limiting
# Add account lockout
# Use secure session management
```

**Red flags to watch for:**
- Custom password hashing
- No rate limiting
- Predictable session IDs
- No MFA option
- Authentication bypasses

---

### Mistake 6: Exposing Sensitive Information in Errors

**What people do:**
Show detailed error messages with stack traces, database errors, or file paths to users.

**Why it's a problem:**
- Information disclosure
- Reveals system architecture
- Database structure exposed
- File paths visible
- Version information leaked
- Helps attackers plan attacks

**The right way:**
Use generic error messages:

```python
# Bad ❌
@app.errorhandler(500)
def server_error(e):
    return f"Error: {str(e)}\n{traceback.format_exc()}", 500

# Good ✅
@app.errorhandler(500)
def server_error(e):
    # Log detailed error internally
    logger.error("Server error", exc_info=True, extra={"request_id": g.request_id})
    
    # Show generic message to user
    return {"error": "An internal error occurred. Please try again later."}, 500

# Development vs Production
if app.config['DEBUG']:
    # Show details in development
    app.config['PROPAGATE_EXCEPTIONS'] = True
else:
    # Generic messages in production
    app.config['PROPAGATE_EXCEPTIONS'] = False
```

**How to fix if you've already done this:**
Implement proper error handling:

```python
# Add global error handlers
# Log errors internally
# Return generic messages
# Remove DEBUG mode in production
# Hide server versions
```

**Red flags to watch for:**
- Stack traces visible to users
- Database errors shown
- Debug mode in production
- File paths in errors
- Server version in headers

---

### Mistake 7: Not Implementing Proper Access Control

**What people do:**
Allow users to access resources without checking permissions, or use client-side access control only.

**Why it's a problem:**
- Unauthorized data access
- Privilege escalation
- Insecure direct object references
- Users can access others' data
- Authorization bypasses
- Data breaches

**The right way:**
Implement server-side access control:

```python
# Bad ❌ - Client-side only
@app.route('/user/<user_id>/profile')
def get_profile(user_id):
    # No permission check!
    user = User.query.get(user_id)
    return jsonify(user.to_dict())

# Good ✅ - Server-side validation
from flask_login import current_user, login_required

@app.route('/user/<user_id>/profile')
@login_required
def get_profile(user_id):
    # Check authorization
    if str(current_user.id) != user_id and not current_user.is_admin:
        abort(403, "Access denied")
    
    user = User.query.get_or_404(user_id)
    return jsonify(user.to_dict())

# Use decorators for common checks
def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_admin:
            abort(403)
        return f(*args, **kwargs)
    return decorated_function

@app.route('/admin/users')
@login_required
@admin_required
def admin_users():
    # Admin only
```

**How to fix if you've already done this:**
Implement authorization:

```python
# Audit all endpoints
# Add permission checks
# Implement RBAC
# Test with different user roles
# Use authorization libraries
```

**Red flags to watch for:**
- No permission checks
- Client-side only access control
- Users accessing others' data
- URL manipulation bypasses security
- Missing @login_required decorators

---

## Intermediate Mistakes

### Mistake 8: Not Protecting Against CSRF

**What people do:**
Don't implement CSRF protection for state-changing operations.

**Why it's a problem:**
- Attackers can perform actions as authenticated users
- Unwanted money transfers
- Account modifications
- Data deletion
- Reputation damage

**The right way:**
Implement CSRF protection:

```python
# Flask-WTF
from flask_wtf.csrf import CSRFProtect

csrf = CSRFProtect(app)

# Forms automatically protected
class TransferForm(FlaskForm):
    amount = DecimalField('Amount')
    to_account = StringField('To Account')

# API endpoints
@app.route('/api/transfer', methods=['POST'])
@csrf.exempt  # If using token-based auth
def transfer():
    # Verify JWT or API key instead
    
# Include CSRF token in forms
<form method="POST">
    {{ form.csrf_token }}
    <!-- form fields -->
</form>

# AJAX requests
<script>
var csrfToken = "{{ csrf_token() }}";
$.ajax({
    headers: {'X-CSRFToken': csrfToken},
    // ...
});
</script>
```

**How to fix if you've already done this:**
Add CSRF protection:

```python
# Enable CSRF middleware
# Add tokens to forms
# Include in AJAX
# Test protection
```

**Red flags to watch for:**
- State changes via GET
- No CSRF tokens
- Forms without protection
- AJAX POST without tokens

---

### Mistake 9: Insufficient Logging and Monitoring

**What people do:**
Don't log security events or monitor for suspicious activity.

**Why it's a problem:**
- Can't detect attacks
- No audit trail
- Difficult incident response
- Unknown breach duration
- Compliance violations

**The right way:**
Log security events:

```python
import logging

# Log security events
logger.info("successful_login", user_id=user.id, ip=request.remote_addr)
logger.warning("failed_login_attempt", username=username, ip=request.remote_addr)
logger.warning("password_change", user_id=user.id, ip=request.remote_addr)
logger.critical("admin_access", user_id=user.id, action=action, resource=resource)

# Monitor for anomalies
failed_attempts = get_failed_login_count(username, last_hour=True)
if failed_attempts > 5:
    logger.warning("brute_force_attempt", username=username, count=failed_attempts)
    # Lock account or alert security team
```

**How to fix if you've already done this:**
Implement security logging:

```python
# Log authentication events
# Log authorization failures
# Log data access
# Set up alerts
# Review logs regularly
```

**Red flags to watch for:**
- No authentication logging
- Can't detect attacks
- No failed login tracking
- Missing audit trail

---

### Mistake 10: Using Vulnerable Dependencies

**What people do:**
Use outdated libraries with known vulnerabilities.

**Why it's a problem:**
- Known exploits available
- Easy attack vector
- Automated scanners find vulnerabilities
- Remote code execution
- Data breaches

**The right way:**
Keep dependencies updated:

```bash
# Check for vulnerabilities
npm audit
pip-audit
snyk test

# Update regularly
npm update
pip install --upgrade -r requirements.txt

# Use Dependabot
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"

# Pin versions but update regularly
# requirements.txt
flask==2.3.0  # Not flask==2.0.0 (old)
requests==2.31.0  # Not requests==2.20.0 (vulnerable)
```

**How to fix if you've already done this:**
Update dependencies:

```bash
# Audit current dependencies
# Update vulnerable packages
# Set up automated scanning
# Enable Dependabot
# Regular update schedule
```

**Red flags to watch for:**
- npm audit warnings
- Outdated dependencies
- No dependency updates
- Known CVEs in packages

---

## Advanced Pitfalls

### Mistake 11: Not Implementing Rate Limiting

**What people do:**
Allow unlimited requests to endpoints, enabling brute force and DDoS attacks.

**Why it's a problem:**
- Brute force attacks succeed
- Account enumeration
- Resource exhaustion
- DDoS vulnerability
- API abuse

**The right way:**
Implement rate limiting:

```python
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(
    app,
    key_func=get_remote_address,
    default_limits=["200 per day", "50 per hour"]
)

# Per-endpoint limits
@app.route("/login", methods=["POST"])
@limiter.limit("5 per minute")
def login():
    # Login logic

@app.route("/api/expensive")
@limiter.limit("10 per hour")
def expensive_operation():
    # Resource-intensive operation

# Custom rate limit by user
def get_user_id():
    return current_user.id if current_user.is_authenticated else get_remote_address()

@limiter.limit("100 per day", key_func=get_user_id)
@app.route("/api/data")
def get_data():
    # Data endpoint
```

**How to fix if you've already done this:**
Add rate limiting:

```python
# Choose rate limiting library
# Set appropriate limits
# Different limits per endpoint
# Monitor rate limit hits
# Add user-based limits
```

**Red flags to watch for:**
- No rate limiting
- Successful brute force attacks
- API abuse
- High server load from single IP
- Account enumeration

---

### Mistake 12: Not Having Security Headers

**What people do:**
Don't set security-related HTTP headers.

**Why it's a problem:**
- Clickjacking attacks
- XSS vulnerabilities
- MIME-type sniffing
- Lack of HTTPS enforcement
- Information disclosure

**The right way:**
Set security headers:

```python
from flask import Flask
from flask_talisman import Talisman

app = Flask(__name__)

# Use Talisman for security headers
Talisman(app,
    force_https=True,
    strict_transport_security=True,
    content_security_policy={
        'default-src': ["'self'"],
        'script-src': ["'self'", "'unsafe-inline'"],
        'style-src': ["'self'", "'unsafe-inline'"],
    },
    content_security_policy_nonce_in=['script-src']
)

# Or manually
@app.after_request
def set_security_headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    response.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
    response.headers['Content-Security-Policy'] = "default-src 'self'"
    return response
```

**How to fix if you've already done this:**
Add security headers:

```bash
# Test current headers
curl -I https://example.com

# Add headers
# Test with securityheaders.com
# Fix CSP violations
# Enable HSTS
```

**Red flags to watch for:**
- Missing security headers
- Failing security header scans
- No CSP
- No X-Frame-Options
- No HSTS

---

## Prevention Checklist

### Development

- [ ] Never commit secrets
- [ ] Validate all input
- [ ] Use parameterized queries
- [ ] Hash passwords properly
- [ ] Use proven auth libraries
- [ ] Implement proper access control

### Infrastructure

- [ ] Use HTTPS everywhere
- [ ] Set security headers
- [ ] Implement rate limiting
- [ ] Configure CORS properly
- [ ] Disable debug mode in production
- [ ] Keep dependencies updated

### Operations

- [ ] Log security events
- [ ] Monitor for attacks
- [ ] Regular security audits
- [ ] Vulnerability scanning
- [ ] Penetration testing
- [ ] Incident response plan

### Compliance

- [ ] No PII in logs
- [ ] Encrypt data at rest
- [ ] Encrypt data in transit
- [ ] Access controls documented
- [ ] Regular backups
- [ ] Disaster recovery tested
