# Module 08: Databases for APIs

## 🎯 Learning Objectives

- ✅ Understand why APIs need databases
- ✅ Know SQL vs NoSQL differences
- ✅ Connect APIs to databases
- ✅ Implement CRUD with persistence
- ✅ Handle database errors properly

**Time Required**: 3-4 hours

## 🗄️ Why APIs Need Databases

APIs without databases are stateless - they can't remember anything. Databases provide:

1. **Persistence**: Data survives server restarts
2. **Consistency**: Single source of truth
3. **Querying**: Find and filter data efficiently
4. **Relationships**: Connect related data
5. **Scalability**: Handle large datasets

### Example: User Management API

**Without Database**:
```
POST /users → Creates user → ❌ Data lost on restart
GET /users  → Returns nothing → ❌ No persistence
```

**With Database**:
```
POST /users → Saves to DB → ✅ Data persists
GET /users  → Reads from DB → ✅ Returns saved users
```

## 📊 SQL vs NoSQL

### SQL (Relational) Databases

**Structure**: Tables with rows and columns

**Examples**: PostgreSQL, MySQL, SQLite, Microsoft SQL Server

**When to Use**:
- Complex relationships between data
- Need ACID transactions
- Structured data with defined schema
- Complex queries (JOINs, aggregations)

**Example Schema**:
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  title VARCHAR(200),
  content TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### NoSQL Databases

**Structure**: Flexible documents, key-value pairs, graphs

**Examples**: MongoDB, Redis, Cassandra, DynamoDB

**When to Use**:
- Flexible or evolving schema
- Need horizontal scaling
- Document-based data
- High write throughput

**Example Document (MongoDB)**:
```json
{
  "_id": "507f1f77bcf86cd799439011",
  "name": "John Doe",
  "email": "john@example.com",
  "posts": [
    {
      "title": "First Post",
      "content": "Hello world"
    }
  ],
  "created_at": "2025-12-19T10:00:00Z"
}
```

### Comparison

| Feature | SQL | NoSQL |
|---------|-----|-------|
| Schema | Fixed | Flexible |
| Scaling | Vertical (bigger server) | Horizontal (more servers) |
| Transactions | Full ACID | Eventual consistency |
| Relationships | JOINs | Embedded or references |
| Query Language | SQL | Varies |
| Use Case | Complex queries | High scalability |

## 🔌 Connecting APIs to Databases

### Architecture

```
Client → API Server → Database
         (Business Logic)
         (Validation)
         (Authentication)
```

### Connection Pattern

```python
# Example with Python/Flask and SQLite

from flask import Flask, request, jsonify
import sqlite3

app = Flask(__name__)

def get_db_connection():
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    return conn

@app.route('/users', methods=['GET'])
def get_users():
    conn = get_db_connection()
    users = conn.execute('SELECT * FROM users').fetchall()
    conn.close()
    return jsonify([dict(user) for user in users])

@app.route('/users', methods=['POST'])
def create_user():
    data = request.get_json()
    conn = get_db_connection()
    conn.execute(
        'INSERT INTO users (name, email) VALUES (?, ?)',
        (data['name'], data['email'])
    )
    conn.commit()
    conn.close()
    return jsonify({'message': 'User created'}), 201
```

## 🔄 CRUD Operations with Database

### Create (INSERT)

**SQL**:
```sql
INSERT INTO users (name, email) 
VALUES ('John Doe', 'john@example.com');
```

**API Endpoint**:
```bash
POST /users
{
  "name": "John Doe",
  "email": "john@example.com"
}
```

### Read (SELECT)

**SQL**:
```sql
# Get all users
SELECT * FROM users;

# Get specific user
SELECT * FROM users WHERE id = 123;

# Filter
SELECT * FROM users WHERE status = 'active';
```

**API Endpoints**:
```bash
GET /users
GET /users/123
GET /users?status=active
```

### Update (UPDATE)

**SQL**:
```sql
UPDATE users 
SET name = 'John Smith', email = 'john.smith@example.com'
WHERE id = 123;
```

**API Endpoint**:
```bash
PUT /users/123
{
  "name": "John Smith",
  "email": "john.smith@example.com"
}
```

