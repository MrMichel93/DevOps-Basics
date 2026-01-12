# Interview Preparation

## 🎯 Purpose

Common networking and API interview questions with comprehensive answers.

## 📡 Networking Fundamentals

### Q: What is the difference between TCP and UDP?

**Answer**:
- **TCP (Transmission Control Protocol)**: Connection-oriented, reliable, ordered delivery, error checking, slower. Used for HTTP, email, file transfer.
- **UDP (User Datagram Protocol)**: Connectionless, fast, no delivery guarantee, no ordering. Used for streaming, gaming, DNS.

**When to use each**:
- TCP: When accuracy matters (web pages, emails, file downloads)
- UDP: When speed matters (video calls, gaming, live streams)

### Q: Explain the OSI model.

**Answer**: 7-layer model describing network communication:

1. **Physical**: Cables, signals
2. **Data Link**: MAC addresses, switches (Ethernet, WiFi)
3. **Network**: IP addresses, routing (IP, ICMP)
4. **Transport**: End-to-end connections (TCP, UDP)
5. **Session**: Managing connections
6. **Presentation**: Data format, encryption
7. **Application**: User-facing protocols (HTTP, FTP, SMTP)

**Practical example**: Sending an email
- Application: SMTP protocol
- Transport: TCP ensures reliable delivery
- Network: IP routes across Internet
- Data Link: Ethernet/WiFi on local network
- Physical: Electrical signals on cables

### Q: What happens when you type a URL in a browser?

**Answer**:

1. **DNS Lookup**: Browser resolves domain to IP address
2. **TCP Connection**: Three-way handshake with server
3. **TLS Handshake** (if HTTPS): Establish encrypted connection
4. **HTTP Request**: Browser sends GET request
5. **Server Processing**: Server generates response
6. **HTTP Response**: Server sends HTML
7. **Rendering**: Browser parses HTML, loads CSS/JS/images
8. **Additional Requests**: For each resource (CSS, JS, images)
9. **Page Display**: Browser renders final page

### Q: What is DNS and how does it work?

**Answer**: DNS (Domain Name System) translates domain names to IP addresses.

**Process**:
1. Check browser cache
2. Check OS cache
3. Ask DNS resolver (ISP)
4. Resolver asks root servers
5. Root directs to TLD servers (.com)
6. TLD directs to authoritative server
7. Authoritative server returns IP
8. IP cached at each level

**Record types**:
- A: IPv4 address
- AAAA: IPv6 address
- CNAME: Alias
- MX: Mail server
- TXT: Text records

## 🌐 HTTP/HTTPS

### Q: What is the difference between HTTP and HTTPS?

**Answer**:
- **HTTP**: Unencrypted, port 80, data sent in plain text, vulnerable to interception
- **HTTPS**: Encrypted with SSL/TLS, port 443, secure, required for sensitive data

**Why HTTPS matters**:
- Encrypts data in transit
- Verifies server identity
- Prevents man-in-the-middle attacks
- Required for modern browser features
- SEO benefits

### Q: Explain HTTP methods and their uses.

**Answer**:
- **GET**: Retrieve data, idempotent, cacheable, no body
- **POST**: Create resource, not idempotent, has body
- **PUT**: Update/replace resource, idempotent, has body
- **PATCH**: Partial update, may not be idempotent, has body
- **DELETE**: Remove resource, idempotent, usually no body
- **HEAD**: Like GET but only headers, no body
- **OPTIONS**: Get allowed methods (CORS)

**Idempotent**: Multiple identical requests have same effect as one

### Q: What are HTTP status codes? Give examples.

**Answer**:

**2xx Success**:
- 200 OK: Request succeeded
- 201 Created: Resource created
- 204 No Content: Success, no response body

**3xx Redirection**:
- 301 Moved Permanently: Resource moved permanently
- 302 Found: Temporary redirect
- 304 Not Modified: Use cached version

**4xx Client Errors**:
- 400 Bad Request: Invalid request
- 401 Unauthorized: Authentication required
- 403 Forbidden: No permission
- 404 Not Found: Resource doesn't exist
- 429 Too Many Requests: Rate limited

**5xx Server Errors**:
- 500 Internal Server Error: Generic server error
- 502 Bad Gateway: Upstream server error
- 503 Service Unavailable: Server down

### Q: What are HTTP headers? Give examples.

**Answer**: Metadata sent with requests/responses

**Request Headers**:
- `Authorization`: Authentication credentials
- `Content-Type`: Body format (application/json)
- `Accept`: Desired response format
- `User-Agent`: Client information

