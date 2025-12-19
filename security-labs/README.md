# Security Labs

## 🎯 Purpose

Hands-on security exercises to learn about vulnerabilities and how to prevent them.

⚠️ **Important**: These exercises are for educational purposes only. Only test on your own applications or with explicit permission.

## 🔒 Lab 1: SQL Injection

### Vulnerable Code Example

```python
# DON'T DO THIS!
@app.route('/user')
def get_user():
    email = request.args.get('email')
    query = f"SELECT * FROM users WHERE email = '{email}'"
    result = db.execute(query)
    return jsonify(result)
```

### Attack Scenario

```bash
# Normal request
curl "http://localhost:5000/user?email=john@example.com"

# SQL Injection attack
curl "http://localhost:5000/user?email=' OR '1'='1"
# Query becomes: SELECT * FROM users WHERE email = '' OR '1'='1'
# Returns ALL users!
```

### Fix

```python
# Use parameterized queries
@app.route('/user')
def get_user():
    email = request.args.get('email')
    query = "SELECT * FROM users WHERE email = ?"
    result = db.execute(query, (email,))
    return jsonify(result)
```

### Exercise

1. Set up vulnerable endpoint
2. Test normal query
3. Try SQL injection attacks
4. Implement parameterized queries
5. Verify injection no longer works

## 🔐 Lab 2: Cross-Site Scripting (XSS)

### Vulnerable Code Example

```python
# DON'T DO THIS!
@app.route('/comment', methods=['POST'])
def add_comment():
    comment = request.form['comment']
    # Store in database
    db.execute('INSERT INTO comments (text) VALUES (?)', (comment,))
    return redirect('/comments')

@app.route('/comments')
def show_comments():
    comments = db.execute('SELECT text FROM comments').fetchall()
    # Render without escaping!
    html = '<div>'
    for comment in comments:
        html += f'<p>{comment[0]}</p>'
    html += '</div>'
    return html
```

### Attack Scenario

```bash
# Attacker posts malicious comment
curl -X POST http://localhost:5000/comment \
  -d 'comment=<script>alert("XSS")</script>'

# Now when anyone views comments, script executes!
```

### Fix

```python
from html import escape

@app.route('/comments')
def show_comments():
    comments = db.execute('SELECT text FROM comments').fetchall()
    html = '<div>'
    for comment in comments:
        # Escape HTML
        safe_comment = escape(comment[0])
        html += f'<p>{safe_comment}</p>'
    html += '</div>'
    return html
```

### Exercise

1. Create comment system
2. Post normal comment
3. Try XSS injection
4. Implement HTML escaping
5. Verify script tags are escaped

## 🚫 Lab 3: Broken Authentication

### Vulnerable Code Example

```python
# DON'T DO THIS!
@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    
    # Storing plain text password!
    user = db.execute(
        'SELECT * FROM users WHERE username = ? AND password = ?',
        (username, password)
    ).fetchone()
    
    if user:
        session['user_id'] = user[0]
        return redirect('/dashboard')
    return 'Invalid credentials', 401
```

### Problems

1. Passwords stored in plain text
2. No rate limiting
3. Weak session management

### Fix

```python
import bcrypt
from flask_limiter import Limiter

limiter = Limiter(app)

@app.route('/register', methods=['POST'])
def register():
    username = request.form['username']
    password = request.form['password']
    
    # Hash password
    hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
    
    db.execute(
        'INSERT INTO users (username, password_hash) VALUES (?, ?)',
        (username, hashed)
    )
    return 'User created', 201

@app.route('/login', methods=['POST'])
@limiter.limit("5 per minute")  # Rate limiting
def login():
    username = request.form['username']
    password = request.form['password']
    
    user = db.execute(
        'SELECT id, password_hash FROM users WHERE username = ?',
        (username,)
    ).fetchone()
    
    if user and bcrypt.checkpw(password.encode(), user[1]):
        session['user_id'] = user[0]
        return redirect('/dashboard')
    
    return 'Invalid credentials', 401
```

### Exercise

1. Create login system with plain text passwords
2. Try logging in
3. Check database - see passwords in clear text
4. Implement bcrypt hashing
5. Add rate limiting
6. Test brute force protection

## 🔑 Lab 4: Broken Authorization

### Vulnerable Code Example

```python
# DON'T DO THIS!
@app.route('/post/<int:post_id>', methods=['DELETE'])
def delete_post(post_id):
    # No authorization check!
    db.execute('DELETE FROM posts WHERE id = ?', (post_id,))
    return 'Deleted', 204
```

### Attack Scenario

```bash
# User 1 creates post (gets id=1)
curl -X POST http://localhost:5000/posts -d 'content=My post' -H 'Cookie: user=1'

# User 2 can delete User 1's post!
curl -X DELETE http://localhost:5000/post/1 -H 'Cookie: user=2'
```

### Fix

