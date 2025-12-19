# Module 07: REST API Design

## 🎯 Learning Objectives

- ✅ Understand RESTful principles
- ✅ Design resource-based URLs
- ✅ Implement CRUD operations properly
- ✅ Follow REST API best practices
- ✅ Version APIs effectively

**Time Required**: 3-4 hours

## 🌐 What is REST?

**REST** (Representational State Transfer) is an architectural style for designing networked applications.

### REST Principles

1. **Client-Server**: Separation of concerns
2. **Stateless**: Each request contains all needed information
3. **Cacheable**: Responses must define if cacheable
4. **Uniform Interface**: Consistent way to interact with resources
5. **Layered System**: Client can't tell if connected directly to server
6. **Code on Demand** (optional): Server can send executable code

## 📦 Resource-Based Design

### Think in Resources, Not Actions

**Bad (RPC-style)**:
```
POST /createUser
POST /deleteUser
GET /getUserById
```

**Good (REST-style)**:
```
POST   /users        (create)
DELETE /users/123    (delete)
GET    /users/123    (read)
```

### Resource Naming Conventions

**Use Nouns, Not Verbs**:
- ✅ `/users`
- ✅ `/products`
- ✅ `/orders`
- ❌ `/getUsers`
- ❌ `/createProduct`
- ❌ `/deleteOrder`

**Use Plural Nouns**:
- ✅ `/users` (not `/user`)
- ✅ `/posts` (not `/post`)

**Use Hierarchical Structure**:
```
/users/123/posts           # User's posts
/users/123/posts/456       # Specific post
/users/123/posts/456/comments  # Post's comments
```

**Lowercase and Hyphens**:
- ✅ `/user-profiles`
- ✅ `/blog-posts`
- ❌ `/UserProfiles`
- ❌ `/blog_posts`

## 🔧 CRUD Operations with HTTP Methods

### Mapping CRUD to HTTP

| Operation | HTTP Method | URL | Body |
|-----------|-------------|-----|------|
| **Create** | POST | `/users` | User data |
| **Read** | GET | `/users/123` | None |
| **Update** | PUT/PATCH | `/users/123` | Updated data |
| **Delete** | DELETE | `/users/123` | None |
| **List** | GET | `/users` | None |

### Detailed Examples

**Create (POST)**:
```bash
POST /api/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com"
}

Response: 201 Created
Location: /api/users/123
{
  "id": 123,
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2025-12-19T10:00:00Z"
}
```

**Read One (GET)**:
```bash
GET /api/users/123

Response: 200 OK
{
  "id": 123,
  "name": "John Doe",
  "email": "john@example.com"
}
```

**Read Many (GET with filters)**:
```bash
GET /api/users?role=admin&page=1&limit=10

Response: 200 OK
{
  "data": [
    {"id": 123, "name": "John Doe"},
    {"id": 124, "name": "Jane Smith"}
  ],
  "page": 1,
  "total": 50
}
```

**Update Full (PUT)**:
```bash
PUT /api/users/123
Content-Type: application/json

{
  "name": "John Smith",
  "email": "john.smith@example.com"
}

Response: 200 OK
{
  "id": 123,
  "name": "John Smith",
  "email": "john.smith@example.com",
  "updated_at": "2025-12-19T11:00:00Z"
}
```

**Update Partial (PATCH)**:
```bash
PATCH /api/users/123
Content-Type: application/json

{
  "name": "John Smith"
}

Response: 200 OK
{
  "id": 123,
  "name": "John Smith",
  "email": "john@example.com"
}
```

**Delete (DELETE)**:
```bash
DELETE /api/users/123

Response: 204 No Content
```

## 🎯 REST API Best Practices

### 1. Use Proper Status Codes

**Success**:
- `200 OK`: Successful GET, PUT, PATCH, DELETE
- `201 Created`: Successful POST
- `204 No Content`: Successful DELETE with no response body

**Client Errors**:
- `400 Bad Request`: Invalid request data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Resource doesn't exist
- `409 Conflict`: Resource conflict
- `422 Unprocessable Entity`: Validation failed

**Server Errors**:
- `500 Internal Server Error`: Generic server error
- `503 Service Unavailable`: Service temporarily down

### 2. Version Your API

**URL Versioning** (recommended):
```
https://api.example.com/v1/users
https://api.example.com/v2/users
```

