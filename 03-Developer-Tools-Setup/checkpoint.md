# Module 3 Checkpoint: Developer Tools Setup

## Before Moving Forward

Complete this checkpoint to ensure you're ready for the next module.

## Knowledge Check (Answer these questions)

### Fundamentals

1. What are Browser DevTools and why are they essential for web development?
   <details>
   <summary>Answer</summary>
   Browser DevTools are built-in debugging and inspection tools in web browsers (Chrome, Firefox, Safari). They allow developers to inspect HTML/CSS, debug JavaScript, monitor network requests, analyze performance, and modify pages in real-time. They're essential because they provide visibility into what's happening behind the scenes, help diagnose issues, and enable rapid iteration without modifying source files.
   </details>

2. What is the purpose of the Network tab in Browser DevTools?
   <details>
   <summary>Answer</summary>
   The Network tab records and displays all HTTP requests made by the page, including HTML, CSS, JavaScript, images, and API calls. It shows request/response headers, status codes, timing information, and payload data. This is crucial for debugging API issues, optimizing page load performance, understanding request flow, and verifying that resources load correctly.
   </details>

3. What is Postman and when would you use it instead of a browser?
   <details>
   <summary>Answer</summary>
   Postman is a dedicated API testing tool that allows you to send HTTP requests (GET, POST, PUT, DELETE, etc.) and inspect responses. Use Postman instead of a browser when: 1) Testing APIs that don't have a web interface, 2) Making POST/PUT/DELETE requests (browsers typically only make GET requests when you visit URLs), 3) Setting custom headers, 4) Saving and organizing request collections, 5) Automating API testing.
   </details>

4. What is curl and what are its main use cases?
   <details>
   <summary>Answer</summary>
   curl is a command-line tool for making HTTP requests. It's used for: 1) Scripting and automation (can be used in shell scripts), 2) Quick API testing without GUI, 3) Testing from servers without graphical interface, 4) CI/CD pipelines and automated testing, 5) Downloading files programmatically. It's powerful, lightweight, and available on virtually every system.
   </details>

### Intermediate

5. How do you inspect the request headers sent by your browser?
   <details>
   <summary>Answer</summary>
   Open Browser DevTools (F12) → Network tab → Reload the page → Click on any request → View "Headers" section. The "Request Headers" section shows what your browser sent, including User-Agent, Accept headers, cookies, and custom headers. Understanding request headers helps debug authentication issues, CORS problems, and server behavior.
   </details>

6. What is the Console tab in DevTools used for?
   <details>
   <summary>Answer</summary>
   The Console tab displays JavaScript errors, warnings, and logs (console.log output). It also provides a JavaScript REPL (Read-Eval-Print Loop) where you can execute JavaScript code in the context of the current page. Uses include: debugging JavaScript, testing functions interactively, inspecting variables, and experimenting with DOM manipulation without editing source files.
   </details>

7. How do you send a POST request with JSON data using curl?
   <details>
   <summary>Answer</summary>
   ```bash
   curl -X POST https://api.example.com/users \
     -H "Content-Type: application/json" \
     -d '{"name": "John", "email": "john@example.com"}'
   ```
   - `-X POST`: Specifies POST method
   - `-H`: Sets headers
   - `-d`: Sends data (automatically sets Content-Type if not specified)
   
   For more complex JSON, use `-d @file.json` to read from a file.
   </details>

8. What is HTTPie and how does it differ from curl?
   <details>
   <summary>Answer</summary>
   HTTPie is a more user-friendly, modern alternative to curl designed specifically for HTTP. Key differences: 1) More intuitive syntax (http GET vs curl -X GET), 2) Colored, formatted output by default, 3) JSON support built-in (automatic Content-Type headers), 4) More readable request/response display, 5) Simpler authentication options. curl is more powerful and universal, HTTPie is more convenient for humans.
   </details>

### Advanced

9. How do you use DevTools to throttle network speed and why would you do this?
   <details>
   <summary>Answer</summary>
   In DevTools Network tab, click the "No throttling" dropdown and select a profile (Fast 3G, Slow 3G, Offline). This simulates slower network conditions to test how your site performs for users with poor connectivity. It helps identify: 1) Performance bottlenecks on slow networks, 2) Loading states and spinners, 3) Timeout issues, 4) Progressive enhancement opportunities. Critical for mobile users in areas with poor connectivity.
   </details>

10. How can you modify and resend an HTTP request using Browser DevTools?
    <details>
    <summary>Answer</summary>
    In Chrome DevTools Network tab: Right-click on a request → "Copy" → "Copy as fetch/cURL". Then paste and modify in Console (for fetch) or terminal (for cURL). Alternatively, in Firefox: Right-click → "Edit and Resend" allows direct editing. In Chrome, you can also use "Copy as Fetch" and modify in Console. This is useful for testing different parameters, headers, or payloads without writing code.
    </details>

