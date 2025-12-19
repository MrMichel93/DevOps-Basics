# Module 04: HTTP Fundamentals

## 🎯 Learning Objectives

- ✅ Understand the HTTP request-response cycle
- ✅ Master HTTP methods (GET, POST, PUT, DELETE, etc.)
- ✅ Know HTTP status codes and their meanings
- ✅ Work with HTTP headers effectively
- ✅ Understand HTTP versions and their differences

**Time Required**: 3-4 hours

## 📡 What is HTTP?

**HTTP** (Hypertext Transfer Protocol) is the foundation of data communication on the Web. It's an application-layer protocol that defines how messages are formatted and transmitted.

### Key Characteristics

- **Stateless**: Each request is independent
- **Client-Server**: Clear separation of concerns
- **Request-Response**: Communication pattern
- **Text-Based**: Human-readable (mostly)
- **Extensible**: Headers can carry any metadata

## 🔄 Request-Response Cycle

### HTTP Request Structure

```
METHOD /path HTTP/1.1
Header-Name: Header-Value
Another-Header: Another-Value

Optional request body
```

**Example**:
```http
GET /api/users/123 HTTP/1.1
Host: api.example.com
User-Agent: Mozilla/5.0
Accept: application/json
Authorization: Bearer token123
```

### HTTP Response Structure

```
HTTP/1.1 STATUS_CODE Status Message
Header-Name: Header-Value
Another-Header: Another-Value

Response body
```

**Example**:
```http
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 85
Date: Fri, 19 Dec 2025 10:00:00 GMT

{
  "id": 123,
  "name": "John Doe",
  "email": "john@example.com"
}
```

## 🔧 HTTP Methods

### GET - Retrieve Data

**Purpose**: Request data from a server

**Characteristics**:
- Should not modify data (idempotent and safe)
- Can be cached
- Parameters in URL query string
- Can be bookmarked

**Example**:
```bash
curl https://api.github.com/users/octocat
```

**Use cases**:
- Fetching a web page
- Getting user profile
- Searching products
- Loading API data

### POST - Create Data

**Purpose**: Submit data to create a new resource

**Characteristics**:
- Can modify server state
- Data in request body
- Not idempotent (repeating creates duplicates)
- Not cached by default

**Example**:
```bash
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Jane","email":"jane@example.com"}'
```

**Use cases**:
- Submitting a form
- Creating a new user
- Uploading a file
- Adding a comment

### PUT - Update/Replace Data

**Purpose**: Update or replace an existing resource

**Characteristics**:
- Idempotent (repeating has same effect)
- Replaces entire resource
- Data in request body

**Example**:
```bash
curl -X PUT https://api.example.com/users/123 \
  -H "Content-Type: application/json" \
  -d '{"name":"Jane Smith","email":"jane@example.com"}'
```

**Use cases**:
- Updating user profile
- Replacing a document
- Updating configuration

### PATCH - Partial Update

**Purpose**: Partially modify a resource

**Characteristics**:
- Only updates specified fields
- More efficient than PUT
- Not always idempotent

**Example**:
```bash
curl -X PATCH https://api.example.com/users/123 \
  -H "Content-Type: application/json" \
  -d '{"name":"Jane Smith"}'
```

### DELETE - Remove Data

**Purpose**: Delete a resource

**Characteristics**:
- Idempotent
- May return deleted resource in response
- No request body typically

**Example**:
```bash
curl -X DELETE https://api.example.com/users/123
```

### Other Methods

**HEAD**: Like GET but only returns headers (no body)
**OPTIONS**: Returns allowed methods for a resource (CORS)
**TRACE**: Echoes request back (debugging)
**CONNECT**: Establishes tunnel (used for HTTPS proxies)

## 📊 HTTP Status Codes

Status codes tell you the result of your request.

### 1xx - Informational

- **100 Continue**: Server received headers, continue with body
- **101 Switching Protocols**: Switching to WebSocket, etc.

### 2xx - Success

- **200 OK**: Request succeeded
- **201 Created**: Resource created successfully (POST)
- **202 Accepted**: Request accepted, processing not complete
- **204 No Content**: Success, but no content to return
- **206 Partial Content**: Partial GET (for resumable downloads)

### 3xx - Redirection

- **301 Moved Permanently**: Resource permanently moved
- **302 Found**: Temporary redirect
- **304 Not Modified**: Use cached version
- **307 Temporary Redirect**: Like 302, but method must not change
- **308 Permanent Redirect**: Like 301, but method must not change

### 4xx - Client Errors

- **400 Bad Request**: Malformed request
- **401 Unauthorized**: Authentication required
- **403 Forbidden**: Authenticated but not authorized
- **404 Not Found**: Resource doesn't exist
- **405 Method Not Allowed**: Wrong HTTP method
- **408 Request Timeout**: Client took too long
- **409 Conflict**: Request conflicts with current state
- **410 Gone**: Resource permanently deleted
- **413 Payload Too Large**: Request body too big
- **415 Unsupported Media Type**: Wrong Content-Type
- **429 Too Many Requests**: Rate limit exceeded

### 5xx - Server Errors

- **500 Internal Server Error**: Generic server error
- **501 Not Implemented**: Method not supported
- **502 Bad Gateway**: Invalid response from upstream server
- **503 Service Unavailable**: Server temporarily down
- **504 Gateway Timeout**: Upstream server timeout

### Common Status Codes Quick Reference

