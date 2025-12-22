# API Troubleshooting Guide

## Issue Categories

### Cannot Connect to API

**Symptoms:**

- Connection timeout
- Connection refused
- Cannot resolve hostname
- Network errors

**Diagnostic Steps:**

1. **Verify API is running**
   ```bash
   curl -I http://api.example.com/health
   ```

2. **Check network connectivity**
   ```bash
   ping api.example.com
   nslookup api.example.com
   telnet api.example.com 443
   ```

3. **Test from different location**
   - Try from different machine/network
   - Use online tools like Postman or httpbin

**Common Causes & Solutions:**

#### Cause 1: Wrong URL or endpoint

**Error message:**
```
Could not resolve host: api.exmaple.com  # Typo!
```

**Solution:**

```bash
# Verify URL carefully
curl https://api.example.com/v1/users  # Correct
# Not: http://api.example.com/v1/users (wrong protocol)
# Not: https://api.example.com/users (missing /v1)

# Check API documentation for correct base URL
```

#### Cause 2: API server not running

**Error message:**
```
curl: (7) Failed to connect to localhost port 8000: Connection refused
```

**Solution:**

```bash
# Check if server is running
ps aux | grep node  # or python, java, etc.
netstat -tulpn | grep 8000
lsof -i :8000

# Start the server
npm start
# or
python app.py
```

#### Cause 3: Firewall blocking connection

**Solution:**

```bash
# Check firewall rules
sudo iptables -L -n
sudo ufw status

# Allow port
sudo ufw allow 8000

# For cloud providers, check security groups
# AWS: EC2 → Security Groups → Edit inbound rules
# Add rule: TCP, Port 8000, Source 0.0.0.0/0
```

#### Cause 4: CORS errors (browser only)

**Error message (in browser console):**
```
Access to fetch at 'https://api.example.com' from origin 'http://localhost:3000' 
has been blocked by CORS policy
```

**Solution:**

Server-side fix (Express.js example):
```javascript
const cors = require('cors');
app.use(cors({
  origin: ['http://localhost:3000', 'https://yourapp.com'],
  credentials: true
}));
```

Client-side workaround (development only):
```javascript
// Use a CORS proxy (development only!)
const proxyUrl = 'https://cors-anywhere.herokuapp.com/';
fetch(proxyUrl + apiUrl)
```

---

### Authentication Errors

**Symptoms:**

- 401 Unauthorized
- 403 Forbidden
- Invalid token errors
- Authentication required

**Diagnostic Steps:**

1. **Check authentication headers**
   ```bash
   curl -v https://api.example.com/protected
   # Look for WWW-Authenticate header
   ```

2. **Verify credentials**
   ```bash
   # Test with credentials
   curl -H "Authorization: Bearer YOUR_TOKEN" https://api.example.com/protected
   ```

**Common Causes & Solutions:**

#### Cause 1: Missing authentication header

**Error message:**
```
401 Unauthorized
{"error": "No authorization header"}
```

**Solution:**

```bash
# Add Authorization header
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.example.com/users

# For API keys
curl -H "X-API-Key: YOUR_API_KEY" \
  https://api.example.com/users

# For basic auth
curl -u username:password \
  https://api.example.com/users
```

In code (JavaScript):
```javascript
fetch('https://api.example.com/users', {
  headers: {
    'Authorization': 'Bearer YOUR_TOKEN'
  }
});
```

In Python:
```python
import requests

headers = {'Authorization': 'Bearer YOUR_TOKEN'}
response = requests.get('https://api.example.com/users', headers=headers)
```

#### Cause 2: Expired token

**Error message:**
```
401 Unauthorized
{"error": "Token has expired"}
```

**Solution:**

1. Refresh the token:
```javascript
// Get new token
const refreshToken = async () => {
  const response = await fetch('/api/auth/refresh', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ refresh_token: storedRefreshToken })
  });
  const data = await response.json();
  return data.access_token;
};
```

