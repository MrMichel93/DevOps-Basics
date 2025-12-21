# Module 06: Monitoring and Logging

## 🎯 Learning Objectives

- ✅ Understand observability principles
- ✅ Implement structured logging
- ✅ Work with Docker container logs
- ✅ Set up health checks
- ✅ Use basic monitoring tools
- ✅ Debug production issues effectively

**Time Required**: 5-7 hours

## 📚 Why Monitoring and Logging Matter

### The Problem

**You get an alert at 3 AM:**
> "Production is down! Users can't access the site!"

**Without Monitoring/Logging:**

- ❓ Which service failed?
- ❓ When did it start?
- ❓ What caused it?
- ❓ Is it still failing?
- ⏰ Hours to diagnose

**With Monitoring/Logging:**

- ✅ API service crashed at 2:47 AM
- ✅ Out of memory error
- ✅ Memory leak in new feature
- ✅ Rolled back in 5 minutes
- ⏱️ Back online in 10 minutes

## 🔍 The Three Pillars of Observability

### 1. Metrics

**What:** Numerical measurements over time  
**Examples:** CPU usage, request count, response time  
**Tools:** Prometheus, Grafana

### 2. Logs

**What:** Event records from applications  
**Examples:** Error messages, request logs, debug info  
**Tools:** ELK Stack, Loki, CloudWatch

### 3. Traces

**What:** Request path through distributed systems  
**Examples:** API call chain, service interactions  
**Tools:** Jaeger, Zipkin, OpenTelemetry

## 📖 Module Content

### Logging Best Practices

**Bad Logging:**

```javascript
console.log("Something happened");
console.log("User logged in");
```

**Good Logging:**

```javascript
logger.info('User login successful', {
    userId: 123,
    ip: '192.168.1.1',
    timestamp: new Date().toISOString(),
    userAgent: req.get('user-agent')
});
```

### Log Levels

```
TRACE - Very detailed, only for development
DEBUG - Diagnostic information
INFO  - General informational messages
WARN  - Warning messages, potential issues
ERROR - Error events, needs attention
FATAL - Critical failures, immediate action
```

**Example:**

```javascript
logger.trace('Entering function calculateTotal');
logger.debug('Processing 15 items');
logger.info('Order created', { orderId: 'ORD-123' });
logger.warn('Inventory low for product SKU-456');
logger.error('Payment failed', { error: err.message });
logger.fatal('Database connection lost');
```

### Docker Container Logs

**View logs:**

```bash
# All logs
docker logs container-name

# Follow logs (like tail -f)
docker logs -f container-name

# Last 100 lines
docker logs --tail 100 container-name

# Since timestamp
docker logs --since 10m container-name
```

**Logging in Docker:**

```javascript
// Just use console.log/error
// Docker captures stdout/stderr
console.log(JSON.stringify({
    level: 'info',
    message: 'Server started',
    port: 3000
}));
```

### Health Checks

**In Dockerfile:**

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3000/health || exit 1
```

**Health endpoint:**

```javascript
app.get('/health', (req, res) => {
    // Check dependencies
    const dbOk = checkDatabase();
    const redisOk = checkRedis();
    
    if (dbOk && redisOk) {
        res.status(200).json({
            status: 'healthy',
            checks: {
                database: 'up',
                redis: 'up'
            }
        });
    } else {
        res.status(503).json({
            status: 'unhealthy',
            checks: {
                database: dbOk ? 'up' : 'down',
                redis: redisOk ? 'up' : 'down'
            }
        });
    }
});
```

### Simple Monitoring Stack

```yaml
# docker-compose.yml
version: '3.8'

services:
  # Your application
  app:
    build: .
    ports:
      - "3000:3000"

  # Prometheus - Metrics collection
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

  # Grafana - Visualization
  grafana:
    image: grafana/grafana
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
```

## 🎯 Real-World Scenarios

### Scenario 1: Debug API Slowness

```bash
# Check container stats
docker stats api-container

# Check logs for slow queries
docker logs api-container | grep "query took"

# Follow logs in real-time
docker logs -f api-container
```

### Scenario 2: Find Why Service Crashed

```bash
# Check last logs before crash
docker logs --tail 100 crashed-container

# Look for error patterns
docker logs crashed-container | grep -i "error\|exception\|fatal"
```

### Scenario 3: Monitor Multiple Services

```bash
# All services status
docker compose ps

# All services logs
docker compose logs -f

# Specific service logs
docker compose logs -f api

# Logs from multiple services
docker compose logs api database
```

## 🏗️ Example Application with Logging

```javascript
// app.js
const winston = require('winston');

