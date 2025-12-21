# Module 6 Checkpoint: Authentication and Authorization

## Before Moving Forward

Complete this checkpoint to ensure you're ready for the next module.

## Knowledge Check (Answer these questions)

### Fundamentals

1. What is the difference between authentication and authorization?
   <details>
   <summary>Answer</summary>
   **Authentication** (AuthN) is verifying who you are - proving identity (login with username/password, fingerprint, etc.). **Authorization** (AuthZ) is verifying what you're allowed to do - checking permissions (can you view this file? edit this record? delete this user?). Example: You authenticate with your username/password to log into Gmail, then Gmail authorizes you to read your emails but not others' emails.
   </details>

2. What are the main types of authentication methods used in web applications?
   <details>
   <summary>Answer</summary>
   1. **Basic Authentication**: Username/password in Base64 (insecure without HTTPS)
   2. **Session-based**: Server stores session data, cookie contains session ID
   3. **Token-based (JWT)**: Stateless tokens containing user info and signature
   4. **OAuth 2.0**: Delegated authorization allowing third-party access
   5. **API Keys**: Simple string identifying application/user
   6. **Multi-factor (MFA)**: Combines multiple methods (password + SMS code)
   7. **Biometric**: Fingerprint, face recognition, etc.
   </details>

3. What is a session and how does session-based authentication work?
   <details>
   <summary>Answer</summary>
   A session is server-side storage of user state. Flow: 1) User logs in with credentials, 2) Server validates and creates session with unique ID, 3) Server stores session data (user ID, permissions) in memory/database, 4) Server sends session ID to client in cookie, 5) Client includes cookie in subsequent requests, 6) Server looks up session by ID to identify user. Sessions expire after inactivity or logout. Stateful - server must store sessions.
   </details>

4. What is JWT (JSON Web Token) and what are its main components?
   <details>
   <summary>Answer</summary>
   JWT is a compact, self-contained token for securely transmitting information between parties. Format: `header.payload.signature`
   
   **Header**: Token type (JWT) and signing algorithm (HS256, RS256)
   **Payload**: Claims (data) about the user (user_id, roles, expiration)
   **Signature**: Cryptographic signature to verify token wasn't tampered with
   
   Example: `eyJhbGci.eyJzdWIi.SflKxw` - each part is Base64Url encoded. Stateless - no server storage needed. Server verifies signature to trust token.
   </details>

### Intermediate

5. What are the advantages and disadvantages of session-based vs token-based authentication?
   <details>
   <summary>Answer</summary>
   **Session-based:**
   - ✅ Server can revoke immediately (logout all devices)
   - ✅ Smaller cookie size
   - ✅ Session data not exposed to client
   - ❌ Requires server-side storage (scalability issue)
   - ❌ Doesn't work well with distributed systems
   - ❌ CSRF vulnerability (needs CSRF tokens)
   
   **Token-based (JWT):**
   - ✅ Stateless - no server storage needed
   - ✅ Works across domains (CORS-friendly)
   - ✅ Scales horizontally (any server can validate)
   - ❌ Can't revoke before expiration (unless using blacklist)
   - ❌ Larger size (sent with every request)
   - ❌ Token payload visible (Base64 is encoding, not encryption)
   </details>

6. What is OAuth 2.0 and when would you use it?
   <details>
   <summary>Answer</summary>
   OAuth 2.0 is an authorization framework that allows applications to obtain limited access to user accounts on another service (like "Sign in with Google"). Use when: 1) Third-party login (social login), 2) Allowing apps to access user data without sharing passwords, 3) Granting granular permissions (read-only access to photos). 
   
   Flow: User clicks "Sign in with Google" → Redirected to Google → User grants permissions → Google sends authorization code → App exchanges code for access token → App uses token to access Google APIs on user's behalf.
   </details>

7. What are refresh tokens and why are they used alongside access tokens?
   <details>
   <summary>Answer</summary>
   **Access tokens** are short-lived (minutes to hours) and grant access to resources. **Refresh tokens** are long-lived (days to months) and are used to obtain new access tokens when they expire. Benefits: 1) If access token is stolen, it expires quickly, 2) User doesn't need to re-login frequently, 3) Can revoke refresh tokens to force re-authentication, 4) Reduces risk of long-lived credentials. Flow: Access token expires → Client sends refresh token → Server validates and issues new access token.
   </details>

8. What is CORS and how does it relate to authentication?
   <details>
   <summary>Answer</summary>
   CORS (Cross-Origin Resource Sharing) controls which websites can make requests to your API from browsers. By default, browsers block cross-origin requests (Same-Origin Policy). With authentication: 1) Cookies don't send cross-origin by default (need credentials: 'include'), 2) Server must allow origin and credentials in CORS headers, 3) Preflight requests check permissions before sending credentials, 4) Tokens in headers avoid some CORS cookie issues. Set `Access-Control-Allow-Credentials: true` and specific origin (not *) for authenticated requests.
   </details>