11. What are Postman Collections and Environments, and why are they useful?
    <details>
    <summary>Answer</summary>
    Collections are groups of related API requests organized in folders. Environments are sets of variables (like API keys, base URLs) that can be switched between (dev, staging, production). They're useful because: 1) Organize APIs logically, 2) Share request examples with team, 3) Switch between environments without editing requests, 4) Document API usage, 5) Run automated test suites. Variables like {{baseUrl}} make requests portable.
    </details>

12. How do you debug CORS issues using DevTools?
    <details>
    <summary>Answer</summary>
    1. Open DevTools Console - CORS errors appear there with detailed messages
    2. Check Network tab - failed requests show in red
    3. Click the failed request → Headers section
    4. Look for "Access-Control-Allow-Origin" in Response Headers
    5. Check if the origin is allowed
    6. Verify preflight OPTIONS request succeeded (for POST/PUT/DELETE)
    7. Check request has correct credentials mode if cookies needed
    
    Common fixes: Ensure server sends proper CORS headers, verify request origin matches allowed origin, check credentials are configured correctly.
    </details>

## Practical Skills Verification

### Task 1: Master Browser DevTools Network Tab
**Objective:** Use DevTools to analyze and understand HTTP traffic.

**Steps:**
1. Open DevTools (F12) and go to Network tab
2. Visit https://jsonplaceholder.typicode.com
3. Enable "Preserve log" to keep requests across page loads
4. Disable cache to ensure fresh requests
5. Navigate to https://jsonplaceholder.typicode.com/users
6. Find the request for "/users" and examine:
   - Status code (should be 200)
   - Response headers (Content-Type: application/json)
   - Response body (JSON array of users)
   - Request headers (User-Agent, Accept)
   - Timing (how long it took)

**Success Criteria:**
- [ ] Can navigate and filter Network tab efficiently
- [ ] Can identify request method, status, and timing
- [ ] Can read request and response headers
- [ ] Understand the request/response cycle

**Troubleshooting:**
If Network tab is empty, ensure you opened DevTools before loading the page. Click "Clear" (circle with line) to clear old requests. Use the filter box to search for specific requests. On slow networks, increase timeout settings.

---

### Task 2: Make API Requests with Postman
**Objective:** Use Postman to test REST API endpoints.

