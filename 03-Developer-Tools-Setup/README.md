# Module 03: Developer Tools Setup

## 🎯 Learning Objectives

By the end of this module, you will be able to:

- ✅ Use Browser DevTools Network tab effectively
- ✅ Install and use Postman for API testing
- ✅ Master curl basics for command-line requests
- ✅ Use HTTPie for human-friendly HTTP requests
- ✅ Choose the right tool for different scenarios

**Time Required**: 2-3 hours

## 🛠️ Why These Tools?

As a developer working with networks and APIs, you need tools to:
- Inspect HTTP requests and responses
- Test APIs without writing code
- Debug network issues
- Automate API testing
- Document API behavior

## 🌐 Browser DevTools (Network Tab)

### Overview

Every modern browser includes powerful developer tools. The Network tab is essential for understanding web communication.

### Opening DevTools

- **Windows/Linux**: `F12` or `Ctrl+Shift+I`
- **macOS**: `Cmd+Option+I`
- Or right-click → "Inspect"

### Network Tab Features

**1. Request List**
- Shows all network requests
- Type: XHR, JS, CSS, IMG, Font, Doc
- Status codes, size, timing

**2. Request Details**
- Headers (request & response)
- Preview (formatted response)
- Response (raw data)
- Timing (waterfall diagram)

**3. Filters**
- Filter by type (XHR, JS, CSS, etc.)
- Search for specific requests
- Filter by domain

### Hands-On Exercise

1. Open Chrome/Firefox
2. Press `F12` → Navigate to **Network** tab
3. Visit https://jsonplaceholder.typicode.com/
4. Click "posts" link
5. Observe:
   - Request method (GET)
   - Status code (200)
   - Response headers
   - JSON response body

### Key Network Tab Features

**Preserve Log**: Keep requests when navigating
**Disable Cache**: Always fetch fresh content
**Throttling**: Simulate slow connections
**Filter**: Show only specific request types

### Exercise: Inspect a Real API Request

```
1. Open DevTools Network tab
2. Visit https://api.github.com/users/octocat
3. Find the API request
4. Check:
   - Request URL
   - Request Method
   - Status Code
   - Response Headers (Content-Type)
   - Response Body (JSON data)
```

## 📮 Postman

### What is Postman?

Postman is the most popular API development tool. It provides a GUI for making HTTP requests and testing APIs.

### Installation

Download from: https://www.postman.com/downloads/

Or via package manager:
```bash
# macOS
brew install --cask postman

# Windows (Chocolatey)
choco install postman

# Linux (Snap)
snap install postman
```

Verify installation: Launch Postman application

### Getting Started

**1. Create a Request**
- Click "New" → "HTTP Request"
- Enter URL: `https://api.github.com/users/octocat`
- Click "Send"

**2. View Response**
- Status code (200 OK)
- Response time
- Response body (formatted JSON)
- Headers

**3. Save Requests**
- Save to collection for reuse
- Organize related requests
- Share with team

### Key Features

**Collections**: Group related requests
**Environments**: Switch between dev/staging/prod
**Variables**: Reuse values across requests
**Tests**: Automated response validation
**Documentation**: Auto-generate API docs

### Practical Exercise: GitHub API

```
1. Create new request
2. Method: GET
3. URL: https://api.github.com/users/YOUR_USERNAME
4. Send request
5. Examine response:
   - Public repos count
   - Followers
   - Avatar URL
```

**Try Different Endpoints**:
- Repositories: `https://api.github.com/users/octocat/repos`
- Rate limit: `https://api.github.com/rate_limit`

### Adding Headers

Some APIs require headers:

```
Example: Authorization header
Key: Authorization
Value: Bearer YOUR_TOKEN

Example: Content-Type
Key: Content-Type
Value: application/json
```

### Sending POST Requests

```
1. Method: POST
2. URL: https://jsonplaceholder.typicode.com/posts
3. Body → raw → JSON
4. Enter JSON data:
{
  "title": "Test Post",
  "body": "This is a test",
  "userId": 1
}
5. Send
```

## 💻 curl (Command-Line Tool)

### What is curl?

curl is a command-line tool for transferring data with URLs. It's ubiquitous, powerful, and perfect for automation.

### Check Installation

```bash
curl --version
```

Should show curl version and supported protocols.

### Basic Usage

**Simple GET request**:
```bash
curl https://api.github.com/users/octocat
```

**Save to file**:
```bash
curl https://api.github.com/users/octocat -o user.json
```

**Follow redirects**:
```bash
curl -L https://github.com
```

**Show headers**:
```bash
curl -i https://api.github.com
```

**Verbose output** (see full request/response):
```bash
curl -v https://api.github.com
```

### Common curl Options

```bash
# GET request with header
curl -H "Accept: application/json" https://api.github.com

# POST request with data
curl -X POST https://jsonplaceholder.typicode.com/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","body":"Content","userId":1}'

# PUT request
curl -X PUT https://jsonplaceholder.typicode.com/posts/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Title"}'

# DELETE request
curl -X DELETE https://jsonplaceholder.typicode.com/posts/1

# Authentication
curl -u username:password https://api.example.com

# Bearer token
curl -H "Authorization: Bearer TOKEN" https://api.example.com
```

### Download Files

```bash
# Download file
curl -O https://example.com/file.zip

# Download with custom name
curl -o myfile.zip https://example.com/file.zip

# Resume interrupted download
curl -C - -O https://example.com/largefile.iso
```

