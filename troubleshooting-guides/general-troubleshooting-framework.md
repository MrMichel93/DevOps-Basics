# DevOps Troubleshooting Framework

## The Scientific Method for DevOps

When something breaks, follow this systematic approach:

1. **Observe** - What's actually happening?
   - What error messages do you see?
   - What behavior are you experiencing?
   - Can you reproduce the issue?
   - Document exactly what you observe

2. **Hypothesize** - What might be causing it?
   - Based on the symptoms, what could be wrong?
   - What changed recently?
   - Generate multiple potential causes
   - Rank them by likelihood

3. **Test** - How can we verify?
   - Design a test to confirm or rule out your hypothesis
   - Make the test as simple and isolated as possible
   - Use tools to gather evidence (logs, metrics, traces)
   - Document the test results

4. **Analyze** - What do results tell us?
   - Did the test confirm your hypothesis?
   - What new information did you learn?
   - Do you need to revise your hypothesis?
   - Are there patterns in the data?

5. **Fix** - Implement solution
   - Apply the minimal change needed
   - Make one change at a time
   - Document what you're changing and why
   - Keep backups or version control

6. **Verify** - Did it work?
   - Test that the original problem is resolved
   - Check that you didn't break anything else
   - Monitor for a period to ensure stability
   - Verify in different environments if applicable

7. **Document** - Record for future
   - Write down what was broken
   - Document the root cause
   - Record the solution steps
   - Add to runbooks or knowledge base

## Troubleshooting Checklist

### When something breaks:

- [ ] Can you reproduce it?
  - Consistent reproduction helps isolate the cause
  - Note the exact steps to reproduce
  - Try to create a minimal reproduction case

- [ ] What changed recently?
  - Code changes (check Git history)
  - Configuration changes
  - Dependency updates
  - Infrastructure changes
  - Environment variables

- [ ] Check the logs
  - Application logs
  - System logs (syslog, journalctl)
  - Container logs (docker logs)
  - CI/CD pipeline logs
  - Web server logs (nginx, apache)

- [ ] Verify connectivity
  - Can you ping the host?
  - Is DNS resolving correctly?
  - Are firewalls blocking traffic?
  - Check network routes
  - Test with telnet/nc for specific ports

- [ ] Check permissions
  - File permissions (ls -la)
  - Directory permissions
  - User/group ownership
  - SELinux/AppArmor policies
  - API authentication/authorization

- [ ] Verify resources (CPU, memory, disk)
  - CPU usage (top, htop)
  - Memory usage (free -h)
  - Disk space (df -h)
  - Disk I/O (iostat)
  - Network bandwidth

- [ ] Compare with working example
  - Test in a known-good environment
  - Compare configurations
  - Diff between working and broken state
  - Check version differences

- [ ] Simplify to minimal reproduction
  - Remove unnecessary components
  - Test with minimal configuration
  - Isolate the specific failing component
  - Strip out complexity until you find the issue

## Common Issues Across Modules

### Decision Tree for Common Problems

```
Problem: Application not accessible
├─ Can't resolve hostname?
│  ├─ YES → Check DNS configuration
│  │       ├─ /etc/resolv.conf correct?
│  │       ├─ Can you ping DNS server?
│  │       └─ Try using IP address instead
│  └─ NO → Continue
│
├─ Connection refused?
│  ├─ YES → Service not running or wrong port
│  │       ├─ Check service status
│  │       ├─ Verify port number
│  │       └─ Check if service is bound to correct interface
│  └─ NO → Continue
│
├─ Connection timeout?
│  ├─ YES → Firewall or network issue
│  │       ├─ Check firewall rules (iptables, ufw)
│  │       ├─ Test with telnet/nc
│  │       └─ Verify security groups (cloud)
│  └─ NO → Continue
│
├─ 403 Forbidden?
│  ├─ YES → Permission issue
│  │       ├─ Check file permissions
│  │       ├─ Verify user running service
│  │       └─ Check authentication headers
│  └─ NO → Continue
│
├─ 500 Internal Server Error?
│  ├─ YES → Application error
│  │       ├─ Check application logs
│  │       ├─ Look for stack traces
│  │       └─ Verify configuration
│  └─ NO → Check specific error message
│
└─ Other error? → See module-specific guides
```

### Issue: "It works on my machine"

**Diagnostic approach:**

1. **Environment differences**
   - Compare environment variables: `env` vs production
   - Check software versions: OS, runtime, dependencies
   - Verify configuration files match
   - Compare resource availability

2. **Data differences**
   - Different database state?
   - Different test data?
   - Cache issues?
   - Different user permissions?

3. **External dependencies**
   - API endpoints different?
   - Database connection strings?
   - File paths absolute vs relative?
   - Network access differences?

**Solution strategies:**