// Configure logger
const logger = winston.createLogger({
    level: process.env.LOG_LEVEL || 'info',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
    ),
    transports: [
        new winston.transports.Console()
    ]
});

// Use in application
app.post('/api/orders', async (req, res) => {
    const startTime = Date.now();
    
    try {
        logger.info('Creating order', {
            userId: req.user.id,
            items: req.body.items.length
        });
        
        const order = await createOrder(req.body);
        
        const duration = Date.now() - startTime;
        logger.info('Order created successfully', {
            orderId: order.id,
            duration: `${duration}ms`
        });
        
        res.json(order);
    } catch (error) {
        logger.error('Order creation failed', {
            error: error.message,
            stack: error.stack,
            userId: req.user.id
        });
        
        res.status(500).json({ error: 'Order creation failed' });
    }
});
```

## 💡 Best Practices

### 1. Structured Logging

```javascript
// ✅ Good - Structured
logger.info('User login', {
    userId: 123,
    ip: '192.168.1.1',
    success: true
});

// ❌ Bad - Unstructured
console.log('User 123 logged in from 192.168.1.1');
```

### 2. Don't Log Sensitive Data

```javascript
// ❌ NEVER do this
logger.info('User login', {
    password: user.password,
    creditCard: user.creditCard
});

// ✅ Good
logger.info('User login', {
    userId: user.id
});
```

### 3. Use Correlation IDs

```javascript
// Add request ID to track across services
app.use((req, res, next) => {
    req.id = uuid.v4();
    logger.info('Request received', {
        requestId: req.id,
        method: req.method,
        path: req.path
    });
    next();
});
```

### 4. Log at the Right Level

- **DEBUG:** Only in development
- **INFO:** Normal operations
- **WARN:** Unusual but handled situations
- **ERROR:** Failures that need investigation

### 5. Include Context

```javascript
// ✅ Good - Provides context
logger.error('Database query failed', {
    query: 'SELECT * FROM users',
    error: err.message,
    duration: '5234ms',
    userId: 123
});

// ❌ Bad - No context
logger.error('Query failed');
```

## 📊 Monitoring Metrics to Track

### Application Metrics

- Request rate (requests/second)
- Error rate (errors/second)
- Response time (p50, p95, p99)
- Active users

### System Metrics

- CPU usage (%)
- Memory usage (%)
- Disk usage (%)
- Network I/O

### Business Metrics

- Orders per hour
- Revenue
- User signups
- Feature usage

## 🚀 Examples

Example configurations coming soon for:

- Application with structured logging
- Health check implementation
- Simple monitoring stack with Prometheus & Grafana
- Log aggregation setup

## 📝 Exercises

Hands-on exercises coming soon! For now, explore the monitoring tools mentioned above.

## 🎓 Key Takeaways

1. **Logs are your debugging tool** - Use them wisely
2. **Structure your logs** - JSON format for easy parsing
3. **Monitor what matters** - The Four Golden Signals
4. **Health checks are essential** - Know when things break
5. **Don't log secrets** - Security first

## 🔒 Security Considerations

### Secure Logging Practices

- NEVER log passwords, tokens, or API keys
- Sanitize sensitive data before logging (mask credit cards, SSNs)
- Use log levels appropriately (DEBUG only in development)
- Implement log retention policies
- Encrypt logs containing sensitive information

### Monitoring Security Events

- Monitor failed login attempts
- Track unusual API usage patterns
- Alert on privilege escalation attempts
- Log all administrative actions
- Monitor for suspicious file access

### Protecting Logs and Metrics

- Restrict access to logging infrastructure
- Use authentication for monitoring dashboards
- Encrypt logs in transit and at rest
- Implement audit logs for who accessed logs
- Don't expose internal metrics publicly

### Security Monitoring

- Set up alerts for security events
- Monitor certificate expiration
- Track dependency vulnerabilities
- Alert on unusual traffic patterns
- Implement intrusion detection logging

### Compliance and Audit

- Maintain tamper-proof audit logs
- Implement log integrity verification
- Follow data retention regulations (GDPR, HIPAA)
- Log access controls and changes
- Regular security log reviews

### Hands-on Security Exercise

[Add exercise: Implement secure logging with sensitive data masking and security event monitoring]

## 🚀 Next Steps

1. Read module content
2. Implement logging in your applications
3. Add health checks to containers
4. Work through examples

**Next Module:** [07-Security-Basics](../07-Security-Basics/)

---

**Remember:** You can't fix what you can't see. Good monitoring and logging are essential for reliable systems!
