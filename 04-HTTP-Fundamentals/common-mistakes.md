# Common Mistakes in HTTP Fundamentals

## Beginner Mistakes

### Mistake 1: Not Understanding HTTP Methods Properly

**What people do:**
Use GET for everything or use POST when other methods are more appropriate.

**Why it's a problem:**
- Violates HTTP semantics
- Security issues (GET with side effects)
- Caching problems
- Poor API design
- Browser history exposes sensitive data

**The right way:**
Use appropriate HTTP methods:

```http
GET /users/123        # Retrieve resource (safe, idempotent)
POST /users           # Create new resource
PUT /users/123        # Replace entire resource (idempotent)
PATCH /users/123      # Partial update
DELETE /users/123     # Delete resource (idempotent)
HEAD /users/123       # Get headers only
OPTIONS /users        # Get allowed methods
```

**How to fix if you've already done this:**
Update to use correct methods:

```python
# Bad ❌
@app.route('/delete_user')  # GET with side effects
def delete_user():
    user_id = request.args.get('id')
    delete_user(user_id)

# Good ✅
@app.route('/users/<user_id>', methods=['DELETE'])
def delete_user(user_id):
    delete_user(user_id)
```

**Red flags to watch for:**
- All routes using GET
- POST for read operations
- Side effects in GET requests
- Sensitive data in URL parameters
- Not using DELETE for deletions

---

### Mistake 2: Not Understanding HTTP Status Codes

**What people do:**
Return 200 OK for everything, even errors, or use wrong status codes.

**Why it's a problem:**
- Clients can't handle responses properly
- Breaks HTTP semantics
- Poor error handling
- Confuses API consumers
- Monitoring issues

**The right way:**
Use appropriate status codes:

```python
# Success
200 OK - Successful GET, PUT, PATCH
201 Created - Successful POST
204 No Content - Successful DELETE
304 Not Modified - Cached response valid

# Client Errors
400 Bad Request - Invalid request
401 Unauthorized - Authentication required
403 Forbidden - No permission
404 Not Found - Resource doesn't exist
409 Conflict - Resource conflict
422 Unprocessable Entity - Validation error

# Server Errors  
500 Internal Server Error - Server fault
502 Bad Gateway - Upstream error
503 Service Unavailable - Temporary outage
504 Gateway Timeout - Upstream timeout

# Example
@app.route('/users/<user_id>')
def get_user(user_id):
    user = User.query.get(user_id)
    if not user:
        abort(404)  # Not 200 with error message
    return jsonify(user.to_dict()), 200
```

**How to fix if you've already done this:**
Return proper status codes:

```python
# Bad ❌
return {"error": "Not found"}, 200

# Good ✅
return {"error": "User not found"}, 404
```

**Red flags to watch for:**
- All responses return 200
- Errors with 200 status
- Success with 500 status
- Using only 200 and 500
- Not checking status codes in clients

---

### Mistake 3: Not Setting Proper Content-Type Headers

**What people do:**
Don't set Content-Type header or use wrong type for response data.

**Why it's a problem:**
- Clients misinterpret response
- Security vulnerabilities (MIME sniffing)
- Broken API consumers
- Character encoding issues
- Wrong data parsing

**The right way:**
Set correct Content-Type:

```python
from flask import Response, jsonify

# JSON
@app.route('/api/users')
def get_users():
    return jsonify(users)  # Automatically sets application/json

# Or manually
response = Response(json.dumps(data), mimetype='application/json')

# Common content types
application/json     # JSON data
text/html           # HTML pages
text/plain          # Plain text
application/xml     # XML data
multipart/form-data # File uploads
application/x-www-form-urlencoded  # Form data

# With charset
Content-Type: application/json; charset=utf-8
```

**How to fix if you've already done this:**
Add Content-Type headers:

```python
# Set default for all routes
@app.after_request
def set_content_type(response):
    if not response.content_type:
        response.content_type = 'application/json'
    return response
```

**Red flags to watch for:**
- No Content-Type header
- text/html for JSON responses
- Character encoding issues
- MIME type mismatches
- Client parsing errors

---

### Mistake 4: Not Understanding Request Headers

**What people do:**
Ignore important request headers or don't know what they mean.

**Why it's a problem:**
- Miss content negotiation
- Ignore client capabilities
- Security issues
- Poor caching
- Broken functionality

**The right way:**
Use headers properly:

```python
from flask import request

# Check headers
@app.route('/api/data')
def get_data():
    # Content negotiation
    if request.headers.get('Accept') == 'application/xml':
        return generate_xml(data)
    return jsonify(data)
    
    # Authentication
    auth_header = request.headers.get('Authorization')
    if not auth_header:
        abort(401)
    
    # CORS
    origin = request.headers.get('Origin')
    
    # User agent
    user_agent = request.headers.get('User-Agent')
    
    # Custom headers
    request_id = request.headers.get('X-Request-ID')

# Common request headers
Accept: application/json
Content-Type: application/json
Authorization: Bearer <token>
User-Agent: Mozilla/5.0...
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
```

