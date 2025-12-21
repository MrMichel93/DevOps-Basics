# Common Mistakes in Command Line Mastery

## Beginner Mistakes

### Mistake 1: Not Using Tab Completion

**What people do:**
Type out full filenames, directory paths, and commands manually instead of using tab completion.

**Why it's a problem:**
- Wastes time typing long paths
- Prone to typos and errors
- Misses available commands and options
- Inefficient workflow
- Doesn't discover command variations

**The right way:**
Use tab completion extensively:

```bash
# Type partial name and press Tab
cd Doc<Tab>         # Completes to Documents/
git che<Tab>        # Shows: checkout, cherry-pick, etc.
ls /usr/loc<Tab>    # Completes to /usr/local/

# Double-tab to see all options
git <Tab><Tab>      # Shows all git commands
ls -<Tab><Tab>      # Shows available flags
```

**How to fix if you've already done this:**
Start using tab completion:

```bash
# Practice with tab completion
cd ~/<Tab><Tab>     # See all directories
cat file<Tab>       # Auto-complete filename

# Install bash-completion for better completion
# Ubuntu/Debian
sudo apt install bash-completion

# macOS
brew install bash-completion
```

**Red flags to watch for:**
- Typing long paths manually
- Frequent typos in filenames
- Not knowing what files exist
- Slow command-line workflow
- Repeatedly looking up command names

---

### Mistake 2: Not Understanding File Paths and Navigation

**What people do:**
Confuse relative and absolute paths, use `cd` multiple times instead of directly navigating, or get lost in directory structure.

**Why it's a problem:**
- Inefficient navigation
- Scripts break when run from different directories
- Confusion about current location
- Errors finding files
- Commands fail due to wrong paths

**The right way:**
Understand and use paths effectively:

```bash
# Absolute path (starts with /)
cd /home/user/projects/myapp
ls /etc/nginx/nginx.conf

# Relative path (from current directory)
cd projects/myapp
cd ../other-project

# Special directories
cd ~           # Home directory
cd -           # Previous directory
cd ..          # Parent directory
cd ../..       # Two levels up

# Check where you are
pwd            # Print working directory

# Navigate efficiently
cd ~/projects/myapp/src/components  # Direct path
# Instead of:
# cd ~
# cd projects
# cd myapp
# cd src
# cd components
```

**How to fix if you've already done this:**
Learn path navigation:

```bash
# Practice commands
pwd                    # Where am I?
cd /absolute/path      # Absolute navigation
cd relative/path       # Relative navigation
cd -                   # Toggle between two directories

# Use path aliases in .bashrc or .zshrc
alias proj='cd ~/projects'
alias app='cd ~/projects/myapp'
```

**Red flags to watch for:**
- Using `cd` many times to reach a directory
- Errors like "No such file or directory"
- Not knowing current directory
- Scripts that only work from one location
- Confusion between `/` and `~`

---

### Mistake 3: Not Using Command History

**What people do:**
Retype commands from scratch instead of using command history navigation.

**Why it's a problem:**
- Wastes time retyping commands
- Makes typos in complex commands
- Can't remember exact syntax used before
- Inefficient for repetitive tasks
- Misses learning from past commands

**The right way:**
Master command history:

```bash
# Navigate history
↑              # Previous command
↓              # Next command
Ctrl+R         # Search history (reverse-i-search)
!!             # Repeat last command
!$             # Last argument of previous command
!n             # Execute command number n from history

# View history
history        # Show command history
history 10     # Show last 10 commands
history | grep docker  # Search history

# Edit and execute
fc             # Edit last command in $EDITOR
fc -l -10      # List last 10 commands

# Clear history if needed
history -c     # Clear session history
```

**How to fix if you've already done this:**
Start using history features:

```bash
# Add to .bashrc for better history
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend    # Append to history, don't overwrite

# Practice Ctrl+R for searching
# Type Ctrl+R, then start typing past command
# Press Ctrl+R again to see previous matches
```

**Red flags to watch for:**
- Retyping long commands
- Can't remember command you just ran
- Making same typos repeatedly
- Not using up arrow
- Slow command execution