### Advanced

9. How do you securely store passwords in a database?
   <details>
   <summary>Answer</summary>
   **Never store plain text passwords!** Use secure hashing:
   
   1. **Hash with bcrypt, Argon2, or scrypt** (NOT MD5, SHA1, or plain SHA256)
   2. **Add salt** (random data) to each password before hashing
   3. **Use slow hashing** (computationally expensive) to prevent brute force
   4. **Use unique salt per password** (prevents rainbow table attacks)
   
   Example flow: User creates password "mypass123" → Generate random salt → Hash "mypass123" + salt → Store hash and salt in DB. Login: User enters password → Retrieve hash and salt from DB → Hash entered password with stored salt → Compare hashes. Libraries like bcrypt handle salting automatically.
   </details>

10. What are the security risks of JWTs and how do you mitigate them?
    <details>
    <summary>Answer</summary>
    **Risks:**
    1. **Token theft (XSS)**: Malicious script steals token from localStorage
    2. **Payload exposed**: Anyone can decode and read payload
    3. **Can't revoke**: Valid tokens work until expiration
    4. **Algorithm confusion**: Attacker changes header to "none" algorithm
    
    **Mitigations:**
    1. **Short expiration** (15-30 minutes for access tokens)
    2. **Use refresh tokens** for long-term access
    3. **Store in httpOnly cookies** (not localStorage) to prevent XSS
    4. **Don't put sensitive data** in payload
    5. **Validate algorithm** in signature verification
    6. **Use HTTPS only** to prevent interception
    7. **Implement token blacklist** for critical revocations
    8. **Rotate secrets** regularly
    </details>

11. Explain the OAuth 2.0 Authorization Code Flow step-by-step.
    <details>
    <summary>Answer</summary>
    **Most secure OAuth flow for web apps:**
    
    1. User clicks "Sign in with Google" on your app
    2. **App redirects** to Google authorization URL with: client_id, redirect_uri, scope, state (CSRF protection)
    3. **User sees Google consent screen**, logs in if needed, grants permissions
    4. **Google redirects back** to your redirect_uri with: authorization code, state
    5. **App validates state** (CSRF protection)
    6. **App exchanges code for tokens**: POST to Google's token endpoint with: code, client_id, client_secret, redirect_uri
    7. **Google returns tokens**: access_token, refresh_token (optional), id_token (for OpenID Connect)
    8. **App uses access_token** to call Google APIs on behalf of user
    
    Code is short-lived (minutes), exchanged server-side where client_secret is secure.
    </details>

12. What is the principle of least privilege and how does it apply to authorization?
    <details>
    <summary>Answer</summary>
    Principle of Least Privilege means users/systems should have only the minimum permissions needed to perform their function. In authorization:
    
    1. **Default deny**: Start with no access, grant only what's needed
    2. **Role-based access control (RBAC)**: Assign roles (admin, editor, viewer) with specific permissions
    3. **Resource-level permissions**: User can edit their own posts, not others'
    4. **Time-limited access**: Temporary elevated privileges expire
    5. **Audit and review**: Regularly review and revoke unnecessary permissions
    
    Example: Customer service rep can view customer data and create tickets, but can't delete accounts or access financial reports. Reduces damage from compromised accounts or insider threats.
    </details>

## Practical Skills Verification

### Task 1: Implement Basic Authentication
**Objective:** Understand and test HTTP Basic Authentication.

**Steps:**
1. Test Basic Auth with httpbin:
   ```bash
   # Success (username: user, password: pass)
   curl -u user:pass https://httpbin.org/basic-auth/user/pass
   
   # Failure (wrong password)
   curl -u user:wrong https://httpbin.org/basic-auth/user/pass
   ```
2. See the Authorization header created:
   ```bash
   curl -v -u user:pass https://httpbin.org/basic-auth/user/pass
   ```
3. Manually create the header (Base64 encode "user:pass"):
   ```bash
   # On Linux/Mac:
   echo -n "user:pass" | base64
   # Returns: dXNlcjpwYXNz
   
   curl -H "Authorization: Basic dXNlcjpwYXNz" \
     https://httpbin.org/basic-auth/user/pass
   ```

**Success Criteria:**
- [ ] Understand Basic Auth header format
- [ ] Can authenticate successfully
- [ ] Recognize that Basic Auth is insecure without HTTPS
- [ ] Know when to use Basic Auth (simple scenarios, always with HTTPS)

**Troubleshooting:**
If authentication fails, check username and password match the URL path (httpbin requires exact match). Remember Basic Auth sends credentials with every request - use HTTPS in production!