**How to fix if you've already done this:**
Start using headers:

```python
# Read and respect headers
# Implement content negotiation
# Check Authorization
# Add custom headers for tracing
```

**Red flags to watch for:**
- Ignoring Accept header
- Not checking Authorization
- Missing content negotiation
- No compression support
- Not using custom headers for tracking

---

### Mistake 5: Not Implementing Proper Caching

**What people do:**
Don't set cache headers or cache inappropriately.

**Why it's a problem:**
- Unnecessary server load
- Slow response times
- Stale data served
- High bandwidth costs
- Poor user experience

**The right way:**
Use caching headers:

```python
from flask import make_response
from datetime import datetime, timedelta

@app.route('/api/static-content')
def static_content():
    response = make_response(jsonify(data))
    
    # Cache for 1 hour
    response.headers['Cache-Control'] = 'public, max-age=3600'
    
    # Set expiry
    expires = datetime.utcnow() + timedelta(hours=1)
    response.headers['Expires'] = expires.strftime('%a, %d %b %Y %H:%M:%S GMT')
    
    # ETag for validation
    response.headers['ETag'] = generate_etag(data)
    
    return response

@app.route('/api/dynamic-content')
def dynamic_content():
    response = make_response(jsonify(data))
    
    # Don't cache
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    
    return response

# Handle conditional requests
@app.route('/api/resource')
def get_resource():
    etag = generate_etag(resource)
    
    if request.headers.get('If-None-Match') == etag:
        return '', 304  # Not Modified
    
    response = make_response(jsonify(resource))
    response.headers['ETag'] = etag
    return response
```

**How to fix if you've already done this:**
Add caching headers:

```python
# For static content: long cache
# For dynamic content: no cache or short cache
# Use ETags for validation
# Implement 304 responses
```

**Red flags to watch for:**
- No Cache-Control headers
- Caching user-specific data
- Not using ETags
- Always downloading full resources
- High server load from repeated requests

---

## Intermediate Mistakes

### Mistake 6: Not Handling CORS Properly

**What people do:**
Don't understand CORS or use `Access-Control-Allow-Origin: *` everywhere.

**Why it's a problem:**
- Security vulnerabilities
- Can't make cross-origin requests
- Credential leakage
- API abuse
- Poor security posture

**The right way:**
Configure CORS properly:

```python
from flask_cors import CORS

# Specific origins
app = Flask(__name__)
CORS(app, origins=['https://example.com', 'https://app.example.com'])

# Or manually
@app.after_request
def add_cors_headers(response):
    origin = request.headers.get('Origin')
    allowed_origins = ['https://example.com', 'https://app.example.com']
    
    if origin in allowed_origins:
        response.headers['Access-Control-Allow-Origin'] = origin
        response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE'
        response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
        response.headers['Access-Control-Allow-Credentials'] = 'true'
    
    return response

# Handle preflight
@app.route('/api/endpoint', methods=['OPTIONS'])
def options_handler():
    return '', 204
```

**How to fix if you've already done this:**
Restrict CORS:

```python
# Remove wildcard * for credentials
# Whitelist specific origins
# Set appropriate methods and headers
# Handle preflight requests
```

**Red flags to watch for:**
- `Access-Control-Allow-Origin: *` with credentials
- CORS errors in browser
- Overly permissive CORS
- Not handling OPTIONS requests
- Security audit failures

---

### Mistake 7: Not Using HTTPS

**What people do:**
Use HTTP instead of HTTPS in production.

**Why it's a problem:**
- Data transmitted in plain text
- Credentials exposed
- Man-in-the-middle attacks
- Session hijacking
- SEO penalties
- Browser warnings

**The right way:**
Use HTTPS everywhere:

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
    
    # HSTS header
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
}
```

**How to fix if you've already done this:**
Enable HTTPS:

```bash
# Get SSL certificate
certbot --nginx -d example.com

# Configure redirect
# Update all links
# Enable HSTS
# Test configuration
```

**Red flags to watch for:**
- HTTP in production
- Mixed content warnings
- Login over HTTP
- No SSL certificate
- Browser security warnings

---

### Mistake 8: Not Understanding Idempotency

**What people do:**
Don't make PUT and DELETE idempotent or make GET non-idempotent.

**Why it's a problem:**
- Duplicate operations on retry
- Inconsistent state
- Broken clients
- Poor reliability
- Can't safely retry requests

**The right way:**
Ensure idempotency:

```python
# Idempotent operations (same result when repeated)
@app.route('/users/<user_id>', methods=['GET'])  # Always idempotent
def get_user(user_id):
    return User.query.get_or_404(user_id)

@app.route('/users/<user_id>', methods=['PUT'])  # Should be idempotent
def update_user(user_id):
    user = User.query.get_or_404(user_id)
    user.name = request.json['name']
    user.email = request.json['email']
    db.session.commit()
    return jsonify(user.to_dict())

