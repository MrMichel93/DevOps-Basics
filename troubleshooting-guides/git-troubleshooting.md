# Git Troubleshooting Guide

## Issue Categories

### Cannot Push to Remote

**Symptoms:**

- Push rejected with error message
- Permission denied errors
- Authentication failures

**Diagnostic Steps:**

1. **Check remote URL**
   ```bash
   git remote -v
   ```

2. **Verify authentication**
   ```bash
   git config --list | grep user
   ssh -T git@github.com  # For SSH
   ```

3. **Check branch status**
   ```bash
   git status
   git log --oneline -5
   ```

**Common Causes & Solutions:**

#### Cause 1: Remote has changes you don't have

**Error message:**
```
! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'origin'
hint: Updates were rejected because the remote contains work that you do not have locally
```

**Solution:**

1. Fetch and merge:
```bash
git fetch origin
git merge origin/main
# Or pull (fetch + merge)
git pull origin main
```

2. Then push:
```bash
git push origin main
```

If conflicts occur during merge, resolve them before pushing.

#### Cause 2: Authentication failure

**Error message:**
```
remote: Permission to user/repo.git denied
fatal: unable to access 'https://github.com/user/repo.git/': The requested URL returned error: 403
```

**Solution:**

For HTTPS:
```bash
# Update credentials
git config --global credential.helper store
git push  # Will prompt for credentials

# Or use personal access token (GitHub)
# Username: your-username
# Password: ghp_yourPersonalAccessToken
```

For SSH:
```bash
# Check SSH key
ssh-add -l

# Add SSH key if needed
ssh-add ~/.ssh/id_rsa

# Test SSH connection
ssh -T git@github.com
```

#### Cause 3: Protected branch

**Error message:**
```
remote: error: GH006: Protected branch update failed
```

**Solution:**

1. Check branch protection rules in GitHub/GitLab
2. Create pull request instead of direct push
3. Or push to a different branch:
```bash
git checkout -b feature/my-changes
git push origin feature/my-changes
```

#### Cause 4: Wrong remote URL

**Solution:**

```bash
# Check current remote
git remote -v

# Update remote URL
git remote set-url origin git@github.com:user/repo.git

# Or for HTTPS
git remote set-url origin https://github.com/user/repo.git
```

---

### Merge Conflicts

**Symptoms:**

- "CONFLICT" messages during merge/pull
- Files marked with conflict markers
- Cannot complete merge

**Diagnostic Steps:**

1. **List conflicted files**
   ```bash
   git status
   git diff --name-only --diff-filter=U
   ```

2. **View conflict details**
   ```bash
   git diff
   ```

**Common Causes & Solutions:**

#### Understanding conflict markers

```
<<<<<<< HEAD
Your changes
=======
Their changes (incoming)
>>>>>>> branch-name
```

**Solution:**

1. **Manually resolve conflicts**
   ```bash
   # Edit files to resolve conflicts
   # Remove conflict markers
   # Keep the code you want
   
   # Example: resolve to keep both changes
   Your changes
   Their changes
   
   # Mark as resolved
   git add conflicted-file.js
   ```

2. **Use merge tool**
   ```bash
   git mergetool
   # Opens configured merge tool (vimdiff, meld, etc.)
   ```

3. **Abort merge if needed**
   ```bash
   git merge --abort
   # Or for rebase
   git rebase --abort
   ```

4. **Complete merge**
   ```bash
   git add .
   git commit  # Or git rebase --continue
   ```

#### Prefer one side entirely

```bash
# Keep all of your changes
git checkout --ours conflicted-file.js
git add conflicted-file.js

# Keep all of their changes
git checkout --theirs conflicted-file.js
git add conflicted-file.js
```

---

### Committed to Wrong Branch

**Symptoms:**

- Changes on wrong branch
- Want to move commits to different branch
- Made commits before creating feature branch

**Diagnostic Steps:**

```bash
git log --oneline -5
git branch
```

**Common Causes & Solutions:**

#### Cause 1: Commits on main instead of feature branch

**Solution - Move uncommitted changes:**
```bash
# If not yet committed
git stash
git checkout -b feature/correct-branch
git stash pop
git add .
git commit -m "Your message"
```

**Solution - Move recent commit:**
```bash
# Move last commit to new branch
git branch feature/correct-branch  # Create branch at current position
git reset --hard HEAD~1           # Move current branch back 1 commit
git checkout feature/correct-branch
```

