# Module 7 Checkpoint: REST API Design

## Before Moving Forward

Complete this checkpoint to ensure you're ready for the next module.

## Knowledge Check (Answer these questions)

### Fundamentals

1. What does REST stand for and what are the core principles of REST?
   <details>
   <summary>Answer</summary>
   REST stands for Representational State Transfer. Core principles:
   1. **Client-Server**: Separation of concerns - client handles UI, server handles data
   2. **Stateless**: Each request contains all information needed; no session state on server
   3. **Cacheable**: Responses must define if they can be cached
   4. **Uniform Interface**: Consistent way to interact with resources (HTTP methods, URIs)
   5. **Layered System**: Client doesn't know if connected directly to server or through intermediaries
   6. **Code on Demand** (optional): Server can send executable code to client
   </details>

2. What is a resource in REST and how should resources be named?
   <details>
   <summary>Answer</summary>
   A resource is any information that can be named - users, posts, orders, products. **Naming conventions:**
   - Use nouns, not verbs: `/users` not `/getUsers`
   - Use plural for collections: `/users`, `/posts`
   - Use singular for specific items: `/users/123`, `/posts/456`
   - Hierarchical relationships: `/users/123/posts` (posts by user 123)
   - Use lowercase and hyphens: `/api/user-profiles` not `/api/UserProfiles`
   - Avoid deep nesting: max 2-3 levels
   </details>

3. How do HTTP methods map to CRUD operations in REST?
   <details>
   <summary>Answer</summary>
   - **CREATE**: POST /users (create new user, returns 201 Created)
   - **READ**: GET /users (list all), GET /users/123 (get one, returns 200 OK)
   - **UPDATE**: PUT /users/123 (replace entire resource) or PATCH /users/123 (partial update, returns 200 OK)
   - **DELETE**: DELETE /users/123 (remove resource, returns 204 No Content or 200 OK)
   
   Additional: HEAD (metadata only), OPTIONS (supported methods)
   </details>

4. What are the common HTTP status codes used in REST APIs and what do they indicate?
   <details>
   <summary>Answer</summary>
   **2xx Success:**
   - 200 OK: Successful GET, PUT, PATCH, or DELETE
   - 201 Created: Successful POST, includes Location header
   - 204 No Content: Successful DELETE or PUT with no response body
   
   **4xx Client Error:**
   - 400 Bad Request: Invalid input/malformed request
   - 401 Unauthorized: Authentication required/failed
   - 403 Forbidden: Authenticated but not authorized
   - 404 Not Found: Resource doesn't exist
   - 409 Conflict: Resource conflict (duplicate email)
   - 422 Unprocessable Entity: Validation errors
   
   **5xx Server Error:**
   - 500 Internal Server Error: Unexpected server error
   - 503 Service Unavailable: Server temporarily unavailable
   </details>

### Intermediate

5. What is the difference between PUT and PATCH methods?
   <details>
   <summary>Answer</summary>
   **PUT** replaces the entire resource - you send the complete representation. If fields are missing, they're set to null/default. Idempotent - calling multiple times has same result.
   
   **PATCH** partially updates a resource - you send only fields to change. Other fields remain unchanged. May or may not be idempotent depending on implementation.
   
   Example:
   ```
   # Original: {"name": "John", "email": "john@example.com", "age": 30}
   
   # PUT /users/123
   {"name": "John Doe", "email": "john@example.com"}
   # Result: {"name": "John Doe", "email": "john@example.com", "age": null}
   
   # PATCH /users/123
   {"name": "John Doe"}
   # Result: {"name": "John Doe", "email": "john@example.com", "age": 30}
   ```
   </details>

