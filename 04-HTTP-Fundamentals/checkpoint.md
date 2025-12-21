# Module 4 Checkpoint: HTTP Fundamentals

## Before Moving Forward

Complete this checkpoint to ensure you're ready for the next module.

## Knowledge Check (Answer these questions)

### Fundamentals

1. What does HTTP stand for and what is its primary purpose?
   <details>
   <summary>Answer</summary>
   HTTP stands for HyperText Transfer Protocol. Its primary purpose is to define how messages are formatted and transmitted between web clients (browsers) and servers. It's an application-layer protocol that enables the transfer of hypertext documents (HTML) and other resources (images, videos, JSON) across the Internet. HTTP is the foundation of data communication on the World Wide Web.
   </details>

2. What are the main HTTP request methods and what is each used for?
   <details>
   <summary>Answer</summary>
   - GET: Retrieve data from a server (read-only, idempotent)
   - POST: Submit data to create a new resource (not idempotent)
   - PUT: Update an entire resource or create if doesn't exist (idempotent)
   - PATCH: Partially update a resource (not necessarily idempotent)
   - DELETE: Remove a resource (idempotent)
   - HEAD: Like GET but returns only headers (no body)
   - OPTIONS: Query supported methods for a resource (used in CORS)
   </details>

3. What do HTTP status codes indicate? Give examples from each category (1xx, 2xx, 3xx, 4xx, 5xx).
   <details>
   <summary>Answer</summary>
   HTTP status codes indicate the result of an HTTP request:
   - 1xx (Informational): 100 Continue - server received headers, client can continue
   - 2xx (Success): 200 OK (success), 201 Created (resource created), 204 No Content (success, no body)
   - 3xx (Redirection): 301 Moved Permanently, 302 Found (temporary redirect), 304 Not Modified (cached)
   - 4xx (Client Error): 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found
   - 5xx (Server Error): 500 Internal Server Error, 502 Bad Gateway, 503 Service Unavailable
   </details>

4. What are HTTP headers and why are they important?
   <details>
   <summary>Answer</summary>
   HTTP headers are key-value pairs sent in requests and responses that provide metadata about the request/response. They're important because they: 1) Specify content type (Content-Type: application/json), 2) Enable caching (Cache-Control, ETag), 3) Provide authentication (Authorization header), 4) Control cookies (Set-Cookie, Cookie), 5) Enable CORS (Access-Control-Allow-Origin), 6) Indicate content encoding, language, length, etc.
   </details>

### Intermediate

5. What is the difference between idempotent and safe HTTP methods?
   <details>
   <summary>Answer</summary>
   Safe methods don't modify server state - they're read-only (GET, HEAD, OPTIONS). Multiple calls have no additional side effects beyond the first. Idempotent methods can be called multiple times with the same result - the server state after multiple identical requests is the same as after a single request (GET, PUT, DELETE, HEAD, OPTIONS). POST is neither safe nor idempotent. PATCH may or may not be idempotent depending on implementation.
   </details>

6. Explain the structure of an HTTP request and response.
   <details>
   <summary>Answer</summary>
   **HTTP Request:**
   1. Request line: Method, URL, HTTP version (GET /api/users HTTP/1.1)
   2. Headers: Key-value pairs (Host: api.example.com, Content-Type: application/json)
   3. Blank line
   4. Body (optional): Data sent to server
   
   **HTTP Response:**
   1. Status line: HTTP version, status code, reason phrase (HTTP/1.1 200 OK)
   2. Headers: Key-value pairs (Content-Type: application/json, Content-Length: 142)
   3. Blank line
   4. Body: Response data (HTML, JSON, etc.)
   </details>

7. What is the difference between HTTP/1.1, HTTP/2, and HTTP/3?
   <details>
   <summary>Answer</summary>
   - HTTP/1.1: Text-based protocol, one request per TCP connection (or sequential with keep-alive), head-of-line blocking
   - HTTP/2: Binary protocol, multiplexing (multiple requests on one connection simultaneously), header compression, server push, more efficient
   - HTTP/3: Uses QUIC (over UDP) instead of TCP, better performance on poor networks, eliminates head-of-line blocking at transport layer, faster connection establishment
   </details>