### Practical Exercise: Test JSONPlaceholder API

```bash
# Get all posts
curl https://jsonplaceholder.typicode.com/posts

# Get specific post
curl https://jsonplaceholder.typicode.com/posts/1

# Create new post
curl -X POST https://jsonplaceholder.typicode.com/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"My Post","body":"Hello World","userId":1}'

# Update post
curl -X PUT https://jsonplaceholder.typicode.com/posts/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated","body":"Changed","userId":1}'

# Delete post
curl -X DELETE https://jsonplaceholder.typicode.com/posts/1
```

## 🎨 HTTPie (Human-Friendly Alternative to curl)

### What is HTTPie?

HTTPie is a user-friendly command-line HTTP client with:
- Syntax highlighting
- JSON support built-in
- Simpler syntax than curl
- Great for interactive use

### Installation

```bash
# macOS
brew install httpie

# Ubuntu/Debian
sudo apt install httpie

# Windows (using pip)
pip install httpie

# Or using Chocolatey
choco install httpie
```

Verify:
```bash
http --version
```

### Basic Usage

**Simple GET** (note: uses `http` command):
```bash
http https://api.github.com/users/octocat
```

Output is automatically:
- Syntax highlighted
- Pretty-printed JSON
- Shows headers and body

**POST with JSON**:
```bash
http POST https://jsonplaceholder.typicode.com/posts \
  title="Test Post" \
  body="Content here" \
  userId=1
```

Note: HTTPie automatically sets `Content-Type: application/json`!

### HTTPie vs curl

**curl**:
```bash
curl -X POST https://api.example.com/data \
  -H "Content-Type: application/json" \
  -d '{"key":"value"}'
```

**HTTPie** (equivalent):
```bash
http POST https://api.example.com/data key=value
```

### HTTPie Features

**Custom headers**:
```bash
http GET https://api.example.com \
  Authorization:"Bearer TOKEN" \
  User-Agent:"MyApp/1.0"
```

**Query parameters**:
```bash
http GET https://api.example.com/search \
  q=="networking" \
  page==1
```

**Download file**:
```bash
http --download https://example.com/file.zip
```

**Follow redirects**:
```bash
http --follow https://github.com
```

**Only show body**:
```bash
http --body https://api.github.com/users/octocat
```

## 🔀 Choosing the Right Tool

### When to Use Each Tool

| Tool | Best For | Pros | Cons |
|------|----------|------|------|
| **Browser DevTools** | Debugging web apps, inspecting requests | Built-in, visual, complete context | Can't easily replay requests |
| **Postman** | API development, team collaboration, documentation | User-friendly, powerful features, shareable | GUI-based, requires installation |
| **curl** | Automation, scripts, CI/CD, production | Universal, scriptable, lightweight | Complex syntax, no formatting |
| **HTTPie** | Interactive testing, learning, quick checks | Human-friendly, beautiful output | Not as widely available as curl |

### Workflow Example

**Development**:
1. Use **Browser DevTools** to see what your web app is doing
2. Use **Postman** to test API endpoints manually
3. Save successful requests in Postman collections

**Testing**:
1. Use **HTTPie** for quick interactive tests
2. Use **curl** in automated test scripts

**Production**:
1. Use **curl** in deployment scripts
2. Use **curl** for health checks and monitoring

## 🧪 Comprehensive Exercise

### Test a Complete API Workflow

Using **JSONPlaceholder** (a fake REST API for testing):

**1. Browser DevTools**:
- Visit https://jsonplaceholder.typicode.com/
- Open Network tab
- Click "posts"
- Inspect the request

**2. Postman**:
- GET all posts: `https://jsonplaceholder.typicode.com/posts`
- GET specific post: `https://jsonplaceholder.typicode.com/posts/1`
- POST new post with JSON body
- Save requests to collection

**3. curl**:
```bash
curl https://jsonplaceholder.typicode.com/posts/1
curl -X POST https://jsonplaceholder.typicode.com/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"curl test","body":"testing","userId":1}'
```

**4. HTTPie**:
```bash
http https://jsonplaceholder.typicode.com/posts/1
http POST https://jsonplaceholder.typicode.com/posts \
  title="httpie test" body="testing" userId=1
```

## 🎯 Key Takeaways

1. **Browser DevTools**: Essential for web debugging
2. **Postman**: Best for API development and team collaboration
3. **curl**: Universal tool for automation and scripting
4. **HTTPie**: User-friendly alternative for interactive use
5. **Right tool for the job**: Each has its strengths

## 📖 Next Steps

Now that you have the tools, it's time to learn HTTP:

➡️ [Module 04: HTTP Fundamentals](../04-HTTP-Fundamentals/) - Methods, status codes, headers

## 🔗 Additional Resources

- [Chrome DevTools Documentation](https://developer.chrome.com/docs/devtools/)
- [Postman Learning Center](https://learning.postman.com/)
- [curl Manual](https://curl.se/docs/manual.html)
- [HTTPie Documentation](https://httpie.io/docs)
- [JSONPlaceholder](https://jsonplaceholder.typicode.com/) - Free fake API for testing

## 💡 Pro Tips

- Master keyboard shortcuts in DevTools
- Create Postman collections for each project
- Use curl's `-v` flag when debugging
- HTTPie's output is great for screenshots and documentation
- All tools can export requests in different formats
