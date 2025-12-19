# Debugging Exercises

## 🎯 Purpose

Hands-on exercises to practice using developer tools for debugging network and API issues.

## 🛠️ Tool-Specific Practice

### Browser DevTools Exercises

#### Exercise 1: Network Tab Analysis
**Objective**: Inspect HTTP requests and identify issues

1. Visit https://jsonplaceholder.typicode.com/
2. Open DevTools (F12) → Network tab
3. Click "posts" link
4. Examine:
   - Request method
   - Status code
   - Response headers
   - Response body
   - Timing information

**Questions**:
- What is the Content-Type?
- How long did the request take?
- Was the response cached?

#### Exercise 2: Failed Request Debugging
**Objective**: Identify why a request failed

1. Visit any website
2. Open DevTools → Network tab
3. Look for failed requests (red status codes)
4. Click on failed request
5. Examine:
   - Status code (4xx or 5xx)
   - Error message in response
   - Request headers
   - Timing (was it a timeout?)

### curl Debugging Exercises

#### Exercise 1: Verbose Mode
```bash
# Use -v to see full request/response
curl -v https://api.github.com/users/octocat

# Identify:
# - HTTP version used
# - TLS version
# - Response headers
# - Status code
```

#### Exercise 2: Follow Redirects
```bash
# See redirect chain
curl -L -v http://github.com

# Count how many redirects
# Note final URL
```

#### Exercise 3: Test Different Methods
```bash
# POST request
curl -X POST https://jsonplaceholder.typicode.com/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"test","body":"content","userId":1}' \
  -v

# Check:
# - Status code (should be 201)
# - Location header
# - Response body
```

### Postman Debugging Exercises

#### Exercise 1: Environment Variables
**Objective**: Use variables to avoid repetition

1. Create environment "JSONPlaceholder"
2. Add variable: `base_url` = `https://jsonplaceholder.typicode.com`
3. Use: `{{base_url}}/posts`
4. Test multiple endpoints

#### Exercise 2: Tests Tab
**Objective**: Automate response validation

```javascript
// In Tests tab
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Response has correct structure", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('id');
    pm.expect(jsonData).to.have.property('title');
});
```

#### Exercise 3: Chain Requests
**Objective**: Use response from one request in another

```javascript
// Request 1: Create user
// In Tests tab:
var jsonData = pm.response.json();
pm.environment.set("user_id", jsonData.id);

// Request 2: Get user
// URL: {{base_url}}/users/{{user_id}}
```

## 🐛 Common Issues and Solutions

### Issue: CORS Error

**Symptom**:
```
Access to fetch at 'https://api.example.com' from origin 'http://localhost:3000'
has been blocked by CORS policy
```

**Debug Steps**:
1. Check if API supports CORS
2. Look for `Access-Control-Allow-Origin` header
3. Use Postman (no CORS restrictions) to verify API works
4. Check if credentials are being sent

### Issue: 401 Unauthorized

**Symptom**: `401 Unauthorized` status code

**Debug Steps**:
1. Check if token is being sent
2. Verify token format (Bearer, Basic, etc.)
3. Check token hasn't expired
4. Test token with curl:
   ```bash
   curl https://api.example.com/protected \
     -H "Authorization: Bearer YOUR_TOKEN" \
     -v
   ```

### Issue: 404 Not Found

**Symptom**: `404 Not Found` status code

**Debug Steps**:
1. Verify URL spelling
2. Check API documentation for correct endpoint
3. Verify HTTP method (GET vs POST)
4. Check if resource exists
5. Look at server logs if available

### Issue: Timeout

**Symptom**: Request takes too long, times out

**Debug Steps**:
1. Check network connectivity: `ping api.example.com`
2. Check if server is up: `curl -I https://api.example.com`
3. Increase timeout: `curl --max-time 60 ...`
4. Check if server is overloaded
5. Look at timing in DevTools

### Issue: SSL/TLS Error

**Symptom**: Certificate verification failed

**Debug Steps**:
1. Check certificate: `openssl s_client -connect api.example.com:443`
2. Verify domain matches certificate
3. Check if certificate is expired
4. Check if intermediate certificates are present

## 🧪 Progressive Challenges

### Challenge 1: API Health Check
Build a script that checks if an API is healthy:
```bash
#!/bin/bash
response=$(curl -s -w "%{http_code}" https://api.example.com/health)
status_code=$(echo "$response" | tail -n1)

if [ "$status_code" -eq 200 ]; then
    echo "✅ API is healthy"
else
    echo "❌ API is down (status: $status_code)"
fi
```

### Challenge 2: Rate Limit Detector
Test API rate limiting:
```bash
#!/bin/bash
for i in {1..100}; do
    response=$(curl -s -w "%{http_code}" https://api.example.com/data)
    status_code=$(echo "$response" | tail -n1)
    
    if [ "$status_code" -eq 429 ]; then
        echo "Rate limited after $i requests"
        break
    fi
done
```

### Challenge 3: Response Time Monitor
Track API response times:
```bash
#!/bin/bash
for i in {1..10}; do
    time=$(curl -w "%{time_total}\n" -o /dev/null -s https://api.example.com/)
    echo "Request $i: ${time}s"
    sleep 1
done
```

## 🔍 Debugging Workflow

1. **Reproduce the issue**: Can you make it happen consistently?
2. **Isolate the problem**: Is it client-side or server-side?
3. **Check the basics**: 
   - Is the URL correct?
   - Is authentication working?
   - Are headers correct?
4. **Use verbose mode**: See full request/response
5. **Compare working vs broken**: What's different?
6. **Simplify**: Reduce to minimal test case
7. **Search error messages**: Google the exact error
8. **Ask for help**: Provide full context and what you've tried

## 📝 Practice Log Template

```markdown
## Issue: [Description]

**Date**: 2025-12-19
**Tool Used**: curl / Postman / DevTools
**Symptom**: [What went wrong]

### Steps to Reproduce
1. 
2. 
3. 

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happened]

### Debug Steps Taken
- [ ] Checked URL spelling
- [ ] Verified authentication
- [ ] Used verbose mode
- [ ] Compared with working example

### Solution
[How you fixed it]

### Lessons Learned
[What you learned from this]
```

## 🎯 Key Debugging Skills

1. **Read error messages carefully**: They often tell you exactly what's wrong
2. **Use verbose mode**: See full request/response
3. **Test in isolation**: Use curl/Postman to eliminate variables
4. **Check documentation**: Verify you're using API correctly
5. **Compare working examples**: See what's different
6. **Use proper tools**: Browser for web, curl for APIs, Postman for exploration
7. **Be systematic**: Work through possibilities methodically

## 🔗 Resources

- [HTTP Status Codes](https://httpstatuses.com/)
- [curl Documentation](https://curl.se/docs/manual.html)
- [Chrome DevTools Network Tab](https://developer.chrome.com/docs/devtools/network/)
- [Postman Learning Center](https://learning.postman.com/)
