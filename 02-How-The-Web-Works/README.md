# Module 02: How The Web Works

## 🎯 Learning Objectives

By the end of this module, you will understand:

- ✅ The difference between the Internet and the Web
- ✅ Client-server architecture
- ✅ URLs and domain structure
- ✅ How web browsers work
- ✅ Web servers and their role
- ✅ Static vs dynamic content

**Time Required**: 2-3 hours

## 🌍 Internet vs Web

### The Internet
- The infrastructure (cables, routers, protocols)
- The network that connects computers
- Includes: Web, email, file transfer, gaming, streaming

### The World Wide Web (WWW)
- A service built on top of the Internet
- Uses HTTP/HTTPS protocol
- Accessed through web browsers
- Just one way to use the Internet

**Analogy**: Internet is like the road system; the Web is like one type of vehicle that uses those roads.

## 🏗️ Client-Server Architecture

### The Model

```
CLIENT                  SERVER
(Your Browser)          (Web Server)
     |                      |
     |---- REQUEST -------→ |
     |                      |
     |                  (Processes)
     |                      |
     |←---- RESPONSE ------- |
     |                      |
```

### Client (Frontend)

**What it is**: The application making requests (usually a web browser)

**What it does**:
- Sends requests to servers
- Receives and displays responses
- Handles user interactions
- Runs JavaScript code

**Examples**:
- Chrome, Firefox, Safari (browsers)
- Mobile apps
- API clients (Postman, curl)

### Server (Backend)

**What it is**: The application responding to requests

**What it does**:
- Listens for requests
- Processes business logic
- Accesses databases
- Sends back responses

**Examples**:
- Apache, Nginx (web servers)
- Node.js, Django, Flask (application servers)
- API servers

## 🔗 Understanding URLs

A **URL** (Uniform Resource Locator) is the address of a resource on the web.

### URL Structure

```
https://www.example.com:443/path/to/page?search=hello&page=2#section

└─┬─┘   └──────┬───────┘ └┬┘ └─────┬──────┘ └────────┬──────────┘ └───┬──┘
  │            │          │        │                  │                │
Scheme      Domain       Port    Path              Query           Fragment
```

### Components Explained

**1. Scheme (Protocol)**
- `http://` - Unencrypted
- `https://` - Encrypted (secure)
- `ftp://` - File transfer
- `ws://` - WebSocket

**2. Domain**
- `www.example.com` - The server's address
- Resolved by DNS to an IP address

**3. Port** (Optional)
- Default: 80 (HTTP), 443 (HTTPS)
- Specifies which service on the server

**4. Path**
- `/path/to/page` - The resource location
- Like folders and files on a computer

**5. Query Parameters**
- `?search=hello&page=2` - Additional data
- Key-value pairs
- Starts with `?`, separated by `&`

**6. Fragment/Anchor**
- `#section` - Location within the page
- Not sent to server
- Handled by browser

### Examples

```
https://github.com/MrMichel93/DevOps-Basics
└─┬─┘   └──┬──┘ └─────────┬──────────────┘
Scheme  Domain           Path

https://www.google.com/search?q=networking&lang=en
└─┬─┘   └──────┬──────┘ └─┬──┘ └────────┬──────────┘
Scheme       Domain      Path        Query

https://developer.mozilla.org/en-US/docs/Web#JavaScript_tutorials
└─┬─┘   └────────┬────────┘ └───────┬──────┘ └────────┬──────────┘
Scheme         Domain              Path            Fragment
```

## 🌐 Domain Structure

### Anatomy of a Domain

```
subdomain.secondleveldomain.topleveldomain
   www    .    example     .    com

Full breakdown:
www.api.example.co.uk
│   │    │       │  │
│   │    │       │  └─ ccTLD (Country Code)
│   │    │       └──── TLD (Top-Level Domain)
│   │    └────────────── Second-Level Domain
│   └─────────────────── Subdomain
└─────────────────────── Subdomain
```

### Domain Types

**Top-Level Domains (TLD)**:
- `.com` - Commercial
- `.org` - Organization
- `.net` - Network
- `.edu` - Education
- `.gov` - Government

**Country Code TLDs**:
- `.uk` - United Kingdom
- `.de` - Germany
- `.jp` - Japan
- `.ca` - Canada

**New TLDs**:
- `.io` - Popular with tech startups
- `.app` - Applications
- `.dev` - Developers

### Subdomains

Different services on same domain:

```
www.example.com      - Main website
api.example.com      - API server
blog.example.com     - Blog
mail.example.com     - Email service
docs.example.com     - Documentation
```

## 🖥️ How Browsers Work

### The Browser's Job

1. **Parse URL** - Understand what you want
2. **DNS Lookup** - Find the server's IP
3. **Establish Connection** - Connect to server
4. **Send Request** - Ask for the resource
5. **Receive Response** - Get HTML, CSS, JS, images
6. **Render Page** - Display content
7. **Execute JavaScript** - Make page interactive

### Browser Components

```
┌─────────────────────────────────────┐
│         User Interface              │ ← Address bar, buttons
├─────────────────────────────────────┤
│         Browser Engine              │ ← Manages the rendering
├─────────────────────────────────────┤
│         Rendering Engine            │ ← Paints the screen
│  (Blink, Webkit, Gecko)            │
├─────────────────────────────────────┤
│         JavaScript Engine           │ ← Executes JS code
│  (V8, SpiderMonkey)                │
├─────────────────────────────────────┤
│     Networking | UI Backend         │ ← HTTP requests
├─────────────────────────────────────┤
│     Data Storage (Cache, Cookies)   │ ← Local storage
└─────────────────────────────────────┘
```