6. How should you handle relationships between resources in REST APIs?
   <details>
   <summary>Answer</summary>
   **Nested routes** for clear relationships:
   - `/users/123/posts` - posts by user 123
   - `/posts/456/comments` - comments on post 456
   
   **Query parameters** for filtering:
   - `/posts?userId=123` - filter posts by user
   - `/comments?postId=456` - filter comments by post
   
   **Include/expand parameters** for related data:
   - `/users/123?include=posts,comments`
   - `/posts/456?expand=author,comments`
   
   **Separate endpoints with IDs** for many-to-many:
   - `/posts/456/tags` - tags for a post
   - `/tags/789/posts` - posts with a tag
   
   Avoid deep nesting (max 2 levels): `/users/123/posts/456/comments/789` is too deep
   </details>

7. What is API versioning and what are the different approaches?
   <details>
   <summary>Answer</summary>
   API versioning manages breaking changes without affecting existing clients. Approaches:
   
   1. **URL Path**: `/api/v1/users`, `/api/v2/users` (most common, very clear)
   2. **Query Parameter**: `/api/users?version=2` (flexible, less common)
   3. **Header**: `Accept: application/vnd.api.v2+json` (cleaner URLs)
   4. **Content Negotiation**: Different media types
   
   **When to version:** Breaking changes (removing fields, changing types, different behavior). **Don't version for:** Adding optional fields, bug fixes, performance improvements (backward compatible).
   </details>

8. How should you design error responses in REST APIs?
   <details>
   <summary>Answer</summary>
   Consistent error response format:
   ```json
   {
     "error": {
       "code": "VALIDATION_ERROR",
       "message": "Invalid input data",
       "details": [
         {
           "field": "email",
           "message": "Email is required"
         },
         {
           "field": "password",
           "message": "Password must be at least 8 characters"
         }
       ],
       "timestamp": "2024-01-15T10:30:00Z",
       "path": "/api/users"
     }
   }
   ```
   
   Include: error code (machine-readable), human-readable message, field-level details for validation, timestamp, request path. Use appropriate status codes.
   </details>

### Advanced

9. What is HATEOAS and how does it relate to REST?
   <details>
   <summary>Answer</summary>
   HATEOAS (Hypermedia As The Engine Of Application State) is a constraint of REST where responses include links to related resources and available actions. This makes the API self-documenting and discoverable.
   
   Example:
   ```json
   {
     "id": 123,
     "name": "John Doe",
     "links": [
       {"rel": "self", "href": "/api/users/123"},
       {"rel": "posts", "href": "/api/users/123/posts"},
       {"rel": "edit", "href": "/api/users/123", "method": "PUT"},
       {"rel": "delete", "href": "/api/users/123", "method": "DELETE"}
     ]
   }
   ```
   
   Benefits: Clients discover actions dynamically, easier to change URIs, self-documenting. Drawback: More complex, not widely adopted in practice.
   </details>

10. How do you design pagination, filtering, and sorting in REST APIs?
    <details>
    <summary>Answer</summary>
    **Pagination:**
    - Offset: `?offset=20&limit=10`
    - Page: `?page=3&per_page=10`
    - Cursor: `?after=abc123&limit=10` (best for real-time data)
    
    **Filtering:**
    - Single: `?status=active`
    - Multiple: `?status=active&role=admin`
    - Operators: `?created_gt=2024-01-01&age_gte=18`
    
    **Sorting:**
    - Single: `?sort=name` or `?sort=-name` (descending)
    - Multiple: `?sort=name,-created_at`
    
    **Response includes metadata:**
    ```json
    {
      "data": [...],
      "pagination": {
        "total": 100,
        "page": 3,
        "per_page": 10,
        "total_pages": 10
      },
      "links": {
        "first": "/api/users?page=1",
        "prev": "/api/users?page=2",
        "next": "/api/users?page=4",
        "last": "/api/users?page=10"
      }
    }
    ```
    </details>

