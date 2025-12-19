# Module 02: Command-Line Mastery - Diagrams

This document contains visual diagrams to help understand Linux file systems, processes, and command-line operations.

## 1. Linux File System Hierarchy

This tree diagram shows the standard Linux directory structure:

```text
/
├── bin/            # Essential command binaries
├── boot/           # Boot loader files
├── dev/            # Device files
├── etc/            # Configuration files
│   ├── apache2/
│   ├── ssh/
│   └── systemd/
├── home/           # User home directories
│   ├── user1/
│   ├── user2/
│   └── user3/
├── lib/            # Shared libraries
├── media/          # Removable media mount points
├── mnt/            # Temporary mount points
├── opt/            # Optional application software
├── proc/           # Process and kernel information
├── root/           # Root user home directory
├── run/            # Runtime data
├── sbin/           # System binaries
├── srv/            # Service data
├── sys/            # System information
├── tmp/            # Temporary files
├── usr/            # User programs
│   ├── bin/
│   ├── lib/
│   ├── local/
│   └── share/
└── var/            # Variable data
    ├── cache/
    ├── log/
    ├── mail/
    └── www/
```

**Important Directories:**

- `/bin` and `/usr/bin` - Executable programs and commands
- `/etc` - System-wide configuration files
- `/home` - User home directories containing personal files
- `/var/log` - System and application log files
- `/tmp` - Temporary files (cleared on reboot)
- `/opt` - Third-party application installations

## 2. Process Hierarchy

This diagram shows parent-child relationships between processes:

```text
        PID 1
      ┌──────┐
      │ init/│
      │systemd│
      └──┬───┘
         │
    ┌────┴────┬────────────┬──────────┐
    │         │            │          │
┌───▼──┐  ┌───▼──┐    ┌────▼───┐  ┌──▼───┐
│ ssh  │  │cron  │    │ login  │  │apache│
│daemon│  │daemon│    │        │  │      │
└──────┘  └──────┘    └────┬───┘  └──┬───┘
                           │         │
                      ┌────▼───┐     │
                      │ bash   │     │
                      │(shell) │     │
                      └────┬───┘     │
                           │         │
                      ┌────┴───┐     │
                      │        │     │
                  ┌───▼──┐ ┌───▼──┐  │
                  │ vim  │ │  ls  │  │
                  └──────┘ └──────┘  │
                                     │
                           ┌─────────┴────┐
                           │              │
                       ┌───▼───┐      ┌───▼───┐
                       │worker1│      │worker2│
                       └───────┘      └───────┘
```

**Process Concepts:**

- **PID (Process ID)**: Unique identifier for each process
- **PPID (Parent Process ID)**: ID of the process that started this one
- **init/systemd**: The first process started by the kernel (PID 1)
- **Child Process**: Process created by another process
- **Daemon**: Background process that runs continuously

**Useful Commands:**

- `ps aux` - List all running processes
- `pstree` - Display process tree
- `top` or `htop` - Interactive process viewer
- `kill <PID>` - Terminate a process
- `pgrep <name>` - Find process ID by name

## 3. Pipe and Redirect Flow

This diagram shows how data flows between commands and files:

```text
┌──────────┐
│ command1 │
└─────┬────┘
      │
      │ stdout (standard output)
      │
      ├──────────────────┬─────────────────────────┐
      │                  │                         │
      │            (pipe │)                  (redirect >)
      │                  │                         │
      │           ┌──────▼──────┐           ┌──────▼──────┐
      │           │  command2   │           │  output.txt │
      │           └──────┬──────┘           └─────────────┘
      │                  │
      │                  │ stdout
      │                  │
      │           (redirect >>)
      │                  │
      │           ┌──────▼──────┐
      │           │   file2.txt │
      │           │  (append)   │
      │           └─────────────┘
      │
stderr  │
      │
(redirect 2>)
      │
┌─────▼────────┐
│  error.log   │
└──────────────┘
```

**Common Operations:**

1. **Pipe (|)**: Connect output of one command to input of another
   - `ls -l | grep ".txt"`

2. **Redirect Output (>)**: Save output to a file (overwrites)
   - `echo "Hello" > file.txt`

3. **Append Output (>>)**: Add output to end of file
   - `echo "World" >> file.txt`

4. **Redirect Error (2>)**: Save error messages to a file
   - `command 2> errors.log`

5. **Redirect Both (2>&1)**: Combine stdout and stderr
   - `command > output.log 2>&1`

**Example Combinations:**

```text
# Count lines in all .txt files
cat *.txt | wc -l

# Find and save errors
grep "ERROR" app.log | sort | uniq > errors.txt

# Search with multiple filters
ps aux | grep nginx | grep -v grep > nginx_processes.txt

# Save both output and errors
./script.sh > output.log 2>&1
```

## 4. Shell Script Execution Flow

This flowchart shows how a shell script is processed and executed:

```text
┌─────────────┐
│   Start     │
│  Execute    │
│   Script    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Shell     │
│   Reads     │
│   Script    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Parse     │
│  Syntax     │
└──────┬──────┘
       │
  ┌────▼────┐
  │ Valid?  │
  └────┬────┘
       │
  ┌────┴────┐
  │         │
┌─▼──┐  ┌───▼────┐
│Yes │  │   No   │
└─┬──┘  └───┬────┘
  │         │
  │    ┌────▼──────┐
  │    │   Show    │
  │    │  Syntax   │
  │    │   Error   │
  │    └────┬──────┘
  │         │
  │    ┌────▼──────┐
  │    │   Exit    │
  │    └───────────┘
  │
  ▼
┌─────────────┐
│  Expand     │
│ Variables   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Execute    │
│  Command 1  │
└──────┬──────┘
       │
  ┌────▼────┐
  │Success? │
  └────┬────┘
       │
  ┌────┴────┐
  │         │
┌─▼──┐  ┌───▼────┐
│Yes │  │   No   │
└─┬──┘  └───┬────┘
  │         │
  │    ┌────▼──────┐
  │    │  Check    │
  │    │set -e flag│
  │    └────┬──────┘
  │         │
  │    ┌────┴────┐
  │    │         │
  │ ┌──▼──┐  ┌───▼───┐
  │ │ Set │  │Not Set│
  │ └──┬──┘  └───┬───┘
  │    │         │
  │ ┌──▼────┐    │
  │ │ Exit  │    │
  │ └───────┘    │
  │              │
  └──────┬───────┘
         │
         ▼
┌─────────────┐
│  Execute    │
│  Command 2  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│     ...     │
│  Continue   │
│   Until     │
│     End     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Generate   │
│   Output    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    Exit     │
│    with     │
│ Exit Code   │
└─────────────┘
```

**Exit Codes:**

- `0` - Success
- `1` - General error
- `2` - Misuse of command
- `126` - Command cannot execute
- `127` - Command not found
- `130` - Script terminated by Ctrl+C

**Script Best Practices:**

- Use `#!/bin/bash` shebang at the start
- Set `set -e` to exit on errors
- Use `set -u` to exit on undefined variables
- Add comments to explain complex logic
- Validate input parameters
- Handle errors gracefully
- Use meaningful variable names