**Solution - Move multiple commits:**
```bash
# Create new branch from current position
git branch feature/correct-branch

# Reset main to where it should be
git reset --hard origin/main

# Switch to new branch (has your commits)
git checkout feature/correct-branch
```

---

### Accidentally Deleted Commits

**Symptoms:**

- Commits missing after reset or rebase
- Lost work after force push
- HEAD detached state

**Diagnostic Steps:**

```bash
# View reflog (Git's safety net)
git reflog

# Show all lost commits
git fsck --lost-found
```

**Common Causes & Solutions:**

#### Cause 1: Hard reset deleted commits

**Solution:**

```bash
# Find commit in reflog
git reflog
# Look for: abc1234 HEAD@{5}: commit: Your commit message

# Recover commit
git cherry-pick abc1234

# Or reset to that point
git reset --hard abc1234

# Or create branch from that commit
git branch recovered-branch abc1234
```

#### Cause 2: Lost commits after rebase

**Solution:**

```bash
# Find pre-rebase position
git reflog
# Look for: def5678 HEAD@{10}: rebase: start

# Return to pre-rebase state
git reset --hard HEAD@{10}
```

#### Cause 3: Detached HEAD state

**Solution:**

```bash
# Create branch to save current position
git branch temp-save

# Or return to previous branch
git checkout main
git merge temp-save  # If you want those changes
```

---

### Large File Issues

**Symptoms:**

- Push rejected due to file size
- Repository very slow to clone
- Error about large files

**Diagnostic Steps:**

```bash
# Find large files
git rev-list --objects --all | \
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | \
  sed -n 's/^blob //p' | \
  sort --numeric-sort --key=2 | \
  tail -n 10
```

**Common Causes & Solutions:**

#### Cause 1: Added large file by mistake

**Error message:**
```
remote: error: File large-file.zip is 123.45 MB; this exceeds GitHub's file size limit of 100 MB
```

**Solution if not yet pushed:**

```bash
# Remove file from staging
git rm --cached large-file.zip

# Add to .gitignore
echo "large-file.zip" >> .gitignore
git add .gitignore

# Amend commit
git commit --amend
```

**Solution if already pushed:**

```bash
# Remove file from history
git filter-branch --tree-filter 'rm -f large-file.zip' HEAD

# Or use BFG Repo-Cleaner (faster)
bfg --delete-files large-file.zip
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push (careful!)
git push --force
```

#### Cause 2: Need to track large files

**Solution:**

Use Git LFS (Large File Storage):

```bash
# Install Git LFS
git lfs install

# Track large files
git lfs track "*.zip"
git lfs track "*.psd"

# Commit .gitattributes
git add .gitattributes
git commit -m "Track large files with LFS"

# Add and commit large files
git add large-file.zip
git commit -m "Add large file"
git push
```

---

### Untracked Files After Clone

**Symptoms:**

- Files appear as untracked after pull
- Line ending issues
- Files show as modified but no changes visible

**Diagnostic Steps:**

```bash
git status
git diff
```

**Common Causes & Solutions:**

#### Cause 1: Line ending differences

**Solution:**

```bash
# Configure line endings
git config --global core.autocrlf true   # Windows
git config --global core.autocrlf input  # Mac/Linux

# Refresh files with new settings
git rm --cached -r .
git reset --hard
```

Create `.gitattributes`:
```
# Auto detect
* text=auto

# Force specific types
*.sh text eol=lf
*.bat text eol=crlf
```

#### Cause 2: Ignored files locally present

**Solution:**

```bash
# Check .gitignore
cat .gitignore

# If file should be ignored
echo "filename" >> .gitignore
git add .gitignore
git commit -m "Update gitignore"

# Clean untracked files (be careful!)
git clean -n  # Dry run
git clean -fd # Actually remove
```

---

### Rebase Issues

**Symptoms:**

- Conflicts during rebase
- Lost commits after rebase
- Rebase in progress can't continue

**Diagnostic Steps:**

```bash
git status
git log --oneline --graph
```

**Common Causes & Solutions:**

#### Cause 1: Conflicts during rebase

**Solution:**

```bash
# Resolve conflicts in files
# Edit conflicted files

# Mark as resolved
git add conflicted-file.js

# Continue rebase
git rebase --continue

# Or skip problematic commit
git rebase --skip

# Or abort entirely
git rebase --abort
```

