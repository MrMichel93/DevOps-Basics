# Command Line Troubleshooting Guide

## Issue Categories

### Command Not Found

**Symptoms:**

- "command not found" error
- Shell can't find executable
- Command works for others but not for you

**Diagnostic Steps:**

1. **Verify command exists**
   ```bash
   which command-name
   whereis command-name
   type command-name
   ```

2. **Check PATH**
   ```bash
   echo $PATH
   ```

3. **Check spelling**
   ```bash
   # Common typos:
   # "pytohn" → "python"
   # "ngnix" → "nginx"
   # "DockerFile" → "Dockerfile"
   ```

**Common Causes & Solutions:**

#### Cause 1: Command not installed

**Solution:**

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install <package-name>

# CentOS/RHEL
sudo yum install <package-name>

# macOS
brew install <package-name>

# Find which package provides a command
apt-cache search <command-name>
yum search <command-name>
```

#### Cause 2: Command not in PATH

**Solution:**

```bash
# Check current PATH
echo $PATH

# Find where command is installed
find / -name command-name 2>/dev/null

# Add directory to PATH temporarily
export PATH=$PATH:/path/to/directory

# Add permanently to ~/.bashrc or ~/.zshrc
echo 'export PATH=$PATH:/path/to/directory' >> ~/.bashrc
source ~/.bashrc

# Or use absolute path
/usr/local/bin/command-name
```

#### Cause 3: Shell doesn't recognize command

**Solution:**

```bash
# Reload shell configuration
source ~/.bashrc
source ~/.zshrc

# Or hash -r to forget remembered paths
hash -r

# Or start new shell session
exec bash
exec zsh
```

---

### Permission Denied

**Symptoms:**

- "Permission denied" error
- Cannot execute script
- Cannot access file/directory
- Cannot write to file

**Diagnostic Steps:**

1. **Check file permissions**
   ```bash
   ls -la file.txt
   ls -ld directory/
   ```

2. **Check ownership**
   ```bash
   ls -la file.txt
   # Shows: owner group
   ```

3. **Identify your user**
   ```bash
   whoami
   id
   groups
   ```

**Common Causes & Solutions:**

#### Cause 1: File not executable

**Error:**
```
bash: ./script.sh: Permission denied
```

**Solution:**

```bash
# Check permissions
ls -la script.sh
# Shows: -rw-r--r--  (not executable)

# Make executable
chmod +x script.sh

# Now shows: -rwxr-xr-x
# Now you can run: ./script.sh
```

#### Cause 2: No read/write permission

**Solution:**

```bash
# Give yourself read permission
chmod u+r file.txt

# Give yourself write permission
chmod u+w file.txt

# Give everyone read permission
chmod a+r file.txt

# Set specific permissions
chmod 755 script.sh    # rwxr-xr-x
chmod 644 file.txt     # rw-r--r--
chmod 600 private.key  # rw-------
```

#### Cause 3: Wrong ownership

**Solution:**

```bash
# Change owner
sudo chown username file.txt

# Change owner and group
sudo chown username:groupname file.txt

# Recursively change ownership
sudo chown -R username:groupname directory/

# Change group only
sudo chgrp groupname file.txt
```

#### Cause 4: Need root privileges

**Solution:**

```bash
# Use sudo for commands requiring root
sudo systemctl restart nginx
sudo apt-get update

# Or switch to root (not recommended)
sudo su -
# Do your work
exit  # Return to normal user
```

---

### Script Errors

**Symptoms:**

- Script exits with error
- Syntax errors
- Unexpected behavior
- Variables not working

**Diagnostic Steps:**

1. **Run with bash -x for debugging**
   ```bash
   bash -x script.sh
   ```

2. **Check syntax**
   ```bash
   bash -n script.sh  # Check syntax without running
   ```

3. **Check shebang line**
   ```bash
   head -1 script.sh
   # Should be: #!/bin/bash or #!/usr/bin/env bash
   ```

**Common Causes & Solutions:**

#### Cause 1: Syntax errors

**Error:**
```
script.sh: line 10: syntax error near unexpected token `fi'
```

**Solution:**

```bash
# Common mistakes:

# 1. Missing 'then' in if statement
if [ $x -eq 1 ]; then  # Need 'then'
  echo "x is 1"
fi

# 2. Missing 'do' in loops
for i in 1 2 3; do     # Need 'do'
  echo $i
done

# 3. Missing closing quotes
echo "Hello World"     # Must close quotes

# 4. Spaces in variable assignment
x=5                    # Correct
x = 5                  # Wrong! No spaces

# 5. Missing spaces in conditionals
if [ $x -eq 1 ]; then  # Need spaces inside [ ]
# Not: if [$x -eq 1]; then
```

#### Cause 2: Variable not set

**Error:**
```
script.sh: line 5: $1: unbound variable
```

**Solution:**

