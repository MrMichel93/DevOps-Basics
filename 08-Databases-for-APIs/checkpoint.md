# Module 8 Checkpoint: Databases for APIs

## Before Moving Forward

Complete this checkpoint to ensure you're ready for the next module.

## Knowledge Check (Answer these questions)

### Fundamentals

1. Why do APIs need databases?
   <details>
   <summary>Answer</summary>
   APIs need databases to: 1) **Persist data** - store information beyond server restarts, 2) **Share data** - multiple clients access the same data, 3) **Query and filter** - efficiently retrieve specific data, 4) **Maintain relationships** - connect related data (users → posts → comments), 5) **Scale** - handle large amounts of data, 6) **Concurrent access** - multiple users can read/write simultaneously with proper isolation, 7) **Data integrity** - enforce constraints and validate data.
   </details>

2. What is the difference between SQL and NoSQL databases?
   <details>
   <summary>Answer</summary>
   **SQL (Relational):**
   - Structured tables with rows and columns
   - Fixed schema (must define columns upfront)
   - ACID transactions (Atomic, Consistent, Isolated, Durable)
   - Relationships via foreign keys
   - Strong consistency
   - Examples: PostgreSQL, MySQL, SQL Server
   - Use for: Financial data, structured data, complex queries
   
   **NoSQL:**
   - Flexible schema (document, key-value, graph, column-family)
   - Schema-less or dynamic schema
   - Eventually consistent (some offer ACID)
   - Denormalized data (embed related data)
   - Examples: MongoDB, Redis, Cassandra, DynamoDB
   - Use for: Unstructured data, rapid development, horizontal scaling
   </details>

3. What are CRUD operations and how do they map to SQL and HTTP?
   <details>
   <summary>Answer</summary>
   CRUD = Create, Read, Update, Delete
   
   | Operation | SQL | HTTP | Example |
   |-----------|-----|------|---------|
   | Create | INSERT | POST | Add new user |
   | Read | SELECT | GET | Fetch user details |
   | Update | UPDATE | PUT/PATCH | Modify user info |
   | Delete | DELETE | DELETE | Remove user |
   
   API layer translates HTTP requests to SQL queries and SQL results to HTTP responses.
   </details>

4. What is a primary key and why is it important?
   <details>
   <summary>Answer</summary>
   A primary key is a unique identifier for each row in a table. Importance: 1) **Uniqueness** - ensures no duplicate rows, 2) **Identity** - provides a way to reference specific records, 3) **Relationships** - used by foreign keys to link tables, 4) **Indexing** - automatically indexed for fast lookups, 5) **Updates/Deletes** - enables targeting specific records. Common types: auto-incrementing integers (1, 2, 3...), UUIDs (globally unique strings). Example: user_id in users table.
   </details>

### Intermediate

5. What is SQL injection and how do you prevent it?
   <details>
   <summary>Answer</summary>
   SQL injection is when attackers insert malicious SQL code through user input to manipulate or access the database.
   
   **Vulnerable code:**
   ```sql
   query = "SELECT * FROM users WHERE email = '" + userInput + "'"
   # If userInput = "' OR '1'='1", returns all users
   ```
   
   **Prevention:**
   1. **Use parameterized queries/prepared statements:**
      ```sql
      query = "SELECT * FROM users WHERE email = ?"
      execute(query, [userInput])  # Driver handles escaping
      ```
   2. **Use ORMs** (Sequelize, SQLAlchemy, Hibernate) that parameterize automatically
   3. **Validate and sanitize** all inputs
   4. **Principle of least privilege** - database user has only needed permissions
   5. **Never concatenate user input** into SQL strings
   </details>

6. What are database indexes and when should you use them?
   <details>
   <summary>Answer</summary>
   Indexes are data structures that improve query speed by creating a lookup table. Like a book index - find pages quickly without reading entire book.
   
   **When to use:**
   - Columns frequently in WHERE clauses (`WHERE user_id = 123`)
   - Columns in JOIN conditions
   - Columns in ORDER BY
   - Foreign keys
   
   **Trade-offs:**
   - ✅ Faster reads (SELECT queries)
   - ❌ Slower writes (INSERT/UPDATE/DELETE must update index)
   - ❌ More storage space
   
   **Example:**
   ```sql
   CREATE INDEX idx_email ON users(email);
   -- Speeds up: SELECT * FROM users WHERE email = 'user@example.com'
   ```
   
   Don't over-index - analyze query patterns first.
   </details>

