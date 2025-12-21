# Module 5 Checkpoint: Working With APIs

## Before Moving Forward

Complete this checkpoint to ensure you're ready for the next module.

## Knowledge Check (Answer these questions)

### Fundamentals

1. What is an API and why are APIs important in modern software development?
   <details>
   <summary>Answer</summary>
   An API (Application Programming Interface) is a set of rules and protocols that allows different software applications to communicate with each other. APIs are important because they: 1) Enable integration between different services (payment processing, maps, authentication), 2) Allow frontend and backend to communicate, 3) Enable mobile apps to access server data, 4) Promote code reuse and modularity, 5) Allow third parties to build on top of platforms (Twitter API, Google Maps API).
   </details>

2. What is the difference between a Web API and other types of APIs?
   <details>
   <summary>Answer</summary>
   Web APIs are APIs accessed over HTTP/HTTPS using URLs. They're designed for network communication and typically return JSON or XML. Other API types include: Library APIs (functions within programming languages), Operating System APIs (system calls), Hardware APIs (device drivers). Web APIs are platform-independent, accessible from any language/device with HTTP support, and are the primary way distributed systems communicate.
   </details>

3. What is JSON and why is it the most common data format for APIs?
   <details>
   <summary>Answer</summary>
   JSON (JavaScript Object Notation) is a lightweight, text-based data format using key-value pairs, arrays, and nested objects. It's popular because: 1) Human-readable and easy to write, 2) Native to JavaScript but supported by all languages, 3) Smaller than XML (less verbose), 4) Easy to parse and generate, 5) Supports complex nested data structures. Example: `{"name": "John", "age": 30, "hobbies": ["reading", "coding"]}`
   </details>

4. What does it mean when an API is RESTful?
   <details>
   <summary>Answer</summary>
   A RESTful API follows REST (Representational State Transfer) architectural principles: 1) Uses standard HTTP methods (GET, POST, PUT, DELETE), 2) Resources are identified by URLs, 3) Stateless - each request contains all needed information, 4) Responses can be cached, 5) Uniform interface. Example: GET /users/123 retrieves user 123, DELETE /users/123 deletes user 123. REST is the most common API architectural style for web services.
   </details>

### Intermediate

5. How do you handle errors when working with APIs?
   <details>
   <summary>Answer</summary>
   Error handling involves:
   1. **Check status codes**: 4xx (client errors), 5xx (server errors)
   2. **Parse error responses**: APIs return error details in response body
   3. **Implement retries**: For transient failures (503, network timeouts)
   4. **Use exponential backoff**: Wait longer between each retry
   5. **Log errors**: For debugging and monitoring
   6. **Provide user feedback**: Display meaningful error messages
   7. **Handle specific errors**: 401 (re-authenticate), 429 (rate limit - slow down), 404 (resource not found)
   </details>

6. What is API rate limiting and why do APIs implement it?
   <details>
   <summary>Answer</summary>
   Rate limiting restricts the number of API requests a client can make in a time period (e.g., 100 requests/hour). APIs implement it to: 1) Prevent abuse and DDoS attacks, 2) Ensure fair usage across all users, 3) Manage server load and costs, 4) Protect against buggy clients making infinite loops. Rate limits are communicated via headers (X-RateLimit-Limit, X-RateLimit-Remaining) and 429 status code when exceeded.
   </details>

7. What are query parameters and path parameters, and when do you use each?
   <details>
   <summary>Answer</summary>
   **Path parameters** are part of the URL path, identifying specific resources: `/users/123/posts/456` (user 123, post 456). Use for: required identifiers, hierarchical relationships.
   
   **Query parameters** are optional key-value pairs after `?`: `/users?role=admin&sort=name`. Use for: filtering, sorting, pagination, optional modifiers.
   
   Example: `GET /api/products/42?include=reviews&limit=10` - Product 42 (path), with reviews, max 10 (query).
   </details>