```bash
# Check if variable is set
if [ -z "$VAR" ]; then
  echo "VAR is not set"
  exit 1
fi

# Provide default value
NAME=${1:-"default_name"}

# Make script fail on unset variables
set -u  # At top of script

# Example:
#!/bin/bash
set -u  # Fail on unset variables
set -e  # Fail on any error

name=${1:-"World"}
echo "Hello, $name!"
```

#### Cause 3: Line ending issues (Windows vs Unix)

**Error:**
```
bash: ./script.sh: /bin/bash^M: bad interpreter
```

**Solution:**

```bash
# Convert Windows (CRLF) to Unix (LF)
dos2unix script.sh

# Or with sed
sed -i 's/\r$//' script.sh

# Or in vim
vim script.sh
:set ff=unix
:wq

# Check line endings
file script.sh
# Should show: ASCII text
# Not: ASCII text, with CRLF line terminators
```

#### Cause 4: Script not finding commands

**Solution:**

```bash
# Use absolute paths in scripts
/usr/bin/python3 script.py  # Not just: python3

# Or set PATH in script
#!/bin/bash
export PATH=/usr/local/bin:/usr/bin:/bin

# Check if command exists before using
if ! command -v docker &> /dev/null; then
  echo "Docker not found"
  exit 1
fi
```

---

### File and Directory Issues

**Symptoms:**

- "No such file or directory"
- Cannot cd into directory
- Cannot create/delete files
- Unexpected file contents

**Diagnostic Steps:**

1. **Verify existence**
   ```bash
   ls -la /path/to/file
   stat /path/to/file
   ```

2. **Check current directory**
   ```bash
   pwd
   ```

3. **Check disk space**
   ```bash
   df -h
   ```

**Common Causes & Solutions:**

#### Cause 1: Wrong path

**Solution:**

```bash
# Use tab completion to avoid typos
cd /usr/loc[TAB]  # Completes to /usr/local/

# Check current directory
pwd

# Use absolute paths
/home/user/script.sh     # Absolute
./script.sh              # Relative (current dir)
../script.sh             # Relative (parent dir)

# Find file
find / -name "filename" 2>/dev/null
locate filename  # If updatedb has been run
```

#### Cause 2: Hidden files

**Solution:**

```bash
# Show hidden files (starting with .)
ls -la

# Hidden file example: .env, .gitignore, .config/
```

#### Cause 3: Special characters in filename

**Solution:**

```bash
# Escape spaces
cd "My Documents"
cd My\ Documents

# Files with dashes
rm -- -filename  # The -- says "no more options"

# Files with special chars
rm "file with spaces & symbols.txt"

# Delete file starting with -
rm ./-filename
```

#### Cause 4: Disk full

**Error:**
```
No space left on device
```

**Solution:**

```bash
# Check disk usage
df -h

# Find large files
du -sh /* | sort -rh | head -10
du -sh /var/* | sort -rh | head -10

# Clean up
sudo apt-get clean       # Clean package cache
docker system prune -a   # Clean Docker
sudo journalctl --vacuum-time=7d  # Clean logs

# Delete old files
find /tmp -type f -atime +7 -delete
```

---

### Process Management Issues

**Symptoms:**

- Cannot kill process
- Process won't stop
- Too many processes
- Background job issues

**Diagnostic Steps:**

1. **List processes**
   ```bash
   ps aux
   ps aux | grep process-name
   top
   htop
   ```

2. **Check process tree**
   ```bash
   pstree
   ps -ef --forest
   ```

**Common Causes & Solutions:**

#### Cause 1: Process won't die with normal kill

**Solution:**

```bash
# Try gentle kill first
kill PID

# If that doesn't work, force kill
kill -9 PID

# Or by name
pkill process-name
pkill -9 process-name

# Kill all processes of a user
sudo pkill -u username

# Find and kill
ps aux | grep python
kill $(pgrep python)
```

#### Cause 2: Background process lost

**Solution:**

```bash
# List background jobs in current shell
jobs

# Bring to foreground
fg %1  # Job number from jobs command

# Send to background
Ctrl+Z  # Suspend current job
bg %1   # Continue in background

# Run command in background from start
command &

# Run and detach from terminal
nohup command &
```

#### Cause 3: Zombie processes

**What it means:**
Processes that have finished but not been cleaned up.

**Solution:**

```bash
# Find zombies
ps aux | grep 'Z'

# Usually killing parent process cleans them up
# Find parent PID
ps -o ppid= -p ZOMBIE_PID

# Kill parent
kill -9 PARENT_PID

# If many zombies, may need to reboot
```

---

### Input/Output Redirection Issues

**Symptoms:**

- Output not saved to file
- Error messages not captured
- Pipes not working
- Append vs overwrite confusion

**Common Causes & Solutions:**

#### Cause 1: Overwrote file accidentally

**Problem:**
```bash
cat file.txt > file.txt  # This empties the file!
```

**Solution:**

```bash
# Use temporary file
cat file.txt > temp.txt && mv temp.txt file.txt

# Or use sponge (from moreutils)
cat file.txt | grep pattern | sponge file.txt
```