- Use containers to ensure environment consistency
- Document all environment-specific settings
- Use configuration management tools
- Maintain parity between dev, staging, and production

### Issue: Intermittent failures

**Diagnostic approach:**

1. **Timing issues**
   - Race conditions in code
   - Network latency variations
   - Caching TTL issues
   - Timeout settings too aggressive

2. **Resource contention**
   - High load periods
   - Memory pressure
   - Disk I/O bottlenecks
   - Connection pool exhaustion

3. **External dependencies**
   - Third-party API rate limits
   - Database connection limits
   - Network instability
   - Load balancer health checks

**Solution strategies:**

- Add detailed logging with timestamps
- Implement retry logic with exponential backoff
- Monitor resource usage over time
- Use distributed tracing tools

### Issue: Slow performance

**Diagnostic approach:**

1. **Profile the application**
   - Use profiling tools for your language
   - Identify bottlenecks in code
   - Check database query performance
   - Analyze network requests

2. **Check infrastructure**
   - CPU usage patterns
   - Memory swapping
   - Disk I/O wait
   - Network latency

3. **Review recent changes**
   - New features added?
   - Database schema changes?
   - Dependency updates?
   - Configuration changes?

**Solution strategies:**

- Optimize database queries (add indexes)
- Implement caching strategically
- Scale horizontally or vertically
- Use CDN for static assets
- Implement asynchronous processing

## General Debugging Techniques

### Divide and Conquer

Break the problem space in half repeatedly:

- Test at different layers (network, application, database)
- Disable half the features to isolate
- Binary search through Git history
- Split complex systems into components

### Rubber Duck Debugging

Explain the problem out loud (or in writing):

- Forces you to slow down and think clearly
- Often reveals assumptions you're making
- Helps identify gaps in understanding
- Can be done with a colleague, or literally a rubber duck

### Use Version Control

Git is your time machine:

```bash
# Find when a bug was introduced
git bisect start
git bisect bad HEAD
git bisect good <last-known-good-commit>

# View what changed in a file
git log -p -- path/to/file

# See who changed a specific line
git blame path/to/file

# Compare branches or commits
git diff branch1..branch2
```

### Add Strategic Logging

Don't just log errors—log the journey:

```python
# Bad: Only log the error
try:
    result = process_data(data)
except Exception as e:
    logger.error(f"Processing failed: {e}")

# Good: Log the context
logger.info(f"Processing data: {data[:100]}...")  # Log input
try:
    result = process_data(data)
    logger.info(f"Processing succeeded: {result}")  # Log success
except Exception as e:
    logger.error(f"Processing failed for data: {data}", exc_info=True)  # Log error with context
```

### Use the Right Tools

Different problems need different tools:

- **Network issues**: tcpdump, wireshark, curl -v, netstat, ss
- **Performance**: profilers, APM tools, time command, strace
- **Logs**: grep, awk, jq, log aggregation tools
- **Debugging**: debuggers (gdb, pdb, node inspect), print statements
- **Monitoring**: prometheus, grafana, datadog, cloudwatch

## Prevention Strategies

### Infrastructure as Code

- Version control your infrastructure
- Review changes before applying
- Test in staging before production
- Maintain documentation in code

### Automated Testing

- Unit tests for individual components
- Integration tests for interactions
- End-to-end tests for critical paths
- Performance tests for benchmarks

### Monitoring and Alerting

- Set up health checks
- Monitor key metrics
- Alert on anomalies
- Create dashboards for visibility

### Documentation

- Maintain runbooks for common issues
- Document architecture decisions
- Keep README files updated
- Write postmortems for incidents

### Regular Maintenance

- Update dependencies regularly
- Review and rotate credentials
- Clean up unused resources
- Audit permissions and access

## Getting Help

When you're stuck:

1. **Search effectively**
   - Include exact error messages
   - Add relevant context (language, framework, version)
   - Try multiple search engines
   - Check Stack Overflow, GitHub issues

2. **Read the documentation**
   - Official docs for the tool/framework
   - API references
   - Release notes and changelogs
   - Migration guides

3. **Ask for help**
   - Provide minimal reproduction steps
   - Include relevant logs and errors
   - Show what you've already tried
   - Be specific about your environment

4. **Community resources**
   - Stack Overflow
   - Reddit communities (r/devops, r/sysadmin)
   - Discord/Slack channels
   - GitHub discussions

## Remember

- **Stay calm**: Panic leads to mistakes
- **Be systematic**: Follow the scientific method
- **Document everything**: Future you will thank you
- **Learn from failures**: Every bug is a learning opportunity
- **Ask for help**: Two heads are better than one
- **Take breaks**: Fresh eyes see new solutions

> "Debugging is like being the detective in a crime movie where you are also the murderer."
> — Filipe Fortes