### Delete (DELETE)

**SQL**:
```sql
DELETE FROM users WHERE id = 123;
```

**API Endpoint**:
```bash
DELETE /users/123
```

## 🛠️ Practical Example: Building a Simple API

### Database Setup (SQLite)

```sql
-- users table
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- posts table
CREATE TABLE posts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### API Implementation (Pseudocode)

```
GET /users
→ SELECT * FROM users
→ Return JSON array

POST /users
→ Validate input
→ INSERT INTO users
→ Return created user (201)

GET /users/:id
→ SELECT * FROM users WHERE id = :id
→ If found: return user (200)
→ If not: return error (404)

PUT /users/:id
→ Validate input
→ UPDATE users WHERE id = :id
→ Return updated user (200)

DELETE /users/:id
→ DELETE FROM users WHERE id = :id
→ Return success (204)

GET /users/:id/posts
→ SELECT * FROM posts WHERE user_id = :id
→ Return JSON array
```

## ⚠️ Error Handling

### Database Connection Errors

```python
try:
    conn = get_db_connection()
except Exception as e:
    return jsonify({
        'error': 'Database connection failed'
    }), 500
```

### Unique Constraint Violations

```python
try:
    conn.execute('INSERT INTO users (email) VALUES (?)', (email,))
except sqlite3.IntegrityError:
    return jsonify({
        'error': 'Email already exists'
    }), 409
```

### Not Found Errors

```python
user = conn.execute('SELECT * FROM users WHERE id = ?', (user_id,)).fetchone()
if not user:
    return jsonify({
        'error': 'User not found'
    }), 404
```

## 🔒 Security Best Practices

### 1. Use Parameterized Queries

**Bad (SQL Injection vulnerability)**:
```python
query = f"SELECT * FROM users WHERE email = '{email}'"
conn.execute(query)
```

**Good**:
```python
query = "SELECT * FROM users WHERE email = ?"
conn.execute(query, (email,))
```

### 2. Validate Input

```python
def validate_user(data):
    if 'email' not in data:
        return False, "Email required"
    if '@' not in data['email']:
        return False, "Invalid email format"
    if len(data['name']) < 2:
        return False, "Name too short"
    return True, None
```

### 3. Hash Passwords

**Never store plain passwords**:
```python
import hashlib

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

# Better: use bcrypt or argon2
import bcrypt
hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
```

### 4. Use Connection Pooling

```python
# Reuse connections instead of creating new ones
from sqlalchemy import create_engine
from sqlalchemy.pool import QueuePool

engine = create_engine(
    'postgresql://user:pass@localhost/db',
    poolclass=QueuePool,
    pool_size=10
)
```

## 🧪 Hands-On Exercise

### Build a Simple Notes API

**Requirements**:
1. Create database with `notes` table
2. Implement CRUD endpoints
3. Add filtering by date
4. Handle errors properly

**Database**:
```sql
CREATE TABLE notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Endpoints to Implement**:
```
POST   /notes           # Create note
GET    /notes           # List all notes
GET    /notes/:id       # Get specific note
PUT    /notes/:id       # Update note
DELETE /notes/:id       # Delete note
```

**Test with curl**:
```bash
# Create
curl -X POST http://localhost:5000/notes \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","content":"Hello"}'

# List
curl http://localhost:5000/notes

# Get one
curl http://localhost:5000/notes/1

# Update
curl -X PUT http://localhost:5000/notes/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated","content":"New content"}'

# Delete
curl -X DELETE http://localhost:5000/notes/1
```

## 🎯 Key Takeaways

1. **Databases**: Essential for data persistence in APIs
2. **SQL vs NoSQL**: Choose based on requirements
3. **CRUD**: Map HTTP methods to database operations
4. **Security**: Use parameterized queries, validate input, hash passwords
5. **Error Handling**: Handle connection, constraint, and not-found errors
6. **Connection Pooling**: Reuse connections for better performance

## 📖 Next Steps

➡️ [Module 09: API Security](../09-API-Security/)

## 🔗 Resources

- [SQLite Tutorial](https://www.sqlitetutorial.net/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [MongoDB University](https://university.mongodb.com/)
- [SQL Injection Prevention](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