---

### Mistake 4: Running Commands Without Understanding Them

**What people do:**
Copy and paste commands from the internet and run them without understanding what they do, especially with sudo.

**Why it's a problem:**
- Can delete all files accidentally
- May install malware or malicious code
- Breaks system configuration
- Creates security vulnerabilities
- No way to troubleshoot when it fails

**The right way:**
Understand commands before running:

```bash
# Bad ❌ - Don't blindly run:
curl https://random-site.com/script.sh | sudo bash

# Good ✅ - Understand first:
# 1. Download and inspect
curl https://site.com/script.sh > script.sh
cat script.sh          # Read the script
less script.sh         # Review carefully

# 2. Understand what it does
# 3. Run if safe
bash script.sh

# Use --help and man pages
ls --help              # Quick help
man ls                 # Full manual
tldr ls                # Simplified examples

# Test dangerous commands safely
rm -rf /tmp/test       # Test on safe directory first
# Instead of directly running on important data
```

**How to fix if you've already done this:**
Review what you've run:

```bash
# Check history for dangerous commands
history | grep sudo
history | grep rm
history | grep curl.*bash

# If you ran something suspicious:
# 1. Review what it might have done
# 2. Check system logs
sudo less /var/log/syslog
# 3. Look for unexpected changes
# 4. Consider system restore if compromised
```

**Red flags to watch for:**
- Copy-pasting commands without reading
- Running `sudo` without understanding why
- Commands with `curl | bash`
- `rm -rf` without double-checking
- Unexpected system behavior after running commands

---

### Mistake 5: Not Using Sudo Properly

**What people do:**
Run everything as sudo/root, or conversely, never use sudo when needed and get permission errors.

**Why it's a problem:**
- Running as sudo: Major security risk, can break system
- Not using sudo: Can't perform necessary system tasks
- Files owned by root when they shouldn't be
- Confusing permission errors
- Accidents have bigger impact

**The right way:**
Use sudo only when necessary:

```bash
# Need sudo for system operations
sudo apt update        # ✅ System package management
sudo systemctl restart nginx  # ✅ System service
sudo nano /etc/hosts   # ✅ System file editing

# Don't need sudo for user operations
git clone repo         # ❌ Don't use sudo
npm install           # ❌ Don't use sudo
mkdir ~/myproject     # ❌ Don't use sudo

# Fix files owned by root
sudo chown -R $USER:$USER ~/myproject

# Check who owns files
ls -la                # Shows owner and permissions
```

**How to fix if you've already done this:**
Fix ownership and permissions:

```bash
# Find files owned by root in home directory
find ~ -user root

# Fix ownership
sudo chown -R $USER:$USER ~/projects
sudo chown -R $USER:$USER ~/.npm
sudo chown -R $USER:$USER ~/.config

# Check current user
whoami
id
```

**Red flags to watch for:**
- Files in home directory owned by root
- Permission denied errors on your own files
- Using sudo for npm/pip install
- Can't edit files you created
- Running text editors with sudo

---

### Mistake 6: Not Understanding Pipes and Redirection

**What people do:**
Run commands separately instead of combining them with pipes, or lose important output by not redirecting.

**Why it's a problem:**
- Inefficient workflows
- Can't create complex command chains
- Loses command output
- Manual processing of data
- Misses powerful command-line capabilities

**The right way:**
Master pipes and redirection:

```bash
# Pipes - pass output to next command
cat file.txt | grep error | wc -l
ls -la | grep ".txt" | sort

# Redirection
command > file.txt      # Overwrite file with output
command >> file.txt     # Append to file
command 2> error.log    # Redirect errors
command &> all.log      # Redirect everything
command < input.txt     # Use file as input

# Common patterns
# Find and count
find . -name "*.js" | wc -l

# Process and save
cat data.csv | grep "error" > errors.csv

# Chain multiple commands
cat access.log | grep "404" | awk '{print $1}' | sort | uniq -c | sort -rn
```

**How to fix if you've already done this:**
Learn pipe patterns:

