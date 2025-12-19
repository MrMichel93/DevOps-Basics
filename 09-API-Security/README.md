# Module 09: API Security

## 🎯 Learning Objectives

- ✅ Implement input validation
- ✅ Understand and configure rate limiting
- ✅ Master CORS properly
- ✅ Prevent SQL injection
- ✅ Prevent XSS attacks

**Time Required**: 3-4 hours

## 🔒 Why API Security Matters

APIs are prime targets for attacks:
- Expose business logic
- Handle sensitive data
- Often lack authentication
- Can be automated for attacks

## ✅ Input Validation

### Why Validate?

Prevent:
- SQL injection
- Code injection
- Buffer overflows
- Business logic errors

### What to Validate

1. **Data Type**: Is it a number, string, email?
2. **Length**: Min/max length
3. **Format**: Email, URL, date format
4. **Range**: Min/max values
5. **Whitelist**: Allowed values only

### Examples

```python
# Email validation
import re
email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
if not re.match(email_pattern, email):
    return error("Invalid email format")

# Length validation
if len(username) < 3 or len(username) > 50:
    return error("Username must be 3-50 characters")

# Type validation
if not isinstance(age, int) or age < 0 or age > 150:
    return error("Invalid age")

# Whitelist validation
allowed_roles = ['user', 'admin', 'moderator']
if role not in allowed_roles:
    return error("Invalid role")
```

### Sanitization

Remove or escape dangerous characters:

```python
import html

# HTML escape
safe_content = html.escape(user_input)

# Remove HTML tags
import re
clean_content = re.sub(r'<[^>]*>', '', user_input)
```

## 🚦 Rate Limiting

### Why Rate Limit?

- Prevent brute force attacks
- Avoid DOS/DDOS
- Protect resources
- Fair usage

### Implementation Strategies

**1. Fixed Window**:
```
100 requests per hour per IP
```

**2. Sliding Window**:
```
Count requests in rolling 60-minute window
```

**3. Token Bucket**:
```
Bucket fills with tokens over time
Each request consumes token
```

### Response Headers

```http
HTTP/1.1 429 Too Many Requests
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1640000000
Retry-After: 3600
```

### Example Implementation

```python
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(
    app,
    key_func=get_remote_address,
    default_limits=["100 per hour", "20 per minute"]
)

@app.route("/api/data")
@limiter.limit("10 per minute")
def get_data():
    return {"data": "..."}
```

## 🌐 CORS (Cross-Origin Resource Sharing)

### What is CORS?

Browser security feature that restricts cross-origin HTTP requests.

### The Problem

```
Website A (https://example.com) 
→ Cannot call API B (https://api.other.com)
→ Blocked by browser
```

### The Solution

API B sends CORS headers allowing Website A:

```http
Access-Control-Allow-Origin: https://example.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Max-Age: 86400
```

### CORS Configurations

**Allow specific origin**:
```python
@app.after_request
def after_request(response):
    response.headers['Access-Control-Allow-Origin'] = 'https://example.com'
    return response
```

**Allow all origins (development only)**:
```python
response.headers['Access-Control-Allow-Origin'] = '*'
```

**Preflight Request**:
```http
OPTIONS /api/users HTTP/1.1
Origin: https://example.com
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Content-Type
```

**Preflight Response**:
```http
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://example.com
Access-Control-Allow-Methods: POST, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type
Access-Control-Max-Age: 86400
```

### CORS Best Practices

1. **Never use `*` in production with credentials**
2. **Whitelist specific origins**
3. **Limit allowed methods**
4. **Limit allowed headers**
5. **Set appropriate max-age**

## 💉 SQL Injection Prevention

### What is SQL Injection?

Attacker inserts SQL code into input to manipulate queries.

### Vulnerable Code

```python
# NEVER DO THIS
email = request.args.get('email')
query = f"SELECT * FROM users WHERE email = '{email}'"
result = conn.execute(query)
```

**Attack**:
```
email = ' OR '1'='1
Query becomes: SELECT * FROM users WHERE email = '' OR '1'='1'
Result: Returns all users!
```

### Prevention

**1. Parameterized Queries**:
```python
email = request.args.get('email')
query = "SELECT * FROM users WHERE email = ?"
result = conn.execute(query, (email,))
```

**2. ORM (Object-Relational Mapping)**:
```python
# SQLAlchemy
users = User.query.filter_by(email=email).all()
```

