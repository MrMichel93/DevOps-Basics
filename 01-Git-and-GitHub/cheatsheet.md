# Git Command Cheatsheet

Quick reference for common Git commands. Bookmark this page!

## 🚀 Setup & Configuration

```bash
# Set your identity
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Check configuration
git config --list

# Set default editor
git config --global core.editor "code --wait"

# Set default branch name
git config --global init.defaultBranch main

# Enable color output
git config --global color.ui auto
```

## 📁 Creating Repositories

```bash
# Initialize new repository
git init

# Clone existing repository
git clone https://github.com/user/repo.git

# Clone to specific directory
git clone https://github.com/user/repo.git my-folder

# Clone specific branch
git clone -b branch-name https://github.com/user/repo.git
```

## 📊 Basic Workflow

```bash
# Check status
git status

# Stage files
git add file.txt                # Stage specific file
git add .                       # Stage all files
git add *.js                    # Stage all .js files
git add src/                    # Stage directory

# Commit changes
git commit -m "Commit message"
git commit -am "Stage and commit tracked files"
git commit --amend              # Modify last commit

# View history
git log                         # Full log
git log --oneline               # Condensed log
git log --graph --all           # Visual graph
git log -p                      # Show diffs
git log --author="Name"         # Filter by author
git log --since="2 weeks ago"   # Filter by date
```

## 🌿 Branching

```bash
# List branches
git branch                      # Local branches
git branch -a                   # All branches
git branch -r                   # Remote branches

# Create branch
git branch branch-name
git checkout -b branch-name     # Create and switch
git switch -c branch-name       # Modern alternative

# Switch branches
git checkout branch-name
git switch branch-name          # Modern alternative
git checkout -                  # Previous branch

# Delete branch
git branch -d branch-name       # Safe delete
git branch -D branch-name       # Force delete
git push origin --delete branch-name  # Delete remote

# Rename branch
git branch -m old-name new-name
```

## 🔀 Merging

```bash
# Merge branch
git checkout main
git merge branch-name

# Merge with no fast-forward
git merge --no-ff branch-name

# Abort merge
git merge --abort

# View merge conflicts
git diff
git diff --name-only --diff-filter=U

# Resolve conflicts
# Edit files, then:
git add .
git commit
```

## 🔄 Remote Repositories

```bash
# List remotes
git remote -v

# Add remote
git remote add origin https://github.com/user/repo.git

# Change remote URL
git remote set-url origin https://github.com/user/repo.git

# Remove remote
git remote remove origin

# Fetch changes
git fetch origin
git fetch --all

# Pull changes
git pull                        # Fetch and merge
git pull --rebase              # Fetch and rebase

# Push changes
git push origin main
git push -u origin main        # Set upstream
git push --all                 # Push all branches
git push --tags                # Push tags
git push --force               # Force push (dangerous!)
```

## ↩️ Undoing Changes

```bash
# Discard changes in working directory
git checkout -- file.txt
git restore file.txt           # Modern alternative

# Unstage files
git reset HEAD file.txt
git restore --staged file.txt  # Modern alternative

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Revert commit (creates new commit)
git revert commit-hash

# Clean untracked files
git clean -n                   # Dry run
git clean -f                   # Remove files
git clean -fd                  # Remove files and directories
```

## 🔍 Viewing Changes

```bash
# View unstaged changes
git diff

# View staged changes
git diff --staged
git diff --cached

# View changes in specific file
git diff file.txt

# View changes between branches
git diff main..feature-branch

# View changes between commits
git diff commit1 commit2

# Show commit details
git show commit-hash

# Show who changed what
git blame file.txt
```

## 🏷️ Tags

```bash
# List tags
git tag

# Create lightweight tag
git tag v1.0.0

# Create annotated tag
git tag -a v1.0.0 -m "Version 1.0.0"

# Tag specific commit
git tag v1.0.0 commit-hash

# Push tags
git push origin v1.0.0         # Push specific tag
git push origin --tags         # Push all tags

# Delete tag
git tag -d v1.0.0              # Delete local
git push origin --delete v1.0.0  # Delete remote

# Checkout tag
git checkout v1.0.0
```

## 💾 Stashing

```bash
# Stash changes
git stash
git stash save "Work in progress"

# List stashes
git stash list

# Apply stash
git stash apply                # Keep stash
git stash pop                  # Apply and remove

# Apply specific stash
git stash apply stash@{0}

# Delete stash
git stash drop stash@{0}

# Clear all stashes
git stash clear

# Stash including untracked files
git stash -u
```

## 🔄 Rebasing

```bash
# Rebase current branch onto main
git rebase main

# Interactive rebase (last 3 commits)
git rebase -i HEAD~3

# Continue after resolving conflicts
git rebase --continue

# Skip current commit
git rebase --skip

# Abort rebase
git rebase --abort

# Rebase and preserve merges
git rebase -p main
```