2. Implement auto-refresh:
```javascript
async function fetchWithAuth(url, options = {}) {
  let response = await fetch(url, {
    ...options,
    headers: {
      ...options.headers,
      'Authorization': `Bearer ${accessToken}`
    }
  });
  
  if (response.status === 401) {
    // Token expired, refresh it
    accessToken = await refreshToken();
    // Retry request
    response = await fetch(url, {
      ...options,
      headers: {
        ...options.headers,
        'Authorization': `Bearer ${accessToken}`
      }
    });
  }
  
  return response;
}
```

#### Cause 3: Wrong permissions (403)

**Error message:**
```
403 Forbidden
{"error": "Insufficient permissions"}
```

**Solution:**

1. Check user role/permissions
2. Request access from admin
3. Use account with appropriate permissions
4. Verify token includes correct scopes

```bash
# Decode JWT to check permissions
# Use jwt.io or:
echo "YOUR_JWT_TOKEN" | cut -d'.' -f2 | base64 -d | jq
```

#### Cause 4: Invalid API key

**Solution:**

```bash
# Verify API key is correct
# Check for:
# - Typos
# - Extra spaces
# - Wrong environment (dev vs prod key)

# Test with curl
curl -H "X-API-Key: YOUR_KEY" \
  https://api.example.com/test

# If still failing, regenerate API key in dashboard
```

---

### Request/Response Issues

**Symptoms:**

- 400 Bad Request
- 422 Unprocessable Entity
- Malformed JSON errors
- Missing required fields

**Diagnostic Steps:**

1. **Inspect full request**
   ```bash
   curl -v -X POST https://api.example.com/users \
     -H "Content-Type: application/json" \
     -d '{"name": "John"}'
   ```

2. **Validate JSON**
   ```bash
   echo '{"name": "John"}' | jq
   ```

3. **Check API documentation**
   - Required fields
   - Data types
   - Format requirements

**Common Causes & Solutions:**

#### Cause 1: Malformed JSON

**Error message:**
```
400 Bad Request
{"error": "Unexpected token } in JSON at position 15"}
```

**Solution:**

```bash
# Bad JSON - trailing comma
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John", "email": "john@example.com",}'

# Good JSON
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John", "email": "john@example.com"}'

# Validate JSON before sending
echo '{"name": "John"}' | jq .  # No output = invalid
```

#### Cause 2: Missing required fields

**Error message:**
```
422 Unprocessable Entity
{"error": "Field 'email' is required"}
```

**Solution:**

```bash
# Check API documentation for required fields
# Include all required fields

curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "age": 30
  }'
```

#### Cause 3: Wrong Content-Type

**Error message:**
```
415 Unsupported Media Type
```

**Solution:**

```bash
# Always specify Content-Type for POST/PUT/PATCH
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John"}'

# For form data
curl -X POST https://api.example.com/upload \
  -F "file=@image.jpg" \
  -F "description=My image"
```

#### Cause 4: Wrong HTTP method

**Error message:**
```
405 Method Not Allowed
```

**Solution:**

```bash
# Check API documentation for correct method
# Common patterns:
# GET - Retrieve data
# POST - Create new resource
# PUT - Full update of resource
# PATCH - Partial update
# DELETE - Remove resource

# Example: Creating a user (usually POST)
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John"}'
```

---

### Rate Limiting

**Symptoms:**

- 429 Too Many Requests
- API stops responding
- Requests getting slower

**Diagnostic Steps:**

1. **Check rate limit headers**
   ```bash
   curl -I https://api.example.com/users
   # Look for:
   # X-RateLimit-Limit: 100
   # X-RateLimit-Remaining: 99
   # X-RateLimit-Reset: 1234567890
   ```

2. **Monitor request frequency**
   ```bash
   # Count requests in logs
   grep "GET /api" access.log | wc -l
   ```

**Common Causes & Solutions:**

#### Cause 1: Exceeded rate limit