11. What are the best practices for API security in REST design?
    <details>
    <summary>Answer</summary>
    1. **Always use HTTPS** - encrypt data in transit
    2. **Authentication**: Use OAuth 2.0, JWT, or API keys (in headers, not URLs)
    3. **Authorization**: Implement role-based or attribute-based access control
    4. **Input validation**: Validate all inputs, sanitize to prevent injection
    5. **Rate limiting**: Prevent abuse with rate limits (per user/IP)
    6. **CORS**: Configure properly, don't use wildcard (*) with credentials
    7. **Security headers**: Use CSP, HSTS, X-Frame-Options
    8. **Sensitive data**: Don't expose in URLs, logs, or error messages
    9. **Versioning**: Allows security fixes without breaking clients
    10. **Audit logging**: Log security events (failed logins, access to sensitive data)
    </details>

12. How do you handle bulk operations and batch requests in REST APIs?
    <details>
    <summary>Answer</summary>
    **Bulk Creation:**
    ```
    POST /api/users
    [
      {"name": "User 1", "email": "user1@example.com"},
      {"name": "User 2", "email": "user2@example.com"}
    ]
    ```
    Response: 207 Multi-Status with individual results
    
    **Bulk Update:**
    ```
    PATCH /api/users
    [
      {"id": 1, "name": "Updated 1"},
      {"id": 2, "name": "Updated 2"}
    ]
    ```
    
    **Bulk Delete:**
    ```
    DELETE /api/users?ids=1,2,3
    or
    DELETE /api/users
    {"ids": [1, 2, 3]}
    ```
    
    **Batch Requests** (multiple different operations):
    ```
    POST /api/batch
    {
      "requests": [
        {"method": "GET", "url": "/users/1"},
        {"method": "POST", "url": "/posts", "body": {...}}
      ]
    }
    ```
    Return array of responses with individual status codes.
    </details>

## Practical Skills Verification

### Task 1: Design a REST API Structure
**Objective:** Design a complete REST API for a real-world application.

**Steps:**
1. Choose a domain (blog, e-commerce, task manager, social media)
2. Identify resources (users, posts, comments, products, orders, etc.)
3. Design endpoints for each resource following REST conventions
4. Map HTTP methods to operations
5. Define URL structure with proper nesting
6. Specify request/response formats
7. Choose appropriate status codes

**Example for a blog:**
```
GET    /api/v1/posts           - List posts
POST   /api/v1/posts           - Create post
GET    /api/v1/posts/123       - Get post 123
PUT    /api/v1/posts/123       - Update post 123
DELETE /api/v1/posts/123       - Delete post 123

GET    /api/v1/posts/123/comments    - Comments on post 123
POST   /api/v1/posts/123/comments    - Add comment to post 123
DELETE /api/v1/comments/456           - Delete comment 456

GET    /api/v1/users/789/posts       - Posts by user 789
```

**Success Criteria:**
- [ ] Follows REST naming conventions (nouns, plural)
- [ ] Appropriate HTTP methods for each operation
- [ ] Proper resource nesting (not too deep)
- [ ] Includes filtering, sorting, pagination parameters
- [ ] Consistent URL structure

**Troubleshooting:**
If unsure about naming, use plural nouns for collections. Avoid verbs in URLs. Keep nesting under 3 levels. Use query parameters for optional features.

---

### Task 2: Implement CRUD Operations
**Objective:** Build a simple REST API with full CRUD functionality.

**Steps:**
1. Choose a framework (Express.js, Flask, FastAPI, Spring Boot, etc.)
2. Create endpoints for a resource (e.g., tasks):
   ```
   POST   /api/tasks       - Create task
   GET    /api/tasks       - List all tasks
   GET    /api/tasks/:id   - Get single task
   PUT    /api/tasks/:id   - Update task
   DELETE /api/tasks/:id   - Delete task
   ```
3. Use in-memory storage or simple file storage (database optional)
4. Return appropriate status codes:
   - 201 for successful POST
   - 200 for successful GET/PUT/DELETE
   - 404 for not found
   - 400 for invalid input