8. What are common request headers and what do they do?
   <details>
   <summary>Answer</summary>
   - Host: Specifies the domain name of the server (required in HTTP/1.1)
   - User-Agent: Identifies the client software (browser, app)
   - Accept: Media types the client can process (application/json, text/html)
   - Content-Type: Media type of the request body (application/json)
   - Authorization: Credentials for authentication (Bearer token, Basic auth)
   - Cookie: Cookies sent to server
   - Accept-Encoding: Compression methods supported (gzip, deflate)
   - Accept-Language: Preferred languages (en-US, es)
   </details>

### Advanced

9. What is content negotiation and how does it work in HTTP?
   <details>
   <summary>Answer</summary>
   Content negotiation is the mechanism for serving different representations of a resource based on client preferences. The client sends Accept headers indicating preferences:
   - Accept: Media type (application/json vs application/xml)
   - Accept-Language: Language (en-US, es-ES)
   - Accept-Encoding: Compression (gzip, br)
   - Accept-Charset: Character encoding
   
   The server selects the best match and responds with Content-Type, Content-Language, etc. headers. If no match, server sends 406 Not Acceptable. This enables serving JSON to APIs, HTML to browsers, from the same endpoint.
   </details>

10. Explain HTTP caching and the role of Cache-Control, ETag, and Last-Modified headers.
    <details>
    <summary>Answer</summary>
    HTTP caching stores responses to reduce server load and improve performance:
    - **Cache-Control**: Directives for caching (max-age=3600, no-cache, private, public)
    - **ETag**: Unique identifier for resource version (hash of content)
    - **Last-Modified**: Timestamp of last modification
    
    Validation workflow: Client has cached resource with ETag "abc123". Client sends request with If-None-Match: "abc123". If unchanged, server responds 304 Not Modified (no body). If changed, server sends 200 OK with new content and new ETag. This saves bandwidth and speeds up loading.
    </details>

11. What are CORS preflight requests and when do they occur?
    <details>
    <summary>Answer</summary>
    CORS preflight is an OPTIONS request sent by the browser before the actual request to check if the server allows cross-origin requests. It occurs when:
    1. Using methods other than GET, HEAD, POST
    2. Using custom headers
    3. Using Content-Type other than application/x-www-form-urlencoded, multipart/form-data, or text/plain
    
    The preflight request includes Origin, Access-Control-Request-Method, Access-Control-Request-Headers. Server responds with Access-Control-Allow-Origin, Access-Control-Allow-Methods, Access-Control-Allow-Headers. If server approves, browser sends the actual request.
    </details>

12. What is the difference between stateless and stateful protocols, and how does HTTP handle state?
    <details>
    <summary>Answer</summary>
    Stateless protocols (like HTTP) don't retain information about previous requests - each request is independent. Stateful protocols maintain session information between requests. HTTP is stateless by design for scalability and reliability, but applications need state (login status, shopping carts). Solutions:
    1. Cookies: Client stores session ID, sends with each request
    2. Tokens: JWT or similar sent in Authorization header
    3. URL parameters: Session info in query string
    4. Hidden form fields: State passed between pages
    
    Server uses these to look up session data, making HTTP appear stateful at the application level.
    </details>

## Practical Skills Verification

### Task 1: Analyze HTTP Request-Response Cycle
**Objective:** Inspect and understand complete HTTP transactions.

**Steps:**
1. Open DevTools Network tab
2. Visit https://httpbin.org/get
3. Find the request in Network tab and examine:
   - Request method (GET)
   - Request URL
   - All request headers
   - Response status (200 OK)
   - All response headers
   - Response body (JSON showing your request details)
4. Visit https://httpbin.org/status/404 and observe 404 response
5. Visit https://httpbin.org/redirect/1 and observe redirect (302)

**Success Criteria:**
- [ ] Can identify all parts of HTTP request
- [ ] Can identify all parts of HTTP response
- [ ] Understand different status codes in practice
- [ ] Can observe redirect behavior

**Troubleshooting:**
If httpbin.org is unavailable, use an alternative like https://postman-echo.com or https://jsonplaceholder.typicode.com. If redirects happen too fast, enable "Preserve log" in DevTools.

---

### Task 2: Test Different HTTP Methods
**Objective:** Make requests using various HTTP methods and understand their purposes.