7. What is the N+1 query problem and how do you solve it?
   <details>
   <summary>Answer</summary>
   N+1 happens when you fetch a list (1 query), then fetch related data for each item (N queries).
   
   **Problem:**
   ```javascript
   // 1 query to get all posts
   posts = db.query("SELECT * FROM posts")
   
   // N queries (one per post) to get authors
   for (post in posts) {
     post.author = db.query("SELECT * FROM users WHERE id = ?", [post.user_id])
   }
   // Total: 1 + N queries (if 100 posts, 101 queries!)
   ```
   
   **Solutions:**
   1. **Eager loading (JOIN):**
      ```sql
      SELECT posts.*, users.name 
      FROM posts 
      JOIN users ON posts.user_id = users.id
      ```
   2. **Batch loading:** Fetch all authors in one query
   3. **Use ORM features:** `Post.findAll({include: User})`
   4. **DataLoader** (in GraphQL) for batching and caching
   </details>

8. What are database migrations and why are they important?
   <details>
   <summary>Answer</summary>
   Migrations are version-controlled database schema changes (add tables, modify columns, create indexes). Benefits:
   
   1. **Version control** - track schema changes like code
   2. **Reproducibility** - same schema across dev/staging/production
   3. **Rollback capability** - undo changes if issues arise
   4. **Team coordination** - everyone has same schema
   5. **Deployment automation** - run migrations as part of deployment
   
   **Example migration:**
   ```sql
   -- Up migration (apply change)
   CREATE TABLE users (
     id SERIAL PRIMARY KEY,
     email VARCHAR(255) UNIQUE NOT NULL,
     created_at TIMESTAMP DEFAULT NOW()
   );
   
   -- Down migration (rollback)
   DROP TABLE users;
   ```
   
   Tools: Alembic (Python), Knex (Node.js), Flyway (Java), Entity Framework (C#)
   </details>

### Advanced

9. What are database transactions and why are they important for APIs?
   <details>
   <summary>Answer</summary>
   A transaction is a sequence of database operations that execute as a single unit - either all succeed or all fail (atomic). ACID properties:
   
   - **Atomic**: All or nothing (if one fails, all rollback)
   - **Consistent**: Database stays in valid state
   - **Isolated**: Concurrent transactions don't interfere
   - **Durable**: Committed data survives crashes
   
   **Example use case:** Transfer money between accounts
   ```sql
   BEGIN TRANSACTION;
   UPDATE accounts SET balance = balance - 100 WHERE id = 1;
   UPDATE accounts SET balance = balance + 100 WHERE id = 2;
   COMMIT;  -- Both succeed or both rollback
   ```
   
   **In APIs:** Create user + send welcome email, place order + reduce inventory, etc. Prevents partial failures leaving database in inconsistent state.
   </details>

10. What is database connection pooling and why is it necessary?
    <details>
    <summary>Answer</summary>
    Connection pooling reuses database connections instead of creating new ones for each request. Benefits:
    
    1. **Performance**: Creating connections is expensive (TCP handshake, authentication)
    2. **Resource limits**: Databases limit concurrent connections
    3. **Scalability**: Handle more requests with fewer connections
    
    **How it works:**
    - Pool maintains open connections (e.g., 5-20)
    - Request needs DB → borrows connection from pool
    - Request done → returns connection to pool
    - If pool empty, request waits or pool creates new connection (up to max)
    
    **Configuration:**
    ```javascript
    const pool = new Pool({
      min: 2,        // Minimum idle connections
      max: 10,       // Maximum total connections
      idleTimeout: 30000  // Close idle connections after 30s
    });
    ```
    </details>

11. What are the differences between vertical and horizontal scaling for databases?
    <details>
    <summary>Answer</summary>
    **Vertical Scaling (Scale Up):**
    - Add more resources to single server (CPU, RAM, disk)
    - ✅ Simple - no code changes
    - ✅ ACID transactions maintained
    - ❌ Limited by hardware (can't scale infinitely)
    - ❌ Single point of failure
    - ❌ Expensive (high-end servers cost exponentially more)
    
    **Horizontal Scaling (Scale Out):**
    - Add more servers/nodes
    - ✅ Nearly unlimited scaling
    - ✅ Better fault tolerance
    - ✅ Cost-effective (commodity hardware)
    - ❌ Complex (sharding, replication)
    - ❌ Harder to maintain consistency
    - ❌ May sacrifice ACID for availability
    
    **Strategies:**
    - **Read replicas**: Master for writes, replicas for reads
    - **Sharding**: Split data across servers (user 1-1000 on server 1, 1001-2000 on server 2)
    - **NoSQL databases** designed for horizontal scaling
    </details>

12. How do you handle database schema evolution in a running production API?
    <details>
    <summary>Answer</summary>
    **Strategies for zero-downtime migrations:**
    
    1. **Backwards-compatible changes:**
       - Add columns (with defaults or nullable)
       - Add tables
       - Add indexes (can be done online in modern DBs)
    
    2. **Breaking changes (multi-step):**
       - Step 1: Add new column, keep old column
       - Step 2: Deploy code writing to both columns
       - Step 3: Backfill old data to new column
       - Step 4: Deploy code reading from new column
       - Step 5: Remove old column
    
    3. **Blue-green deployment:**
       - Deploy new version alongside old
       - Switch traffic when ready
       - Keep old version for rollback
    
    4. **Feature flags:**
       - Deploy code with new logic disabled
       - Run migration
       - Enable new feature
    
    5. **Test thoroughly:**
       - Test migrations on production copy
       - Have rollback plan
       - Monitor after deployment
    </details>

## Practical Skills Verification

### Task 1: Set Up a Database
**Objective:** Install and configure a database for use with an API.

**Steps:**
1. Choose a database (PostgreSQL, MySQL, or MongoDB recommended)
2. Install locally:
   - **PostgreSQL**: Download from postgresql.org or use Docker
     ```bash
     docker run --name postgres -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres
     ```
   - **MongoDB**: Download from mongodb.com or use Docker
     ```bash
     docker run --name mongo -p 27017:27017 -d mongo
     ```
3. Connect using CLI:
   - PostgreSQL: `psql -h localhost -U postgres`
   - MongoDB: `mongosh`
4. Create a database:
   - PostgreSQL: `CREATE DATABASE api_dev;`
   - MongoDB: `use api_dev`
5. Create a test table/collection

**Success Criteria:**
- [ ] Database installed and running
- [ ] Can connect via CLI
- [ ] Database created
- [ ] Can execute basic queries

**Troubleshooting:**
If connection fails, check if service is running. For Docker, use `docker ps` to verify container is running. Check port isn't already in use. On Windows, may need to add to Windows Firewall.

---

### Task 2: Implement CRUD with SQL
**Objective:** Write SQL queries for all CRUD operations.

**Steps:**
1. Create a users table:
   ```sql
   CREATE TABLE users (
     id SERIAL PRIMARY KEY,
     email VARCHAR(255) UNIQUE NOT NULL,
     name VARCHAR(255) NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   ```

2. **Create:**
   ```sql
   INSERT INTO users (email, name) 
   VALUES ('john@example.com', 'John Doe')
   RETURNING *;
   ```

3. **Read:**
   ```sql
   -- All users
   SELECT * FROM users;
   
   -- Single user
   SELECT * FROM users WHERE id = 1;
   
   -- Filtered
   SELECT * FROM users WHERE email LIKE '%@example.com';
   ```

4. **Update:**
   ```sql
   UPDATE users 
   SET name = 'John Smith' 
   WHERE id = 1
   RETURNING *;
   ```

5. **Delete:**
   ```sql
   DELETE FROM users WHERE id = 1;
   ```

**Success Criteria:**
- [ ] Can create records
- [ ] Can query single and multiple records
- [ ] Can update records
- [ ] Can delete records
- [ ] Understand RETURNING clause (PostgreSQL)

**Troubleshooting:**
If UNIQUE constraint fails, user with that email already exists. If foreign key errors, ensure referenced records exist. Use RETURNING to see affected rows.

---

### Task 3: Connect API to Database
**Objective:** Integrate database into your API.

**Steps:**
1. Install database driver:
   - Node.js + PostgreSQL: `npm install pg`
   - Python + PostgreSQL: `pip install psycopg2-binary`
   - Node.js + MongoDB: `npm install mongodb`
   
2. Create connection pool:
   ```javascript
   // Node.js with pg
   const { Pool } = require('pg');
   const pool = new Pool({
     host: 'localhost',
     port: 5432,
     database: 'api_dev',
     user: 'postgres',
     password: 'password',
     max: 10
   });
   ```

3. Implement API endpoint with database:
   ```javascript
   app.get('/api/users', async (req, res) => {
     try {
       const result = await pool.query('SELECT * FROM users');
       res.json(result.rows);
     } catch (err) {
       res.status(500).json({ error: err.message });
     }
   });
   ```

4. Test API endpoints

**Success Criteria:**
- [ ] Database connection established
- [ ] API can query database
- [ ] API can insert/update/delete
- [ ] Errors handled gracefully
- [ ] Connection pool configured

**Troubleshooting:**
If connection fails, verify credentials and database is running. Check firewall rules. Ensure database URL format is correct. Test connection separately before integrating with API.

---

### Task 4: Implement Parameterized Queries
**Objective:** Protect against SQL injection using parameterized queries.

**Steps:**
1. **Wrong way (vulnerable):**
   ```javascript
   // NEVER DO THIS!
   const query = `SELECT * FROM users WHERE email = '${req.query.email}'`;
   ```

2. **Right way (safe):**
   ```javascript
   // pg (PostgreSQL)
   const query = 'SELECT * FROM users WHERE email = $1';
   const result = await pool.query(query, [req.query.email]);
   
   // mysql2
   const query = 'SELECT * FROM users WHERE email = ?';
   const [rows] = await connection.query(query, [req.query.email]);
   ```

3. Test with malicious input:
   ```
   Try: email=' OR '1'='1
   Parameterized query treats this as literal string, not SQL
   ```

4. Implement all API endpoints with parameterized queries

**Success Criteria:**
- [ ] All queries use parameters/placeholders
- [ ] No string concatenation for SQL
- [ ] Protection against SQL injection verified
- [ ] Understand why parameterization prevents injection

**Troubleshooting:**
Different databases use different placeholders: PostgreSQL ($1, $2), MySQL (?), SQLite (?). Consult driver documentation for correct syntax.

---

### Task 5: Implement Database Migrations
**Objective:** Version control your database schema.

**Steps:**
1. Install migration tool:
   - Node.js: `npm install knex` (also supports migrations)
   - Python: `pip install alembic`
   
2. Initialize migrations:
   ```bash
   # Knex
   npx knex init
   npx knex migrate:make create_users_table
   
   # Alembic
   alembic init alembic
   alembic revision -m "create users table"
   ```

3. Write migration:
   ```javascript
   // Knex migration
   exports.up = function(knex) {
     return knex.schema.createTable('users', table => {
       table.increments('id').primary();
       table.string('email').unique().notNullable();
       table.string('name').notNullable();
       table.timestamps(true, true);
     });
   };
   
   exports.down = function(knex) {
     return knex.schema.dropTable('users');
   };
   ```

4. Run migration:
   ```bash
   npx knex migrate:latest
   ```

5. Rollback (test):
   ```bash
   npx knex migrate:rollback
   ```

**Success Criteria:**
- [ ] Migration tool configured
- [ ] Can create migrations
- [ ] Can run migrations (up)
- [ ] Can rollback migrations (down)
- [ ] Migrations tracked in version control

**Troubleshooting:**
If migration fails, check syntax and database connection. Ensure migration tool has permissions to create tables. Check migration tracking table exists.

## Project-Based Assessment

**Mini-Project:** Build a Complete API with Database Integration

Create a fully functional API with proper database integration, following all best practices.

**Requirements:**

**Database Design:**
- [ ] Design schema for at least 3 related tables (e.g., users, posts, comments)
- [ ] Define primary and foreign keys
- [ ] Add appropriate indexes
- [ ] Include timestamps (created_at, updated_at)

**Implementation:**
- [ ] Set up database with migrations
- [ ] Implement all CRUD operations for each resource
- [ ] Use parameterized queries (prevent SQL injection)
- [ ] Implement connection pooling
- [ ] Handle database errors gracefully

**Relationships:**
- [ ] Implement one-to-many relationships (user has many posts)
- [ ] Implement many-to-many if applicable (posts have many tags)
- [ ] Use JOIN queries to fetch related data
- [ ] Solve N+1 query problem with eager loading

**Advanced Features:**
- [ ] Implement pagination (limit/offset or cursor-based)
- [ ] Implement filtering (by status, date range, etc.)
- [ ] Implement sorting (by date, name, etc.)
- [ ] Implement search functionality
- [ ] Use transactions for multi-step operations

**Data Validation:**
- [ ] Validate inputs before database operations
- [ ] Handle constraint violations (unique, foreign key, not null)
- [ ] Return meaningful error messages

**Performance:**
- [ ] Add indexes on frequently queried columns
- [ ] Monitor and log slow queries
- [ ] Optimize N+1 queries

**Testing:**
- [ ] Test all CRUD operations
- [ ] Test with invalid data
- [ ] Test constraint violations
- [ ] Test concurrent requests
- [ ] Measure query performance

**Documentation:**
- [ ] Database schema diagram (ERD)
- [ ] Setup instructions (database creation, migrations)
- [ ] Environment variable configuration
- [ ] Example SQL queries
- [ ] API endpoints documentation

**Evaluation Rubric:**
| Criteria | Needs Work | Good | Excellent |
|----------|------------|------|-----------|
| **Schema Design** | Basic, no relationships | Proper relationships, some optimization | Well-designed, normalized, indexed |
| **Security** | Vulnerable to SQL injection | Uses parameterized queries | Comprehensive validation and sanitization |
| **Performance** | N+1 queries, no indexes | Some optimization | Fully optimized with indexes, eager loading |
| **Code Quality** | Hardcoded values, messy | Organized, uses ORM/query builder | Clean, modular, follows best practices |
| **Features** | Basic CRUD only | CRUD + filtering/pagination | Full-featured with search, transactions |

**Sample Solution:**
See `checkpoint-solutions/08-blog-api-with-db/` for a complete implementation with PostgreSQL.

## Self-Assessment

Rate your confidence (1-5) in these areas:
- [ ] Understanding SQL vs NoSQL: ___/5
- [ ] Writing SQL queries (CRUD operations): ___/5
- [ ] Connecting API to database securely: ___/5
- [ ] Database optimization (indexes, N+1 queries): ___/5

**If you scored below 3 on any:**
- Practice writing SQL queries on platforms like SQLZoo or LeetCode
- Build small projects with database integration
- Study database indexing and query optimization
- Review SQL injection prevention techniques

**If you scored 4+ on all:**
- You're ready to move forward!
- Consider the advanced challenges below

## Advanced Challenges (Optional)

For those who want to go deeper:

1. **Database Replication**: Set up a master-slave replication. Configure API to write to master, read from replicas. Handle replication lag. Test failover scenarios.

2. **Database Sharding**: Implement horizontal sharding for a users table. Split by user ID ranges or hash. Handle cross-shard queries. Understand trade-offs.

3. **Full-Text Search**: Implement full-text search using PostgreSQL's `tsvector` or Elasticsearch. Create search indexes, implement ranking, handle typos/stemming.

4. **Query Optimization**: Use EXPLAIN ANALYZE to understand query plans. Identify and fix slow queries. Compare indexed vs non-indexed performance. Optimize JOIN queries.

5. **Multi-Tenancy**: Design a multi-tenant database schema. Implement row-level security or separate schemas per tenant. Ensure data isolation. Handle tenant-specific migrations.

## Ready to Continue?

- [ ] I've completed the knowledge check (80% or better)
- [ ] I've verified all practical skills
- [ ] I've completed the mini-project
- [ ] I feel confident in this module's concepts
- [ ] I've reviewed common-mistakes.md (if available)

✅ **You've completed all core API development modules! Proceed to security and advanced topics (Modules 9-13) or start building your capstone project.**
