# Common Mistakes in Working With APIs

## Beginner Mistakes

### Mistake 1: Not Reading API Documentation

**What people do:**
Try to use APIs by guessing endpoints and parameters instead of reading documentation.

**Why it's a problem:**
- Incorrect API usage
- Missing required parameters
- Wrong data formats
- Authentication failures
- Wasted time debugging

**The right way:**
Read documentation first:
- Available endpoints
- Required/optional parameters
- Authentication methods
- Response formats
- Rate limits
- Error codes

**How to fix if you've already done this:**
Always check official API documentation before implementing.

**Red flags to watch for:**
- Frequent 400/401 errors
- Trial and error approach
- Missing authentication
- Wrong request formats

---

### Mistake 2: Not Handling Errors Properly

**What people do:**
Assume API calls always succeed without proper error handling.

**Why it's a problem:**
- Application crashes on API errors
- Poor user experience
- No retry logic
- Can't debug issues
- Data inconsistencies

**The right way:**
Handle errors comprehensively:

```python
import requests
from requests.exceptions import Timeout, ConnectionError

def call_api(url):
    try:
        response = requests.get(url, timeout=5)
        response.raise_for_status()  # Raise exception for 4xx/5xx
        return response.json()
    except Timeout:
        logger.error("API timeout")
        # Retry logic
    except ConnectionError:
        logger.error("API connection error")
        # Fall back or retry
    except requests.HTTPError as e:
        if e.response.status_code == 404:
            logger.warning("Resource not found")
        elif e.response.status_code == 429:
            logger.warning("Rate limited")
            # Back off and retry
        elif e.response.status_code >= 500:
            logger.error("Server error")
            # Retry with backoff
        else:
            logger.error(f"HTTP error: {e}")
    except ValueError:
        logger.error("Invalid JSON response")
    return None
```

**How to fix if you've already done this:**
Add comprehensive error handling to all API calls.

**Red flags to watch for:**
- No try-catch blocks
- Application crashes
- No error logging
- No retry logic

---

### Mistake 3: Not Respecting Rate Limits

**What people do:**
Make unlimited API requests without checking rate limits.

**Why it's a problem:**
- API blocks your requests (429 errors)
- Account suspension
- Service degradation
- Banned API keys
- Poor citizenship

**The right way:**
Implement rate limiting:

```python
import time
from ratelimit import limits, sleep_and_retry

# Respect API limit: 100 calls per minute
@sleep_and_retry
@limits(calls=100, period=60)
def call_api(url):
    response = requests.get(url)
    
    # Check rate limit headers
    remaining = int(response.headers.get('X-RateLimit-Remaining', 0))
    if remaining < 10:
        reset_time = int(response.headers.get('X-RateLimit-Reset', 0))
        sleep_time = reset_time - time.time()
        if sleep_time > 0:
            time.sleep(sleep_time)
    
    return response.json()
```

**How to fix if you've already done this:**
Add rate limiting and exponential backoff.

**Red flags to watch for:**
- Frequent 429 errors
- API key blocked
- No rate limit handling
- Burst requests

---

### Mistake 4: Hardcoding API Keys

**What people do:**
Put API keys directly in code.

**Why it's a problem:**
- Security breach
- Keys in version control
- Can't rotate keys easily
- Exposure to public
- Compliance violations

**The right way:**
Use environment variables:

```python
import os
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv('API_KEY')
if not API_KEY:
    raise ValueError("API_KEY not set")

headers = {
    'Authorization': f'Bearer {API_KEY}'
}

response = requests.get(url, headers=headers)
```

**How to fix if you've already done this:**
Move all keys to environment variables and rotate exposed keys.

**Red flags to watch for:**
- API keys in code
- Keys in git history
- No .env.example file
- Keys in logs

---

### Mistake 5: Not Validating Responses

**What people do:**
Assume API responses always have the expected structure.

