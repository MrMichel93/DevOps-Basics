# Common Mistakes in Monitoring and Logging

## Beginner Mistakes

### Mistake 1: Not Implementing Logging from the Start

**What people do:**
Build applications without proper logging, using only print/console statements or no logging at all.

**Why it's a problem:**
- Can't debug production issues
- No audit trail of system behavior
- Difficult to troubleshoot errors
- Can't track application flow
- No visibility into what happened
- Incident resolution takes much longer

**The right way:**
Implement structured logging from day one:

```python
# Bad ❌
print("User logged in")
print(f"Error: {error}")

# Good ✅
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

logger.info("User logged in", extra={"user_id": user.id, "ip": request.ip})
logger.error("Payment failed", extra={"order_id": order_id, "error": str(e)})
```

**How to fix if you've already done this:**
Add logging to existing application:

```python
# Replace print statements
# Add structured logging
# Include context in logs
# Set appropriate log levels
# Configure log output format
```

**Red flags to watch for:**
- Only print statements in code
- Can't debug production issues
- No log files
- Searching through console output
- No context about what happened

---

### Mistake 2: Logging Too Much or Too Little

**What people do:**
Either log every single action (debug logs in production) or barely log anything (only errors).

**Why it's a problem:**
- Too much: Disk space fills up, hard to find important info, performance impact
- Too little: Can't debug issues, missing context, no operational insight
- Difficult to balance
- High storage costs
- Compliance issues

**The right way:**
Use appropriate log levels:

```python
import logging

# Configure different levels for environments
if os.getenv('ENV') == 'production':
    logging.basicConfig(level=logging.WARNING)
else:
    logging.basicConfig(level=logging.DEBUG)

# Use correct log levels
logger.debug("Detailed info for debugging")  # Dev only
logger.info("User action or system event")   # Important events
logger.warning("Something unexpected")        # Potential issues
logger.error("Error occurred but handled")    # Errors
logger.critical("System-critical failure")    # Severe issues

# Good balance
logger.info("User authenticated", extra={"user_id": user.id})
logger.warning("Rate limit approaching", extra={"current": 950, "max": 1000})
logger.error("Payment gateway timeout", extra={"gateway": "stripe", "order_id": order.id})
```

**How to fix if you've already done this:**
Adjust log levels and verbosity:

```bash
# Review current logs
# Set INFO level for production
# Keep DEBUG for development
# Add sampling for high-volume logs
# Implement log rotation
```

**Red flags to watch for:**
- Disk full from logs
- Can't find relevant information
- Logs are 99% debug statements
- Missing error context
- Production debug logging

---

### Mistake 3: No Centralized Logging

**What people do:**
Leave logs scattered across multiple servers with no aggregation or search capability.

**Why it's a problem:**
- Must SSH to each server to view logs
- Can't correlate events across services
- Difficult to search logs
- No historical analysis
- Logs lost when servers fail
- Time-consuming troubleshooting

**The right way:**
Use centralized logging solution:

```yaml
# Example: Ship logs to centralized system
# Using ELK Stack (Elasticsearch, Logstash, Kibana)
# Or alternatives: Splunk, Datadog, CloudWatch

# Filebeat configuration
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/app/*.log
    json.keys_under_root: true
    
output.elasticsearch:
  hosts: ["elasticsearch:9200"]
  index: "app-logs-%{+yyyy.MM.dd}"

# Application logs to stdout (Docker)
# Let logging driver handle forwarding
```

**How to fix if you've already done this:**
Implement log aggregation:

```bash
# Choose logging solution
# Install log shipper (Filebeat, Fluentd)
# Configure log forwarding
# Set up dashboards
# Create search queries
```

**Red flags to watch for:**
- SSHing to servers to view logs
- Can't search across all logs
- Logs disappear when server restarts
- Multi-hour troubleshooting sessions
- No log retention

---

### Mistake 4: Not Including Context in Logs

**What people do:**
Log generic messages without user IDs, request IDs, timestamps, or other context.

**Why it's a problem:**
- Can't trace request flow
- Don't know which user had issue
- Can't correlate related logs
- Missing debugging information
- Difficult to reproduce issues
- Poor incident response