**Response Headers**:
- `Content-Type`: Response format
- `Cache-Control`: Caching directives
- `Set-Cookie`: Set cookies
- `Access-Control-Allow-Origin`: CORS

**Security Headers**:
- `Strict-Transport-Security`: Force HTTPS
- `X-Content-Type-Options`: Prevent MIME sniffing
- `Content-Security-Policy`: XSS protection

## 🔌 REST APIs

### Q: What is REST?

**Answer**: REST (Representational State Transfer) is an architectural style for designing networked applications.

**Principles**:
1. **Client-Server**: Separation of concerns
2. **Stateless**: Each request contains all needed information
3. **Cacheable**: Responses can be cached
4. **Uniform Interface**: Consistent way to interact
5. **Layered System**: Client can't tell if connected directly
6. **Code on Demand** (optional): Server can send executable code

**RESTful characteristics**:
- Resource-based URLs (`/users/123`)
- HTTP methods for operations
- Standard status codes
- JSON/XML responses
- Stateless communication

### Q: How would you design a RESTful API for a blog?

**Answer**:

```
Resources: Posts, Comments, Authors

Endpoints:
GET    /posts              - List all posts
POST   /posts              - Create post
GET    /posts/{id}         - Get specific post
PUT    /posts/{id}         - Update post
DELETE /posts/{id}         - Delete post
GET    /posts/{id}/comments - Get post comments
POST   /posts/{id}/comments - Add comment

Query parameters:
/posts?author=john&sort=date&limit=10

Response format:
{
  "data": [...],
  "meta": {
    "page": 1,
    "total": 50
  }
}
```

**Design decisions**:
- Use nouns, not verbs
- Plural names
- Nested resources for relationships
- Query params for filtering/sorting
- Consistent error format
- Versioning (`/v1/posts`)

### Q: What is the difference between PUT and PATCH?

**Answer**:
- **PUT**: Replaces entire resource, idempotent, send all fields
- **PATCH**: Partial update, only changed fields, may not be idempotent

**Example**:

User: `{"name": "John", "email": "john@example.com", "age": 30}`

PUT request (must send all fields):
```json
{
  "name": "John Smith",
  "email": "john@example.com",
  "age": 30
}
```

PATCH request (only changed fields):
```json
{
  "name": "John Smith"
}
```

## 🔐 Authentication & Security

### Q: Explain different authentication methods.

**Answer**:

**1. Session-Based**:
- Server stores session
- Cookie sent to client
- Client includes cookie in requests
- Server validates session

**2. Token-Based (JWT)**:
- Server generates signed token
- Client stores token
- Client sends in Authorization header
- Server verifies signature (stateless)

**3. OAuth 2.0**:
- Third-party authorization
- User grants permission
- Client gets access token
- Used for "Sign in with Google/GitHub"

**4. API Keys**:
- Simple identifier
- Good for server-to-server
- Limited to identifying client

### Q: What is JWT and how does it work?

**Answer**: JWT (JSON Web Token) is a compact, self-contained token for securely transmitting information.

**Structure**: `header.payload.signature`

**Example**:
```
Header: {"alg": "HS256", "typ": "JWT"}
Payload: {"sub": "123", "name": "John", "exp": 1700000000}
Signature: HMACSHA256(header + payload, secret)
```

**Flow**:
1. User logs in
2. Server verifies credentials
3. Server generates JWT with user data
4. Client stores JWT
5. Client sends JWT in requests: `Authorization: Bearer <token>`
6. Server verifies signature
7. Server extracts user info from payload

**Pros**: Stateless, scalable, cross-domain
**Cons**: Can't revoke until expiry, larger than session ID

### Q: What is CORS and why is it important?

**Answer**: CORS (Cross-Origin Resource Sharing) is a browser security feature that restricts cross-origin HTTP requests.

**Problem it solves**:
```
Website A (https://example.com)
Cannot call API B (https://api.other.com)
Blocked by browser for security
```

**Solution**: Server B sends CORS headers:
```
Access-Control-Allow-Origin: https://example.com
Access-Control-Allow-Methods: GET, POST
Access-Control-Allow-Headers: Content-Type
```

**Preflight request** (OPTIONS):
Browser asks: "Can I make this request?"
Server responds: "Yes, from these origins"

**Common issues**:
- Wildcard (`*`) doesn't work with credentials
- Need to handle OPTIONS requests
- Check headers match what's allowed

### Q: How do you prevent SQL injection?

**Answer**:

**Vulnerable code**:
```python
query = f"SELECT * FROM users WHERE email = '{email}'"
```

