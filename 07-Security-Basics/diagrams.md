# Module 07: Security Basics - Diagrams

This document contains visual diagrams to help understand security concepts, layers, and best practices.

## 1. Security Layers

This diagram shows the different security layers from infrastructure to code:

```text
┌─────────────────────────────────────────────────────────────┐
│                 Infrastructure Security                     │
│                  (Outermost Layer)                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  • Network segmentation and firewalls                       │
│  • VPC and subnet isolation                                 │
│  • DDoS protection                                          │
│  • Load balancer security                                   │
│  • Physical security                                        │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │            Container Security                         │ │
│  │                                                       │ │
│  ├───────────────────────────────────────────────────────┤ │
│  │                                                       │ │
│  │  • Container image scanning                           │ │
│  │  • Runtime security                                   │ │
│  │  • Resource limits                                    │ │
│  │  • Read-only file systems                             │ │
│  │  • Non-root users                                     │ │
│  │                                                       │ │
│  │  ┌─────────────────────────────────────────────────┐ │ │
│  │  │        Application Security                     │ │ │
│  │  │                                                 │ │ │
│  │  ├─────────────────────────────────────────────────┤ │ │
│  │  │                                                 │ │ │
│  │  │  • Authentication & Authorization               │ │ │
│  │  │  • Input validation                             │ │ │
│  │  │  • Session management                           │ │ │
│  │  │  • API security                                 │ │ │
│  │  │  • Security headers                             │ │ │
│  │  │                                                 │ │ │
│  │  │  ┌───────────────────────────────────────────┐ │ │ │
│  │  │  │         Code Security                     │ │ │ │
│  │  │  │        (Innermost Layer)                  │ │ │ │
│  │  │  ├───────────────────────────────────────────┤ │ │ │
│  │  │  │                                           │ │ │ │
│  │  │  │  • Secure coding practices                │ │ │ │
│  │  │  │  • Dependency scanning                    │ │ │ │
│  │  │  │  • No hardcoded secrets                   │ │ │ │
│  │  │  │  • Code review                            │ │ │ │
│  │  │  │  • SAST/DAST testing                      │ │ │ │
│  │  │  │                                           │ │ │ │
│  │  │  └───────────────────────────────────────────┘ │ │ │
│  │  │                                                 │ │ │
│  │  └─────────────────────────────────────────────────┘ │ │
│  │                                                       │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Defense in Depth Strategy:**

Each layer provides protection, so if one is breached, others still defend:

```text
Attack Attempt
      │
      ▼
┌─────────────┐
│Infrastructure│  ── Firewall blocks? ──> Attack Stopped ✓
└──────┬──────┘
       │ (bypassed)
       ▼
┌─────────────┐
│  Container  │  ── Isolation blocks? ──> Attack Stopped ✓
└──────┬──────┘
       │ (bypassed)
       ▼
┌─────────────┐
│ Application │  ── Auth blocks? ──────> Attack Stopped ✓
└──────┬──────┘
       │ (bypassed)
       ▼
┌─────────────┐
│    Code     │  ── Input validation? ─> Attack Stopped ✓
└─────────────┘
```

## 2. Secret Management Flow

This diagram shows proper secrets handling from storage to usage:

```text
┌─────────────────────────────────────────────────────────────┐
│                    Secret Storage                           │
└─────────────────────────────────────────────────────────────┘

        ┌──────────────┐      ┌──────────────┐
        │   Vault      │      │   AWS KMS    │
        │ (HashiCorp)  │      │ Secrets Mgr  │
        └──────┬───────┘      └──────┬───────┘
               │                     │
               │  Encrypted Transit  │
               │      (TLS)          │
               └──────────┬──────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                 Access Control Layer                        │
└─────────────────────────────────────────────────────────────┘

                 ┌────────────────┐
                 │  Authenticate  │
                 │   & Authorize  │
                 │                │
                 │  - Service ID  │
                 │  - API Key     │
                 │  - IAM Role    │
                 └────────┬───────┘
                          │
                     ┌────▼────┐
                     │Allowed? │
                     └────┬────┘
                          │
                     ┌────┴────┐
                     │         │
                ┌────▼───┐ ┌───▼────┐
                │  Yes   │ │   No   │
                └────┬───┘ └───┬────┘
                     │         │
                     │    ┌────▼──────┐
                     │    │   Deny    │
                     │    │  Access   │
                     │    │   Log     │
                     │    └───────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                  Secret Injection                           │
