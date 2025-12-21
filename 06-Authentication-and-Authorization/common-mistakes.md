# Common Mistakes in Authentication and Authorization

## Beginner Mistakes

### Mistake 1: Confusing Authentication and Authorization

**What people do:**
Use the terms interchangeably or don't understand the difference.

**Why it's a problem:**
- Incorrect access control implementation
- Security vulnerabilities
- Poor system design
- Confusion in requirements

**The right way:**
Understand the distinction:
- Authentication: Who are you? (login, identity verification)
- Authorization: What can you do? (permissions, access control)

Example: User logs in (authentication), then checks if they can delete a post (authorization).

**How to fix if you've already done this:**
Separate authentication and authorization logic in your application.

**Red flags to watch for:**
- Only checking if user is logged in
- No permission checks
- Mixing authentication and authorization code
- Users accessing unauthorized resources

---

### Mistake 2: Storing Passwords in Plain Text

**What people do:**
Store passwords without hashing in the database.

**Why it's a problem:**
- Major security breach if database compromised
- Regulatory violations
- Loss of user trust
- Legal liability
- Account takeover

**The right way:**
Always hash passwords with a strong algorithm:

```python
from werkzeug.security import generate_password_hash, check_password_hash

# Store password
hashed = generate_password_hash(password, method='pbkdf2:sha256')

# Verify password
if check_password_hash(hashed, attempted_password):
    # Login successful
    
# Or use bcrypt
import bcrypt

hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
if bcrypt.checkpw(password.encode('utf-8'), hashed):
    # Login successful
```

**How to fix if you've already done this:**
Migrate immediately: hash all passwords, force password reset for all users.

**Red flags to watch for:**
- SELECT * shows readable passwords
- Password recovery emails contain actual password
- Database breach exposes passwords
- Compliance audit failures

---

### Mistake 3: Not Implementing Session Expiration

**What people do:**
Create sessions that never expire.

**Why it's a problem:**
- Session hijacking risk
- Unauthorized access if device stolen
- Compliance violations
- Security best practice violation

**The right way:**
Implement session timeout:

```python
from flask import session
from datetime import timedelta

app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(hours=1)

@app.before_request
def make_session_permanent():
    session.permanent = True
```

**How to fix if you've already done this:**
Add session expiration and refresh logic.

**Red flags to watch for:**
- Sessions lasting indefinitely
- No logout needed
- Old sessions still valid
- Security audit findings

---

### Mistake 4: Using Weak Password Requirements

**What people do:**
Allow weak passwords like "password" or "123456".

**Why it's a problem:**
- Easy to brute force
- Account compromises
- Security breaches
- Compliance violations

**The right way:**
Enforce strong password policy:
- Minimum 12 characters
- Mix of uppercase, lowercase, numbers, symbols
- Not common passwords
- Password strength checking

```python
import re

def is_strong_password(password):
    if len(password) < 12:
        return False
    if not re.search(r'[A-Z]', password):
        return False
    if not re.search(r'[a-z]', password):
        return False
    if not re.search(r'[0-9]', password):
        return False
    if not re.search(r'[!@#$%^&*]', password):
        return False
    # Check against common passwords list
    if password in common_passwords:
        return False
    return True
```

**How to fix if you've already done this:**
Implement password policy and force password changes.

**Red flags to watch for:**
- Users with "password123"
- No password requirements
- Easy account breaches
- Weak password notices

---

## Intermediate Mistakes

### Mistake 5: Not Implementing Multi-Factor Authentication

**What people do:**
Rely solely on passwords without 2FA/MFA.

**Why it's a problem:**
- Single point of failure
- Vulnerable to password theft
- No additional security layer
- Compliance issues for sensitive data

**The right way:**
Implement MFA:

```python
import pyotp

# Generate secret for user
secret = pyotp.random_base32()

# User scans QR code with authenticator app
totp = pyotp.TOTP(secret)
provisioning_uri = totp.provisioning_uri(user.email, issuer_name="YourApp")

# Verify MFA code
def verify_mfa(user, code):
    totp = pyotp.TOTP(user.mfa_secret)
    return totp.verify(code, valid_window=1)
```

**How to fix if you've already done this:**
Add MFA option, encourage or require for sensitive operations.

**Red flags to watch for:**
- Only password authentication
- No 2FA option
- Account takeovers
- Compliance requirements unmet

---

### Mistake 6: Improperly Implementing JWT

**What people do:**
Use JWT incorrectly: no signature verification, storing sensitive data, or no expiration.

**Why it's a problem:**
- Token forgery
- Information disclosure
- Permanent tokens
- Security vulnerabilities

**The right way:**
Implement JWT properly:

```python
import jwt
from datetime import datetime, timedelta

SECRET_KEY = os.getenv('JWT_SECRET_KEY')

# Generate token
def generate_token(user_id):
    payload = {
        'user_id': user_id,
        'exp': datetime.utcnow() + timedelta(hours=1),
        'iat': datetime.utcnow()
    }
    return jwt.encode(payload, SECRET_KEY, algorithm='HS256')

# Verify token
def verify_token(token):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        return payload['user_id']
    except jwt.ExpiredSignatureError:
        return None  # Token expired
    except jwt.InvalidTokenError:
        return None  # Invalid token
```

**How to fix if you've already done this:**
Review JWT implementation: add expiration, verify signatures, don't store secrets.

**Red flags to watch for:**
- No token expiration
- algorithm='none' in tokens
- Sensitive data in JWT payload
- No signature verification

---

## Advanced Pitfalls

### Mistake 7: Not Implementing Rate Limiting on Login

**What people do:**
Allow unlimited login attempts.

**Why it's a problem:**
- Brute force attacks succeed
- Credential stuffing
- Account compromise
- System abuse

**The right way:**
Implement rate limiting:

```python
from flask_limiter import Limiter

limiter = Limiter(app, key_func=lambda: request.remote_addr)

@app.route('/login', methods=['POST'])
@limiter.limit("5 per minute")
def login():
    # Login logic
    pass

# Account lockout after failures
failed_attempts = {}

def check_login_attempts(username):
    attempts = failed_attempts.get(username, 0)
    if attempts >= 5:
        # Account locked
        return False
    return True

def record_failed_login(username):
    failed_attempts[username] = failed_attempts.get(username, 0) + 1
```

**How to fix if you've already done this:**
Add rate limiting and account lockout.

**Red flags to watch for:**
- Successful brute force attacks
- No login attempt limits
- Many failed login attempts
- Account compromises

---

## Prevention Checklist

### Authentication
- [ ] Hash all passwords (bcrypt/pbkdf2)
- [ ] Enforce strong password policy
- [ ] Implement session expiration
- [ ] Add MFA/2FA option
- [ ] Rate limit login attempts
- [ ] Use HTTPS for all auth endpoints

### Authorization
- [ ] Separate from authentication
- [ ] Implement RBAC or ABAC
- [ ] Check permissions on every request
- [ ] Use principle of least privilege
- [ ] Audit authorization logic
- [ ] Test with different user roles

### Tokens & Sessions
- [ ] Set JWT expiration
- [ ] Verify JWT signatures
- [ ] Secure session storage
- [ ] Implement token refresh
- [ ] Revoke compromised tokens
- [ ] Use secure cookies (HttpOnly, Secure)