**Prevention:**
```bash
# Append instead of overwrite
echo "new line" >> file.txt  # Append
echo "new line" > file.txt   # Overwrite

# Use -i with tools that support it
sed -i 's/old/new/g' file.txt  # Edit in place
```

#### Cause 2: Not capturing stderr

**Problem:**
Error messages not in output file.

**Solution:**

```bash
# Redirect both stdout and stderr
command > output.txt 2>&1

# Or modern syntax
command &> output.txt

# Redirect stderr to file, stdout to terminal
command 2> errors.txt

# Discard output
command > /dev/null 2>&1
```

#### Cause 3: Pipe not working as expected

**Solution:**

```bash
# Some programs don't read from stdin
# Use xargs to convert stdin to arguments
find . -name "*.txt" | xargs grep "pattern"

# Or with -print0 and -0 for files with spaces
find . -name "*.txt" -print0 | xargs -0 grep "pattern"

# Use process substitution
diff <(sort file1.txt) <(sort file2.txt)
```

---

### Environment Variable Issues

**Symptoms:**

- Variables not set
- PATH not working
- Changes not persisting

**Common Causes & Solutions:**

#### Cause 1: Variable not exported

**Problem:**
Variable set but not available to child processes.

**Solution:**

```bash
# This works only in current shell
VAR="value"

# This exports to child processes
export VAR="value"

# Or in two steps
VAR="value"
export VAR

# Check if exported
env | grep VAR
printenv VAR
```

#### Cause 2: Changes don't persist

**Solution:**

```bash
# Add to appropriate config file:

# For bash (all sessions)
echo 'export PATH=$PATH:/new/path' >> ~/.bashrc

# For bash (login shells)
echo 'export PATH=$PATH:/new/path' >> ~/.bash_profile

# For zsh
echo 'export PATH=$PATH:/new/path' >> ~/.zshrc

# For all users (requires root)
echo 'export PATH=$PATH:/new/path' | sudo tee -a /etc/environment

# Reload configuration
source ~/.bashrc
```

#### Cause 3: Variable has spaces or special chars

**Solution:**

```bash
# Always quote variable values
VAR="value with spaces"
export VAR

# Use variables in quotes
echo "$VAR"          # Good
echo $VAR            # Can break with spaces

# Example:
FILE="my document.txt"
cat "$FILE"          # Works
cat $FILE            # Tries to cat "my" and "document.txt"
```

---

## Quick Reference

### Essential Commands

```bash
# File operations
ls -la               # List all files with details
cd /path             # Change directory
pwd                  # Print working directory
cp source dest       # Copy
mv old new           # Move/rename
rm file              # Remove file
rm -rf dir/          # Remove directory and contents
mkdir dir            # Create directory
touch file           # Create empty file

# Viewing files
cat file             # View entire file
less file            # Page through file
head file            # First 10 lines
tail file            # Last 10 lines
tail -f file         # Follow file (live updates)

# Searching
grep pattern file    # Search in file
grep -r pattern dir/ # Search recursively
find / -name file    # Find file by name

# Permissions
chmod +x file        # Make executable
chmod 755 file       # Set specific permissions
chown user:group file # Change ownership

# Process management
ps aux               # List all processes
top                  # Interactive process viewer
kill PID             # Stop process
kill -9 PID          # Force stop

# System info
df -h                # Disk usage
free -h              # Memory usage
uname -a             # System information
```

### Debugging Commands

```bash
# Run with tracing
bash -x script.sh    # Trace execution
set -x               # Enable tracing in script

# Check syntax
bash -n script.sh    # Check without running

# Useful flags
set -e               # Exit on error
set -u               # Error on unset variable
set -o pipefail      # Fail if any pipe command fails

# Debug info
echo $?              # Last command's exit code
echo $PATH           # Current PATH
env                  # All environment variables
```

## Prevention Tips

1. **Always use quotes**
   ```bash
   rm "$file"         # Safe
   rm $file           # Dangerous with spaces
   ```

2. **Check before destructive operations**
   ```bash
   # Dry run
   rm -i file         # Ask before removing
   
   # Preview
   ls file            # Verify exists
   ```

3. **Use absolute paths in scripts**
   ```bash
   /usr/bin/python3   # Reliable
   python3            # May not be found
   ```

4. **Add error handling**
   ```bash
   #!/bin/bash
   set -euo pipefail  # Fail fast
   
   if [ ! -f "file.txt" ]; then
     echo "File not found"
     exit 1
   fi
   ```

5. **Test scripts in safe environment first**
   ```bash
   # Use test directory
   mkdir test
   cd test
   # Run script here first
   ```

## When to Ask for Help

If you've tried these steps and still stuck:

1. Check man pages: `man command`
2. Use --help flag: `command --help`
3. Search error message online
4. Ask on Stack Overflow
5. Check command's documentation

When asking, provide:
- Exact command you ran
- Complete error message
- Your OS and shell version
- What you've already tried
- Output of relevant diagnostic commands
