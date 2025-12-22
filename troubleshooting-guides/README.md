# Troubleshooting Guides

A comprehensive collection of troubleshooting guides to help you diagnose and fix common issues across DevOps tools and technologies.

## 📚 Available Guides

### [General Troubleshooting Framework](./general-troubleshooting-framework.md)
**Start here!** Learn the scientific method for debugging any problem:
- The systematic approach to troubleshooting
- Comprehensive troubleshooting checklist
- Common issues across all modules
- Decision trees for quick diagnosis
- Prevention strategies

**Best for:** Learning a methodical approach to solving any technical problem.

---

### Module-Specific Guides

#### [Docker Troubleshooting](./docker-troubleshooting.md)
Solve Docker container and image issues:
- Container won't start
- Image build failures
- Networking problems
- Volume and data issues
- Docker Compose troubleshooting

**Common issues covered:** Exit codes, port conflicts, permission errors, performance problems.

---

#### [CI/CD with GitHub Actions Troubleshooting](./cicd-troubleshooting.md)
Fix GitHub Actions workflow problems:
- Workflow won't trigger
- Build failures
- Permission issues
- Timeout problems
- Caching issues
- Docker in CI/CD

**Common issues covered:** YAML errors, missing secrets, rate limits, artifact handling.

---

#### [Git Troubleshooting](./git-troubleshooting.md)
Resolve Git and version control issues:
- Cannot push to remote
- Merge conflicts
- Committed to wrong branch
- Accidentally deleted commits
- Large file issues
- Submodule problems

**Common issues covered:** Authentication, branch protection, rebase issues, line endings.

---

#### [API Troubleshooting](./api-troubleshooting.md)
Debug API connectivity and integration:
- Cannot connect to API
- Authentication errors
- Request/response issues
- Rate limiting
- Timeout problems
- SSL/TLS certificate errors

**Common issues covered:** CORS, 401/403 errors, JSON formatting, expired tokens.

---

#### [Networking Troubleshooting](./networking-troubleshooting.md)
Solve network connectivity problems:
- Cannot reach host/server
- Port not accessible
- DNS issues
- Slow network performance
- SSL/TLS certificate errors
- Port forwarding/NAT issues

**Common issues covered:** Firewall, routing, DNS resolution, bandwidth issues.

---

#### [Command Line Troubleshooting](./command-line-troubleshooting.md)
Fix common shell and script issues:
- Command not found
- Permission denied
- Script errors
- File and directory issues
- Process management
- Environment variables

**Common issues covered:** PATH issues, file permissions, syntax errors, background jobs.

---

### [Error Message Decoder](./error-message-decoder.md)
**Quick reference!** Plain English translations of common error messages:
- Docker errors
- Git errors
- CI/CD errors
- API/HTTP errors
- Command line errors
- Network errors
- Linux/system errors

**Best for:** When you see an error and want to know what it means and how to fix it fast.

---

## 🎯 How to Use These Guides

### When You Encounter a Problem:

1. **Start with the General Framework**
   - Learn the systematic approach
   - Use the troubleshooting checklist
   - Follow the decision tree

2. **Check the Error Decoder**
   - Look up your specific error message
   - Get plain English explanation
   - Follow quick solutions

3. **Dive into Module-Specific Guide**
   - Find your issue category
   - Follow diagnostic steps
   - Try solutions in order

4. **Apply Prevention Tips**
   - Learn from the issue
   - Implement preventive measures
   - Document for future reference

### Quick Lookup

