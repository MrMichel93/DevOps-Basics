# API Examples

## 🎯 Purpose

Sample APIs and code examples for hands-on practice with different technologies and patterns.

## 🌐 Free Public APIs for Practice

### 1. JSONPlaceholder
**URL**: https://jsonplaceholder.typicode.com/

**What it is**: Fake REST API for testing and prototyping

**Endpoints**:
```
GET    /posts
GET    /posts/1
POST   /posts
PUT    /posts/1
PATCH  /posts/1
DELETE /posts/1

Also: /comments, /albums, /photos, /todos, /users
```

**Example**:
```bash
curl https://jsonplaceholder.typicode.com/posts/1
```

### 2. GitHub API
**URL**: https://api.github.com

**What it is**: Access GitHub data

**Endpoints**:
```
GET /users/:username
GET /users/:username/repos
GET /repos/:owner/:repo
GET /search/repositories?q=query
```

**Example**:
```bash
curl https://api.github.com/users/octocat
```

### 3. REQ | RES
**URL**: https://reqres.in/

**What it is**: Test API with realistic data

**Endpoints**:
```
GET    /api/users
GET    /api/users/1
POST   /api/users
PUT    /api/users/1
DELETE /api/users/1
```

**Example**:
```bash
curl https://reqres.in/api/users?page=1
```

### 4. Dog API
**URL**: https://dog.ceo/dog-api/

**What it is**: Random dog images

**Endpoints**:
```
GET /api/breeds/image/random
GET /api/breeds/list/all
GET /api/breed/hound/images
```

**Example**:
```bash
curl https://dog.ceo/api/breeds/image/random
```

### 5. OpenWeatherMap
**URL**: https://openweathermap.org/api

**What it is**: Weather data (requires free API key)

**Example**:
```bash
curl "https://api.openweathermap.org/data/2.5/weather?q=London&appid=YOUR_API_KEY"
```

## 💻 Sample API Implementations

### Simple REST API (Python/Flask)

```python
from flask import Flask, jsonify, request

app = Flask(__name__)

# In-memory database
posts = [
    {'id': 1, 'title': 'First Post', 'content': 'Hello World'},
    {'id': 2, 'title': 'Second Post', 'content': 'Another post'}
]

# List all posts
@app.route('/api/posts', methods=['GET'])
def get_posts():
    return jsonify(posts)

# Get single post
@app.route('/api/posts/<int:post_id>', methods=['GET'])
def get_post(post_id):
    post = next((p for p in posts if p['id'] == post_id), None)
    if post:
        return jsonify(post)
    return jsonify({'error': 'Post not found'}), 404

# Create post
@app.route('/api/posts', methods=['POST'])
def create_post():
    data = request.get_json()
    new_post = {
        'id': len(posts) + 1,
        'title': data['title'],
        'content': data['content']
    }
    posts.append(new_post)
    return jsonify(new_post), 201

# Update post
@app.route('/api/posts/<int:post_id>', methods=['PUT'])
def update_post(post_id):
    post = next((p for p in posts if p['id'] == post_id), None)
    if not post:
        return jsonify({'error': 'Post not found'}), 404
    
    data = request.get_json()
    post['title'] = data.get('title', post['title'])
    post['content'] = data.get('content', post['content'])
    return jsonify(post)

# Delete post
@app.route('/api/posts/<int:post_id>', methods=['DELETE'])
def delete_post(post_id):
    global posts
    posts = [p for p in posts if p['id'] != post_id]
    return '', 204

if __name__ == '__main__':
    app.run(debug=True)
```

### Simple REST API (Node.js/Express)

```javascript
const express = require('express');
const app = express();

app.use(express.json());

// In-memory database
let posts = [
    { id: 1, title: 'First Post', content: 'Hello World' },
    { id: 2, title: 'Second Post', content: 'Another post' }
];

// List all posts
app.get('/api/posts', (req, res) => {
    res.json(posts);
});

// Get single post
app.get('/api/posts/:id', (req, res) => {
    const post = posts.find(p => p.id === parseInt(req.params.id));
    if (post) {
        res.json(post);
    } else {
        res.status(404).json({ error: 'Post not found' });
    }
});

// Create post
app.post('/api/posts', (req, res) => {
    const newPost = {
        id: posts.length + 1,
        title: req.body.title,
        content: req.body.content
    };
    posts.push(newPost);
    res.status(201).json(newPost);
});

// Update post
app.put('/api/posts/:id', (req, res) => {
    const post = posts.find(p => p.id === parseInt(req.params.id));
    if (!post) {
        return res.status(404).json({ error: 'Post not found' });
    }
    
    post.title = req.body.title || post.title;
    post.content = req.body.content || post.content;
    res.json(post);
});

// Delete post
app.delete('/api/posts/:id', (req, res) => {
    posts = posts.filter(p => p.id !== parseInt(req.params.id));
    res.status(204).send();
});

app.listen(3000, () => {
    console.log('Server running on http://localhost:3000');
});
```