**Steps:**
1. Using Postman or curl, test these endpoints:
   
   **GET request:**
   ```bash
   curl https://jsonplaceholder.typicode.com/posts/1
   ```
   
   **POST request:**
   ```bash
   curl -X POST https://jsonplaceholder.typicode.com/posts \
     -H "Content-Type: application/json" \
     -d '{"title":"Test","body":"Content","userId":1}'
   ```
   
   **PUT request:**
   ```bash
   curl -X PUT https://jsonplaceholder.typicode.com/posts/1 \
     -H "Content-Type: application/json" \
     -d '{"id":1,"title":"Updated","body":"New content","userId":1}'
   ```
   
   **DELETE request:**
   ```bash
   curl -X DELETE https://jsonplaceholder.typicode.com/posts/1
   ```

2. Observe the status codes for each (200, 201, 200, 200)
3. Note which methods include request body

**Success Criteria:**
- [ ] Successfully make GET, POST, PUT, DELETE requests
- [ ] Understand when to use each method
- [ ] Can set Content-Type header correctly
- [ ] Understand idempotency of each method

**Troubleshooting:**
JSONPlaceholder is a fake API - it simulates responses without actually modifying data. If requests fail, check Content-Type header is set for POST/PUT. On Windows, escape quotes in JSON or use a file: `curl -X POST ... -d @data.json`

---

### Task 3: Explore HTTP Headers
**Objective:** Understand common HTTP headers and their effects.

**Steps:**
1. Make a request with custom User-Agent:
   ```bash
   curl -H "User-Agent: MyApp/1.0" https://httpbin.org/user-agent
   ```
2. Request JSON vs HTML:
   ```bash
   curl -H "Accept: application/json" https://httpbin.org/json
   curl -H "Accept: text/html" https://httpbin.org/html
   ```
3. Send and receive compressed data:
   ```bash
   curl -H "Accept-Encoding: gzip" https://httpbin.org/gzip --compressed
   ```
4. Observe headers in response:
   ```bash
   curl -i https://httpbin.org/response-headers?X-Custom=Value
   ```

**Success Criteria:**
- [ ] Can set custom request headers
- [ ] Understand content negotiation (Accept header)
- [ ] Can observe response headers
- [ ] Understand compression headers

**Troubleshooting:**
If `-i` shows too much output, use `-I` (HEAD request) to see only headers. If compression doesn't work, ensure `--compressed` flag is used. httpbin.org is specifically designed for testing - it echoes back what you send.

---

### Task 4: HTTP Status Code Scenarios
**Objective:** Experience different HTTP status codes and understand their meanings.

**Steps:**
1. Test various status codes using httpbin.org:
   ```bash
   # Success
   curl -i https://httpbin.org/status/200
   
   # Created
   curl -i https://httpbin.org/status/201
   
   # Redirect
   curl -i https://httpbin.org/status/302
   
   # Not Modified
   curl -i https://httpbin.org/status/304
   
   # Bad Request
   curl -i https://httpbin.org/status/400
   
   # Unauthorized
   curl -i https://httpbin.org/status/401
   
   # Not Found
   curl -i https://httpbin.org/status/404
   
   # Server Error
   curl -i https://httpbin.org/status/500
   ```
2. Note the status line and reason phrase for each
3. Use DevTools to trigger real scenarios (404 by visiting non-existent page)

**Success Criteria:**
- [ ] Can recognize status codes by category (2xx, 3xx, 4xx, 5xx)
- [ ] Understand when each status code is appropriate
- [ ] Can debug issues based on status codes

**Troubleshooting:**
curl follows redirects with `-L` flag. Without it, you'll see the redirect response itself. For 304 Not Modified, you need conditional headers (If-None-Match, If-Modified-Since).

---

### Task 5: Authentication and Authorization Headers
**Objective:** Understand how HTTP handles authentication.

**Steps:**
1. Test Basic Authentication:
   ```bash
   curl -u username:password https://httpbin.org/basic-auth/username/password
   ```
2. Observe the Authorization header created:
   ```bash
   curl -v -u username:password https://httpbin.org/basic-auth/username/password
   ```
3. Test Bearer token (common for APIs):
   ```bash
   curl -H "Authorization: Bearer my-token-here" https://httpbin.org/bearer
   ```
4. Test without authentication and observe 401:
   ```bash
   curl -i https://httpbin.org/basic-auth/username/password
   ```

**Success Criteria:**
- [ ] Understand Basic Authentication encoding (Base64)
- [ ] Can send Bearer tokens in Authorization header
- [ ] Recognize 401 Unauthorized responses
- [ ] Understand difference between authentication and authorization