@app.route('/users/<user_id>', methods=['DELETE'])  # Should be idempotent
def delete_user(user_id):
    user = User.query.get(user_id)
    if user:
        db.session.delete(user)
        db.session.commit()
    return '', 204  # Same result if deleted multiple times

# Non-idempotent (use POST)
@app.route('/users', methods=['POST'])
def create_user():
    # Creates new user each time
    user = User(**request.json)
    db.session.add(user)
    db.session.commit()
    return jsonify(user.to_dict()), 201

# Make POST idempotent with idempotency key
@app.route('/payments', methods=['POST'])
def create_payment():
    idempotency_key = request.headers.get('Idempotency-Key')
    if not idempotency_key:
        abort(400, 'Idempotency-Key required')
    
    # Check if already processed
    existing = Payment.query.filter_by(idempotency_key=idempotency_key).first()
    if existing:
        return jsonify(existing.to_dict()), 200
    
    # Process payment
    payment = create_payment(request.json)
    payment.idempotency_key = idempotency_key
    db.session.add(payment)
    db.session.commit()
    return jsonify(payment.to_dict()), 201
```

**How to fix if you've already done this:**
Implement idempotency:

```python
# Make PUT/DELETE idempotent
# Use idempotency keys for POST
# Don't change state in GET
# Handle retries safely
```

**Red flags to watch for:**
- Duplicate records from retries
- GET requests changing state
- PUT creating duplicates
- Can't safely retry operations
- Inconsistent state from network errors

---

## Advanced Pitfalls

### Mistake 9: Not Implementing Rate Limiting

**What people do:**
Allow unlimited requests without rate limiting.

**Why it's a problem:**
- DDoS vulnerabilities
- Resource exhaustion
- API abuse
- Unfair usage
- Service degradation

**The right way:**
Implement rate limiting:

```python
from flask_limiter import Limiter

limiter = Limiter(
    app,
    key_func=lambda: request.remote_addr,
    default_limits=["1000 per day", "100 per hour"]
)

@app.route('/api/search')
@limiter.limit("10 per minute")
def search():
    # Expensive operation
    pass

# Return rate limit headers
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640000000

# Return 429 when exceeded
@app.errorhandler(429)
def rate_limit_exceeded(e):
    return {"error": "Rate limit exceeded"}, 429
```

**How to fix if you've already done this:**
Add rate limiting:

```python
# Choose rate limiting strategy
# Set appropriate limits
# Return proper headers
# Handle 429 responses
```

**Red flags to watch for:**
- No rate limiting
- API abuse
- Resource exhaustion
- DDoS attacks succeed
- Unfair resource distribution

---

### Mistake 10: Not Handling Redirects Properly

**What people do:**
Use wrong redirect status codes or create redirect loops.

**Why it's a problem:**
- Poor SEO
- Confused clients
- Redirect loops
- Lost POST data
- Broken bookmarks

**The right way:**
Use correct redirect codes:

```python
from flask import redirect, url_for

# Permanent redirect (301) - Use for moved resources
@app.route('/old-url')
def old_route():
    return redirect(url_for('new_route'), code=301)

# Temporary redirect (302/307) - Use for temporary moves
@app.route('/maintenance')
def under_maintenance():
    return redirect(url_for('maintenance_page'), code=302)

# See Other (303) - After POST to prevent resubmission
@app.route('/form', methods=['POST'])
def submit_form():
    process_form(request.form)
    return redirect(url_for('success'), code=303)

# Temporary redirect (307) - Preserves method
@app.route('/api/v1/resource')
def api_v1():
    return redirect(url_for('api_v2'), code=307)

# Prevent redirect loops
@app.route('/page1')
def page1():
    if some_condition:
        return redirect(url_for('page2'))
    # Don't redirect back to page1!
```

**How to fix if you've already done this:**
Use correct redirects:

```python
# 301 for permanent moves
# 302 for temporary
# 303 after POST
# 307 to preserve method
# Check for loops
```

**Red flags to watch for:**
- All redirects using 302
- Redirect loops
- POST data lost on redirect
- SEO issues from wrong codes
- Bookmarks to redirected URLs

---

## Prevention Checklist

### Request/Response Basics

- [ ] Use appropriate HTTP methods
- [ ] Return correct status codes
- [ ] Set Content-Type headers
- [ ] Read and respect request headers
- [ ] Implement content negotiation

### Security

- [ ] Use HTTPS everywhere
- [ ] Configure CORS properly
- [ ] Implement rate limiting
- [ ] Set security headers
- [ ] Validate all inputs

### Performance

- [ ] Use caching headers appropriately
- [ ] Implement compression
- [ ] Handle conditional requests
- [ ] Use CDN for static content
- [ ] Monitor response times

### API Design

- [ ] Follow HTTP semantics
- [ ] Ensure idempotency for PUT/DELETE
- [ ] Use appropriate redirect codes
- [ ] Version API properly
- [ ] Document all endpoints