**Why it's a problem:**
- KeyError exceptions
- Wrong data types
- Missing fields
- Application crashes
- Data corruption

**The right way:**
Validate API responses:

```python
from jsonschema import validate, ValidationError

# Define expected schema
user_schema = {
    "type": "object",
    "properties": {
        "id": {"type": "integer"},
        "name": {"type": "string"},
        "email": {"type": "string", "format": "email"}
    },
    "required": ["id", "name", "email"]
}

def get_user(user_id):
    response = requests.get(f'/api/users/{user_id}')
    data = response.json()
    
    try:
        validate(instance=data, schema=user_schema)
        return data
    except ValidationError as e:
        logger.error(f"Invalid API response: {e}")
        return None

# Or manual validation
def validate_user(data):
    if not isinstance(data.get('id'), int):
        raise ValueError("Invalid user ID")
    if not data.get('email'):
        raise ValueError("Missing email")
    return data
```

**How to fix if you've already done this:**
Add response validation to all API calls.

**Red flags to watch for:**
- KeyError exceptions
- Unexpected data types
- Missing field errors
- No validation logic

---

## Intermediate Mistakes

### Mistake 6: No Retry Logic

**What people do:**
Fail immediately on transient errors without retrying.

**Why it's a problem:**
- Poor reliability
- Fails on temporary issues
- No resilience
- Bad user experience
- Unnecessary failures

**The right way:**
Implement retry with exponential backoff:

```python
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10),
    retry=retry_if_exception_type((Timeout, ConnectionError))
)
def call_api_with_retry(url):
    response = requests.get(url, timeout=5)
    response.raise_for_status()
    return response.json()

# Or manual retry
import time

def call_api_with_manual_retry(url, max_retries=3):
    for attempt in range(max_retries):
        try:
            response = requests.get(url, timeout=5)
            response.raise_for_status()
            return response.json()
        except (Timeout, ConnectionError) as e:
            if attempt == max_retries - 1:
                raise
            wait_time = 2 ** attempt  # Exponential backoff
            time.sleep(wait_time)
```

**How to fix if you've already done this:**
Add retry logic for transient failures.

**Red flags to watch for:**
- No retry on timeouts
- Fails on temporary errors
- No exponential backoff
- Poor reliability

---

### Mistake 7: Not Using Pagination

**What people do:**
Try to fetch all results at once or don't handle paginated responses.

**Why it's a problem:**
- Timeouts on large datasets
- Memory issues
- Incomplete data
- API limits exceeded
- Poor performance

**The right way:**
Handle pagination:

```python
def get_all_users(base_url):
    all_users = []
    page = 1
    
    while True:
        response = requests.get(
            f'{base_url}/users',
            params={'page': page, 'per_page': 100}
        )
        data = response.json()
        users = data.get('users', [])
        
        if not users:
            break
            
        all_users.extend(users)
        
        # Check if more pages
        if not data.get('has_next_page'):
            break
            
        page += 1
        time.sleep(0.1)  # Rate limiting
    
    return all_users

# Or cursor-based
def get_all_with_cursor(base_url):
    all_items = []
    cursor = None
    
    while True:
        params = {'limit': 100}
        if cursor:
            params['cursor'] = cursor
            
        response = requests.get(f'{base_url}/items', params=params)
        data = response.json()
        
        all_items.extend(data['items'])
        
        cursor = data.get('next_cursor')
        if not cursor:
            break
    
    return all_items
```

**How to fix if you've already done this:**
Implement pagination handling.

**Red flags to watch for:**
- Timeouts on large requests
- Incomplete data
- Not handling next_page
- Memory issues

---

### Mistake 8: Not Caching API Responses

**What people do:**
Make the same API calls repeatedly without caching.

**Why it's a problem:**
- Unnecessary API calls
- Slow performance
- Rate limit waste
- Higher costs
- Poor efficiency

**The right way:**
Implement caching:

```python
from functools import lru_cache
import redis
import json

# Simple in-memory cache
@lru_cache(maxsize=100)
def get_user_cached(user_id):
    return requests.get(f'/api/users/{user_id}').json()

# Redis cache
redis_client = redis.Redis(host='localhost', port=6379)

def get_with_redis_cache(key, fetch_func, ttl=3600):
    # Check cache
    cached = redis_client.get(key)
    if cached:
        return json.loads(cached)
    
    # Fetch from API
    data = fetch_func()
    
    # Store in cache
    redis_client.setex(key, ttl, json.dumps(data))
    return data

# Usage
user_data = get_with_redis_cache(
    f'user:{user_id}',
    lambda: requests.get(f'/api/users/{user_id}').json(),
    ttl=3600
)
```

**How to fix if you've already done this:**
Add caching for frequently accessed data.

**Red flags to watch for:**
- Repeated identical requests
- Slow performance
- High API usage
- No caching strategy

---

## Advanced Pitfalls

### Mistake 9: Not Using Async/Concurrent Requests

**What people do:**
Make API calls sequentially when they could be parallel.

**Why it's a problem:**
- Slow performance
- Wasted time waiting
- Poor scalability
- Bad user experience
- Inefficient resource usage

**The right way:**
Use concurrent requests:

```python
import asyncio
import aiohttp

async def fetch_user(session, user_id):
    async with session.get(f'/api/users/{user_id}') as response:
        return await response.json()

async def fetch_all_users(user_ids):
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_user(session, uid) for uid in user_ids]
        return await asyncio.gather(*tasks)

# Usage
user_ids = [1, 2, 3, 4, 5]
users = asyncio.run(fetch_all_users(user_ids))

# Or with requests and threading
from concurrent.futures import ThreadPoolExecutor
import requests

def fetch_user_sync(user_id):
    return requests.get(f'/api/users/{user_id}').json()

with ThreadPoolExecutor(max_workers=5) as executor:
    users = list(executor.map(fetch_user_sync, user_ids))
```

**How to fix if you've already done this:**
Use async or threading for multiple requests.

**Red flags to watch for:**
- Sequential API calls
- Long wait times
- Poor performance
- Not utilizing concurrency

---

### Mistake 10: Not Implementing Timeouts

**What people do:**
Make API calls without timeout settings.

**Why it's a problem:**
- Hanging requests
- Resource exhaustion
- Poor user experience
- No failure handling
- Application becomes unresponsive

**The right way:**
Always set timeouts:

```python
import requests

# Set timeout
response = requests.get(url, timeout=5)  # 5 second timeout

# Different connect and read timeouts
response = requests.get(url, timeout=(3, 10))  # 3s connect, 10s read

# With retries and timeout
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

session = requests.Session()
retry_strategy = Retry(
    total=3,
    backoff_factor=1,
    status_forcelist=[429, 500, 502, 503, 504]
)
adapter = HTTPAdapter(max_retries=retry_strategy)
session.mount("http://", adapter)
session.mount("https://", adapter)

response = session.get(url, timeout=5)
```

**How to fix if you've already done this:**
Add timeouts to all API calls.

**Red flags to watch for:**
- Hanging requests
- No timeout configured
- Unresponsive application
- Resource leaks

---

## Prevention Checklist

### Before Using API
- [ ] Read complete documentation
- [ ] Understand authentication
- [ ] Know rate limits
- [ ] Test in development
- [ ] Understand data formats

### Implementation
- [ ] Use environment variables for keys
- [ ] Handle all error cases
- [ ] Implement retry logic
- [ ] Add timeout settings
- [ ] Validate responses
- [ ] Implement caching
- [ ] Handle pagination
- [ ] Respect rate limits

### Production
- [ ] Monitor API usage
- [ ] Log errors properly
- [ ] Set up alerts
- [ ] Have fallback strategies
- [ ] Document API integration
- [ ] Test error scenarios