```bash
# Practice common patterns
# 1. Search and count
grep "error" log.txt | wc -l

# 2. Filter and sort
ps aux | grep python | awk '{print $2, $11}'

# 3. Process and save
cat input.txt | sort | uniq > output.txt

# 4. Real-time monitoring
tail -f access.log | grep "ERROR"
```

**Red flags to watch for:**
- Running same command multiple times
- Manually processing output
- Can't create complex filters
- Losing command output
- Not using grep, awk, sort together

---

### Mistake 7: Ignoring File Permissions

**What people do:**
Don't understand or check file permissions, use `chmod 777` for everything, or can't execute scripts.

**Why it's a problem:**
- Security vulnerabilities with 777 permissions
- Can't execute scripts
- Files accessible to wrong users
- Confusion about permission errors
- Breaks security best practices

**The right way:**
Understand and set appropriate permissions:

```bash
# Read permissions
ls -la               # View permissions
# -rwxr-xr-x
# - = file type
# rwx = owner (read, write, execute)
# r-x = group (read, execute)
# r-x = others (read, execute)

# Set permissions correctly
chmod 644 file.txt   # Owner: rw-, Others: r--
chmod 755 script.sh  # Owner: rwx, Others: r-x
chmod +x script.sh   # Make executable

# Bad ❌
chmod 777 file       # Everyone can do everything!

# Good ✅
chmod 600 private_key  # Only owner can read
chmod 755 script.sh    # Owner full, others read/execute
chmod 644 config.json  # Owner rw, others read

# Change ownership
chown user:group file
sudo chown -R $USER:$USER ~/project
```

**How to fix if you've already done this:**
Audit and fix permissions:

```bash
# Find files with 777 permissions
find ~ -type f -perm 0777

# Fix common issues
chmod 755 ~/bin/*.sh        # Scripts executable
chmod 644 ~/.ssh/config     # SSH config readable
chmod 600 ~/.ssh/id_rsa     # Private key secure
chmod 644 ~/.bashrc         # Config readable
```

**Red flags to watch for:**
- Using `chmod 777` frequently
- Permission denied on scripts
- SSH key too open errors
- Everyone can edit your files
- Scripts not executable

---

## Intermediate Mistakes

### Mistake 8: Not Using Aliases and Functions

**What people do:**
Type long, complex commands repeatedly instead of creating shortcuts.

**Why it's a problem:**
- Wasted time typing
- Prone to errors in complex commands
- Difficult to remember exact syntax
- Inefficient workflow
- Misses automation opportunities

**The right way:**
Create aliases and functions:

```bash
# Add to ~/.bashrc or ~/.zshrc

# Simple aliases
alias ll='ls -lahF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias gs='git status'
alias gc='git commit'
alias gp='git push'

# Directory shortcuts
alias proj='cd ~/projects'
alias docs='cd ~/Documents'

# System shortcuts
alias update='sudo apt update && sudo apt upgrade'
alias ports='netstat -tulanp'

# Functions for complex logic
mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.gz)  tar xzf "$1"    ;;
            *.zip)     unzip "$1"      ;;
            *.tar.bz2) tar xjf "$1"    ;;
            *)         echo "Unknown format" ;;
        esac
    fi
}
```

**How to fix if you've already done this:**
Create useful aliases:

```bash
# Edit your shell config
nano ~/.bashrc   # or ~/.zshrc

# Add aliases you use frequently
# Reload configuration
source ~/.bashrc
```

**Red flags to watch for:**
- Typing same long commands daily
- Complex git commands every time
- Manual navigation to same directories
- Repeating multi-step processes
- Looking up command syntax frequently

---

### Mistake 9: Not Using Screen or Tmux for Long-Running Tasks

**What people do:**
Run long processes directly in SSH sessions without screen/tmux, losing work when connection drops.

**Why it's a problem:**
- Lost work when SSH disconnects
- Can't detach from running processes
- Can't access process from different location
- No way to recover disconnected sessions
- Wasted time restarting processes

**The right way:**
Use tmux or screen for remote work:

```bash
# Using tmux
tmux                    # Start new session
tmux new -s mysession   # Named session

# Inside tmux
Ctrl+b d                # Detach from session
# (Process continues running)

# Reconnect later
tmux attach             # Attach to last session
tmux attach -t mysession  # Attach to specific session
tmux ls                 # List sessions

# Split panes
Ctrl+b %                # Vertical split
Ctrl+b "                # Horizontal split
Ctrl+b arrow            # Navigate panes

# Using screen (alternative)
screen                  # Start screen
Ctrl+a d                # Detach
screen -r               # Reattach
screen -ls              # List sessions
```

**How to fix if you've already done this:**
Start using tmux:

```bash
# Install tmux
sudo apt install tmux   # Ubuntu
brew install tmux       # macOS

# Start using for long tasks
tmux new -s build
npm run build  # Long-running task
# Press Ctrl+b d to detach
# Close terminal, come back later
tmux attach -t build
```

**Red flags to watch for:**
- Lost work from dropped connections
- Can't close laptop during long tasks
- Restarting builds after disconnect
- Running multiple SSH windows
- Can't access running processes from different location

---

### Mistake 10: Not Understanding Process Management

**What people do:**
Don't know how to stop stuck processes, leave zombie processes, or don't understand background jobs.

**Why it's a problem:**
- Stuck processes consume resources
- Can't stop hung programs
- System slowdown from zombie processes
- Lost foreground terminal access
- Can't manage multiple tasks

**The right way:**
Manage processes effectively:

```bash
# View processes
ps aux              # All processes
ps aux | grep python  # Find specific process
top                 # Interactive process viewer
htop                # Better interactive viewer

# Background jobs
command &           # Run in background
Ctrl+Z              # Suspend current job
bg                  # Continue in background
fg                  # Bring to foreground
jobs                # List background jobs

# Kill processes
Ctrl+C              # Interrupt (SIGINT)
kill PID            # Terminate process (SIGTERM)
kill -9 PID         # Force kill (SIGKILL)
killall process_name  # Kill all matching
pkill -f pattern    # Kill by pattern

# Find and kill
ps aux | grep stuck_process
kill 12345          # Kill by PID

# Or one-liner
pkill -f "python app.py"
```

**How to fix if you've already done this:**
Clean up stuck processes:

```bash
# Find resource-heavy processes
top
# Press M to sort by memory
# Press P to sort by CPU
# Note PID of stuck process

# Kill stuck process
kill -9 PID

# Or find and kill
ps aux | grep -i stuck
kill $(ps aux | grep 'stuck_process' | awk '{print $2}')
```

**Red flags to watch for:**
- Can't close terminal due to running process
- Processes consuming 100% CPU
- Many zombie processes
- Terminal becomes unresponsive
- Don't know how to kill processes

---

### Mistake 11: Not Using Find and Grep Effectively

**What people do:**
Manually search through directories or use basic find/grep without understanding powerful options.

**Why it's a problem:**
- Wastes time manual searching
- Misses files or content
- Can't handle complex searches
- Inefficient file management
- Limited search capabilities

**The right way:**
Master find and grep:

```bash
# Find files by name
find . -name "*.js"
find . -iname "*.JS"        # Case insensitive
find . -name "test*"
find . -type f -name "*.log"  # Files only
find . -type d -name "node_modules"  # Directories only

# Find by size, time
find . -size +100M          # Larger than 100MB
find . -mtime -7            # Modified in last 7 days
find . -atime +30           # Accessed 30+ days ago

# Execute commands on found files
find . -name "*.tmp" -delete
find . -name "*.js" -exec wc -l {} \;

# Grep - search file contents
grep "error" file.txt
grep -r "TODO" .            # Recursive
grep -i "error" file.txt    # Case insensitive
grep -n "error" file.txt    # Show line numbers
grep -v "debug" file.txt    # Invert match

# Complex patterns
grep -E "error|warning" file.txt  # Multiple patterns
grep -A 3 "error" file.txt   # 3 lines after match
grep -B 3 "error" file.txt   # 3 lines before
grep -C 3 "error" file.txt   # 3 lines context

# Combine find and grep
find . -name "*.js" -exec grep -l "TODO" {} \;
```