**The right way:**
Include rich context:

```python
# Bad ❌
logger.error("Database connection failed")

# Good ✅
logger.error(
    "Database connection failed",
    extra={
        "error": str(e),
        "host": db_host,
        "port": db_port,
        "database": db_name,
        "retry_count": retry_count,
        "request_id": request.id,
        "user_id": user.id if user else None,
        "timestamp": datetime.utcnow().isoformat()
    }
)

# Structured logging with context
import structlog

logger = structlog.get_logger()
logger = logger.bind(
    request_id=request_id,
    user_id=user_id,
    session_id=session_id
)

logger.info("checkout_initiated", cart_total=total, item_count=count)
logger.error("payment_failed", gateway="stripe", error=error_msg)
```

**How to fix if you've already done this:**
Add context to logs:

```python
# Add request_id to all logs
# Include user context
# Add timestamps
# Use structured logging
# Add environment info
```

**Red flags to watch for:**
- Generic error messages
- Can't find user's specific error
- No way to trace request
- Missing timestamps
- Unclear which environment

---

### Mistake 5: No Monitoring or Alerts

**What people do:**
Only look at logs after users report problems, with no proactive monitoring or alerting.

**Why it's a problem:**
- Learn about issues from customers
- Slow incident response
- Poor user experience
- No visibility into system health
- Can't prevent issues
- Higher downtime costs

**The right way:**
Implement monitoring and alerts:

```yaml
# Prometheus alert rules
groups:
  - name: application_alerts
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High error rate detected"
          
      - alert: ServiceDown
        expr: up{job="app"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service is down"
          
      - alert: HighResponseTime
        expr: http_request_duration_seconds{quantile="0.95"} > 2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "95th percentile response time > 2s"
```

**How to fix if you've already done this:**
Set up monitoring:

```bash
# Choose monitoring solution (Prometheus, Datadog, CloudWatch)
# Define key metrics
# Set up dashboards
# Configure alerts
# Test alert delivery
# Document on-call procedures
```

**Red flags to watch for:**
- Users report issues before you know
- No visibility into system health
- Discovering outages hours later
- No performance metrics
- Reactive instead of proactive

---

### Mistake 6: Not Rotating or Archiving Logs

**What people do:**
Let logs grow indefinitely without rotation or archiving strategy.

**Why it's a problem:**
- Disk space fills up
- Application crashes from full disk
- Slow log access
- High storage costs
- Can't find recent logs in huge files
- System outages from disk full

**The right way:**
Implement log rotation:

```bash
# Using logrotate (Linux)
# /etc/logrotate.d/app
/var/log/app/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 app app
    sharedscripts
    postrotate
        systemctl reload app
    endscript
}

# Or in application
# Python logging with rotation
from logging.handlers import RotatingFileHandler

handler = RotatingFileHandler(
    'app.log',
    maxBytes=10485760,  # 10MB
    backupCount=5
)

# Time-based rotation
from logging.handlers import TimedRotatingFileHandler

handler = TimedRotatingFileHandler(
    'app.log',
    when='midnight',
    interval=1,
    backupCount=30
)
```

**How to fix if you've already done this:**
Set up log rotation:

```bash
# Configure logrotate
# Set retention policy
# Compress old logs
# Archive to cheap storage
# Monitor disk usage
```

**Red flags to watch for:**
- Disk space warnings
- Multi-GB log files
- Application crashes from full disk
- Can't open log files (too large)
- No old logs available

---

## Intermediate Mistakes

### Mistake 7: Not Using Structured Logging

**What people do:**
Use plain text log messages instead of structured formats like JSON.

**Why it's a problem:**
- Difficult to parse and search
- Can't filter by fields
- Hard to aggregate metrics from logs
- Poor integration with log analysis tools
- Manual parsing required

**The right way:**
Use structured logging (JSON):

