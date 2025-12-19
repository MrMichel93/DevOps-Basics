# Module 06: Authentication and Authorization

## 🎯 Learning Objectives

- ✅ Understand authentication vs authorization
- ✅ Learn session-based authentication
- ✅ Master token-based auth (JWT)
- ✅ Understand OAuth 2.0 basics
- ✅ Work with API keys securely

**Time Required**: 3-4 hours

## 🔐 Authentication vs Authorization

### Authentication

**Who are you?**

Verifying identity - proving you are who you claim to be.

Examples:
- Username and password
- Fingerprint scan
- Two-factor authentication (2FA)

### Authorization

**What can you do?**

Determining what an authenticated user is allowed to access.

Examples:
- Admin can delete users
- Regular user can only view their own profile
- Guest can only read public content

### Real-World Analogy

**Authentication**: Showing your ID at airport security  
**Authorization**: Your boarding pass determines which plane you can board

## 🍪 Session-Based Authentication

### How It Works

```
1. User logs in with credentials
2. Server validates credentials
3. Server creates session, stores in database
4. Server sends session ID to client via cookie
5. Client includes cookie in subsequent requests
6. Server validates session ID before processing requests
```

### Example Flow

```bash
# 1. Login
POST /api/login
Body: {"username": "john", "password": "secret"}

Response:
Set-Cookie: sessionId=abc123; HttpOnly; Secure

# 2. Authenticated request
GET /api/profile
Cookie: sessionId=abc123

# 3. Logout
POST /api/logout
Cookie: sessionId=abc123
```

### Pros and Cons

**Pros**:
- Server has full control
- Can revoke sessions immediately
- Well-understood pattern

**Cons**:
- Requires server-side storage
- Difficult to scale (session store)
- CSRF vulnerabilities if not protected

## 🎫 Token-Based Authentication (JWT)

### What is JWT?

**JWT** (JSON Web Token) is a compact, self-contained token for securely transmitting information.

### JWT Structure

```
header.payload.signature

Example:
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

### JWT Components

**1. Header** (algorithm and token type):
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

**2. Payload** (claims - data about user):
```json
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true,
  "iat": 1516239022,
  "exp": 1516242622
}
```

**3. Signature** (verification):
```
HMACSHA256(
  base64UrlEncode(header) + "." + base64UrlEncode(payload),
  secret
)
```

### How JWT Works

```
1. User logs in with credentials
2. Server validates credentials
3. Server generates JWT with user info
4. Client stores JWT (localStorage or memory)
5. Client sends JWT in Authorization header
6. Server verifies JWT signature
7. Server extracts user info from JWT
```

### Using JWT in Requests

```bash
# Login to get token
curl -X POST https://api.example.com/login \
  -H "Content-Type: application/json" \
  -d '{"username":"john","password":"secret"}'

Response:
{
  "token": "eyJhbGc...signature"
}

# Use token for authenticated requests
curl https://api.example.com/profile \
  -H "Authorization: Bearer eyJhbGc...signature"
```

### JWT Best Practices

1. **Use HTTPS**: Always transmit over encrypted connection
2. **Short expiration**: 15-30 minutes for access tokens
3. **Refresh tokens**: Long-lived tokens to get new access tokens
4. **Store securely**: Never in localStorage if XSS risk
5. **Validate properly**: Check signature, expiration, issuer

### Pros and Cons

**Pros**:
- Stateless (no server storage needed)
- Scalable (no session store)
- Cross-domain (can use across services)
- Mobile-friendly

**Cons**:
- Can't revoke until expiration
- Token size larger than session ID
- Can contain stale data

## 🔑 API Keys

### What Are API Keys?

Simple authentication method - a unique identifier for API clients.

### Using API Keys

**In Header**:
```bash
curl https://api.example.com/data \
  -H "X-API-Key: your_api_key_here"