└─────────────────────────────────────────────────────────────┘

              ┌──────────────────┐
              │   Environment    │
              │    Variables     │
              │                  │
              │  DB_PASSWORD=*** │
              │  API_KEY=***     │
              └────────┬─────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                 Application Runtime                         │
└─────────────────────────────────────────────────────────────┘

            ┌────────────────────────┐
            │   Application Reads    │
            │    Secrets from        │
            │    Environment         │
            │                        │
            │  ✓ Never logged        │
            │  ✓ Never in code       │
            │  ✓ Memory only         │
            └────────────────────────┘
```

**Secret Lifecycle:**

```text
Creation ──> Storage ──> Distribution ──> Usage ──> Rotation ──> Revocation
    │           │            │            │           │            │
    ▼           ▼            ▼            ▼           ▼            ▼
Generate    Encrypt     Inject to    Access in   Update with  Remove and
randomly    at rest     container    memory only  new value   audit access
```

**DO's and DON'Ts:**

```text
✅ DO:
├─ Use secret management services (Vault, AWS Secrets Manager)
├─ Rotate secrets regularly
├─ Use different secrets per environment
├─ Encrypt secrets at rest and in transit
├─ Audit secret access
├─ Use least privilege access
└─ Inject secrets at runtime

❌ DON'T:
├─ Hardcode secrets in source code
├─ Commit secrets to Git
├─ Log secrets
├─ Share secrets via email/chat
├─ Use same secrets across environments
├─ Store secrets in plain text
└─ Include secrets in container images
```

**Secret Access Example:**

```text
Wrong Way:
┌────────────────────────────────────┐
│ config.py                          │
├────────────────────────────────────┤
│ DB_PASSWORD = "mypassword123"      │
│ API_KEY = "abc123def456"           │
└────────────────────────────────────┘
       │
       ▼
   Committed to Git ❌
   Visible in code ❌
   Shared with everyone ❌

Right Way:
┌────────────────────────────────────┐
│ config.py                          │
├────────────────────────────────────┤
│ DB_PASSWORD = os.getenv('DB_PASS') │
│ API_KEY = os.getenv('API_KEY')     │
└────────────────────────────────────┘
       │
       ▼
   Reads from environment ✓
   Not in source code ✓
   Controlled access ✓
```

## 3. Security Scanning Pipeline

This diagram shows the complete security scanning process:

```text
┌─────────────────────────────────────────────────────────────┐
│                    Source Code                              │
└─────────────────────────────────────────────────────────────┘
                          │
                          │ git push
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              SAST (Static Analysis)                         │
│          Static Application Security Testing                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Scans: Source code before compilation                      │
│  Finds:                                                     │
│    • SQL injection vulnerabilities                          │
│    • XSS vulnerabilities                                    │
│    • Hardcoded secrets                                      │
│    • Insecure functions                                     │
│    • Buffer overflows                                       │
│                                                             │
│  Tools: SonarQube, Snyk, Checkmarx                          │
└──────────────────────────┬──────────────────────────────────┘
                           │
                      ┌────▼────┐
                      │  Pass?  │
                      └────┬────┘
                           │
                      ┌────┴────┐
                      │         │
                 ┌────▼───┐ ┌───▼────┐
                 │  Yes   │ │   No   │
                 └────┬───┘ └───┬────┘
                      │         │
                      │    ┌────▼──────┐
                      │    │   STOP    │
                      │    │Fix Issues │
                      │    └───────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│            Dependency Scanning                              │
│          Software Composition Analysis (SCA)                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Scans: Third-party dependencies                            │
│  Finds:                                                     │
│    • Known vulnerabilities (CVEs)                           │
│    • Outdated packages                                      │
│    • License issues                                         │
│    • Malicious packages                                     │
│                                                             │
│  Tools: npm audit, Snyk, Dependabot                         │
└──────────────────────────┬──────────────────────────────────┘
                           │
                      ┌────▼────┐
                      │  Pass?  │
                      └────┬────┘
                           │
                      ┌────┴────┐
                      │         │
                 ┌────▼───┐ ┌───▼────┐
                 │  Yes   │ │   No   │
                 └────┬───┘ └───┬────┘
                      │         │
                      │    ┌────▼──────┐
                      │    │   STOP    │
                      │    │ Update or │
                      │    │  Patch    │
                      │    └───────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│            Container Image Scanning                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Scans: Docker images and layers                            │