```python
# Plain text logging ❌
logging.info("User john@example.com logged in from 192.168.1.1")

# Structured logging ✅
import structlog

logger = structlog.get_logger()
logger.info(
    "user_login",
    user_email="john@example.com",
    ip_address="192.168.1.1",
    timestamp=datetime.utcnow().isoformat()
)

# Output:
# {"event": "user_login", "user_email": "john@example.com", "ip_address": "192.168.1.1", "timestamp": "2024-01-01T12:00:00"}

# Easy to search and filter in log aggregation tools
```

**How to fix if you've already done this:**
Migrate to structured logging:

```python
# Configure JSON logging
# Update log statements
# Use logging libraries (structlog, python-json-logger)
# Update log parsers
```

**Red flags to watch for:**
- Can't search logs by specific fields
- Manual parsing of log messages
- Difficulty creating metrics from logs
- Complex regex patterns to extract data

---

### Mistake 8: Missing Correlation IDs

**What people do:**
Don't track requests across multiple services or log entries.

**Why it's a problem:**
- Can't trace request through system
- Difficult to debug distributed systems
- Can't correlate related events
- Lost context in microservices
- Slow troubleshooting

**The right way:**
Use correlation/request IDs:

```python
import uuid
from flask import request, g

@app.before_request
def before_request():
    g.request_id = request.headers.get('X-Request-ID', str(uuid.uuid4()))
    logger = logging.getLogger()
    logger = logger.bind(request_id=g.request_id)

@app.route('/api/endpoint')
def endpoint():
    logger.info("Processing request", request_id=g.request_id)
    # Pass to downstream services
    response = requests.post(
        'http://service-b/api',
        headers={'X-Request-ID': g.request_id}
    )
```

**How to fix if you've already done this:**
Add correlation IDs:

```python
# Generate unique ID per request
# Add to all log statements
# Pass to downstream services
# Include in responses
```

**Red flags to watch for:**
- Can't trace request flow
- Lost context in microservices
- Difficult debugging
- No request timeline

---

### Mistake 9: Not Monitoring Business Metrics

**What people do:**
Only monitor technical metrics (CPU, memory) without tracking business KPIs.

**Why it's a problem:**
- Miss business impact of technical issues
- Can't correlate technical and business problems
- No visibility into user experience
- Difficult to prioritize fixes
- Miss revenue-impacting issues

**The right way:**
Monitor business metrics:

```python
# Track business events
from prometheus_client import Counter, Histogram

# Business metrics
orders_created = Counter('orders_created_total', 'Total orders created')
order_value = Histogram('order_value_dollars', 'Order value in dollars')
payment_failures = Counter('payment_failures_total', 'Payment failures', ['gateway'])

# Track in code
def create_order(order_data):
    try:
        order = Order.create(order_data)
        orders_created.inc()
        order_value.observe(order.total)
        return order
    except PaymentError as e:
        payment_failures.labels(gateway=order.payment_gateway).inc()
        raise
```

**How to fix if you've already done this:**
Add business metrics:

```bash
# Define key business metrics
# Instrument code
# Create business dashboards
# Set business-focused alerts
```

**Red flags to watch for:**
- Only technical dashboards
- Don't know business impact
- Can't answer "how many orders today?"
- No revenue monitoring
- Missing user behavior metrics

---

### Mistake 10: No Log Security or PII Handling

**What people do:**
Log sensitive data like passwords, credit cards, API keys, or personally identifiable information.

**Why it's a problem:**
- Security compliance violations
- GDPR/PII violations
- Credentials exposed in logs
- Security audit failures
- Potential data breaches
- Legal liability

**The right way:**
Sanitize and secure logs:

```python
# Bad ❌
logger.info(f"User login: email={email}, password={password}")
logger.info(f"Payment: card={card_number}, cvv={cvv}")

# Good ✅
def sanitize_email(email):
    """Mask email for logging"""
    parts = email.split('@')
    return f"{parts[0][0]}***@{parts[1]}"

def mask_card(card_number):
    """Mask card number"""
    return f"****-****-****-{card_number[-4:]}"

logger.info(
    "user_login",
    email=sanitize_email(user.email),
    # Never log password
)

logger.info(
    "payment_processed",
    card_last4=card_number[-4:],  # Only last 4 digits
    # Never log full card or CVV
    amount=amount,
    currency=currency
)

# Secure log files
# chmod 600 /var/log/app/app.log
# Encrypt logs at rest
# Restrict log access
```