**Header Versioning**:
```
GET /users
Accept: application/vnd.api.v2+json
```

**Query Parameter**:
```
GET /users?version=2
```

### 3. Provide Filtering, Sorting, Pagination

**Filtering**:
```
GET /users?role=admin
GET /users?status=active&country=US
```

**Sorting**:
```
GET /users?sort=created_at
GET /users?sort=-created_at  (descending)
GET /users?sort=name,created_at
```

**Pagination**:
```
GET /users?page=2&limit=10
GET /users?offset=20&limit=10
```

**Response**:
```json
{
  "data": [...],
  "meta": {
    "page": 2,
    "limit": 10,
    "total": 100,
    "pages": 10
  },
  "links": {
    "first": "/users?page=1&limit=10",
    "prev": "/users?page=1&limit=10",
    "next": "/users?page=3&limit=10",
    "last": "/users?page=10&limit=10"
  }
}
```

### 4. Use Consistent Error Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      },
      {
        "field": "age",
        "message": "Must be at least 18"
      }
    ]
  }
}
```

### 5. Handle Nested Resources Carefully

**Good**:
```
GET /users/123/posts          # Get user's posts
POST /users/123/posts         # Create post for user
GET /posts/456                # Get specific post
```

**Avoid Deep Nesting**:
```
# Too deep - hard to manage
GET /users/123/posts/456/comments/789/replies
```

**Better**:
```
GET /comments/789/replies
```

### 6. Use HATEOAS (Optional)

Include links to related resources:

```json
{
  "id": 123,
  "name": "John Doe",
  "links": {
    "self": "/users/123",
    "posts": "/users/123/posts",
    "followers": "/users/123/followers"
  }
}
```

## 🏗️ API Design Example

### Blog API Design

**Resources**:
- Users
- Posts
- Comments

**Endpoints**:

```
# Users
GET    /users          # List users
POST   /users          # Create user
GET    /users/123      # Get user
PUT    /users/123      # Update user
DELETE /users/123      # Delete user

# Posts
GET    /posts          # List all posts
POST   /posts          # Create post
GET    /posts/456      # Get post
PUT    /posts/456      # Update post
DELETE /posts/456      # Delete post

# User's posts
GET    /users/123/posts  # Get user's posts
POST   /users/123/posts  # Create post for user

# Comments
GET    /posts/456/comments      # Get post's comments
POST   /posts/456/comments      # Add comment to post
GET    /comments/789            # Get comment
PUT    /comments/789            # Update comment
DELETE /comments/789            # Delete comment
```

## 🧪 Hands-On Exercise

### Design an E-commerce API

Resources: Products, Orders, Cart

**Try designing**:
1. Product CRUD operations
2. Adding products to cart
3. Creating an order from cart
4. Listing user's orders
5. Getting order details

**Sample Solution**:
```
# Products
GET    /products
POST   /products
GET    /products/123
PUT    /products/123
DELETE /products/123

# Cart
GET    /cart
POST   /cart/items          # Add to cart
DELETE /cart/items/456      # Remove from cart

# Orders
GET    /orders              # List user's orders
POST   /orders              # Create order
GET    /orders/789          # Get order details
GET    /orders/789/items    # Get order items
```

## 📋 REST API Checklist

- [ ] Use nouns for resources
- [ ] Use plural nouns
- [ ] Use HTTP methods correctly
- [ ] Return appropriate status codes
- [ ] Version your API
- [ ] Provide filtering, sorting, pagination
- [ ] Use consistent error format
- [ ] Document your API
- [ ] Implement rate limiting
- [ ] Use HTTPS
- [ ] Support content negotiation
- [ ] Consider caching headers

## 🎯 Key Takeaways

1. **REST**: Architectural style for APIs
2. **Resources**: Think nouns, not verbs
3. **HTTP Methods**: Use correctly for CRUD
4. **Status Codes**: Communicate results clearly
5. **Consistency**: Follow conventions throughout
6. **Documentation**: Essential for API adoption

## 📖 Next Steps

➡️ [Module 08: Databases for APIs](../08-Databases-for-APIs/)

## 🔗 Resources

- [RESTful API Design Best Practices](https://restfulapi.net/)
- [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines)
- [Google API Design Guide](https://cloud.google.com/apis/design)
- [JSON:API Specification](https://jsonapi.org/)