## 🍒 Cherry-Picking

```bash
# Apply specific commit
git cherry-pick commit-hash

# Apply multiple commits
git cherry-pick commit1 commit2

# Cherry-pick without committing
git cherry-pick -n commit-hash

# Abort cherry-pick
git cherry-pick --abort
```

## 🔍 Searching

```bash
# Search for text in files
git grep "search term"

# Search in specific branch
git grep "search term" branch-name

# Search with line numbers
git grep -n "search term"

# Search for word
git grep -w "word"

# Find commits that changed a specific line
git log -S "search term" --source --all
```

## 📋 History & Information

```bash
# View commit history
git log --oneline --graph --all --decorate

# View file history
git log --follow file.txt

# View changes in commit
git show commit-hash

# View branch history
git log main..feature-branch

# View reflog (recovery)
git reflog

# Statistics
git shortlog -sn                # Commit count by author
git log --since="1 month ago"
```

## 🔧 Advanced

```bash
# Create patch
git format-patch -1 commit-hash

# Apply patch
git apply patch-file.patch

# Archive repository
git archive --format=zip HEAD > archive.zip

# Count commits
git rev-list --count HEAD

# Find common ancestor
git merge-base branch1 branch2

# Bisect (binary search for bugs)
git bisect start
git bisect bad
git bisect good commit-hash

# Submodules
git submodule add https://github.com/user/repo.git
git submodule update --init --recursive
```

## 🚨 Emergency Commands

```bash
# Undo last push (if no one pulled)
git push --force-with-lease

# Recover deleted branch
git reflog
git checkout -b branch-name commit-hash

# Recover lost commits
git reflog
git cherry-pick commit-hash

# Remove file from history
git filter-branch --tree-filter 'rm -f passwords.txt' HEAD

# Reset to remote state
git fetch origin
git reset --hard origin/main
```

## 🎯 Common Workflows

### Daily Development

```bash
git pull                       # Get latest changes
# ... make changes ...
git add .
git commit -m "Description"
git push
```

### Feature Branch

```bash
git checkout main
git pull
git checkout -b feature-name
# ... develop feature ...
git add .
git commit -m "feat: Description"
git push -u origin feature-name
# Create PR on GitHub
```

### Fixing Mistakes

```bash
# Wrong commit message
git commit --amend -m "Correct message"

# Forgot to add file
git add forgotten-file.txt
git commit --amend --no-edit

# Committed to wrong branch
git reset HEAD~1                # Undo commit
git stash                       # Save changes
git checkout correct-branch
git stash pop
git add .
git commit -m "Message"
```

### Update Fork

```bash
git remote add upstream https://github.com/original/repo.git
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

## 📖 Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

**Types:** feat, fix, docs, style, refactor, test, chore

**Example:**
```
feat: Add user authentication

Implemented JWT-based authentication system.
Users can now register and login.

Closes #123
```

## 🚫 .gitignore Patterns

```gitignore
# Files
*.log
secret.txt

# Directories
node_modules/
dist/

# Patterns
**/.DS_Store
**/temp/*

# Exceptions
!important.log

# Root only
/config.json
```

## 🔑 SSH Setup

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your@email.com"

# Start ssh-agent
eval "$(ssh-agent -s)"

# Add key
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub
# Add to GitHub: Settings → SSH Keys

# Test connection
ssh -T git@github.com
```

## ⚙️ Aliases

Add to `~/.gitconfig`:

```ini
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = log --oneline --graph --all --decorate
    amend = commit --amend --no-edit
    undo = reset HEAD~1
```

Usage:
```bash
git st      # Instead of git status
git visual  # Pretty log
git undo    # Undo last commit
```

## 💡 Pro Tips

1. **Use `git status` constantly** - Know what state you're in
2. **Commit often** - Small, focused commits are easier to manage
3. **Write good messages** - Your future self will thank you
4. **Branch for everything** - Keep main branch clean
5. **Pull before push** - Avoid conflicts
6. **Review before committing** - Use `git diff`
7. **Learn to undo** - Mistakes happen, know how to fix them
8. **Use .gitignore** - Don't commit unnecessary files

## 🆘 Getting Help

```bash
# Command help
git help <command>
git <command> --help

# Quick reference
git <command> -h

# Example
git help commit
git commit -h
```

## 📚 Resources

- [Official Git Documentation](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com/)
- [Git Flight Rules](https://github.com/k88hudson/git-flight-rules)
- [Oh Shit, Git!?!](https://ohshitgit.com/)

---

**Print this page or save it for quick reference!**

[Back to Module 01](./README.md)