### Rendering Pipeline

```
1. HTML → DOM Tree
   Parse HTML into structured tree

2. CSS → CSSOM Tree
   Parse CSS rules

3. DOM + CSSOM → Render Tree
   Combine structure and styles

4. Layout
   Calculate positions and sizes

5. Paint
   Draw pixels on screen
```

### Browser Developer Tools

Access: `F12` or `Ctrl+Shift+I` (Windows/Linux) or `Cmd+Option+I` (macOS)

**Key Tabs**:
- **Elements**: Inspect HTML/CSS
- **Console**: JavaScript debugging
- **Network**: See all requests
- **Application**: Storage, cookies, cache
- **Performance**: Analyze loading

## 🗄️ Web Servers

### What is a Web Server?

Software that listens for HTTP requests and sends back responses.

### Popular Web Servers

**1. Nginx**
- Modern, high-performance
- Great for static content
- Often used as reverse proxy

**2. Apache**
- Most popular historically
- Highly configurable
- Modular architecture

**3. Node.js (with Express)**
- JavaScript on server
- Great for APIs
- Full-stack JavaScript

**4. IIS**
- Microsoft's web server
- Integrated with Windows
- Good for .NET applications

### Static vs Dynamic Content

#### Static Content

Content that doesn't change:
- HTML files
- Images
- CSS stylesheets
- JavaScript files
- PDFs, videos

**How it works**:
```
Browser → Request index.html → Server → Reads file → Sends file
```

**Advantages**:
- Fast
- Cacheable
- Simple
- Secure (no code execution)

#### Dynamic Content

Content generated on-the-fly:
- Personalized pages
- Search results
- User dashboards
- Live data

**How it works**:
```
Browser → Request /user/profile
       ↓
    Server → Runs code → Queries database → Generates HTML → Sends response
```

**Examples**:
- Social media feeds
- E-commerce product pages
- Weather websites
- News sites with latest articles

## 🔄 The Request-Response Cycle

### Detailed Flow

```
1. User types URL or clicks link

2. Browser parses URL
   - Scheme: HTTPS
   - Domain: example.com
   - Path: /products

3. DNS Resolution
   - Browser cache?
   - OS cache?
   - DNS server → IP address

4. TCP Connection
   - Three-way handshake
   - Establishes connection

5. TLS Handshake (if HTTPS)
   - Verify certificate
   - Encrypt connection

6. HTTP Request
   - Method: GET
   - Headers: Accept, User-Agent, etc.
   - Body: (empty for GET)

7. Server Processing
   - Route the request
   - Run application logic
   - Query database if needed
   - Generate response

8. HTTP Response
   - Status: 200 OK
   - Headers: Content-Type, etc.
   - Body: HTML content

9. Browser Rendering
   - Parse HTML
   - Load CSS, JS, images
   - Render page

10. Additional Requests
    - For each image, CSS, JS file
    - May use same connection (HTTP/2)
```

## 🧪 Hands-On Exercises

### Exercise 1: Inspect a URL

Break down this URL:
```
https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=30s#comments
```

Identify: scheme, domain, path, query parameters, fragment

### Exercise 2: Use Browser DevTools

1. Open any website
2. Press `F12` to open DevTools
3. Go to **Network** tab
4. Refresh the page
5. Click on the first request (usually HTML document)
6. Examine:
   - Request headers
   - Response headers
   - Response body
   - Timing

### Exercise 3: Compare Static vs Dynamic

**Static site**: https://example.com
- View page source (`Ctrl+U`)
- Notice HTML is complete

**Dynamic site**: https://reddit.com
- View page source
- Notice minimal HTML, lots of JavaScript

### Exercise 4: Test DNS Resolution

```bash
# Resolve a domain to IP
nslookup github.com

# Time how long a request takes
curl -w "\nTime: %{time_total}s\n" https://github.com
```

## 🎯 Key Takeaways

1. **Web ≠ Internet**: The Web is just one service using the Internet
2. **Client-Server**: Fundamental architecture of the Web
3. **URLs**: Structured addresses for web resources
4. **Domains**: Hierarchical naming system
5. **Browsers**: Complex software that interprets and displays web content
6. **Web Servers**: Software that responds to HTTP requests
7. **Static vs Dynamic**: Content can be pre-made or generated on-demand

## 📖 Next Steps

Now that you understand how the Web works, it's time to learn the tools:

➡️ [Module 03: Developer Tools Setup](../03-Developer-Tools-Setup/) - Browser DevTools, Postman, curl

## 🔗 Additional Resources

- [How Browsers Work](https://web.dev/howbrowserswork/)
- [What Happens When You Type a URL](https://github.com/alex/what-happens-when)
- [HTTP vs HTTPS (Video)](https://www.youtube.com/watch?v=hExRDVZHhig)
- [DNS Explained Visually](https://howdns.works/)

## 💡 Did You Know?

- The first website ever is still online: http://info.cern.ch/
- The average web page makes over 70 HTTP requests
- Your browser caches resources to avoid downloading them again
- HTTP/2 can send multiple resources over a single connection