| Code | Meaning | What to do |
|------|---------|------------|
| 200 | Success | Continue |
| 201 | Created | Resource created successfully |
| 400 | Bad Request | Check your request data |
| 401 | Unauthorized | Add authentication |
| 403 | Forbidden | Check permissions |
| 404 | Not Found | Check URL/endpoint |
| 429 | Too Many Requests | Slow down, implement backoff |
| 500 | Server Error | Retry later or contact support |
| 503 | Service Unavailable | Server down, retry later |

## 📋 HTTP Headers

Headers provide metadata about requests and responses.

### Request Headers

**Common Request Headers**:

```http
# Who you are
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)

# What you want
Accept: application/json
Accept-Language: en-US,en;q=0.9
Accept-Encoding: gzip, deflate, br

# Where you came from
Referer: https://example.com/previous-page

# Authentication
Authorization: Bearer eyJhbGc...

# Caching
If-None-Match: "etag-value"
If-Modified-Since: Wed, 21 Oct 2015 07:28:00 GMT

# Content info (for POST/PUT)
Content-Type: application/json
Content-Length: 1234

# Custom headers (usually prefixed)
X-API-Key: your-api-key
X-Request-ID: uuid-here
```

### Response Headers

**Common Response Headers**:

```http
# Content info
Content-Type: application/json; charset=utf-8
Content-Length: 5678
Content-Encoding: gzip

# Caching
Cache-Control: max-age=3600, public
ETag: "686897696a7c876b7e"
Last-Modified: Wed, 21 Oct 2015 07:28:00 GMT
Expires: Thu, 01 Dec 2025 16:00:00 GMT

# Security
Strict-Transport-Security: max-age=31536000
X-Content-Type-Options: nosniff
X-Frame-Options: DENY

# CORS
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT
Access-Control-Allow-Headers: Content-Type

# Server info
Server: nginx/1.18.0
Date: Fri, 19 Dec 2025 10:00:00 GMT

# Location (redirects, created resources)
Location: https://api.example.com/users/123
```

### Important Header Categories

**1. Content Negotiation**
- `Accept`: What format client wants
- `Content-Type`: What format is being sent

**2. Authentication**
- `Authorization`: Credentials for access
- `WWW-Authenticate`: Authentication method required

**3. Caching**
- `Cache-Control`: Caching directives
- `ETag`: Resource version identifier

**4. CORS**
- `Access-Control-Allow-Origin`: Which origins can access
- `Access-Control-Allow-Methods`: Which methods allowed
- `Access-Control-Allow-Headers`: Which headers allowed

**5. Security**
- `Strict-Transport-Security`: Force HTTPS
- `Content-Security-Policy`: XSS protection
- `X-Frame-Options`: Clickjacking protection

## 🔢 HTTP Versions

### HTTP/1.1 (1997-present)

**Features**:
- Persistent connections (keep-alive)
- Chunked transfer encoding
- Host header (multiple domains on one IP)
- Caching

**Limitations**:
- Head-of-line blocking (requests queued)
- Lots of header redundancy
- Uncompressed headers

### HTTP/2 (2015)

**Improvements**:
- Binary protocol (more efficient)
- Multiplexing (multiple requests in parallel)
- Header compression (HPACK)
- Server push (server can send resources proactively)
- Stream prioritization

**Benefits**:
- Faster page loads
- More efficient bandwidth use
- Single connection per domain

### HTTP/3 (2022)

**Improvements**:
- Built on QUIC (UDP-based)
- Even faster connection setup
- Better mobile performance
- Improved loss recovery

## 🧪 Hands-On Exercises

### Exercise 1: Test HTTP Methods

```bash
# GET
curl https://jsonplaceholder.typicode.com/posts/1

# POST
curl -X POST https://jsonplaceholder.typicode.com/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","body":"Content","userId":1}'

# PUT
curl -X PUT https://jsonplaceholder.typicode.com/posts/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated","body":"New content","userId":1}'

# PATCH
curl -X PATCH https://jsonplaceholder.typicode.com/posts/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Patched"}'

# DELETE
curl -X DELETE https://jsonplaceholder.typicode.com/posts/1
```

### Exercise 2: Explore Status Codes

```bash
# 200 OK
curl -I https://api.github.com

# 404 Not Found
curl -I https://api.github.com/this-does-not-exist

# 301 Redirect
curl -I http://github.com

# Follow redirects
curl -L -I http://github.com
```

### Exercise 3: Work with Headers

```bash
# View all headers
curl -v https://api.github.com

# Send custom header
curl -H "Accept: application/json" \
     -H "User-Agent: MyApp/1.0" \
     https://api.github.com

# See only response headers
curl -I https://api.github.com
```

### Exercise 4: Test Caching

```bash
# First request (will cache)
curl -I https://example.com

# Second request (check If-Modified-Since)
curl -I https://example.com \
  -H "If-Modified-Since: Wed, 21 Oct 2015 07:28:00 GMT"
```

## 🎯 Key Takeaways

1. **HTTP**: Foundation of web communication
2. **Methods**: GET (read), POST (create), PUT (update), DELETE (remove)
3. **Status Codes**: 2xx success, 3xx redirect, 4xx client error, 5xx server error
4. **Headers**: Metadata for requests and responses
5. **Versions**: HTTP/1.1 (legacy), HTTP/2 (modern), HTTP/3 (future)

## 📖 Next Steps

➡️ [Module 05: Working With APIs](../05-Working-With-APIs/) - Practical API consumption

## 🔗 Resources

- [MDN HTTP Documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP)
- [HTTP Status Dogs](https://httpstatusdogs.com/)
- [HTTP Cats](https://http.cat/)
- [RFC 7231 - HTTP/1.1 Semantics](https://tools.ietf.org/html/rfc7231)