**Error message:**
```
429 Too Many Requests
{"error": "Rate limit exceeded. Try again in 60 seconds"}
```

**Solution:**

Implement exponential backoff:

```javascript
async function fetchWithRetry(url, options = {}, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    const response = await fetch(url, options);
    
    if (response.status === 429) {
      // Check Retry-After header
      const retryAfter = response.headers.get('Retry-After');
      const delay = retryAfter ? parseInt(retryAfter) * 1000 : Math.pow(2, i) * 1000;
      
      console.log(`Rate limited. Waiting ${delay}ms before retry ${i + 1}`);
      await new Promise(resolve => setTimeout(resolve, delay));
      continue;
    }
    
    return response;
  }
  
  throw new Error('Max retries exceeded');
}
```

Python example:
```python
import time
import requests

def fetch_with_retry(url, max_retries=3):
    for i in range(max_retries):
        response = requests.get(url)
        
        if response.status_code == 429:
            retry_after = int(response.headers.get('Retry-After', 2 ** i))
            print(f"Rate limited. Waiting {retry_after}s")
            time.sleep(retry_after)
            continue
        
        return response
    
    raise Exception('Max retries exceeded')
```

#### Cause 2: Too many parallel requests

**Solution:**

```javascript
// Bad - all at once
const urls = [/* many URLs */];
const promises = urls.map(url => fetch(url));
await Promise.all(promises);  // May hit rate limit

// Good - batch requests
async function batchFetch(urls, batchSize = 5) {
  const results = [];
  for (let i = 0; i < urls.length; i += batchSize) {
    const batch = urls.slice(i, i + batchSize);
    const batchResults = await Promise.all(
      batch.map(url => fetch(url))
    );
    results.push(...batchResults);
    
    // Optional: delay between batches
    if (i + batchSize < urls.length) {
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }
  return results;
}
```

---

### Timeout Issues

**Symptoms:**

- Request times out
- No response received
- Gateway timeout errors (504)

**Diagnostic Steps:**

1. **Check response time**
   ```bash
   time curl https://api.example.com/slow-endpoint
   ```

2. **Monitor server logs**
   ```bash
   tail -f /var/log/api/access.log
   ```

**Common Causes & Solutions:**

#### Cause 1: Request timeout too short

**Solution:**

Increase timeout:

```javascript
// JavaScript fetch with timeout
async function fetchWithTimeout(url, timeout = 5000) {
  const controller = new AbortController();
  const id = setTimeout(() => controller.abort(), timeout);
  
  try {
    const response = await fetch(url, {
      signal: controller.signal
    });
    clearTimeout(id);
    return response;
  } catch (error) {
    clearTimeout(id);
    if (error.name === 'AbortError') {
      throw new Error('Request timeout');
    }
    throw error;
  }
}

// Use with longer timeout
const response = await fetchWithTimeout(url, 30000);  // 30 seconds
```

Python:
```python
import requests

# Set timeout (in seconds)
response = requests.get(url, timeout=30)
```

cURL:
```bash
# Set timeout with --max-time
curl --max-time 30 https://api.example.com/slow
```

#### Cause 2: Slow API endpoint

**Solution:**

1. Optimize query/processing on server
2. Add caching
3. Use pagination for large datasets
4. Implement async processing for long tasks

```javascript
// Instead of waiting for long process
// POST to start job, GET to check status

// Start job
const startResponse = await fetch('/api/jobs', {
  method: 'POST',
  body: JSON.stringify({ task: 'generate_report' })
});
const { jobId } = await startResponse.json();

// Poll for completion
async function waitForJob(jobId) {
  while (true) {
    const response = await fetch(`/api/jobs/${jobId}`);
    const { status, result } = await response.json();
    
    if (status === 'completed') {
      return result;
    }
    
    if (status === 'failed') {
      throw new Error('Job failed');
    }
    
    // Wait before checking again
    await new Promise(resolve => setTimeout(resolve, 2000));
  }
}

const result = await waitForJob(jobId);
```

