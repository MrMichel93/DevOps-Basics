# Module 05: Working With APIs

## 🎯 Learning Objectives

- ✅ Make API requests with different tools
- ✅ Read and understand API documentation
- ✅ Handle JSON and XML responses
- ✅ Implement error handling
- ✅ Work with query parameters and request bodies

**Time Required**: 3-4 hours

## 🔌 What is an API?

**API** (Application Programming Interface) allows different software applications to communicate. A web API uses HTTP to enable interaction between client and server.

### Why APIs Matter

- Share data between applications
- Build integrations
- Create mobile apps
- Automate tasks
- Access third-party services

## 📖 Reading API Documentation

Good API documentation includes:

1. **Base URL**: Where the API lives
2. **Authentication**: How to prove identity
3. **Endpoints**: Available resources
4. **Methods**: HTTP verbs supported
5. **Parameters**: Required and optional data
6. **Responses**: Expected return data
7. **Error codes**: What errors mean
8. **Rate limits**: Request throttling
9. **Examples**: Sample requests

### Example Documentation Structure

```
Base URL: https://api.example.com/v1

Endpoint: GET /users
Description: Get list of users
Parameters:
  - page (optional): Page number
  - limit (optional): Results per page
Response: 200 OK
{
  "users": [...]
}
```

## 🧰 Making Requests with Different Tools

### Using curl

```bash
# Basic GET
curl https://api.github.com/users/octocat

# With query parameters
curl "https://api.github.com/search/repositories?q=language:python&sort=stars"

# With headers
curl -H "Accept: application/json" \
     -H "Authorization: Bearer TOKEN" \
     https://api.example.com/data

# POST with JSON
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John","email":"john@example.com"}'
```

### Using HTTPie

```bash
# Basic GET
http https://api.github.com/users/octocat

# With query parameters
http GET https://api.github.com/search/repositories q=="language:python" sort==stars

# With headers
http GET https://api.example.com/data \
  Authorization:"Bearer TOKEN"

# POST with JSON
http POST https://api.example.com/users \
  name="John" email="john@example.com"
```

### Using Postman

1. Create new request
2. Select method (GET, POST, etc.)
3. Enter URL
4. Add headers in "Headers" tab
5. Add body in "Body" tab
6. Click "Send"

## 📊 Handling Responses

### JSON (JavaScript Object Notation)

Most common API response format:

```json
{
  "id": 123,
  "name": "John Doe",
  "email": "john@example.com",
  "roles": ["user", "admin"],
  "profile": {
    "age": 30,
    "location": "New York"
  }
}
```

**Parsing JSON** (curl + jq):
```bash
curl https://api.github.com/users/octocat | jq '.name'
```

### XML

Older format, still used in some APIs:

```xml
<user>
  <id>123</id>
  <name>John Doe</name>
  <email>john@example.com</email>
</user>
```

## 🔑 Query Parameters

Send data in URL for GET requests:

```bash
# Single parameter
curl "https://api.example.com/search?q=networking"

# Multiple parameters
curl "https://api.example.com/search?q=networking&page=2&limit=10"

# URL encoding (spaces, special chars)
curl "https://api.example.com/search?q=hello%20world"
```

## 📝 Request Bodies

Send data in body for POST/PUT/PATCH:

### JSON Body

```bash
curl -X POST https://api.example.com/posts \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My Post",
    "body": "Content here",
    "tags": ["tech", "api"]
  }'
```

### Form Data

```bash
curl -X POST https://api.example.com/upload \
  -F "file=@document.pdf" \
  -F "title=My Document"
```

## ⚠️ Error Handling

### Common Error Patterns

**400 Bad Request**:
```json
{
  "error": "Validation failed",
  "details": {
    "email": "Invalid email format"
  }
}
```

**401 Unauthorized**:
```json
{
  "error": "Authentication required",
  "message": "Please provide valid credentials"
}
```

**404 Not Found**:
```json
{
  "error": "Resource not found",
  "resource": "User",
  "id": 123
}
```

**429 Too Many Requests**:
```json
{
  "error": "Rate limit exceeded",
  "retry_after": 60
}
```

**500 Internal Server Error**:
```json
{
  "error": "Internal server error",
  "request_id": "abc123"
}
```

### Handling Errors in Practice

```bash
# Check status code
response=$(curl -s -w "%{http_code}" https://api.example.com/data)
status_code=$(echo "$response" | tail -n1)

if [ "$status_code" -eq 200 ]; then
  echo "Success!"
else
  echo "Error: $status_code"
fi
```

## 🧪 Hands-On Exercises

### Exercise 1: Explore GitHub API

```bash
# Get your user info
curl https://api.github.com/users/YOUR_USERNAME

# Get repositories
curl https://api.github.com/users/YOUR_USERNAME/repos

# Search repositories
curl "https://api.github.com/search/repositories?q=language:python&sort=stars&order=desc"
```

### Exercise 2: Use JSONPlaceholder

```bash
# Get all posts
curl https://jsonplaceholder.typicode.com/posts

# Get specific post
curl https://jsonplaceholder.typicode.com/posts/1

# Get post comments
curl https://jsonplaceholder.typicode.com/posts/1/comments

# Create post
curl -X POST https://jsonplaceholder.typicode.com/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","body":"Content","userId":1}'

# Update post
curl -X PUT https://jsonplaceholder.typicode.com/posts/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated","body":"New","userId":1}'

# Delete post
curl -X DELETE https://jsonplaceholder.typicode.com/posts/1
```

### Exercise 3: Work with Query Parameters

```bash
# Filter posts by user
curl "https://jsonplaceholder.typicode.com/posts?userId=1"

# Get nested resources
curl "https://jsonplaceholder.typicode.com/comments?postId=1"
```

### Exercise 4: Parse JSON Responses

If you have `jq` installed:

```bash
# Extract specific field
curl https://api.github.com/users/octocat | jq '.name'

# Get array element
curl https://jsonplaceholder.typicode.com/posts | jq '.[0].title'

# Filter array
curl https://jsonplaceholder.typicode.com/posts | jq '.[] | select(.userId == 1)'
```

## 🎯 Best Practices

1. **Always check status codes** before processing responses
2. **Handle errors gracefully** with retry logic
3. **Respect rate limits** to avoid being blocked
4. **Use appropriate HTTP methods** (GET for read, POST for create)
5. **Set correct Content-Type** header
6. **Keep API keys secure** (never commit to version control)
7. **Cache responses** when appropriate
8. **Use API versioning** when available
9. **Read documentation** thoroughly
10. **Test with fake APIs** before using production

## 🔗 Free APIs for Practice

- **JSONPlaceholder**: https://jsonplaceholder.typicode.com/
- **GitHub API**: https://api.github.com
- **OpenWeatherMap**: https://openweathermap.org/api (free tier)
- **REQ | RES**: https://reqres.in/
- **Dog API**: https://dog.ceo/dog-api/
- **Cat Facts**: https://catfact.ninja/
- **Public APIs List**: https://github.com/public-apis/public-apis

## 📖 Next Steps

➡️ [Module 06: Authentication and Authorization](../06-Authentication-and-Authorization/)

## 🔗 Resources

- [REST API Tutorial](https://restfulapi.net/)
- [JSON Formatter](https://jsonformatter.org/)
- [jq Tutorial](https://stedolan.github.io/jq/tutorial/)
- [Postman Learning Center](https://learning.postman.com/)
