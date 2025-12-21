# Module 02: Command-Line Mastery

## 🎯 Learning Objectives

By the end of this module, you will be able to:

- ✅ Navigate filesystem efficiently using command line
- ✅ Manipulate files and directories with confidence
- ✅ Use pipes and redirection effectively
- ✅ Manage processes and system resources
- ✅ Write shell scripts for automation
- ✅ Master essential DevOps command-line tools

**Time Required**: 6-8 hours

## 📚 Why This Matters

### The Power of the Command Line

**In DevOps, the command line is your primary interface:**

- Servers don't have graphical interfaces
- Automation requires scriptable commands
- Remote work happens via SSH and terminal
- Many DevOps tools are CLI-first (Docker, kubectl, terraform)

**Real scenarios where CLI is essential:**

- 🔥 Production server is down - you SSH in to investigate
- 🚀 Deploying application - you run deployment scripts
- 📊 Checking logs - you tail and grep log files
- ⚙️ Configuring services - you edit config files and restart services

### CLI vs GUI

**GUI (Graphical User Interface):**

- ✅ Easy to learn
- ✅ Visual feedback
- ❌ Hard to automate
- ❌ Slow for repetitive tasks
- ❌ Not available on servers

**CLI (Command Line Interface):**

- ✅ Extremely fast for experts
- ✅ Easy to automate
- ✅ Works over SSH
- ✅ Composable (combine commands)
- ❌ Steeper learning curve

**The truth:** You need both, but CLI is non-negotiable for DevOps.

## 🗺️ Module Structure

### 1. [Navigation](./01-navigation.md)

Master filesystem navigation and exploration.

- `cd`, `ls`, `pwd`
- Find files with `find` and `locate`
- Directory trees and paths
- Working efficiently with directories

### 2. [File Operations](./02-file-operations.md)

Learn to manipulate files and search content.

- View files: `cat`, `less`, `head`, `tail`
- Search content: `grep`, `sed`, `awk`
- Pipes and redirection
- Text processing power tools

### 3. [Process Management](./03-process-management.md)

Control running processes and system resources.

- View processes: `ps`, `top`, `htop`
- Kill processes safely
- Background and foreground jobs
- System monitoring

### 4. [Shell Scripting](./04-shell-scripting.md)

Automate tasks with bash scripts.

- Writing your first script
- Variables and loops
- Functions and conditionals
- Real automation examples

## 📂 Practical Scripts

### [Example Scripts](./scripts/)

We provide production-ready scripts:

- **[deploy.sh](./scripts/deploy.sh)** - Application deployment script
- **[backup.sh](./scripts/backup.sh)** - Automated backup system
- **[healthcheck.sh](./scripts/healthcheck.sh)** - Service health monitoring

Study these to see professional scripting in action!

## 🏋️ Hands-On Exercises

Practice the commands covered in this module by working through the scripts in the `scripts/` directory. Try modifying them and understanding how they work!

## 🎓 How to Use This Module

1. **Work through lessons in order** - Each builds on the previous
2. **Type every command yourself** - Watching isn't learning
3. **Experiment fearlessly** - Use test directories
4. **Practice daily** - Use CLI for regular tasks
5. **Complete all exercises** - Practice makes perfect

## 💡 Before You Begin

### Set Up Practice Environment

```bash
# Create practice directory
mkdir -p ~/devops-practice/cli-practice
cd ~/devops-practice/cli-practice

# Create some test files
echo "Hello, DevOps!" > hello.txt
echo "Learning CLI" > learning.txt
mkdir -p projects/web projects/mobile
touch projects/web/app.js projects/mobile/app.swift
```

### Essential Keyboard Shortcuts

Learn these immediately - they'll save hours:

```
Tab              - Auto-complete (press it constantly!)
Ctrl+C           - Cancel current command
Ctrl+D           - Exit (logout)
Ctrl+L           - Clear screen (or type 'clear')
Ctrl+A           - Jump to start of line
Ctrl+E           - Jump to end of line
Ctrl+U           - Delete from cursor to start
Ctrl+K           - Delete from cursor to end
Ctrl+R           - Search command history
Ctrl+Z           - Suspend current process
Up/Down Arrow    - Navigate command history
!!               - Repeat last command
!$               - Last argument of previous command
```

### Command Structure

```
command [options] [arguments]

Examples:
ls -la /home/user
│  │   └─ argument (what to act on)
│  └─ options (how to act)
└─ command (what to do)
```

Options can be:

- Short: `-a`, `-l`, `-h`
- Combined: `-lah` (same as `-l -a -h`)
- Long: `--all`, `--help`

## 🌟 Philosophy of Unix Commands

Unix commands follow these principles:

1. **Do one thing well** - Each command has one purpose
2. **Work together** - Commands can be combined (pipes)
3. **Text streams** - Everything is text (easy to process)
4. **Silent on success** - No news is good news

**Example:**

```bash
# Each command does one thing
cat file.txt | grep "error" | wc -l

# cat - reads file
# grep - filters lines
# wc - counts lines
```

## 🎯 Common Patterns

### Pattern 1: Navigate and Check

