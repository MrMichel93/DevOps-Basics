# Common Mistakes in REST API Design

## Beginner Mistakes

### Mistake 1: Not Using Appropriate HTTP Methods

**What people do:**
Use POST for everything or GET for operations that modify data.

**Why it's a problem:**
- Violates REST principles
- Breaks caching
- Security issues
- Poor API semantics
- Confusing for clients

**The right way:**
Use correct HTTP methods:
- GET: Retrieve resources (safe, idempotent)
- POST: Create new resources
- PUT: Replace entire resource (idempotent)
- PATCH: Partial update
- DELETE: Remove resource (idempotent)

```
GET    /api/users        # List users
GET    /api/users/123    # Get specific user
POST   /api/users        # Create user
PUT    /api/users/123    # Replace user
PATCH  /api/users/123    # Update user partially
DELETE /api/users/123    # Delete user
```

**How to fix if you've already done this:**
Update endpoints to use appropriate methods.

**Red flags to watch for:**
- All endpoints using POST
- GET requests modifying data
- DELETE using POST
- Not supporting PUT/PATCH

---

### Mistake 2: Poor URL Design

**What people do:**
Use verbs in URLs, inconsistent naming, or non-hierarchical structures.

**Why it's a problem:**
- Confusing API structure
- Difficult to understand
- Not RESTful
- Hard to maintain
- Poor developer experience

**The right way:**
Follow REST URL conventions:

```
# Bad ❌
POST /createUser
GET /getUserById/123
POST /deleteUser/123
GET /api/get-all-posts

# Good ✅
POST /users
GET /users/123
DELETE /users/123
GET /posts

# Hierarchical resources
GET /users/123/posts
GET /users/123/posts/456
GET /users/123/posts/456/comments

# Filtering and sorting
GET /posts?status=published&sort=created_at
GET /users?role=admin&page=2
```

**How to fix if you've already done this:**
Redesign URLs to use nouns, be hierarchical, and be consistent.

**Red flags to watch for:**
- Verbs in URLs
- Inconsistent naming
- No hierarchy
- Random URL patterns

---

### Mistake 3: Not Versioning the API

**What people do:**
Make breaking changes without versioning.

**Why it's a problem:**
- Breaks existing clients
- No backward compatibility
- Difficult to maintain
- Poor upgrade path
- Angry users

**The right way:**
Implement API versioning:

```
# URL versioning (most common)
GET /api/v1/users
GET /api/v2/users

# Header versioning
GET /users
Accept: application/vnd.myapi.v1+json

# Query parameter
GET /users?version=1

# Maintain multiple versions
# Deprecate old versions gradually
# Document migration path
```

**How to fix if you've already done this:**
Add versioning before next breaking change.

**Red flags to watch for:**
- No version in URLs
- Breaking changes break clients
- No deprecation notices
- No migration guide

---

## Intermediate Mistakes

### Mistake 4: Inconsistent Response Formats

**What people do:**
Return different data structures for similar operations.

**Why it's a problem:**
- Confusing for clients
- Difficult to parse
- Maintenance nightmare
- Poor developer experience

**The right way:**
Use consistent response format:

```json
// Success response
{
  "status": "success",
  "data": {
    "id": 123,
    "name": "John Doe"
  }
}

// List response
{
  "status": "success",
  "data": {
    "items": [...],
    "total": 100,
    "page": 1,
    "per_page": 20
  }
}

// Error response
{
  "status": "error",
  "error": {
    "code": "USER_NOT_FOUND",
    "message": "User with ID 123 not found"
  }
}
```

**How to fix if you've already done this:**
Standardize response format across all endpoints.

**Red flags to watch for:**
- Different response structures
- Inconsistent field names
- Mixed data formats
- No standard error format

---

### Mistake 5: Not Implementing Proper Error Handling

**What people do:**
Return 200 OK with error message or use wrong status codes.

**Why it's a problem:**
- Clients can't handle errors properly
- Breaks HTTP semantics
- Difficult debugging
- Poor error handling

**The right way:**
Use proper status codes and error responses:

```python
# Return appropriate status codes
@app.route('/users/<int:user_id>')
def get_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return {"error": "User not found"}, 404
    return jsonify(user.to_dict()), 200

# Detailed error responses
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {"field": "email", "message": "Invalid email format"},
      {"field": "age", "message": "Must be at least 18"}
    ]
  }
}

# Status codes
200 OK - Success
201 Created - Resource created
204 No Content - Success with no body
400 Bad Request - Invalid input
401 Unauthorized - Authentication required
403 Forbidden - No permission
404 Not Found - Resource not found
409 Conflict - Resource conflict
422 Unprocessable Entity - Validation error
500 Internal Server Error - Server error
```

**How to fix if you've already done this:**
Update all endpoints to return proper status codes.

**Red flags to watch for:**
- All responses return 200
- Errors with success status
- No error details
- Generic error messages

---

## Advanced Pitfalls

### Mistake 6: Not Implementing HATEOAS

**What people do:**
Return data without links to related resources.

**Why it's a problem:**
- Clients must construct URLs
- Tight coupling
- Hard to discover API
- Not truly RESTful

**The right way:**
Include links in responses:

```json
{
  "id": 123,
  "name": "John Doe",
  "email": "john@example.com",
  "_links": {
    "self": {"href": "/users/123"},
    "posts": {"href": "/users/123/posts"},
    "avatar": {"href": "/users/123/avatar"}
  }
}
```

**How to fix if you've already done this:**
Add _links or links object to responses.

**Red flags to watch for:**
- No links in responses
- Clients hardcoding URLs
- Difficult API navigation

---

### Mistake 7: Poor Pagination Implementation

**What people do:**
Return all results without pagination or implement it incorrectly.

**Why it's a problem:**
- Performance issues
- Timeouts
- Memory problems
- Poor user experience

**The right way:**
Implement proper pagination:

```python
@app.route('/posts')
def get_posts():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)
    
    posts = Post.query.paginate(page=page, per_page=per_page)
    
    return {
        "data": [post.to_dict() for post in posts.items],
        "pagination": {
            "page": page,
            "per_page": per_page,
            "total": posts.total,
            "pages": posts.pages
        },
        "_links": {
            "self": f"/posts?page={page}&per_page={per_page}",
            "next": f"/posts?page={page+1}&per_page={per_page}" if posts.has_next else None,
            "prev": f"/posts?page={page-1}&per_page={per_page}" if posts.has_prev else None
        }
    }
```

**How to fix if you've already done this:**
Add pagination to all list endpoints.

**Red flags to watch for:**
- Returning thousands of records
- No pagination support
- Timeouts on list requests
- Poor performance

---

## Prevention Checklist

### API Design
- [ ] Use appropriate HTTP methods
- [ ] Nouns in URLs, not verbs
- [ ] Hierarchical resource structure
- [ ] Consistent naming conventions
- [ ] API versioning implemented
- [ ] HATEOAS links included

### Responses
- [ ] Consistent response format
- [ ] Proper HTTP status codes
- [ ] Detailed error messages
- [ ] Pagination for lists
- [ ] Appropriate Content-Type headers
- [ ] Include metadata

### Best Practices
- [ ] Documentation complete
- [ ] Examples provided
- [ ] Rate limiting implemented
- [ ] Authentication required
- [ ] Input validation
- [ ] Idempotent operations