**Troubleshooting:**
Basic auth format is `username:password` Base64 encoded, sent as `Authorization: Basic <encoded>`. Bearer tokens are sent as `Authorization: Bearer <token>`. Don't confuse 401 (Unauthorized - authentication failed) with 403 (Forbidden - authenticated but not authorized).

## Project-Based Assessment

**Mini-Project:** HTTP Protocol Documentation and Testing Suite

Create a comprehensive guide to HTTP protocol features with practical demonstrations.

**Requirements:**
- [ ] Document and test all major HTTP methods (GET, POST, PUT, PATCH, DELETE) with examples
- [ ] Create a status code reference guide with:
  - [ ] At least 3 examples from each category (2xx, 3xx, 4xx, 5xx)
  - [ ] Real-world scenarios for when each occurs
  - [ ] How to handle each in client code
- [ ] Header deep-dive covering:
  - [ ] 5+ request headers with examples
  - [ ] 5+ response headers with examples
  - [ ] Security-related headers (CORS, CSP, etc.)
- [ ] Demonstrate HTTP features:
  - [ ] Content negotiation (Accept headers)
  - [ ] Caching (Cache-Control, ETag)
  - [ ] Compression (Accept-Encoding, Content-Encoding)
  - [ ] Redirects (3xx status codes)
  - [ ] Authentication (Basic, Bearer)
- [ ] Create comparison table: HTTP/1.1 vs HTTP/2 vs HTTP/3
- [ ] Build a troubleshooting flowchart for common HTTP issues
- [ ] Include curl/Postman examples for each concept
- [ ] Test everything and include screenshots/output

**Evaluation Rubric:**
| Criteria | Needs Work | Good | Excellent |
|----------|------------|------|-----------|
| **Protocol Knowledge** | Surface-level understanding, errors present | Good grasp of HTTP fundamentals | Expert-level knowledge with nuanced understanding |
| **Practical Examples** | Few working examples, not well explained | Most examples work and are explained | All examples work perfectly with detailed explanations |
| **Documentation Quality** | Disorganized, hard to follow | Well-structured, clear | Professional reference guide quality |
| **Completeness** | Missing 3+ requirements | Missing 1-2 requirements | All requirements met plus extras (HTTP/2 features, WebSockets comparison) |

**Sample Solution:**
See `checkpoint-solutions/04-http-protocol-guide.md` for a complete example.

## Self-Assessment

Rate your confidence (1-5) in these areas:
- [ ] Understanding HTTP methods and when to use each: ___/5
- [ ] Interpreting HTTP status codes: ___/5
- [ ] Working with HTTP headers: ___/5
- [ ] Understanding HTTP request-response cycle: ___/5

**If you scored below 3 on any:**
- Re-read the HTTP Fundamentals module sections
- Practice with httpbin.org to see HTTP in action
- Review MDN's HTTP documentation
- Test APIs to see real-world HTTP usage

**If you scored 4+ on all:**
- You're ready to move forward!
- Consider the advanced challenges below

## Advanced Challenges (Optional)

For those who want to go deeper:

1. **HTTP/2 Server Push**: Research and document how HTTP/2 server push works. Find websites using it (Chrome DevTools shows this). Understand the performance benefits and when to use it.

2. **Implement HTTP Client**: Write a simple HTTP client in your preferred language that can make GET and POST requests. Parse responses, handle redirects, and display headers. Don't use high-level libraries - use sockets or low-level HTTP libraries.

3. **Cache Optimization**: Analyze a website's caching strategy using DevTools. Identify improvements (better Cache-Control headers, ETags, etc.). Document before/after load times.

4. **CORS Deep Dive**: Set up two local servers on different ports. Implement CORS preflight handling. Test simple vs preflight requests. Understand security implications of overly permissive CORS.

5. **HTTP Security Headers**: Research and document security headers (CSP, HSTS, X-Frame-Options, etc.). Use securityheaders.com to analyze websites. Create a checklist for secure HTTP responses.

## Ready to Continue?

- [ ] I've completed the knowledge check (80% or better)
- [ ] I've verified all practical skills
- [ ] I've completed the mini-project
- [ ] I feel confident in this module's concepts
- [ ] I've reviewed common-mistakes.md

✅ **Proceed to Module 5: Working With APIs**