│  Finds:                                                     │
│    • Vulnerable base images                                 │
│    • OS package vulnerabilities                             │
│    • Malware                                                │
│    • Misconfigurations                                      │
│    • Exposed secrets                                        │
│                                                             │
│  Tools: Trivy, Clair, Docker Scout                          │
└──────────────────────────┬──────────────────────────────────┘
                           │
                      ┌────▼────┐
                      │  Pass?  │
                      └────┬────┘
                           │
                      ┌────┴────┐
                      │         │
                 ┌────▼───┐ ┌───▼────┐
                 │  Yes   │ │   No   │
                 └────┬───┘ └───┬────┘
                      │         │
                      │    ┌────▼──────┐
                      │    │   STOP    │
                      │    │ Rebuild   │
                      │    │  Image    │
                      │    └───────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│          Deploy to Staging/Production                       │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│              DAST (Dynamic Analysis)                        │
│          Dynamic Application Security Testing               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Scans: Running application                                 │
│  Finds:                                                     │
│    • Authentication issues                                  │
│    • Session management flaws                               │
│    • Server misconfigurations                               │
│    • API vulnerabilities                                    │
│    • Real runtime issues                                    │
│                                                             │
│  Tools: OWASP ZAP, Burp Suite                               │
└──────────────────────────┬──────────────────────────────────┘
                           │
                      ┌────▼────┐
                      │  Pass?  │
                      └────┬────┘
                           │
                      ┌────┴────┐
                      │         │
                 ┌────▼───┐ ┌───▼────┐
                 │  Yes   │ │   No   │
                 └────┬───┘ └───┬────┘
                      │         │
                      │    ┌────▼──────┐
                      │    │  Alert    │
                      │    │  & Track  │
                      │    └───────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                   Production                                │
│              Continuous Monitoring                          │
└─────────────────────────────────────────────────────────────┘
```

**Scan Type Comparison:**

```text
┌──────────────┬──────────────┬──────────────┬──────────────┐
│   Scan Type  │     When     │     What     │   Finds      │
├──────────────┼──────────────┼──────────────┼──────────────┤
│    SAST      │  Pre-build   │ Source code  │ Code issues  │
│     SCA      │  Pre-build   │ Dependencies │ CVEs         │
│   Container  │  Post-build  │ Images       │ Layer issues │
│    DAST      │  Runtime     │ Running app  │ Config issues│
└──────────────┴──────────────┴──────────────┴──────────────┘
```

## 4. Attack Surface Map

This diagram shows potential vulnerability points in a system:

```text
┌─────────────────────────────────────────────────────────────┐
│                   External Attackers                        │
└─────────────────────────────────────────────────────────────┘
                           │
       ┌───────────────────┼───────────────────┐
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│   Public    │    │     DNS      │    │   Email     │
│     Web     │    │              │    │   Phishing  │
└──────┬──────┘    └──────┬───────┘    └──────┬──────┘
       │                  │                   │
       │                  └─────────┬─────────┘
       │                            │
       ▼                            ▼
┌─────────────────────────────────────────────────────────────┐
│                  Internet Edge                              │
│  ┌────────────────────────────────────────────────────┐     │
│  │ Potential Attack Vectors:                          │     │
│  │ 1. DDoS attacks                                    │     │
│  │ 2. DNS hijacking                                   │     │
│  │ 3. SSL/TLS vulnerabilities                         │     │
│  └────────────────────────────────────────────────────┘     │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    Load Balancer / WAF                      │
│  ┌────────────────────────────────────────────────────┐     │
│  │ Potential Attack Vectors:                          │     │
│  │ 4. SQL injection                                   │     │
│  │ 5. XSS attacks                                     │     │
│  │ 6. CSRF attacks                                    │     │
│  │ 7. API abuse                                       │     │
│  └────────────────────────────────────────────────────┘     │
└──────────────────────────┬──────────────────────────────────┘
                           │
       ┌───────────────────┼───────────────────┐
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│     Web     │    │     API      │    │   Admin     │
│   Server    │    │   Gateway    │    │   Panel     │
│             │    │              │    │             │
└──────┬──────┘    └──────┬───────┘    └──────┬──────┘
       │                  │                   │