**Attack**: `email = ' OR '1'='1`

**Prevention**:

1. **Parameterized queries** (best):
```python
query = "SELECT * FROM users WHERE email = ?"
db.execute(query, (email,))
```

2. **ORM** (recommended):
```python
User.query.filter_by(email=email).first()
```

3. **Input validation**:
```python
if not is_valid_email(email):
    return error("Invalid email")
```

4. **Least privilege**: Database user should have minimal permissions

### Q: What is XSS and how do you prevent it?

**Answer**: XSS (Cross-Site Scripting) is injecting malicious JavaScript into web pages.

**Types**:
- **Stored**: Saved in database, affects all users
- **Reflected**: In URL, immediate execution
- **DOM-based**: Manipulates page DOM

**Example attack**:
```javascript
Comment: <script>steal_cookies()</script>
```

**Prevention**:

1. **Output encoding**:
```python
from html import escape
safe_content = escape(user_input)
```

2. **Content Security Policy**:
```
Content-Security-Policy: default-src 'self'
```

3. **HTTPOnly cookies**:
```
Set-Cookie: session=abc; HttpOnly; Secure
```

4. **Sanitize rich text**:
```python
import bleach
clean = bleach.clean(html, tags=['p', 'b'])
```

## 🔄 Real-Time Communication

### Q: When would you use WebSockets vs HTTP?

**Answer**:

**Use WebSockets for**:
- Chat applications
- Live feeds
- Collaborative editing
- Real-time gaming
- Live sports scores
- Instant notifications

**Use HTTP for**:
- Standard CRUD operations
- RESTful APIs
- Infrequent updates
- Cacheable data
- Simple request-response

**WebSocket advantages**:
- Bidirectional communication
- Lower latency
- Less overhead after connection
- Server can push data

**HTTP advantages**:
- Simpler to implement
- Better caching
- Better for debugging
- Works with existing infrastructure

## 💡 Practical Scenarios

### Q: How would you debug a 500 error from an API?

**Answer**:

1. **Check server logs**: What's the actual error?
2. **Reproduce**: Can you make it happen again?
3. **Simplify**: Minimal request that triggers error
4. **Check recent changes**: What changed recently?
5. **Verify data**: Is input valid?
6. **Check dependencies**: Database, external APIs up?
7. **Check resources**: Out of memory/disk?
8. **Use verbose mode**: `curl -v` to see full request
9. **Check status of services**: All systems operational?

### Q: API is slow. How do you investigate?

**Answer**:

1. **Measure**: Use timing in DevTools/curl
2. **Identify bottleneck**:
   - Network latency?
   - Database queries?
   - External API calls?
   - CPU/memory usage?
3. **Solutions**:
   - Add caching
   - Optimize database queries
   - Add indexes
   - Use CDN
   - Implement pagination
   - Async processing
   - Load balancing

### Q: How do you handle rate limiting?

**Answer**:

**As API provider**:
- Implement rate limiting (e.g., 100 req/hour)
- Return 429 status code
- Include headers:
  ```
  X-RateLimit-Limit: 100
  X-RateLimit-Remaining: 10
  X-RateLimit-Reset: 1700000000
  Retry-After: 3600
  ```

**As API consumer**:
- Respect rate limits
- Parse rate limit headers
- Implement exponential backoff
- Cache responses when possible
- Batch requests
- Use webhooks instead of polling

## 🎯 Behavioral Questions

### Q: Describe a time you had to debug a complex networking issue.

**Structure your answer**:
1. **Situation**: What was the problem?
2. **Task**: What needed to be done?
3. **Action**: What steps did you take?
4. **Result**: What was the outcome?

**Example**:
"Users reported slow API responses. I used DevTools to measure response times, identified slow database queries, added indexes, implemented caching, and reduced average response time from 2s to 200ms."

## 📚 Study Tips

1. **Practice with real APIs**: GitHub, JSONPlaceholder
2. **Build projects**: Implement concepts hands-on
3. **Use tools**: curl, Postman, DevTools
4. **Read RFCs**: Understand protocols deeply
5. **Follow blogs**: Stay updated on best practices
6. **Do coding challenges**: Practice problem-solving
7. **Mock interviews**: Practice explaining concepts

## 🔗 Resources

- [GeeksforGeeks - Networking Interview Questions](https://www.geeksforgeeks.org/networking-interview-questions/)
- [System Design Primer](https://github.com/donnemartin/system-design-primer)
- [LeetCode](https://leetcode.com/)
- [Pramp](https://www.pramp.com/) - Mock interviews