---

### Task 2: Work with JWT Tokens
**Objective:** Create, decode, and verify JWT tokens.

**Steps:**
1. Visit https://jwt.io to understand JWT structure
2. Create a JWT with this payload:
   ```json
   {
     "sub": "1234567890",
     "name": "John Doe",
     "admin": true,
     "iat": 1516239022
   }
   ```
3. Use secret: "your-256-bit-secret"
4. Decode the token (paste into jwt.io or use command line):
   ```bash
   # Install jwt-cli: npm install -g jwt-cli
   jwt decode YOUR_TOKEN
   ```
5. Try modifying the payload and observe signature verification failure
6. Test with a real API that uses JWT (if available)

**Success Criteria:**
- [ ] Understand JWT structure (header.payload.signature)
- [ ] Can decode JWT to read payload
- [ ] Understand that signature prevents tampering
- [ ] Know that payload is NOT encrypted (don't store secrets)

**Troubleshooting:**
If signature verification fails, ensure secret matches exactly. Remember: JWT is Base64Url encoded (not encrypted). Anyone can decode and read the payload - only the signature proves authenticity.

---

### Task 3: Explore OAuth 2.0 Flow
**Objective:** Understand OAuth 2.0 by observing a real implementation.

**Steps:**
1. Create a GitHub OAuth App:
   - Go to GitHub Settings → Developer settings → OAuth Apps → New OAuth App
   - Set Homepage URL: http://localhost:3000
   - Set Callback URL: http://localhost:3000/callback
   - Note your Client ID and Client Secret
2. Build the authorization URL:
   ```
   https://github.com/login/oauth/authorize?client_id=YOUR_CLIENT_ID&redirect_uri=http://localhost:3000/callback&scope=read:user
   ```
3. Visit the URL in browser (you'll see GitHub's consent screen)
4. After granting, you'll be redirected with an authorization code
5. Exchange code for token (requires server):
   ```bash
   curl -X POST https://github.com/login/oauth/access_token \
     -d "client_id=YOUR_CLIENT_ID" \
     -d "client_secret=YOUR_CLIENT_SECRET" \
     -d "code=AUTHORIZATION_CODE" \
     -H "Accept: application/json"
   ```

**Success Criteria:**
- [ ] Understand OAuth actors (client, authorization server, resource server, user)
- [ ] Can initiate OAuth flow
- [ ] Understand authorization code exchange
- [ ] Know the difference between authorization code and access token

**Troubleshooting:**
If redirect doesn't work, use a tool like https://oauthdebugger.com or ngrok to create a temporary callback URL. Code expires quickly (10 minutes) - exchange immediately. Never expose client_secret in client-side code!

---

### Task 4: Implement Authorization Checks
**Objective:** Understand role-based authorization logic.

**Steps:**
1. Design a simple authorization model:
   - Resources: Posts, Comments, Users
   - Roles: Admin, Editor, Viewer
   - Permissions:
     - Admin: Can do everything
     - Editor: Can create/edit/delete own posts, create comments
     - Viewer: Can view posts and comments only
2. Write pseudocode for authorization checks:
   ```
   function canDeletePost(user, post):
     if user.role == "admin":
       return true
     if user.role == "editor" AND post.author == user.id:
       return true
     return false
   ```
3. Test scenarios:
   - Admin deletes any post (allowed)
   - Editor deletes own post (allowed)
   - Editor deletes other's post (denied)
   - Viewer deletes post (denied)

**Success Criteria:**
- [ ] Can design a permission model
- [ ] Understand role-based access control (RBAC)
- [ ] Can implement authorization logic
- [ ] Know the difference between authentication and authorization

**Troubleshooting:**
If confused about permissions, start simple with just two roles (admin, user). Add complexity gradually. Consider: What's the default? (deny all, then grant) Who can do what? (create permission matrix).

---

### Task 5: Secure API Key Management
**Objective:** Learn to securely handle API credentials.

**Steps:**
1. Create a `.env` file (don't commit to git):
   ```
   API_KEY=your_api_key_here
   DATABASE_URL=postgresql://user:pass@localhost/db
   JWT_SECRET=your-secret-key
   ```
2. Add `.env` to `.gitignore`
3. Load environment variables in code:
   ```javascript
   // Node.js
   require('dotenv').config();
   const apiKey = process.env.API_KEY;
   ```
   ```python
   # Python
   import os
   from dotenv import load_dotenv
   load_dotenv()
   api_key = os.getenv('API_KEY')
   ```
4. Create `.env.example` with dummy values (safe to commit):
   ```
   API_KEY=your_api_key_here
   DATABASE_URL=your_database_url
   JWT_SECRET=your_jwt_secret
   ```

**Success Criteria:**
- [ ] Never commit secrets to version control
- [ ] Use environment variables for configuration
- [ ] Provide example configuration for other developers
- [ ] Understand the risks of exposed credentials

**Troubleshooting:**
If environment variables aren't loading, check file path and loading order. In production, use secret management services (AWS Secrets Manager, Azure Key Vault, HashiCorp Vault) instead of .env files.

## Project-Based Assessment

**Mini-Project:** Build an Authentication System

Create a simple authentication and authorization system for an API.

**Requirements:**

**Authentication Implementation:**
- [ ] Implement user registration endpoint (POST /api/auth/register)
  - [ ] Hash passwords with bcrypt (or Argon2)
  - [ ] Validate email format and password strength
  - [ ] Store users in database/file
- [ ] Implement login endpoint (POST /api/auth/login)
  - [ ] Verify credentials
  - [ ] Return JWT access token (15-min expiration)
  - [ ] Return refresh token (7-day expiration)
- [ ] Implement token refresh endpoint (POST /api/auth/refresh)
- [ ] Implement logout (invalidate refresh token)

**Authorization Implementation:**
- [ ] Define at least 3 roles (admin, editor, viewer)
- [ ] Implement protected routes requiring authentication
- [ ] Implement role-based access control
- [ ] Create middleware to verify JWT and extract user

**Security Requirements:**
- [ ] Use HTTPS (in production)
- [ ] Store passwords hashed with salt
- [ ] Implement rate limiting on auth endpoints
- [ ] Validate all inputs
- [ ] Use httpOnly cookies for tokens (or Authorization header)
- [ ] Implement CSRF protection if using cookies

**Documentation:**
- [ ] API documentation for all endpoints
- [ ] Example requests and responses
- [ ] Setup instructions
- [ ] Security considerations document
- [ ] Testing guide (how to test different roles)

**Testing:**
- [ ] Test successful registration and login
- [ ] Test failed login attempts
- [ ] Test token expiration and refresh
- [ ] Test authorization for different roles
- [ ] Test security measures (SQL injection attempts, XSS, etc.)

**Evaluation Rubric:**
| Criteria | Needs Work | Good | Excellent |
|----------|------------|------|-----------|
| **Security** | Stores plain passwords, no validation | Hashed passwords, basic security | Industry-standard security practices, comprehensive validation |
| **Functionality** | Basic login/logout only | Authentication + basic authorization | Full auth system with refresh tokens, role-based access |
| **Code Quality** | Hardcoded secrets, messy code | Organized, uses env variables | Clean, modular, follows best practices |
| **Documentation** | Minimal or missing | Basic usage docs | Comprehensive docs with security notes |

**Sample Solution:**
See `checkpoint-solutions/06-auth-system/` for a complete implementation in Node.js/Express and Python/Flask.

## Self-Assessment

Rate your confidence (1-5) in these areas:
- [ ] Understanding authentication vs authorization: ___/5
- [ ] Implementing JWT-based authentication: ___/5
- [ ] Understanding OAuth 2.0 flows: ___/5
- [ ] Implementing secure authorization checks: ___/5

**If you scored below 3 on any:**
- Review authentication and authorization fundamentals
- Practice implementing auth from scratch
- Study OAuth 2.0 flows with diagrams
- Review common security vulnerabilities (OWASP Top 10)

**If you scored 4+ on all:**
- You're ready to move forward!
- Consider the advanced challenges below

## Advanced Challenges (Optional)

For those who want to go deeper:

1. **Implement Multi-Factor Authentication (MFA)**: Add TOTP (Time-based One-Time Password) using libraries like speakeasy or pyotp. Generate QR codes for authenticator apps. Implement backup codes.

2. **OAuth 2.0 Server**: Build a complete OAuth 2.0 authorization server from scratch. Implement authorization code flow, client credentials flow, and refresh token flow. Understand grant types deeply.

3. **Password Reset Flow**: Implement secure password reset with: email verification, time-limited reset tokens, secure token generation, password strength requirements, prevention of token reuse.

4. **Session Management**: Build a session management system with: device tracking (remember user's devices), concurrent session limits, remote logout (logout all devices), suspicious activity detection.

5. **Fine-Grained Authorization**: Implement attribute-based access control (ABAC) or policy-based access control. Use libraries like Casbin or Ory Keto. Handle complex scenarios like "users can edit posts they created OR posts in their department."

## Ready to Continue?

- [ ] I've completed the knowledge check (80% or better)
- [ ] I've verified all practical skills
- [ ] I've completed the mini-project
- [ ] I feel confident in this module's concepts
- [ ] I've reviewed common-mistakes.md (if available)

✅ **Proceed to Module 7: REST API Design**