**How to fix if you've already done this:**
Audit and sanitize logs:

```bash
# Search logs for PII
grep -r "password\|ssn\|credit_card" /var/log/

# Remove sensitive logs
# Rotate exposed logs
# Update logging code
# Add sanitization functions
# Set file permissions
```

**Red flags to watch for:**
- Passwords in logs
- Credit card numbers
- API keys visible
- SSNs or PII in logs
- Compliance violations

---

## Advanced Pitfalls

### Mistake 11: No Log Sampling for High-Volume Events

**What people do:**
Log every single event even for high-frequency operations, overwhelming the logging system.

**Why it's a problem:**
- Excessive storage costs
- Performance impact on application
- Log system overwhelmed
- Difficult to find important logs
- Network bandwidth wasted

**The right way:**
Use sampling for high-volume logs:

```python
import random

class SamplingLogger:
    def __init__(self, logger, sample_rate=0.01):
        self.logger = logger
        self.sample_rate = sample_rate
    
    def sampled_log(self, level, message, **kwargs):
        if random.random() < self.sample_rate:
            getattr(self.logger, level)(message, **kwargs)

# Sample 1% of high-frequency events
sampled = SamplingLogger(logger, sample_rate=0.01)

# High-frequency event (thousands per second)
sampled.sampled_log('info', 'cache_hit', key=cache_key)

# Always log errors
logger.error('cache_error', error=str(e))
```

**How to fix if you've already done this:**
Implement sampling:

```python
# Identify high-volume logs
# Add sampling logic
# Keep error logs at 100%
# Monitor sampling effectiveness
```

**Red flags to watch for:**
- Millions of identical log entries
- High logging costs
- Performance degradation from logging
- Logs dominated by routine events

---

### Mistake 12: Not Testing Monitoring and Alerts

**What people do:**
Set up alerts but never test if they actually fire or reach the right people.

**Why it's a problem:**
- Alerts don't work when needed
- Wrong people get notifications
- Alert fatigue from false positives
- Miss critical issues
- No confidence in alerting

**The right way:**
Test alerts regularly:

```bash
# Test alert rules
# Fire test alerts
# Verify notification delivery
# Check escalation paths
# Practice incident response

# Example: Test Prometheus alert
# Manually trigger condition
curl -X POST http://localhost:9090/api/v1/alerts

# Verify alert received
# Check PagerDuty/Slack/Email
# Test on-call rotation
# Run fire drills
```

**How to fix if you've already done this:**
Test monitoring:

```bash
# Schedule regular tests
# Verify all alerts
# Test notification channels
# Update on-call contacts
# Document test results
```

**Red flags to watch for:**
- Never received test alerts
- Uncertain if alerts work
- Wrong people notified
- Alerts to inactive channels
- No alert testing schedule

---

## Prevention Checklist

### Application Development

- [ ] Implement structured logging from start
- [ ] Use appropriate log levels
- [ ] Include correlation IDs
- [ ] Add context to all logs
- [ ] Sanitize sensitive data
- [ ] Use logging framework properly

### Infrastructure Setup

- [ ] Configure centralized logging
- [ ] Set up log rotation
- [ ] Implement log retention policy
- [ ] Secure log files and access
- [ ] Configure log shipping
- [ ] Set up log archival

### Monitoring Configuration

- [ ] Define key metrics to track
- [ ] Set up dashboards
- [ ] Configure alerts for critical issues
- [ ] Test alert delivery
- [ ] Monitor business metrics
- [ ] Track SLIs/SLOs

### Operations

- [ ] Monitor disk usage for logs
- [ ] Review and tune log levels
- [ ] Check log aggregation working
- [ ] Test alert escalations
- [ ] Update dashboards regularly
- [ ] Review monitoring gaps

### Security & Compliance

- [ ] No PII in logs
- [ ] No credentials logged
- [ ] Encrypt logs at rest
- [ ] Restrict log access
- [ ] Audit log content
- [ ] Comply with retention policies
