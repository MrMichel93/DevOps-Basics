# Module 12: HTTPS and TLS

## 🎯 Learning Objectives

- ✅ Understand how encryption works
- ✅ Learn about SSL/TLS certificates
- ✅ Recognize man-in-the-middle attacks
- ✅ Know how to set up HTTPS
- ✅ Understand certificate authorities

**Time Required**: 3-4 hours

## 🔒 HTTP vs HTTPS

### HTTP (Insecure)

```
You → [Request: username=john&password=secret] → Server
         ↑ Anyone can read this!
```

Problems:
- Data sent in plain text
- Can be intercepted
- Can be modified
- No verification of server identity

### HTTPS (Secure)

```
You → [Encrypted: x8f9a...] → Server
         ↑ Encrypted, unreadable!
```

Benefits:
- Encrypted communication
- Data integrity (can't be modified)
- Server authentication
- SEO boost
- Required for modern web features

## 🔐 How Encryption Works

### Symmetric Encryption

Same key encrypts and decrypts:

```
Message + Key → Encrypted
Encrypted + Key → Message
```

**Fast but has a problem**: How do you share the key securely?

### Asymmetric Encryption

Two keys: public and private

```
Public Key (sharable) → Encrypts data
Private Key (secret) → Decrypts data
```

**Example**:
```
1. Server has: Public Key + Private Key
2. Server shares: Public Key (anyone can have it)
3. You encrypt with: Public Key
4. Server decrypts with: Private Key (only server has it)
```

## 🤝 TLS Handshake

When you connect to HTTPS website:

```
1. Client Hello
   - Supported TLS versions
   - Supported cipher suites
   - Random number

2. Server Hello
   - Chosen TLS version
   - Chosen cipher suite
   - Server's certificate
   - Random number

3. Client Verifies Certificate
   - Is it signed by trusted CA?
   - Is it valid (not expired)?
   - Does domain match?

4. Key Exchange
   - Client generates pre-master secret
   - Encrypts it with server's public key
   - Sends to server

5. Both Generate Session Keys
   - Use pre-master secret + random numbers
   - Now have symmetric encryption key

6. Secure Communication Begins
   - All data encrypted with session key
   - Fast symmetric encryption
```

## 📜 SSL/TLS Certificates

### What is a Certificate?

Digital document that proves server identity:

```
Certificate contains:
- Domain name (example.com)
- Organization details
- Public key
- Issue and expiry dates
- Certificate Authority signature
```

### Certificate Types

**Domain Validated (DV)**:
- Validates domain ownership only
- Free (Let's Encrypt)
- Quick to get
- Good for blogs, personal sites

**Organization Validated (OV)**:
- Validates organization details
- Shows organization name
- More expensive
- Good for businesses

**Extended Validation (EV)**:
- Rigorous validation
- Shows organization name in browser
- Most expensive
- Good for banks, e-commerce

### Certificate Chain

```
Root CA (Trusted by browsers)
  └── Intermediate CA
        └── Your Certificate
```

Browser trusts root → trusts intermediate → trusts your cert

## 🏢 Certificate Authorities (CA)

### What is a CA?

Trusted organization that issues certificates:

**Major CAs**:
- Let's Encrypt (Free!)
- DigiCert
- GlobalSign
- Comodo

### How CA Trust Works

```
1. CA verifies you own the domain
2. CA signs your certificate
3. Browsers trust the CA
4. Therefore, browsers trust your certificate
```

### Self-Signed Certificates

You can create your own certificate:

```bash
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
```

**Problem**: Browsers don't trust it (will show warning)

**Use cases**:
- Development/testing
- Internal networks
- Not for production websites

## 🛡️ Man-in-the-Middle (MITM) Attacks

### What is MITM?

Attacker intercepts communication between you and server:

```
You → Attacker → Server
      ↑ Reads/modifies everything!
```

### How HTTPS Prevents MITM

**Without HTTPS**:
```
You → [username=john] → Attacker → Server
      Attacker can read and modify!
```

**With HTTPS**:
```
You → [Encrypted: x8f9a...] → Attacker → Server
      Attacker can't decrypt!
      Attacker can't modify (integrity check fails)!
```

### Certificate Pinning

Extra security - app only accepts specific certificate:

```
App says: "I only trust this exact certificate"
Fake certificate → Rejected, even if signed by CA
```

## 🔧 Setting Up HTTPS

### Using Let's Encrypt (Free)

**With Certbot** (automated):

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Get certificate and auto-configure Nginx
sudo certbot --nginx -d example.com -d www.example.com

# Auto-renewal (runs twice daily)
sudo certbot renew --dry-run
```

**Manual process**:

```bash
# 1. Generate certificate
sudo certbot certonly --standalone -d example.com

# 2. Certificate saved to:
# /etc/letsencrypt/live/example.com/fullchain.pem
# /etc/letsencrypt/live/example.com/privkey.pem

# 3. Configure web server (see below)
```

### Nginx Configuration

```nginx
server {
    listen 80;
    server_name example.com;
    
    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name example.com;
    
    # SSL certificate
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    
    # SSL settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers HIGH:!aNULL:!MD5;
    
    # HSTS (force HTTPS for 1 year)
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    
    location / {
        # Your application
        proxy_pass http://localhost:3000;
    }
}
```

### Apache Configuration

```apache
<VirtualHost *:80>
    ServerName example.com
    Redirect permanent / https://example.com/
</VirtualHost>

<VirtualHost *:443>
    ServerName example.com
    
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/example.com/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/example.com/privkey.pem
    
    # Modern configuration
    SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
    SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5
    
    Header always set Strict-Transport-Security "max-age=31536000"
    
    # Your application
    ProxyPass / http://localhost:3000/
</VirtualHost>
```

## 🔍 Testing HTTPS Setup

### Check Certificate

```bash
# View certificate details
openssl s_client -connect example.com:443 -servername example.com

# Check expiry
echo | openssl s_client -connect example.com:443 2>/dev/null | openssl x509 -noout -dates
```

### Online Tools

- **SSL Labs**: https://www.ssllabs.com/ssltest/
  - Comprehensive SSL/TLS test
  - Grades A+ to F
  - Shows vulnerabilities

- **Security Headers**: https://securityheaders.com/
  - Checks security headers
  - HSTS, CSP, X-Frame-Options

## 🔒 Security Best Practices

### 1. Use Strong TLS Version

```nginx
# Only use TLS 1.2 and 1.3
ssl_protocols TLSv1.2 TLSv1.3;
```

### 2. Implement HSTS

```
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

Forces browsers to always use HTTPS.

### 3. Redirect HTTP to HTTPS

```nginx
# Permanent redirect
return 301 https://$server_name$request_uri;
```

### 4. Keep Certificates Up to Date

```bash
# Auto-renewal with Let's Encrypt
sudo certbot renew

# Add to crontab
0 0 * * * certbot renew --quiet
```

### 5. Use Strong Ciphers

```nginx
ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256...';
ssl_prefer_server_ciphers on;
```

### 6. Enable HTTP/2

```nginx
listen 443 ssl http2;
```

Faster performance with HTTPS.

## 🧪 Hands-On Exercises

### Exercise 1: Check HTTPS Certificate

```bash
# View certificate for any website
openssl s_client -connect github.com:443 -servername github.com < /dev/null

# Check Google's certificate
openssl s_client -connect google.com:443 < /dev/null 2>/dev/null | openssl x509 -noout -text
```

### Exercise 2: Generate Self-Signed Certificate

```bash
# Generate certificate (for local testing)
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes

# View certificate
openssl x509 -in cert.pem -text -noout
```

### Exercise 3: Test Website SSL

Visit https://www.ssllabs.com/ssltest/ and test:
- google.com
- github.com
- Your own website (if you have one)

## ⚠️ Common Issues

### Mixed Content

HTTPS page loading HTTP resources:

```html
<!-- Bad: HTTP image on HTTPS page -->
<img src="http://example.com/image.jpg">

<!-- Good: HTTPS image -->
<img src="https://example.com/image.jpg">

<!-- Better: Protocol-relative -->
<img src="//example.com/image.jpg">
```

### Certificate Expired

```
Solution: Renew certificate
sudo certbot renew
```

### Wrong Certificate (Domain Mismatch)

```
Certificate for: www.example.com
But visiting: example.com
Solution: Include both in certificate
```

## 🎯 Key Takeaways

1. **HTTPS**: Encrypts data between client and server
2. **TLS Handshake**: Establishes secure connection
3. **Certificates**: Prove server identity
4. **CAs**: Trusted authorities that issue certificates
5. **Let's Encrypt**: Free, automated certificates
6. **MITM**: HTTPS prevents these attacks
7. **HSTS**: Force browsers to use HTTPS
8. **Always use HTTPS in production**

## 📖 Next Steps

➡️ [Module 13: Network Security Best Practices](../13-Network-Security-Best-Practices/)

## 🔗 Resources

- [Let's Encrypt](https://letsencrypt.org/)
- [SSL Labs Test](https://www.ssllabs.com/ssltest/)
- [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/)
- [How HTTPS Works (Comic)](https://howhttps.works/)
- [HTTPS Explained with Carrier Pigeons](https://freecodecamp.org/news/https-explained-with-carrier-pigeons-7029d2193351/)