5. Test with Postman or curl

**Success Criteria:**
- [ ] All CRUD operations work correctly
- [ ] Correct HTTP status codes returned
- [ ] Proper JSON request/response format
- [ ] Input validation implemented
- [ ] Handles errors gracefully

**Troubleshooting:**
If framework is unfamiliar, start with tutorials. Use scaffolding tools (express-generator, create-fastapi-app). Test each endpoint individually before moving to next.

---

### Task 3: Implement Pagination and Filtering
**Objective:** Add pagination and filtering to a collection endpoint.

**Steps:**
1. Modify GET /api/tasks to support:
   - Pagination: `?page=1&limit=10`
   - Filtering: `?status=completed&priority=high`
   - Sorting: `?sort=created_at&order=desc`
2. Return metadata with results:
   ```json
   {
     "data": [...],
     "pagination": {
       "page": 1,
       "limit": 10,
       "total": 50,
       "totalPages": 5
     }
   }
   ```
3. Include links to next/previous pages
4. Test edge cases (page beyond total, invalid filters)

**Success Criteria:**
- [ ] Pagination works correctly
- [ ] Multiple filters can be combined
- [ ] Sorting in both directions works
- [ ] Returns appropriate metadata
- [ ] Handles invalid parameters gracefully

**Troubleshooting:**
If pagination math is confusing: totalPages = Math.ceil(total / limit), offset = (page - 1) * limit. Validate page and limit are positive integers.

---

### Task 4: Design Error Responses
**Objective:** Create consistent error handling across your API.

**Steps:**
1. Create a standard error response format:
   ```json
   {
     "error": {
       "code": "RESOURCE_NOT_FOUND",
       "message": "Task with id 123 not found",
       "status": 404,
       "timestamp": "2024-01-15T10:30:00Z"
     }
   }
   ```
2. Implement error codes for common scenarios:
   - VALIDATION_ERROR (400)
   - UNAUTHORIZED (401)
   - FORBIDDEN (403)
   - RESOURCE_NOT_FOUND (404)
   - INTERNAL_SERVER_ERROR (500)
3. For validation errors, include field details:
   ```json
   {
     "error": {
       "code": "VALIDATION_ERROR",
       "message": "Invalid input",
       "details": [
         {"field": "email", "message": "Email is required"},
         {"field": "title", "message": "Title must be at least 3 characters"}
       ]
     }
   }
   ```
4. Test error scenarios and verify consistent format

**Success Criteria:**
- [ ] Consistent error format across all endpoints
- [ ] Machine-readable error codes
- [ ] Human-readable messages
- [ ] Field-level validation details
- [ ] Appropriate HTTP status codes

**Troubleshooting:**
If errors aren't caught, implement global error handler middleware. In Express: `app.use((err, req, res, next) => {...})`. In Flask: `@app.errorhandler(Exception)`.

---

### Task 5: API Documentation
**Objective:** Document your API for other developers.

**Steps:**
1. For each endpoint, document:
   - URL and HTTP method
   - Description
   - Request headers (authentication, content-type)
   - Request body (with example)
   - Response format (with example)
   - Possible status codes
   - Error responses
2. Include authentication instructions
3. Provide example requests using curl or code snippets
4. Document query parameters (pagination, filtering)
5. Create a "Getting Started" guide

**Success Criteria:**
- [ ] All endpoints documented
- [ ] Examples provided for each endpoint
- [ ] Authentication explained
- [ ] Error responses documented
- [ ] Easy to follow for new developers

**Troubleshooting:**
Consider using tools like Swagger/OpenAPI for automated documentation. Markdown is fine for simple APIs. Include real examples, not just schema.

## Project-Based Assessment

**Mini-Project:** Design and Implement a Complete REST API

Create a production-quality REST API for a real-world application.

**Requirements:**