## 🧪 Practice Exercises

### Exercise 1: CRUD Operations
Practice with JSONPlaceholder:

```bash
# Create
curl -X POST https://jsonplaceholder.typicode.com/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"My Post","body":"Content","userId":1}'

# Read
curl https://jsonplaceholder.typicode.com/posts/1

# Update
curl -X PUT https://jsonplaceholder.typicode.com/posts/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated","body":"New content","userId":1}'

# Delete
curl -X DELETE https://jsonplaceholder.typicode.com/posts/1
```

### Exercise 2: Filtering and Pagination

```bash
# Filter by userId
curl "https://jsonplaceholder.typicode.com/posts?userId=1"

# Get nested resources
curl "https://jsonplaceholder.typicode.com/posts/1/comments"

# Limit results
curl "https://jsonplaceholder.typicode.com/posts?_limit=5"
```

### Exercise 3: GitHub API Exploration

```bash
# Get user info
curl https://api.github.com/users/octocat

# Get user's repos
curl https://api.github.com/users/octocat/repos

# Search repositories
curl "https://api.github.com/search/repositories?q=language:python&sort=stars"

# Get rate limit info
curl https://api.github.com/rate_limit
```

## 📚 Complete API Examples

### Weather Dashboard API

Combine multiple APIs:

```bash
# Get current weather
curl "https://api.openweathermap.org/data/2.5/weather?q=London&appid=YOUR_KEY"

# Get forecast
curl "https://api.openweathermap.org/data/2.5/forecast?q=London&appid=YOUR_KEY"
```

### Social Media Feed API

Simulate a social feed:

```bash
# Get posts
curl https://jsonplaceholder.typicode.com/posts

# Get post comments
curl https://jsonplaceholder.typicode.com/posts/1/comments

# Get user who created post
curl https://jsonplaceholder.typicode.com/users/1
```

## 🔒 Authentication Examples

### API Key Authentication

```bash
curl https://api.example.com/data \
  -H "X-API-Key: your_api_key_here"
```

### Bearer Token Authentication

```bash
curl https://api.example.com/protected \
  -H "Authorization: Bearer eyJhbGc..."
```

### Basic Authentication

```bash
curl https://api.example.com/admin \
  -u username:password
```

## 🎯 Best Practices Examples

### Good API Response Structure

```json
{
  "success": true,
  "data": {
    "id": 123,
    "name": "Example"
  },
  "meta": {
    "timestamp": "2025-12-19T10:00:00Z",
    "version": "1.0"
  }
}
```

### Good Error Response

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

### Pagination Response

```json
{
  "data": [...],
  "pagination": {
    "page": 2,
    "per_page": 10,
    "total": 100,
    "total_pages": 10
  },
  "links": {
    "first": "/posts?page=1",
    "prev": "/posts?page=1",
    "next": "/posts?page=3",
    "last": "/posts?page=10"
  }
}
```

## 🔗 Additional API Lists

- **Public APIs List**: https://github.com/public-apis/public-apis
- **Any API**: https://any-api.com/
- **RapidAPI**: https://rapidapi.com/
- **API List**: https://apilist.fun/

## 💡 Tips

1. **Always read documentation**: Every API is different
2. **Check rate limits**: Don't abuse free tiers
3. **Handle errors**: APIs fail, plan for it
4. **Test with small data**: Before bulk operations
5. **Use environment variables**: For API keys
6. **Start simple**: Get working, then add features
7. **Monitor usage**: Track API calls

## 🎓 Learning Path

1. **Week 1**: Practice with JSONPlaceholder (no auth required)
2. **Week 2**: Explore GitHub API (learn authentication)
3. **Week 3**: Build simple API (implement CRUD)
4. **Week 4**: Add authentication to your API
5. **Week 5**: Combine multiple APIs in project