**Steps:**
1. Install Postman (https://www.postman.com/downloads/) or use web version
2. Create a new request
3. Make a GET request to: `https://api.github.com/users/octocat`
4. Examine the JSON response
5. Make a POST request to: `https://jsonplaceholder.typicode.com/posts`
   - Set Body type to "raw" and "JSON"
   - Add JSON data:
     ```json
     {
       "title": "Test Post",
       "body": "This is a test",
       "userId": 1
     }
     ```
6. Verify you get a 201 Created response

**Success Criteria:**
- [ ] Successfully make GET requests
- [ ] Successfully make POST requests with JSON body
- [ ] Can read and understand API responses
- [ ] Can set headers and request body

**Troubleshooting:**
If POST requests fail, verify Content-Type header is set to "application/json". Check the response for error messages. JSONPlaceholder is a fake API so it won't actually create resources, but it simulates the response.

---

### Task 3: Use curl for Command-Line API Testing
**Objective:** Make HTTP requests from the terminal using curl.

**Steps:**
1. Open terminal/command prompt
2. Make a simple GET request:
   ```bash
   curl https://api.github.com/users/octocat
   ```
3. Make request with verbose output:
   ```bash
   curl -v https://api.github.com/users/octocat
   ```
4. Make POST request with JSON:
   ```bash
   curl -X POST https://jsonplaceholder.typicode.com/posts \
     -H "Content-Type: application/json" \
     -d '{"title":"Test","body":"Content","userId":1}'
   ```
5. Save response to file:
   ```bash
   curl https://api.github.com/users/octocat -o user.json
   ```

**Success Criteria:**
- [ ] Can make GET requests with curl
- [ ] Can make POST requests with JSON payload
- [ ] Can use -v flag to see request/response details
- [ ] Can save responses to files

**Troubleshooting:**
On Windows, use double quotes for JSON and escape inner quotes: `"{\"title\":\"Test\"}"`. If curl is not found, ensure it's installed (comes with Windows 10+, macOS, most Linux distros). Use Git Bash on Windows if needed.

---

### Task 4: HTTPie for Human-Friendly Requests
**Objective:** Use HTTPie as a more readable alternative to curl.

**Steps:**
1. Install HTTPie: `pip install httpie` or `brew install httpie`
2. Make a GET request:
   ```bash
   http GET https://api.github.com/users/octocat
   ```
3. Make a POST request (note the simple syntax):
   ```bash
   http POST https://jsonplaceholder.typicode.com/posts \
     title="Test Post" body="Content" userId=1
   ```
4. Add custom headers:
   ```bash
   http GET https://api.github.com/users/octocat \
     User-Agent:"My-App/1.0"
   ```
5. Download a file:
   ```bash
   http --download GET https://api.github.com/users/octocat
   ```

**Success Criteria:**
- [ ] HTTPie is installed and working
- [ ] Can make requests with simpler syntax than curl
- [ ] Appreciate colored, formatted output
- [ ] Understand when to use HTTPie vs curl

**Troubleshooting:**
If pip is not found, install Python first. On some systems, use `pip3` instead of `pip`. If you prefer, HTTPie is optional - curl is more universal and sufficient for most tasks.

---

### Task 5: Debug with Console and Elements
**Objective:** Use DevTools Console and Elements tabs for debugging.

**Steps:**
1. Visit any website
2. Open DevTools → Console tab
3. Run JavaScript commands:
   ```javascript
   console.log('Hello from console');
   document.title;
   document.querySelectorAll('a').length;
   ```
4. Go to Elements tab
5. Right-click an element → Inspect
6. Modify element CSS in Styles panel
7. Use "Select element" tool to inspect different parts of page

**Success Criteria:**
- [ ] Can execute JavaScript in Console
- [ ] Can inspect and modify elements
- [ ] Can change CSS styles in real-time
- [ ] Understand these changes are temporary

**Troubleshooting:**
If Console shows errors, they're from the page's JavaScript, not your commands. You can still run your own code. In Elements tab, changes are local only - refresh to reset. Use "Computed" tab to see final calculated styles.

## Project-Based Assessment

**Mini-Project:** API Testing Suite Documentation

Create a comprehensive API testing guide for a public API.

**Requirements:**
- [ ] Choose a public REST API (GitHub API, JSONPlaceholder, OpenWeather, etc.)
- [ ] Document at least 5 different endpoints
- [ ] For each endpoint, provide:
  - [ ] Purpose/description
  - [ ] Example request using curl
  - [ ] Example request using HTTPie (or Postman screenshot)
  - [ ] Expected response with status code
  - [ ] Common error scenarios and responses
- [ ] Create a Postman collection with all requests
- [ ] Include examples of: GET, POST, PUT/PATCH, DELETE (if API supports)
- [ ] Document required headers (API keys, Content-Type, etc.)
- [ ] Create a troubleshooting guide covering:
  - [ ] Authentication errors (401, 403)
  - [ ] Not found errors (404)
  - [ ] Rate limiting (429)
  - [ ] Server errors (500, 503)
- [ ] Use DevTools to capture and screenshot at least 3 requests
- [ ] Export and include your Postman collection JSON

**Evaluation Rubric:**
| Criteria | Needs Work | Good | Excellent |
|----------|------------|------|-----------|
| **Tool Proficiency** | Only uses one tool, basic usage | Uses multiple tools competently | Expert use of DevTools, Postman, and curl/HTTPie |
| **Documentation** | Incomplete, hard to follow | Clear documentation for most endpoints | Professional-quality API documentation with examples |
| **Error Handling** | Doesn't cover errors | Covers common errors | Comprehensive error scenarios with solutions |
| **Completeness** | Missing 3+ requirements | Missing 1-2 requirements | All requirements met plus extras (authentication, pagination, etc.) |

**Sample Solution:**
See `checkpoint-solutions/03-api-testing-suite.md` for an example using the GitHub API.

## Self-Assessment

Rate your confidence (1-5) in these areas:
- [ ] Using Browser DevTools Network tab: ___/5
- [ ] Making API requests with Postman: ___/5
- [ ] Using curl from command line: ___/5
- [ ] Debugging web applications with DevTools: ___/5

**If you scored below 3 on any:**
- Practice with the tools daily - muscle memory matters
- Follow along with YouTube tutorials on DevTools
- Test different public APIs to gain experience
- Review the tool documentation (Chrome DevTools, Postman docs)

**If you scored 4+ on all:**
- You're ready to move forward!
- Consider the advanced challenges below

## Advanced Challenges (Optional)

For those who want to go deeper:

1. **Postman Automation**: Learn Postman's test scripts feature. Write tests that validate status codes, check response schemas, and verify data. Create a collection that runs automated tests against an API.

2. **curl Scripting**: Write a bash/PowerShell script that uses curl to: 1) Make an API request, 2) Parse the JSON response (using jq), 3) Use that data in another request. Example: Get user ID, then fetch that user's repositories.

3. **DevTools Performance**: Use the Performance tab to record page load. Identify bottlenecks, understand the flame graph, and find long-running JavaScript or render-blocking resources. Compare performance before and after optimization.

4. **Network HAR Files**: Export a HAR (HTTP Archive) file from DevTools. Understand its format, import it back into DevTools or other tools, and use it for performance analysis.

5. **API Authentication**: Test an API that requires authentication (GitHub with personal access token, or Twitter API). Learn to securely manage API keys, use environment variables, and implement OAuth flows in Postman.

## Ready to Continue?

- [ ] I've completed the knowledge check (80% or better)
- [ ] I've verified all practical skills
- [ ] I've completed the mini-project
- [ ] I feel confident in this module's concepts
- [ ] I've reviewed common-mistakes.md (if available)

✅ **Proceed to Module 4: HTTP Fundamentals**