**API Design:**
- [ ] Choose a domain (e-commerce, social media, project management, etc.)
- [ ] Identify at least 5 resource types
- [ ] Design complete endpoint structure (15+ endpoints)
- [ ] Create API specification document

**Implementation:**
- [ ] Implement all CRUD operations for main resources
- [ ] Implement relationships between resources
- [ ] Add pagination, filtering, and sorting
- [ ] Implement search functionality
- [ ] Version your API (/api/v1)

**Data Validation:**
- [ ] Validate all inputs
- [ ] Return detailed validation errors (field-level)
- [ ] Sanitize inputs to prevent injection

**Authentication & Authorization:**
- [ ] Implement authentication (JWT or session-based)
- [ ] Protect endpoints requiring authentication
- [ ] Implement authorization checks (role-based)

**Error Handling:**
- [ ] Consistent error response format
- [ ] Appropriate HTTP status codes
- [ ] Logging of errors

**Testing:**
- [ ] Test all endpoints with Postman/curl
- [ ] Create Postman collection
- [ ] Test error scenarios
- [ ] Test with invalid/edge case inputs

**Documentation:**
- [ ] Complete API documentation
- [ ] Setup and installation guide
- [ ] Authentication guide
- [ ] Example requests for all endpoints
- [ ] Export OpenAPI/Swagger spec (bonus)

**Evaluation Rubric:**
| Criteria | Needs Work | Good | Excellent |
|----------|------------|------|-----------|
| **REST Principles** | Doesn't follow REST conventions | Mostly RESTful, minor issues | Perfectly RESTful, best practices followed |
| **Functionality** | Basic CRUD only | Full CRUD with filtering/pagination | Complete with search, relationships, advanced features |
| **Error Handling** | Inconsistent or missing | Standard format, good coverage | Comprehensive with detailed validation |
| **Security** | No authentication | Basic authentication | Full auth/authz with validation |
| **Documentation** | Minimal or confusing | Good coverage, clear | Professional, comprehensive, examples |

**Sample Solution:**
See `checkpoint-solutions/07-task-management-api/` for a complete Task Management API implementation.

## Self-Assessment

Rate your confidence (1-5) in these areas:
- [ ] Understanding REST principles: ___/5
- [ ] Designing RESTful endpoints: ___/5
- [ ] Implementing CRUD operations: ___/5
- [ ] API versioning and documentation: ___/5

**If you scored below 3 on any:**
- Review REST architecture principles
- Study well-designed public APIs (GitHub, Stripe, Twilio)
- Practice designing endpoints for different domains
- Implement a simple API from scratch

**If you scored 4+ on all:**
- You're ready to move forward!
- Consider the advanced challenges below

## Advanced Challenges (Optional)

For those who want to go deeper:

1. **GraphQL Comparison**: Learn GraphQL and compare it to REST. Implement the same API in both REST and GraphQL. Understand when to use each. Analyze over-fetching and under-fetching problems.

2. **API Gateway Pattern**: Implement an API gateway that sits in front of multiple microservices. Handle routing, authentication, rate limiting, and request aggregation at the gateway level.

3. **Hypermedia API (HATEOAS)**: Fully implement HATEOAS in your API. Include links for all available actions. Create a client that discovers and navigates the API using links only.

4. **API Versioning Strategy**: Implement multiple versioning strategies side-by-side (URL, header, content negotiation). Create a system to maintain multiple versions with shared code. Develop a deprecation strategy.

5. **OpenAPI/Swagger**: Generate OpenAPI 3.0 specification for your API. Use tools to generate client SDKs in multiple languages (JavaScript, Python, Java). Set up Swagger UI for interactive documentation.

## Ready to Continue?

- [ ] I've completed the knowledge check (80% or better)
- [ ] I've verified all practical skills
- [ ] I've completed the mini-project
- [ ] I feel confident in this module's concepts
- [ ] I've reviewed common-mistakes.md (if available)

✅ **Proceed to Module 8: Databases for APIs**