┌──────┴──────────────────┴───────────────────┴──────┐
│ Potential Attack Vectors:                          │
│ 8. Authentication bypass                           │
│ 9. Session hijacking                               │
│ 10. Privilege escalation                           │
│ 11. Insecure direct object references             │
│ 12. Broken access control                          │
└──────────────────────┬─────────────────────────────┘
                       │
       ┌───────────────┼───────────────┐
       │               │               │
       ▼               ▼               ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│ Application │ │    Cache    │ │   Message   │
│   Logic     │ │   (Redis)   │ │    Queue    │
└──────┬──────┘ └──────┬──────┘ └──────┬──────┘
       │               │               │
┌──────┴───────────────┴───────────────┴──────┐
│ Potential Attack Vectors:                   │
│ 13. Business logic flaws                    │
│ 14. Race conditions                          │
│ 15. Cache poisoning                          │
│ 16. Message injection                        │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
            ┌────────────────────┐
            │      Database      │
            │    (PostgreSQL)    │
            └──────────┬─────────┘
                       │
            ┌──────────┴──────────────────────┐
            │ Potential Attack Vectors:       │
            │ 17. SQL injection               │
            │ 18. Data exposure               │
            │ 19. Weak encryption             │
            │ 20. Backup exposure             │
            └─────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    Internal Threats                         │
├─────────────────────────────────────────────────────────────┤
│ Potential Attack Vectors:                                   │
│ 21. Compromised credentials                                 │
│ 22. Malicious insiders                                      │
│ 23. Lateral movement                                        │
│ 24. Data exfiltration                                       │
└─────────────────────────────────────────────────────────────┘
```

**Attack Surface Reduction Strategies:**

```text
Layer 1: Perimeter Security
├─ Use Web Application Firewall (WAF)
├─ Implement DDoS protection
├─ Enable rate limiting
└─ Use CDN with security features

Layer 2: Network Security
├─ Network segmentation
├─ Least privilege network access
├─ Encrypted communications (TLS)
└─ Private subnets for databases

Layer 3: Application Security
├─ Input validation
├─ Output encoding
├─ Secure authentication
├─ CSRF tokens
└─ Security headers

Layer 4: Data Security
├─ Encryption at rest
├─ Encryption in transit
├─ Secure backups
├─ Data classification
└─ Access logging

Layer 5: Monitoring & Response
├─ Security monitoring
├─ Intrusion detection
├─ Incident response plan
└─ Regular security audits
```

**Common Vulnerability Categories (OWASP Top 10):**

```text
1. Broken Access Control          ━━━━━━━━━━ High Risk
2. Cryptographic Failures          ━━━━━━━━━  High Risk
3. Injection                       ━━━━━━━━   High Risk
4. Insecure Design                 ━━━━━━━    Medium Risk
5. Security Misconfiguration       ━━━━━━━    Medium Risk
6. Vulnerable Components           ━━━━━━     Medium Risk
7. Authentication Failures         ━━━━━━     Medium Risk
8. Software & Data Integrity       ━━━━━      Low Risk
9. Logging & Monitoring Failures   ━━━━       Low Risk
10. Server-Side Request Forgery    ━━━        Low Risk
```

**Security Testing Frequency:**

```text
┌────────────────────┬──────────────┬─────────────┐
│   Test Type        │  Frequency   │   Trigger   │
├────────────────────┼──────────────┼─────────────┤
│ SAST               │  Every commit│  Git push   │
│ Dependency Scan    │  Daily       │  Scheduled  │
│ Container Scan     │  Every build │  CI/CD      │
│ DAST               │  Weekly      │  Scheduled  │
│ Penetration Test   │  Quarterly   │  Manual     │
│ Security Audit     │  Annually    │  Manual     │
└────────────────────┴──────────────┴─────────────┘
```

**Incident Response Flow:**

```text
Detection → Containment → Investigation → Remediation → Recovery → Lessons Learned
    │            │              │               │            │              │
    ▼            ▼              ▼               ▼            ▼              ▼
 Alert       Isolate        Analyze         Fix Bug     Restore        Update
 Raised      Affected       Root Cause      Deploy      Service       Security
             Systems        Gather          Patch       Monitor       Practices
                           Evidence
```