```

**In Query Parameter** (less secure):
```bash
curl "https://api.example.com/data?api_key=your_api_key_here"
```

### When to Use API Keys

- Server-to-server communication
- Identifying clients (not users)
- Rate limiting
- Simple authentication needs

### API Key Best Practices

1. **Keep secret**: Never expose in client-side code
2. **Environment variables**: Store in env vars, not code
3. **Rotate regularly**: Change keys periodically
4. **Use HTTPS**: Always encrypt transmission
5. **Limit permissions**: Principle of least privilege
6. **Monitor usage**: Track for suspicious activity

## 🔐 OAuth 2.0 Basics

### What is OAuth 2.0?

Authorization framework allowing third-party applications limited access to user accounts.

### Real-World Example

"Sign in with Google" or "Sign in with GitHub"

### OAuth Roles

1. **Resource Owner**: The user
2. **Client**: The application wanting access
3. **Authorization Server**: Issues tokens (e.g., Google)
4. **Resource Server**: Hosts protected data (e.g., Google Drive)

### OAuth 2.0 Flow (Authorization Code)

```
1. User clicks "Sign in with Google"
2. Client redirects to Google's auth page
3. User logs in and grants permission
4. Google redirects back with authorization code
5. Client exchanges code for access token
6. Client uses access token to access user's data
```

### Example Flow

```bash
# 1. Redirect user to authorization URL
https://accounts.google.com/o/oauth2/v2/auth?
  client_id=YOUR_CLIENT_ID&
  redirect_uri=YOUR_REDIRECT_URI&
  response_type=code&
  scope=profile email

# 2. User authorizes, gets redirected back
https://yourapp.com/callback?code=AUTHORIZATION_CODE

# 3. Exchange code for token
curl -X POST https://oauth2.googleapis.com/token \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET" \
  -d "code=AUTHORIZATION_CODE" \
  -d "redirect_uri=YOUR_REDIRECT_URI" \
  -d "grant_type=authorization_code"

Response:
{
  "access_token": "ya29.a0...",
  "expires_in": 3600,
  "refresh_token": "1//...",
  "token_type": "Bearer"
}

# 4. Use access token
curl https://www.googleapis.com/oauth2/v1/userinfo \
  -H "Authorization: Bearer ya29.a0..."
```

### OAuth 2.0 Grant Types

1. **Authorization Code**: For web apps (most secure)
2. **Implicit**: For SPAs (deprecated, use PKCE instead)
3. **Client Credentials**: For server-to-server
4. **Password**: For trusted applications (discouraged)
5. **Refresh Token**: Get new access token

### When to Use OAuth

- Third-party login ("Sign in with...")
- Accessing user data from another service
- Delegated authorization
- Multiple applications accessing same resources

## 🔒 Security Best Practices

### 1. Never Commit Secrets

```bash
# Bad - DON'T do this
API_KEY = "sk_live_abc123"

# Good - Use environment variables
API_KEY = os.environ.get('API_KEY')
```

Use `.gitignore`:
```
.env
secrets.json
config/secrets.yml
```

### 2. Use HTTPS Everywhere

```bash
# Bad
http://api.example.com

# Good
https://api.example.com
```

### 3. Implement Rate Limiting

Prevent abuse and brute force attacks:
```
429 Too Many Requests
Retry-After: 60
```

### 4. Use Secure Headers

```http
Authorization: Bearer token
X-API-Key: key
```

Never in URL:
```bash
# Bad - visible in logs, history, referrer
https://api.example.com/data?api_key=secret
```

### 5. Validate Tokens Properly

- Check signature
- Check expiration
- Check issuer
- Check audience

## 🧪 Hands-On Exercises

### Exercise 1: API Key Authentication

```bash
# GitHub API with authentication
curl https://api.github.com/user \
  -H "Authorization: token YOUR_GITHUB_TOKEN"

# Without auth (limited)
curl https://api.github.com/users/octocat
```

### Exercise 2: JWT Debugging

Visit https://jwt.io and decode this token:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

See the header, payload, and understand the structure.

### Exercise 3: Test OAuth with GitHub

1. Create GitHub OAuth App: https://github.com/settings/developers
2. Follow Authorization Code flow
3. Get access token
4. Make authenticated requests

## 🎯 Key Takeaways

1. **Authentication**: Verify identity (who you are)
2. **Authorization**: Determine permissions (what you can do)
3. **Sessions**: Server-side state, good control
4. **JWT**: Stateless tokens, scalable
5. **API Keys**: Simple identification, good for services
6. **OAuth**: Delegated authorization, third-party access
7. **Security**: Use HTTPS, never commit secrets, validate properly

## 📖 Next Steps

➡️ [Module 07: REST API Design](../07-REST-API-Design/)

## 🔗 Resources

- [JWT.io](https://jwt.io/)
- [OAuth 2.0 Simplified](https://aaronparecki.com/oauth-2-simplified/)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [GitHub OAuth Documentation](https://docs.github.com/en/developers/apps/building-oauth-apps)