8. How do you consume an API from code (in any programming language)?
   <details>
   <summary>Answer</summary>
   General steps (example in JavaScript fetch):
   1. **Make HTTP request** to API endpoint
   2. **Include headers** (Content-Type, Authorization)
   3. **Send data** in request body (for POST/PUT)
   4. **Receive response** asynchronously
   5. **Check status code** (200 = success)
   6. **Parse response body** (JSON.parse or automatic)
   7. **Handle errors** (try/catch, check status)
   8. **Use the data** in your application
   
   Libraries: fetch/axios (JavaScript), requests (Python), HttpClient (C#), OkHttp (Java)
   </details>

### Advanced

9. What is API versioning and what are the different approaches?
   <details>
   <summary>Answer</summary>
   API versioning allows evolving the API without breaking existing clients. Approaches:
   
   1. **URL versioning**: `/api/v1/users`, `/api/v2/users` (most common, clear)
   2. **Header versioning**: `Accept: application/vnd.api.v2+json` (cleaner URLs)
   3. **Query parameter**: `/api/users?version=2` (flexible but less common)
   4. **Content negotiation**: Different Accept header values
   
   URL versioning is most popular due to simplicity. Version when making breaking changes (removing fields, changing types), not for additions (backward compatible).
   </details>

10. Explain pagination in APIs and common pagination strategies.
    <details>
    <summary>Answer</summary>
    Pagination splits large result sets into manageable pages. Strategies:
    
    1. **Offset-based**: `?offset=20&limit=10` (skip 20, return 10)
       - Simple, but can miss/duplicate items if data changes
    
    2. **Page-based**: `?page=3&per_page=10` (page 3, 10 items)
       - User-friendly, same issue as offset
    
    3. **Cursor-based**: `?after=abc123&limit=10` (items after cursor)
       - Consistent results, handles data changes, used by Facebook/Twitter
    
    Response includes: data array, total count, next/previous links, current page info.
    </details>

11. What are API keys vs OAuth tokens, and when do you use each?
    <details>
    <summary>Answer</summary>
    **API Keys**:
    - Simple string identifying the application
    - Used in header or query string
    - Good for: server-to-server, simple authentication
    - All-or-nothing access (no granular permissions)
    - Example: Google Maps API, Weather APIs
    
    **OAuth Tokens**:
    - Temporary, scoped access tokens
    - User grants specific permissions
    - Good for: user-facing apps, third-party integrations
    - Can be revoked without changing credentials
    - Example: "Sign in with Google", GitHub app access
    
    Use API keys for simple scenarios, OAuth for user authorization and fine-grained access.
    </details>

12. How do you test and debug API integrations?
    <details>
    <summary>Answer</summary>
    Testing and debugging strategies:
    1. **Use API testing tools**: Postman, Insomnia for manual testing
    2. **Check documentation**: Verify endpoint URLs, required parameters
    3. **Inspect request/response**: Use browser DevTools, curl -v, or logging
    4. **Validate JSON**: Use JSON validators, check for syntax errors
    5. **Test error cases**: Invalid data, missing auth, rate limits
    6. **Mock APIs**: Use tools like json-server, mockoon for development
    7. **Monitor in production**: Log API calls, response times, errors
    8. **Use API sandboxes**: Many APIs provide test environments
    9. **Unit test integrations**: Mock API responses in tests
    </details>

## Practical Skills Verification

### Task 1: Consume a REST API
**Objective:** Make API requests and parse JSON responses.

**Steps:**
1. Use JSONPlaceholder (https://jsonplaceholder.typicode.com) - a free fake API
2. Get list of users:
   ```bash
   curl https://jsonplaceholder.typicode.com/users
   ```
3. Get specific user:
   ```bash
   curl https://jsonplaceholder.typicode.com/users/1
   ```
4. Get user's posts:
   ```bash
   curl https://jsonplaceholder.typicode.com/posts?userId=1
   ```
5. Create a new post (won't actually save):
   ```bash
   curl -X POST https://jsonplaceholder.typicode.com/posts \
     -H "Content-Type: application/json" \
     -d '{"title":"My Post","body":"Content here","userId":1}'
   ```

**Success Criteria:**
- [ ] Successfully retrieve data from API
- [ ] Can filter results using query parameters
- [ ] Can create resources using POST
- [ ] Understand JSON response structure

**Troubleshooting:**
If requests fail, check your internet connection. If JSON is hard to read, pipe to `jq` (JSON processor): `curl ... | jq`. On Windows, use PowerShell's `ConvertFrom-Json` or install jq.

---

### Task 2: Handle API Authentication
**Objective:** Work with APIs that require authentication.

**Steps:**
1. Create a GitHub personal access token (Settings → Developer settings → Tokens)
2. Use it to access GitHub API:
   ```bash
   curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://api.github.com/user
   ```
3. List your repositories:
   ```bash
   curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://api.github.com/user/repos
   ```
4. Try without authentication and observe 401 error:
   ```bash
   curl https://api.github.com/user
   ```

**Success Criteria:**
- [ ] Successfully authenticate with API
- [ ] Can access protected endpoints
- [ ] Understand 401 Unauthorized errors
- [ ] Know how to secure API keys (environment variables)

**Troubleshooting:**
Never commit API keys to git! Use environment variables: `export GITHUB_TOKEN="your_token"` then `curl -H "Authorization: Bearer $GITHUB_TOKEN"`. If token doesn't work, check it has necessary scopes/permissions.

---

### Task 3: Parse and Navigate JSON Responses
**Objective:** Extract specific data from complex JSON responses.

**Steps:**
1. Get a complex JSON response:
   ```bash
   curl https://api.github.com/repos/microsoft/vscode
   ```
2. Using Postman or browser, examine the JSON structure
3. Extract specific fields using jq:
   ```bash
   # Get just the name
   curl https://api.github.com/repos/microsoft/vscode | jq '.name'
   
   # Get stars count
   curl https://api.github.com/repos/microsoft/vscode | jq '.stargazers_count'
   
   # Get owner login
   curl https://api.github.com/repos/microsoft/vscode | jq '.owner.login'
   ```
4. In your programming language, parse JSON and access nested fields

**Success Criteria:**
- [ ] Can navigate nested JSON objects
- [ ] Can extract arrays from JSON
- [ ] Understand JSON path notation
- [ ] Can parse JSON in code

**Troubleshooting:**
If jq is not installed: `brew install jq` (Mac), `apt-get install jq` (Linux), or download from https://stedolan.github.io/jq/. Alternatively, use online JSON viewers or programming language JSON parsers.

---

### Task 4: Implement Pagination
**Objective:** Handle paginated API responses.

**Steps:**
1. Get first page of GitHub repositories:
   ```bash
   curl "https://api.github.com/users/microsoft/repos?per_page=5&page=1"
   ```
2. Get second page:
   ```bash
   curl "https://api.github.com/users/microsoft/repos?per_page=5&page=2"
   ```
3. Check response headers for pagination info:
   ```bash
   curl -I "https://api.github.com/users/microsoft/repos?per_page=5"
   ```
   Look for `Link` header with next, prev, first, last URLs
4. Write code to iterate through all pages

**Success Criteria:**
- [ ] Understand pagination parameters (page, per_page, limit, offset)
- [ ] Can navigate multiple pages
- [ ] Can detect last page
- [ ] Understand Link header pagination

**Troubleshooting:**
If there's no Link header, the API might use a different pagination method. Check API documentation. Some APIs include total count and page info in response body instead of headers.

---

### Task 5: Error Handling and Rate Limiting
**Objective:** Handle API errors gracefully.

**Steps:**
1. Make many rapid requests to GitHub API to trigger rate limit:
   ```bash
   for i in {1..100}; do
     curl -i https://api.github.com/users/microsoft/repos
   done
   ```
2. Observe rate limit headers:
   - `X-RateLimit-Limit`: Total requests allowed
   - `X-RateLimit-Remaining`: Requests remaining
   - `X-RateLimit-Reset`: When limit resets (Unix timestamp)
3. When you get 429 status, implement retry logic with exponential backoff
4. Test error scenarios:
   ```bash
   # 404 - Not Found
   curl -i https://api.github.com/users/nonexistentuser12345
   
   # 401 - Unauthorized
   curl -i https://api.github.com/user
   ```

**Success Criteria:**
- [ ] Can interpret rate limit headers
- [ ] Understand 429 Too Many Requests
- [ ] Implement retry logic
- [ ] Handle different error status codes appropriately

**Troubleshooting:**
If you can't trigger rate limit, you might be authenticated (higher limits). Try without token. To convert Unix timestamp: `date -r TIMESTAMP` (Mac/Linux) or use online converters.

## Project-Based Assessment

**Mini-Project:** Build an API Integration Application

Create a command-line or simple web application that integrates with a public API.

**Requirements:**
- [ ] Choose a public API (GitHub, OpenWeather, NewsAPI, Spotify, etc.)
- [ ] Implement at least 4 different endpoints/features
- [ ] Handle authentication (API key or OAuth if required)
- [ ] Parse and display JSON responses in user-friendly format
- [ ] Implement error handling for:
  - [ ] Network errors
  - [ ] 4xx client errors (404, 401, 403)
  - [ ] 5xx server errors
  - [ ] Rate limiting (429)
- [ ] Implement pagination (if API returns large datasets)
- [ ] Cache responses to reduce API calls (bonus)
- [ ] Create documentation including:
  - [ ] How to get API credentials
  - [ ] How to run your application
  - [ ] Example usage/screenshots
  - [ ] Error scenarios and how they're handled
- [ ] Store API keys securely (environment variables, config files not in git)
- [ ] Include rate limit tracking (show remaining requests)

**Example Project Ideas:**
- Weather dashboard (OpenWeather API)
- GitHub repository analyzer (GitHub API)
- News aggregator (NewsAPI)
- Movie search app (TMDB API)
- Currency converter (ExchangeRate API)

**Evaluation Rubric:**
| Criteria | Needs Work | Good | Excellent |
|----------|------------|------|-----------|
| **API Integration** | Basic GET requests only | Multiple endpoints, POST/PUT working | Complex integrations, handles all HTTP methods |
| **Error Handling** | Crashes on errors | Catches errors, basic messages | Comprehensive error handling with retry logic |
| **Code Quality** | Hard to read, no structure | Organized, commented | Clean, modular, follows best practices |
| **User Experience** | Raw JSON output | Formatted, usable | Polished UI/UX, helpful error messages |
| **Documentation** | Minimal or missing | Basic setup instructions | Complete documentation with examples |

**Sample Solution:**
See `checkpoint-solutions/05-github-repo-analyzer/` for a complete example application.

## Self-Assessment

Rate your confidence (1-5) in these areas:
- [ ] Understanding REST API concepts: ___/5
- [ ] Making API requests with various tools: ___/5
- [ ] Parsing JSON responses: ___/5
- [ ] Handling API errors and rate limits: ___/5

**If you scored below 3 on any:**
- Practice with multiple different APIs
- Build small projects consuming APIs
- Review JSON structure and practice parsing
- Study API documentation to understand patterns

**If you scored 4+ on all:**
- You're ready to move forward!
- Consider the advanced challenges below

## Advanced Challenges (Optional)

For those who want to go deeper:

1. **GraphQL API**: Learn about GraphQL as an alternative to REST. Try GitHub's GraphQL API. Compare querying REST vs GraphQL for the same data. Understand over-fetching and under-fetching problems GraphQL solves.

2. **API SDK Development**: Create a reusable library/SDK for a public API in your language of choice. Implement: authentication, all endpoints, error handling, rate limiting, pagination. Publish to package manager (npm, PyPI).

3. **Webhook Integration**: Set up webhooks for an API that supports them (GitHub, Stripe). Create a server to receive webhook events. Verify webhook signatures for security. Process events in real-time.

4. **API Performance Optimization**: Implement caching (in-memory or Redis) for API responses. Add request debouncing/throttling. Measure and document performance improvements. Use concurrent requests where appropriate.

5. **API Mock Server**: Create a mock API server that mimics a real API's behavior. Use tools like json-server, mockoon, or write your own. Use for testing when external API is unavailable or rate-limited.

## Ready to Continue?

- [ ] I've completed the knowledge check (80% or better)
- [ ] I've verified all practical skills
- [ ] I've completed the mini-project
- [ ] I feel confident in this module's concepts
- [ ] I've reviewed common-mistakes.md

✅ **Proceed to Module 6: Authentication and Authorization**