```bash
cd /var/log        # Go to logs
ls -lh             # List files with human-readable sizes
less syslog        # View log file
```

### Pattern 2: Find and Act

```bash
# Find all .log files and compress them
find /var/log -name "*.log" -exec gzip {} \;
```

### Pattern 3: Filter and Process

```bash
# Find error lines in log
grep "ERROR" app.log | wc -l

# Count unique errors
grep "ERROR" app.log | sort | uniq -c
```

### Pattern 4: Monitor and React

```bash
# Watch log file in real-time
tail -f /var/log/app.log

# Monitor processes
watch -n 2 'ps aux | grep python'
```

## 📊 By the End of This Module

You'll be able to:

**Navigate like a pro:**

```bash
cd ~/projects/app/src
ls -la
find . -name "*.py" | wc -l
```

**Process text efficiently:**

```bash
cat app.log | grep "ERROR" | sed 's/ERROR/CRITICAL/' | tee errors.txt
```

**Manage processes:**

```bash
ps aux | grep node
kill -9 12345
nohup python app.py &
```

**Write automation scripts:**

```bash
#!/bin/bash
for server in web1 web2 web3; do
    ssh $server "systemctl status nginx"
done
```

## 🚀 Real-World Scenarios

### Scenario 1: Debug Production Issue

```bash
# SSH to server
ssh production-server

# Check if service is running
systemctl status nginx

# View recent errors
tail -100 /var/log/nginx/error.log

# Check system resources
top

# Find processes using port
netstat -tulpn | grep :80
```

### Scenario 2: Deploy Application

```bash
# Navigate to app directory
cd /opt/applications/myapp

# Pull latest code
git pull origin main

# Install dependencies
npm install

# Stop old process
pkill -f "node app.js"

# Start new process
nohup node app.js > app.log 2>&1 &
```

### Scenario 3: Analyze Logs

```bash
# Count errors by type
grep "ERROR" app.log | cut -d: -f2 | sort | uniq -c | sort -rn

# Find requests from specific IP
grep "192.168.1.100" access.log | wc -l

# Extract slow queries
awk '$NF > 1000' slow-query.log
```

## 🎓 Learning Tips

1. **Use a cheat sheet** - Keep one open while learning
2. **Read error messages** - They're usually helpful
3. **Use `man` pages** - `man ls` shows complete documentation
4. **Use `--help`** - Most commands support `ls --help`
5. **Google is OK** - Everyone looks up commands
6. **Practice daily** - Use CLI for regular file management

## 🐛 What Could Go Wrong?

### "Command not found"

**Solution:** Install the package or check your PATH

```bash
# Check if command exists
which git

# Install if missing (Ubuntu/Debian)
sudo apt install git

# Install if missing (macOS)
brew install git
```

### "Permission denied"

**Solution:** You need elevated privileges

```bash
# Try with sudo
sudo command

# Or fix permissions
chmod +x script.sh
```

### Accidentally Deleted Files

**Solution:** Be careful with `rm`. There's no recycle bin!

```bash
# Always verify before deleting
ls -la file.txt
rm file.txt

# Use -i for interactive mode
alias rm='rm -i'
```

## 🔍 Essential Commands Quick Reference

```bash
# Navigation
cd, ls, pwd, pushd, popd

# File viewing
cat, less, more, head, tail

# File manipulation
cp, mv, rm, mkdir, rmdir, touch

# Searching
grep, find, locate, which

# Text processing
sed, awk, cut, sort, uniq, wc

# Process management
ps, top, kill, pkill, jobs, bg, fg

# System info
df, du, free, uname, hostname

# Networking
ping, curl, wget, netstat, ss

# File permissions
chmod, chown, chgrp

# Compression
tar, gzip, zip, unzip
```

## 📖 Resources

- [GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/)
- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
- [Command Line Crash Course](https://learnpythonthehardway.org/book/appendixa.html)
- [Explain Shell](https://explainshell.com/) - Explains any command

## 🔒 Security Considerations

### File Permissions Matter

- Understanding file permission format (rwxrwxrwx)
- Never use chmod 777 in production
- Principle of least privilege
- Secure script permissions (750: owner can read/write/execute, group can read/execute, others have no access)

### Secure Shell Scripting

- Validate all inputs
- Quote variables properly
- Use absolute paths
- Avoid eval and exec with user input

### Safe Credential Handling

- Never hardcode passwords in scripts
- Use environment variables or secret managers
- Secure temporary files (use mktemp)
- Clean up sensitive data

### Audit Commands

- Be cautious with rm -rf
- Verify paths before destructive operations
- Use -i flag for interactive confirmation
- Keep audit logs of critical commands

### Hands-on Security Exercise

[Add exercise: Write a secure backup script with proper permissions]

## 🚀 Ready to Start?

Begin with [01: Navigation](./01-navigation.md) and work through each lesson.

**Remember:** Everyone was intimidated by the command line at first. With practice, it becomes second nature and incredibly powerful!

Let's dive in! 💻

---

**Pro Tip:** Set up a practice environment where you can experiment without fear. Breaking things in practice is how you learn!