```python
@app.route('/post/<int:post_id>', methods=['DELETE'])
def delete_post(post_id):
    user_id = session.get('user_id')
    if not user_id:
        return 'Unauthorized', 401
    
    # Check ownership
    post = db.execute(
        'SELECT author_id FROM posts WHERE id = ?',
        (post_id,)
    ).fetchone()
    
    if not post:
        return 'Not found', 404
    
    if post[0] != user_id:
        return 'Forbidden', 403
    
    db.execute('DELETE FROM posts WHERE id = ?', (post_id,))
    return 'Deleted', 204
```

### Exercise

1. Create multi-user system
2. Let users create posts
3. Try deleting other users' posts (should fail!)
4. Implement authorization checks
5. Test with different user scenarios

## 🔐 Lab 5: Insecure Direct Object Reference (IDOR)

### Vulnerable Code Example

```python
# DON'T DO THIS!
@app.route('/profile/<int:user_id>')
def view_profile(user_id):
    # Anyone can view any profile by changing ID!
    user = db.execute(
        'SELECT * FROM users WHERE id = ?',
        (user_id,)
    ).fetchone()
    return jsonify(user)
```

### Attack Scenario

```bash
# View your profile
curl http://localhost:5000/profile/123

# View someone else's profile by guessing ID
curl http://localhost:5000/profile/124
curl http://localhost:5000/profile/125
# etc.
```

### Fix Option 1: Check Ownership

```python
@app.route('/profile/<int:user_id>')
def view_profile(user_id):
    current_user_id = session.get('user_id')
    
    # Only allow viewing own profile
    if user_id != current_user_id:
        return 'Forbidden', 403
    
    user = db.execute(
        'SELECT * FROM users WHERE id = ?',
        (user_id,)
    ).fetchone()
    return jsonify(user)
```

### Fix Option 2: Use Non-Sequential IDs

```python
import uuid

# Use UUIDs instead of sequential IDs
@app.route('/register', methods=['POST'])
def register():
    user_id = str(uuid.uuid4())
    # Store with UUID
    db.execute(
        'INSERT INTO users (id, username) VALUES (?, ?)',
        (user_id, username)
    )
```

### Exercise

1. Create user profiles with sequential IDs
2. Try accessing different user IDs
3. Implement ownership checks
4. Try again (should fail)
5. Optionally implement UUIDs

## 🚦 Lab 6: Rate Limiting Bypass

### Vulnerable Code Example

```python
# Basic rate limiting by IP
rate_limits = {}

@app.route('/api/data')
def get_data():
    ip = request.remote_addr
    
    # Count requests
    if ip in rate_limits:
        if rate_limits[ip] > 100:
            return 'Rate limited', 429
        rate_limits[ip] += 1
    else:
        rate_limits[ip] = 1
    
    return jsonify({'data': '...'})
```

### Attack Scenario

```bash
# Attacker changes IP or uses proxies to bypass
curl http://localhost:5000/api/data -H "X-Forwarded-For: 1.2.3.4"
curl http://localhost:5000/api/data -H "X-Forwarded-For: 5.6.7.8"
# etc.
```

### Fix

```python
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(
    app,
    key_func=get_remote_address,
    default_limits=["100 per hour"]
)

@app.route('/api/data')
@limiter.limit("10 per minute")
def get_data():
    return jsonify({'data': '...'})
```

### Exercise

1. Implement basic rate limiting
2. Try to bypass with headers
3. Use proper rate limiting library
4. Test with many requests
5. Verify proper blocking

## 🧪 Security Testing Checklist

### For Each Lab:

- [ ] **Understand the vulnerability**: What's wrong?
- [ ] **Reproduce the attack**: Can you exploit it?
- [ ] **Implement the fix**: Apply security measure
- [ ] **Verify the fix**: Confirm exploit no longer works
- [ ] **Document**: Write notes on what you learned

## 🎯 Additional Challenges

### Challenge 1: CSRF Protection

Implement Cross-Site Request Forgery protection:

```python
from flask_wtf.csrf import CSRFProtect

csrf = CSRFProtect(app)

@app.route('/transfer', methods=['POST'])
@csrf.protect
def transfer_money():
    # CSRF token automatically validated
    # Malicious sites can't forge requests
    return 'Transfer successful'
```

### Challenge 2: Password Security

Implement strong password requirements:

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
    return True
```

### Challenge 3: API Security Headers

Implement all security headers:

```python
@app.after_request
def set_security_headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    response.headers['Strict-Transport-Security'] = 'max-age=31536000'
    response.headers['Content-Security-Policy'] = "default-src 'self'"
    return response
```

## ⚠️ Important Reminders

1. **Only test on your own applications**
2. **Never use these techniques maliciously**
3. **Report vulnerabilities responsibly**
4. **Keep learning about new threats**
5. **Security is an ongoing process**

## 🔗 Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)
- [HackTheBox](https://www.hackthebox.com/)
- [OWASP WebGoat](https://owasp.org/www-project-webgoat/)