---

### SSL/TLS Certificate Issues

**Symptoms:**

- SSL certificate error
- Certificate verification failed
- Untrusted certificate

**Diagnostic Steps:**

1. **Check certificate**
   ```bash
   openssl s_client -connect api.example.com:443 -servername api.example.com
   ```

2. **View certificate details**
   ```bash
   curl -vI https://api.example.com 2>&1 | grep -A 10 "Server certificate"
   ```

**Common Causes & Solutions:**

#### Cause 1: Self-signed certificate

**Error message:**
```
SSL certificate problem: self signed certificate
```

**Solution:**

Development only (NOT for production):
```bash
# cURL - skip verification
curl -k https://api.example.com

# Node.js - disable SSL verification (DANGEROUS!)
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

# Python requests
import requests
requests.get('https://api.example.com', verify=False)
```

Proper solution:
1. Get proper SSL certificate (Let's Encrypt is free)
2. Or add self-signed cert to trusted store

#### Cause 2: Expired certificate

**Solution:**

1. Server-side: Renew certificate
2. Client-side: Update certificate bundle
```bash
# Update CA certificates (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install ca-certificates
```

#### Cause 3: Hostname mismatch

**Error message:**
```
SSL: certificate subject name 'example.com' does not match target host name 'api.example.com'
```

**Solution:**

Server-side: Get certificate with correct hostname/SANs

---

## Quick Reference Commands

### Testing APIs with cURL

```bash
# GET request
curl https://api.example.com/users

# POST with JSON
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John", "email": "john@example.com"}'

# With authentication
curl -H "Authorization: Bearer TOKEN" \
  https://api.example.com/protected

# View headers
curl -I https://api.example.com/users
curl -v https://api.example.com/users  # Verbose

# Save response
curl -o response.json https://api.example.com/users

# Follow redirects
curl -L https://api.example.com/redirect

# Upload file
curl -X POST https://api.example.com/upload \
  -F "file=@image.jpg"

# Basic auth
curl -u username:password https://api.example.com/protected
```

### Testing with HTTPie (more user-friendly)

```bash
# Install
pip install httpie

# GET request
http https://api.example.com/users

# POST with JSON (automatic)
http POST https://api.example.com/users \
  name=John email=john@example.com

# With auth
http https://api.example.com/protected \
  Authorization:"Bearer TOKEN"

# Download file
http --download https://api.example.com/files/report.pdf
```

### Common HTTP Status Codes

```
2xx - Success
200 OK - Request succeeded
201 Created - Resource created
204 No Content - Success but no response body

4xx - Client Errors
400 Bad Request - Invalid request
401 Unauthorized - Authentication required
403 Forbidden - Not allowed
404 Not Found - Resource doesn't exist
422 Unprocessable Entity - Validation error
429 Too Many Requests - Rate limited

5xx - Server Errors
500 Internal Server Error - Server error
502 Bad Gateway - Invalid response from upstream
503 Service Unavailable - Server temporarily down
504 Gateway Timeout - Upstream timeout
```

## Prevention Tips

1. **Always handle errors**
```javascript
async function callAPI() {
  try {
    const response = await fetch('https://api.example.com/users');
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }
    
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('API call failed:', error);
    // Handle error appropriately
    throw error;
  }
}
```

2. **Implement retry logic**
3. **Use timeouts**
4. **Log requests for debugging**
5. **Validate data before sending**
6. **Use API client libraries**
7. **Monitor API health**
8. **Read the documentation!**

## When to Ask for Help

If you've tried these steps and still stuck:

1. Check API documentation thoroughly
2. Search API provider's support forum
3. Check GitHub issues if API is open source
4. Test with different tools (curl, Postman, code)
5. Ask on Stack Overflow with API-specific tag

When asking, provide:
- Exact endpoint URL (sanitize sensitive data)
- Request method and headers
- Request body if applicable
- Response status code and body
- Error messages
- What you've already tried