**How to fix if you've already done this:**
Practice search commands:

```bash
# Common patterns
# Find large files
find . -type f -size +100M

# Find old logs
find /var/log -name "*.log" -mtime +30

# Search code for patterns
grep -r "api_key" --include="*.js" .

# Find and remove
find . -name "*.tmp" -type f -delete
```

**Red flags to watch for:**
- Manually searching directories
- Can't find files quickly
- Don't know where files are
- Missing files in searches
- Slow file location

---

### Mistake 12: Not Understanding Environment Variables

**What people do:**
Don't use or understand environment variables, hardcode paths and configuration.

**Why it's a problem:**
- Scripts break on different systems
- Can't configure without editing code
- Hardcoded credentials
- Inflexible automation
- Configuration management issues

**The right way:**
Use environment variables:

```bash
# View environment
env                 # All variables
echo $PATH          # Specific variable
echo $HOME
echo $USER

# Set temporarily
export API_KEY="my-key"
export NODE_ENV="production"

# Use in scripts
echo "User: $USER"
echo "Home: $HOME"

# Add to .bashrc for persistence
export PATH="$HOME/bin:$PATH"
export EDITOR="vim"
export LANG="en_US.UTF-8"

# In scripts
#!/bin/bash
DB_HOST=${DB_HOST:-localhost}  # Default value
DB_PORT=${DB_PORT:-5432}

# Use .env files
# .env
API_KEY=secret_key
DB_URL=postgres://localhost

# Load in scripts
source .env
# Or use dotenv tools
```

**How to fix if you've already done this:**
Migrate to environment variables:

```bash
# Before: Hardcoded
DB_HOST="localhost"

# After: Environment variable
DB_HOST=${DB_HOST:-localhost}

# Create .env file
cat > .env << EOF
API_KEY=your_key
DB_HOST=localhost
DB_PORT=5432
EOF

# Add to .gitignore
echo ".env" >> .gitignore
```

**Red flags to watch for:**
- Hardcoded paths in scripts
- Credentials in scripts
- Scripts work only on one machine
- No configuration flexibility
- Editing scripts for different environments

---

## Advanced Pitfalls

### Mistake 13: Not Using Bash Scripts for Automation

**What people do:**
Repeat manual command sequences instead of creating scripts.

**Why it's a problem:**
- Wastes time on repetitive tasks
- Prone to forgetting steps
- Errors in manual execution
- Can't share procedures easily
- No automation benefits

**The right way:**
Create bash scripts:

```bash
#!/bin/bash
# deploy.sh - Deployment script

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Variables
PROJECT_DIR="/var/www/myapp"
BACKUP_DIR="/var/backups"
DATE=$(date +%Y%m%d-%H%M%S)

# Functions
backup() {
    echo "Creating backup..."
    tar -czf "$BACKUP_DIR/backup-$DATE.tar.gz" "$PROJECT_DIR"
}

deploy() {
    echo "Deploying application..."
    cd "$PROJECT_DIR"
    git pull origin main
    npm install
    npm run build
    pm2 restart app
}

# Main script
echo "Starting deployment at $DATE"
backup
deploy
echo "Deployment complete!"
```

**How to fix if you've already done this:**
Create automation scripts:

```bash
# Identify repetitive tasks
# Create script
nano ~/bin/backup.sh

# Make executable
chmod +x ~/bin/backup.sh

# Add to PATH if needed
export PATH="$HOME/bin:$PATH"
```

**Red flags to watch for:**
- Typing same commands daily
- Forgetting steps in procedures
- Inconsistent task execution
- No documentation of processes
- Can't delegate tasks easily

---

### Mistake 14: Not Understanding Standard Streams

**What people do:**
Don't understand stdin, stdout, stderr, losing error messages or mixing output types.

**Why it's a problem:**
- Error messages get lost
- Can't separate errors from output
- Difficult debugging
- Logs mixed with errors
- Poor error handling

**The right way:**
Use streams correctly:

```bash
# Standard streams
# stdin  (0) - Input
# stdout (1) - Normal output
# stderr (2) - Error output

# Redirect stdout
command > output.txt        # Overwrite
command >> output.txt       # Append

# Redirect stderr
command 2> errors.txt
command 2>> errors.txt

# Redirect both
command > output.txt 2> errors.txt
command &> all.txt           # Both to same file
command > output.txt 2>&1    # Stderr to stdout

# Discard output
command > /dev/null          # Discard stdout
command 2> /dev/null         # Discard stderr
command &> /dev/null         # Discard both

# Practical examples
# Only errors to file
make 2> build-errors.log

# Separate logs
./app > app.log 2> app-errors.log

# Silent execution
command &> /dev/null
```

**How to fix if you've already done this:**
Fix output handling:

```bash
# Capture both streams properly
./script.sh > output.log 2> error.log

# Or combined
./script.sh &> combined.log

# In scripts, log to stderr
echo "Error occurred" >&2
```

**Red flags to watch for:**
- Lost error messages
- Can't find error output
- Logs mixed with normal output
- Difficult to debug issues
- Not capturing stderr

---

### Mistake 15: Not Using Job Control and Signals

**What people do:**
Don't understand signals (SIGTERM, SIGKILL), can't properly control jobs, or force kill everything.

**Why it's a problem:**
- Improper process shutdown
- Data corruption from force kills
- Can't gracefully stop services
- Don't understand process lifecycle
- Lost work from improper termination

**The right way:**
Understand signals and job control:

```bash
# Signals
kill -l             # List all signals
kill -TERM PID      # Graceful termination (default)
kill -KILL PID      # Force kill (last resort)
kill -HUP PID       # Reload configuration

# Job control
command &           # Background
Ctrl+Z              # Suspend (SIGTSTP)
bg %1               # Resume in background
fg %1               # Resume in foreground
jobs                # List jobs
disown %1           # Detach from shell

# Proper shutdown sequence
kill -TERM PID      # Try graceful
sleep 5
kill -KILL PID      # Force if needed

# Trap signals in scripts
#!/bin/bash
cleanup() {
    echo "Cleaning up..."
    rm -f /tmp/lockfile
}
trap cleanup EXIT
trap cleanup SIGTERM SIGINT
```

**How to fix if you've already done this:**
Use proper signals:

```bash
# Instead of always using -9
kill -9 PID         # ❌ Force kill immediately

# Try graceful first
kill PID            # ✅ SIGTERM - graceful
# Wait a few seconds
# If still running:
kill -9 PID         # Force if needed
```

**Red flags to watch for:**
- Always using `kill -9`
- Corrupted data after kills
- Services don't shutdown cleanly
- Lost unsaved work
- Don't understand signal differences

---

## Prevention Checklist

### Daily Usage

- [ ] Use tab completion for paths and commands
- [ ] Navigate with absolute/relative paths efficiently
- [ ] Use command history (Ctrl+R, up arrow)
- [ ] Check commands with --help before running
- [ ] Use sudo only when necessary
- [ ] Verify current directory with pwd

### File Management

- [ ] Check permissions with ls -la
- [ ] Set appropriate permissions (644 files, 755 scripts)
- [ ] Use find for locating files
- [ ] Use grep for searching content
- [ ] Understand file ownership
- [ ] Keep home directory organized

### Process Management

- [ ] Use tmux/screen for long-running tasks
- [ ] Understand background jobs
- [ ] Know how to kill processes properly
- [ ] Monitor resource usage with top/htop
- [ ] Handle signals appropriately
- [ ] Clean up finished processes

### Automation

- [ ] Create aliases for common commands
- [ ] Write scripts for repetitive tasks
- [ ] Use environment variables for configuration
- [ ] Version control your scripts
- [ ] Document your automation
- [ ] Test scripts before deploying

### Safety

- [ ] Understand commands before running
- [ ] Test dangerous commands on safe data first
- [ ] Backup before major operations
- [ ] Use version control for important files
- [ ] Don't run random internet scripts blindly
- [ ] Keep configuration files backed up