#### Cause 2: Accidentally rebased shared branch

**Problem:**
Rebased a branch others are using (changes history).

**Solution:**

```bash
# DON'T force push shared branches!
# Instead, merge instead of rebase:
git merge origin/main

# If you already force pushed, others need to:
git fetch origin
git reset --hard origin/branch-name
# They lose their local commits - communicate first!
```

---

### Submodule Issues

**Symptoms:**

- Submodule directory empty after clone
- Submodule not updating
- Conflicts with submodules

**Diagnostic Steps:**

```bash
git submodule status
git submodule foreach 'git status'
```

**Common Causes & Solutions:**

#### Cause 1: Submodules not initialized

**Solution:**

```bash
# After cloning repo with submodules
git submodule init
git submodule update

# Or clone with submodules
git clone --recursive <repo-url>
```

#### Cause 2: Submodule detached HEAD

**Solution:**

```bash
# Enter submodule
cd submodule-directory

# Checkout branch
git checkout main

# Or update all submodules
git submodule foreach 'git checkout main'
```

---

## Quick Reference Commands

### Status and History

```bash
# Check status
git status
git status -s  # Short format

# View history
git log --oneline --graph --all
git log -p  # Show patches
git log --author="Name"
git log --since="2 weeks ago"

# View changes
git diff
git diff --staged
git diff branch1..branch2

# Show specific commit
git show abc1234
```

### Undoing Changes

```bash
# Discard working directory changes
git checkout -- file.txt
git restore file.txt  # Newer syntax

# Unstage file
git reset HEAD file.txt
git restore --staged file.txt  # Newer syntax

# Amend last commit
git commit --amend
git commit --amend --no-edit  # Keep same message

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Undo pushed commit (creates new commit)
git revert abc1234
```

### Branch Management

```bash
# List branches
git branch
git branch -a  # Include remote
git branch -r  # Remote only

# Create branch
git branch feature-name
git checkout -b feature-name  # Create and switch

# Delete branch
git branch -d feature-name  # Safe delete
git branch -D feature-name  # Force delete

# Rename branch
git branch -m old-name new-name
```

### Remote Operations

```bash
# List remotes
git remote -v

# Add remote
git remote add origin <url>

# Update remote URL
git remote set-url origin <new-url>

# Fetch updates
git fetch origin
git fetch --all

# Pull changes
git pull origin main

# Push changes
git push origin main
git push -u origin feature  # Set upstream
git push --force-with-lease # Safer force push
```

### Stashing

```bash
# Stash changes
git stash
git stash save "message"

# List stashes
git stash list

# Apply stash
git stash apply
git stash apply stash@{0}

# Apply and remove
git stash pop

# View stash contents
git stash show -p stash@{0}

# Drop stash
git stash drop stash@{0}

# Clear all stashes
git stash clear
```

## Prevention Tips

1. **Use branches for all work**
   ```bash
   git checkout -b feature/new-work
   # Never work directly on main
   ```

2. **Commit frequently**
   ```bash
   # Small, focused commits
   git add specific-file.js
   git commit -m "Add user validation"
   ```

3. **Write good commit messages**
   ```
   Short summary (50 chars or less)
   
   More detailed explanation if needed.
   - What changed
   - Why it changed
   - Any side effects
   ```

4. **Pull before push**
   ```bash
   git pull origin main
   git push origin main
   ```

5. **Use .gitignore early**
   ```bash
   # Add .gitignore before first commit
   echo "node_modules/" >> .gitignore
   echo ".env" >> .gitignore
   ```

6. **Configure Git properly**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your@email.com"
   git config --global init.defaultBranch main
   git config --global core.editor "code --wait"  # VSCode
   ```

## When to Ask for Help

If you've tried these steps and still stuck:

1. Check [Git documentation](https://git-scm.com/doc)
2. Search [Stack Overflow](https://stackoverflow.com/questions/tagged/git)
3. Try [Git Flight Rules](https://github.com/k88hudson/git-flight-rules) - community troubleshooting guide
4. Ask in [r/git](https://reddit.com/r/git)
5. Use `git help <command>` for built-in help

When asking, provide:
- Git version (`git --version`)
- Exact commands you ran
- Complete error messages
- What you've already tried
- Output of `git status` and `git log --oneline -5`
