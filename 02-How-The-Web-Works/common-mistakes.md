# Common Mistakes in How The Web Works

## Beginner Mistakes

### Mistake 1: Not Understanding Client-Server Architecture

**What people do:**
Don't understand the basic request-response model of the web.

**Why it's a problem:**
- Can't troubleshoot web issues
- Don't understand where processing happens
- Confusion about state management
- Poor application architecture decisions

**The right way:**
Understand client-server model:
- Client (browser) sends HTTP requests
- Server processes and sends HTTP responses
- Stateless communication
- Each request is independent

**How to fix if you've already done this:**
Learn the fundamentals of web architecture and request-response cycle.

**Red flags to watch for:**
- Expecting server to remember client state without cookies/sessions
- Not understanding where code executes
- Confusion about client vs server-side rendering

---

### Mistake 2: Confusing Frontend and Backend

**What people do:**
Don't understand what runs where (client vs server).

**Why it's a problem:**
- Security vulnerabilities (trusting client-side validation)
- Performance issues (wrong processing location)
- Confusion about technology choices
- Poor architecture

**The right way:**
Know what executes where:
- Frontend: HTML, CSS, JavaScript (in browser)
- Backend: Python, Node.js, Java, etc. (on server)
- API: Communication between them

**How to fix if you've already done this:**
Learn separation of concerns and where each technology executes.

**Red flags to watch for:**
- Only client-side validation
- Sensitive logic in JavaScript
- Not understanding SPA vs server-rendered

---

### Mistake 3: Not Understanding URLs Properly

**What people do:**
Don't understand URL structure and components.

**Why it's a problem:**
- Can't construct or parse URLs
- Issues with routing
- Query parameter confusion
- Broken links

**The right way:**
Understand URL components:
```
https://user:pass@example.com:443/path/to/page?key=value&foo=bar#section

Protocol: https
Credentials: user:pass (avoid!)
Domain: example.com
Port: 443
Path: /path/to/page
Query: key=value&foo=bar
Fragment: #section
```

**How to fix if you've already done this:**
Learn URL structure and proper encoding.

**Red flags to watch for:**
- Not URL-encoding parameters
- Hardcoding URLs
- Not understanding query strings

---

### Mistake 4: Not Understanding Cookies and Sessions

**What people do:**
Don't understand how state is maintained across requests.

**Why it's a problem:**
- Can't implement authentication properly
- Session management issues
- Security vulnerabilities
- Privacy concerns

**The right way:**
Understand state management:
- HTTP is stateless
- Cookies store data on client
- Sessions store data on server
- Cookies link client to session

**How to fix if you've already done this:**
Implement proper session management and secure cookie handling.

**Red flags to watch for:**
- Storing sensitive data in cookies
- Not using HttpOnly or Secure flags
- Session fixation vulnerabilities

---

## Intermediate Mistakes

### Mistake 5: Not Understanding How Browsers Work

**What people do:**
Don't understand browser rendering, caching, or the critical rendering path.

**Why it's a problem:**
- Performance issues
- Poor user experience
- Inefficient resource loading
- No optimization strategy

**The right way:**
Understand browser behavior:
- Parsing HTML
- Loading resources (CSS, JS, images)
- Rendering pipeline
- Caching mechanisms

**How to fix if you've already done this:**
Learn browser internals and optimize accordingly.

**Red flags to watch for:**
- Blocking JavaScript
- No resource optimization
- Poor load performance
- Render-blocking resources

---

### Mistake 6: Not Understanding Same-Origin Policy

**What people do:**
Don't understand browser security model and CORS.

**Why it's a problem:**
- CORS errors
- Security misconfigurations
- Can't make cross-origin requests
- XSS vulnerabilities

**The right way:**
Understand same-origin policy:
- Protocol + Domain + Port must match
- CORS allows controlled exceptions
- Important security feature

**How to fix if you've already done this:**
Configure CORS properly and understand security implications.

**Red flags to watch for:**
- Frequent CORS errors
- Overly permissive CORS (*)
- Security vulnerabilities
- Not understanding postMessage

---

## Prevention Checklist

### Understanding Basics
- [ ] Know client-server model
- [ ] Understand frontend vs backend
- [ ] Know URL structure
- [ ] Understand HTTP request-response
- [ ] Know how browsers work

### Security
- [ ] Understand same-origin policy
- [ ] Configure CORS properly
- [ ] Secure cookie handling
- [ ] Proper session management
- [ ] HTTPS everywhere