**3. Input Validation**:
```python
if not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', email):
    return error("Invalid email")
```

**4. Principle of Least Privilege**:
```sql
-- Database user should only have needed permissions
GRANT SELECT, INSERT ON users TO api_user;
-- Don't grant DROP, ALTER, etc.
```

## 🔐 XSS (Cross-Site Scripting) Prevention

### What is XSS?

Attacker injects malicious JavaScript into web pages.

### Types

**1. Stored XSS**:
```
User posts: <script>steal_cookies()</script>
Stored in database
Executed when others view the post
```

**2. Reflected XSS**:
```
URL: https://example.com/search?q=<script>alert('XSS')</script>
Script reflected in page, executes immediately
```

**3. DOM-based XSS**:
```javascript
// Vulnerable code
document.getElementById('div').innerHTML = userInput;
```

### Prevention

**1. Output Encoding**:
```python
from html import escape

# Escape HTML
safe_content = escape(user_input)
# < becomes &lt;
# > becomes &gt;
# & becomes &amp;
```

**2. Content Security Policy**:
```http
Content-Security-Policy: default-src 'self'; script-src 'self' https://trusted.cdn.com
```

**3. HTTPOnly Cookies**:
```http
Set-Cookie: sessionId=abc123; HttpOnly; Secure
```

**4. X-XSS-Protection Header**:
```http
X-XSS-Protection: 1; mode=block
```

**5. Sanitize Rich Text**:
```python
import bleach

allowed_tags = ['p', 'br', 'strong', 'em']
clean_html = bleach.clean(user_html, tags=allowed_tags)
```

## 🛡️ Additional Security Measures

### HTTPS Only

```http
Strict-Transport-Security: max-age=31536000; includeSubDomains
```

### Security Headers

```http
# Prevent clickjacking
X-Frame-Options: DENY

# Prevent MIME sniffing
X-Content-Type-Options: nosniff

# Referrer policy
Referrer-Policy: no-referrer-when-downgrade
```

### API Keys Security

```python
# Don't expose in code
API_KEY = os.environ.get('API_KEY')

# Use separate keys for different environments
if os.environ.get('ENV') == 'production':
    API_KEY = os.environ.get('PROD_API_KEY')
else:
    API_KEY = os.environ.get('DEV_API_KEY')
```

### Error Messages

**Bad** (leaks information):
```json
{
  "error": "SQL error: table 'users' doesn't exist at line 42"
}
```

**Good** (generic):
```json
{
  "error": "An error occurred processing your request",
  "request_id": "abc123"
}
```

## 🧪 Hands-On Exercises

### Exercise 1: Test SQL Injection

```bash
# Try to inject SQL
curl "http://localhost:5000/users?email=' OR '1'='1"

# Should be prevented by parameterized queries
```

### Exercise 2: Test Rate Limiting

```bash
# Send many requests quickly
for i in {1..100}; do
  curl http://localhost:5000/api/data
done

# Should eventually return 429 Too Many Requests
```

### Exercise 3: Test CORS

```html
<!-- Create test.html -->
<script>
fetch('http://localhost:5000/api/data')
  .then(r => r.json())
  .then(console.log)
  .catch(console.error);
</script>

<!-- Open in browser, check console for CORS errors -->
```

## 🎯 Security Checklist

- [ ] Validate all input (type, length, format)
- [ ] Use parameterized queries
- [ ] Implement rate limiting
- [ ] Configure CORS properly
- [ ] Escape output (prevent XSS)
- [ ] Use HTTPS
- [ ] Set security headers
- [ ] Hash passwords (bcrypt/argon2)
- [ ] Use HTTPOnly cookies
- [ ] Implement authentication
- [ ] Log security events
- [ ] Keep dependencies updated
- [ ] Regular security audits

## 🎯 Key Takeaways

1. **Input Validation**: Never trust user input
2. **Rate Limiting**: Protect against abuse
3. **CORS**: Control cross-origin access
4. **SQL Injection**: Use parameterized queries
5. **XSS**: Escape output, use CSP
6. **Defense in Depth**: Multiple layers of security

## 📖 Next Steps

➡️ [Module 10: WebSockets](../10-WebSockets/)

## 🔗 Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP API Security Top 10](https://owasp.org/www-project-api-security/)
- [Content Security Policy Reference](https://content-security-policy.com/)
- [Security Headers](https://securityheaders.com/)