| Problem | Guide to Check |
|---------|---------------|
| "Container exits immediately" | [Docker](./docker-troubleshooting.md#container-wont-start) |
| "Workflow won't run" | [CI/CD](./cicd-troubleshooting.md#workflow-wont-trigger) |
| "Merge conflict" | [Git](./git-troubleshooting.md#merge-conflicts) |
| "401 Unauthorized" | [API](./api-troubleshooting.md#authentication-errors) |
| "Connection refused" | [Networking](./networking-troubleshooting.md#cannot-reach-hostserver) |
| "Command not found" | [Command Line](./command-line-troubleshooting.md#command-not-found) |
| Any error message | [Error Decoder](./error-message-decoder.md) |

---

## 🔍 The Troubleshooting Process

Every guide follows this structure:

### 1. Issue Categories
Common problems organized by type

### 2. Symptoms
How to recognize this issue

### 3. Diagnostic Steps
Commands and checks to identify the root cause

### 4. Common Causes & Solutions
Most frequent reasons and how to fix them

### 5. Prevention Tips
How to avoid this issue in the future

### 6. Quick Reference
Essential commands and patterns

---

## 💡 General Troubleshooting Tips

### The 5 Whys Technique

Ask "why" five times to get to the root cause:

1. **Why** won't the container start?  
   → Because the command fails
   
2. **Why** does the command fail?  
   → Because the executable isn't found
   
3. **Why** isn't the executable found?  
   → Because it's not in the PATH
   
4. **Why** isn't it in the PATH?  
   → Because the installation didn't complete
   
5. **Why** didn't installation complete?  
   → Because of missing dependencies

**Root cause:** Missing dependencies → Install them

### Divide and Conquer

Break complex problems into smaller pieces:

- Test each component independently
- Disable half the features to isolate the issue
- Simplify until you find the minimal failing case
- Add complexity back piece by piece

### Gather Evidence

Before trying solutions:

```bash
# Save current state
git status > debug/git-status.txt
docker ps -a > debug/containers.txt
journalctl -n 100 > debug/recent-logs.txt

# Document everything you try
echo "Tried solution X at $(date)" >> debug/attempts.log
```

---

## 🎓 Learning from Issues

### Create a Personal Runbook

When you solve an issue:

1. **Document the problem**
   - What was broken?
   - How did you notice?
   
2. **Record the solution**
   - What fixed it?
   - Why did that work?
   
3. **Add prevention**
   - How to avoid next time?
   - What monitoring to add?

### Example Template

```markdown
## Issue: Docker Container Won't Start (2024-01-15)

**Problem:**
Container exits immediately with code 127

**Symptoms:**
- `docker ps` shows nothing
- `docker ps -a` shows exited container
- Logs show "command not found"

**Root Cause:**
Typo in CMD instruction: "ngnix" instead of "nginx"

**Solution:**
1. Check Dockerfile line 15
2. Fix typo: CMD ["nginx", "-g", "daemon off;"]
3. Rebuild image: docker build -t myapp .
4. Test: docker run myapp

**Prevention:**
- Add spell check to IDE
- Use docker linting (hadolint)
- Test builds in CI before deploying

**Time to resolve:** 30 minutes
**Key learning:** Always check spelling in Dockerfile commands
```

---

## 📖 Additional Resources

### Official Documentation

- [Docker Docs](https://docs.docker.com/)
- [Git Documentation](https://git-scm.com/doc)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Linux Man Pages](https://man7.org/linux/man-pages/)

### Community Resources

- [Stack Overflow](https://stackoverflow.com/)
- [DevOps Stack Exchange](https://devops.stackexchange.com/)
- [r/devops](https://reddit.com/r/devops)
- [r/docker](https://reddit.com/r/docker)
- [r/git](https://reddit.com/r/git)

### Troubleshooting Tools

- [Explain Shell](https://explainshell.com/) - Understand complex commands
- [ShellCheck](https://www.shellcheck.net/) - Shell script analyzer
- [JSON Lint](https://jsonlint.com/) - Validate JSON
- [YAML Lint](http://www.yamllint.com/) - Validate YAML
- [Regex101](https://regex101.com/) - Test regular expressions

---

## 🤝 Contributing

Found a common issue not covered here? Have a better solution? Contributions welcome!

1. Create a new issue describing the problem
2. Submit a pull request with your solution
3. Follow the existing format and style
4. Include examples and commands

---

## ⚡ Quick Tips

### Before You Start Troubleshooting:

- [ ] Can you reproduce the issue consistently?
- [ ] What changed since it last worked?
- [ ] Have you checked the logs?
- [ ] Is it just you, or affecting others too?
- [ ] Do you have backups/version control?

### While Troubleshooting:

- [ ] Document each step you try
- [ ] Make one change at a time
- [ ] Test after each change
- [ ] Keep notes of what works and what doesn't
- [ ] Take breaks if frustrated

### After Solving:

- [ ] Document the solution
- [ ] Implement prevention measures
- [ ] Share with team if relevant
- [ ] Update documentation
- [ ] Create tests if applicable

---

## 🎯 Remember

> "It's not a bug, it's an opportunity to learn."

- **Stay calm** - Panic leads to mistakes
- **Be systematic** - Follow the process
- **Ask for help** - No shame in getting stuck
- **Document everything** - Future you will be grateful
- **Learn and improve** - Every issue is a lesson

---

## 📞 When to Escalate

It's okay to ask for help when:

- You've tried multiple solutions without success
- The issue affects production services
- You're not sure about the impact of potential fixes
- The problem is outside your area of expertise
- Time is running out and you need assistance

**When asking for help, always include:**

1. What you're trying to do
2. What's actually happening
3. Error messages (exact text)
4. What you've already tried
5. Your environment details (OS, versions, etc.)
6. Steps to reproduce

---

**Happy troubleshooting! 🔧**

Remember: The best debuggers are systematic, patient, and willing to learn from every issue.
