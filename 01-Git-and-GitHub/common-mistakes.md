# Common Mistakes in Git and GitHub

## Beginner Mistakes

### Mistake 1: Committing Directly to Main Branch

**What people do:**
Make all commits directly to the `main` or `master` branch without creating feature branches.

**Why it's a problem:**
- Breaks the production branch with untested code
- Makes it difficult to isolate and review changes
- Prevents parallel development with team members
- No easy way to rollback specific features
- Disrupts CI/CD pipelines that auto-deploy from main

**The right way:**
Always create feature branches for new work:

```bash
git checkout -b feature/new-feature
# Make your changes and commits
git push origin feature/new-feature
# Create a pull request for review
```

**How to fix if you've already done this:**
If you've committed to main but haven't pushed:

```bash
# Create a new branch with your changes
git branch feature/my-work
# Reset main to origin
git reset --hard origin/main
# Switch to your feature branch
git checkout feature/my-work
```

**Red flags to watch for:**
- Your `git log` on main shows many small commits from you
- Team members complain about broken code on main
- CI/CD pipeline fails frequently
- No pull requests in your GitHub repository

---

### Mistake 2: Adding Large Binary Files to Git

**What people do:**
Commit large files like videos, compiled binaries, datasets, or build artifacts directly to the repository.

**Why it's a problem:**
- Git tracks every version of every file forever
- Repository becomes huge and slow to clone
- Wastes bandwidth and storage for everyone
- GitHub has file size limits (100MB warning, 100MB hard limit)
- Slows down all Git operations (clone, fetch, push)

**The right way:**
Use `.gitignore` to exclude large files and build artifacts:

```bash
# Add to .gitignore
*.mp4
*.zip
*.exe
*.dll
node_modules/
dist/
build/
```

For necessary large files, use Git LFS (Large File Storage):

```bash
git lfs install
git lfs track "*.psd"
git lfs track "*.mp4"
git add .gitattributes
```

**How to fix if you've already done this:**
Remove the large file from Git history:

```bash
# Install BFG Repo-Cleaner
# Remove files larger than 100MB
java -jar bfg.jar --strip-blobs-bigger-than 100M my-repo.git
cd my-repo.git
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git push --force
```

Or use `git filter-repo`:

```bash
git filter-repo --strip-blobs-bigger-than 100M
```

**Red flags to watch for:**
- Clone takes several minutes or fails
- Warning: "Large files detected" when pushing
- Repository size shown in GitHub is over 100MB
- Team complains about slow Git operations

---

### Mistake 3: Writing Poor Commit Messages

**What people do:**
Write vague, uninformative commit messages like "fix", "update", "wip", or "asdf".

**Why it's a problem:**
- Impossible to understand what changed without reading the code
- Difficult to find specific changes later
- Makes debugging and rollbacks harder
- Shows unprofessionalism in team environments
- Breaks automated changelog generation

**The right way:**
Write clear, descriptive commit messages following conventions:

```bash
# Good commit messages
git commit -m "Add user authentication with JWT tokens"
git commit -m "Fix memory leak in image upload handler"
git commit -m "Update README with installation instructions"

# Even better - use conventional commits
git commit -m "feat: add user authentication with JWT"
git commit -m "fix: resolve memory leak in image upload"
git commit -m "docs: update README with installation steps"
```

Format: `<type>: <description>`

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**How to fix if you've already done this:**
For the last commit (before pushing):

```bash
git commit --amend -m "Better commit message"
```

For multiple commits (interactive rebase):

```bash
git rebase -i HEAD~3  # Last 3 commits
# Change 'pick' to 'reword' for commits you want to change
```

**Red flags to watch for:**
- Your git log looks like: "fix", "update", "stuff", "more stuff"
- Can't find when a specific feature was added
- Team asks you "what was in that commit?"
- Using `git commit -m "WIP"` frequently

---

### Mistake 4: Force Pushing to Shared Branches

**What people do:**
Use `git push --force` on branches that other people are working on, especially `main` or `develop`.

**Why it's a problem:**
- Overwrites other people's work
- Causes conflicts for everyone who has pulled the branch
- Can permanently lose commits and history
- Breaks ongoing pull requests
- Creates chaos in team environments

**The right way:**
Only force push to your own feature branches, and use `--force-with-lease` for safety:

```bash
# On your personal feature branch
git push --force-with-lease origin feature/my-work

# Never on shared branches like main or develop
```

If you need to update main, use pull requests and merge:

```bash
# Don't do this:
git push --force origin main  # ❌ NEVER

# Do this instead:
git checkout feature/my-work
git push origin feature/my-work
# Create pull request and merge through GitHub
```

**How to fix if you've already done this:**
If you force pushed to a shared branch, immediately notify your team:

```bash
# If commits are lost, recover from reflog
git reflog
git reset --hard <commit-hash>
git push --force-with-lease

# Team members need to reset their local branches:
git fetch origin
git reset --hard origin/main
```

**Red flags to watch for:**
- Team members report missing commits
- Error messages like "your branch and origin have diverged"
- Pull requests suddenly show hundreds of changes
- Angry teammates in Slack/Teams

---

### Mistake 5: Not Pulling Before Pushing

**What people do:**
Make local commits and try to push without pulling the latest changes first.

**Why it's a problem:**
- Push gets rejected with "non-fast-forward" error
- Creates unnecessary merge commits
- May cause merge conflicts
- Slows down workflow with failed pushes
- Can lead to frustration and force push temptation

**The right way:**
Always pull (or fetch) before starting work and before pushing:

```bash
# Start of day
git checkout main
git pull origin main

# Create feature branch from latest main
git checkout -b feature/new-work

# Before pushing
git fetch origin
git rebase origin/main  # Or merge if you prefer
git push origin feature/new-work
```

Or use `git pull --rebase` workflow:

```bash
git pull --rebase origin main
git push origin feature/my-work
```

**How to fix if you've already done this:**
When push is rejected:

```bash
# Pull with rebase to avoid merge commit
git pull --rebase origin main

# Resolve any conflicts if they appear
# Then push
git push origin feature/my-work
```

**Red flags to watch for:**
- Frequent "rejected - non-fast-forward" errors
- Many merge commits in your history
- Teammates' changes missing from your local repo
- Conflicts when you finally pull

---

### Mistake 6: Ignoring or Mishandling Merge Conflicts

**What people do:**
Accept all changes without understanding them, delete conflict markers without resolving properly, or give up and start over.

**Why it's a problem:**
- Loses important code changes
- Introduces bugs by keeping wrong version
- Breaks functionality that was working
- Wastes time redoing work
- Creates more conflicts down the line

**The right way:**
Carefully review and resolve each conflict:

```bash
# When conflict occurs
git status  # See which files have conflicts

# Open conflicted file - you'll see:
<<<<<<< HEAD
Your changes
=======
Their changes
>>>>>>> feature-branch

# Manually edit to keep the correct code
# Remove conflict markers
# Test that code still works

git add resolved-file.js
git commit -m "Resolve merge conflict in feature X"
```

Use merge tools for complex conflicts:

```bash
git mergetool  # Opens visual merge tool
```

**How to fix if you've already done this:**
If you resolved incorrectly:

```bash
# Abort the merge and start over
git merge --abort

# Or if already committed
git reset --hard HEAD~1
git merge feature-branch  # Try again
```

**Red flags to watch for:**
- Code that worked before merge is now broken
- Missing functionality after merge
- Duplicate code sections
- Tests fail after merge
- Conflict markers (<<<<<<) in committed code

---

### Mistake 7: Not Backing Up Before Rebasing

**What people do:**
Run `git rebase` without creating a backup branch, then panic when something goes wrong.

**Why it's a problem:**
- Rebase rewrites history and can lose commits
- If rebase goes wrong, hard to recover
- Interactive rebase can accidentally drop commits
- Conflicts during rebase can be complex
- May lose work if you don't know how to abort

**The right way:**
Always create a backup branch before rebasing:

```bash
# Create backup
git branch backup-before-rebase

# Now safely rebase
git rebase main

# If something goes wrong
git rebase --abort
git reset --hard backup-before-rebase

# If successful, delete backup
git branch -d backup-before-rebase
```

**How to fix if you've already done this:**
If rebase went wrong and you didn't backup:

```bash
# Use reflog to find your previous state
git reflog
# Find the commit before rebase (look for "rebase: checkout")
git reset --hard HEAD@{5}  # Use appropriate number

# Or reset to specific commit
git reset --hard <commit-hash>
```

**Red flags to watch for:**
- Missing commits after rebase
- "Detached HEAD state" and confusion
- Rebase conflicts you can't resolve
- Features disappear after rebase
- Panic and uncertainty about git state

---

## Intermediate Mistakes

### Mistake 8: Not Using .gitignore Properly

**What people do:**
Commit IDE configurations, environment files, dependencies, or OS-specific files to the repository.

**Why it's a problem:**
- Pollutes repository with unnecessary files
- Exposes sensitive data (API keys, passwords)
- Causes conflicts with different team setups
- Wastes storage and bandwidth
- Leaks local paths and configurations

**The right way:**
Create comprehensive `.gitignore` file:

```bash
# Dependencies
node_modules/
venv/
vendor/

# Build outputs
dist/
build/
*.exe

# IDE
.vscode/
.idea/
*.swp

# Environment files
.env
.env.local

# OS files
.DS_Store
Thumbs.db
```

**How to fix if you've already done this:**
Remove tracked files that should be ignored:

```bash
# Add to .gitignore first
echo "node_modules/" >> .gitignore

# Remove from Git but keep locally
git rm -r --cached node_modules/
git commit -m "Remove node_modules from tracking"
```

**Red flags to watch for:**
- `.env` files in repository
- `node_modules/` committed (huge repo size)
- Different IDE settings causing conflicts
- Sensitive credentials in commit history

---

### Mistake 9: Creating Too Many or Too Few Commits

**What people do:**
Either commit every tiny change (100 commits for a small feature) or make giant commits with everything (one commit with 50 files).

**Why it's a problem:**
- Too many: Cluttered history, hard to review
- Too few: Impossible to isolate changes, risky rollbacks
- Makes code review painful
- Difficult to use git bisect for debugging
- Hard to understand feature development

**The right way:**
Make atomic commits - one logical change per commit:

```bash
# Good commit granularity
git add user-auth.js
git commit -m "Add JWT token generation"

git add user-model.js
git commit -m "Create User model with validation"

git add auth-routes.js
git commit -m "Add authentication routes"

# Use interactive add for partial commits
git add -p  # Stage hunks selectively
```

**How to fix if you've already done this:**
Squash too many commits (before pushing):

```bash
git rebase -i HEAD~10  # Last 10 commits
# Change 'pick' to 'squash' for commits to combine
```

Split a large commit:

```bash
git reset HEAD~1  # Unstage last commit
# Now commit changes in smaller chunks
git add file1.js
git commit -m "Part 1: Add feature X"
git add file2.js
git commit -m "Part 2: Update feature Y"
```

**Red flags to watch for:**
- Pull request with 50+ commits for simple feature
- Commit messages like "fix typo" (10 times)
- One commit changes 100 files across entire app
- Can't rollback specific functionality

---

### Mistake 10: Not Understanding Detached HEAD State

**What people do:**
Check out a specific commit or tag, make changes and commits, then switch branches and lose the work.

**Why it's a problem:**
- Commits made in detached HEAD are not on any branch
- Easy to lose work when switching branches
- Confusing state for Git beginners
- Changes may become unreachable
- Requires reflog knowledge to recover

**The right way:**
If you need to work from a specific commit, create a branch:

```bash
# Don't just checkout a commit
git checkout abc1234  # ❌ Enters detached HEAD

# Instead, create a branch
git checkout -b fix-from-old-commit abc1234  # ✅
# Now you're on a branch, commits are safe
```

**How to fix if you've already done this:**
If you made commits in detached HEAD:

```bash
# Before switching away, note the commit hash
git log  # Copy the latest commit hash

# Or after switching, use reflog
git reflog  # Find your lost commits

# Create a branch to save the work
git branch recover-work <commit-hash>
git checkout recover-work
```

**Red flags to watch for:**
- Warning: "You are in 'detached HEAD' state"
- Made commits but can't see them in any branch
- Commits disappear after switching branches
- Confusion about current Git state

---

### Mistake 11: Storing Secrets in Git

**What people do:**
Commit API keys, passwords, database credentials, or private keys directly in code or config files.

**Why it's a problem:**
- Secrets are in Git history forever
- Major security vulnerability
- Exposed to anyone with repository access
- Can't remove easily (need to rewrite history)
- Requires rotating all exposed credentials
- May violate compliance regulations

**The right way:**
Use environment variables and never commit them:

```bash
# Create .env file
echo "API_KEY=your_key_here" > .env
echo "DB_PASSWORD=secret" >> .env

# Add to .gitignore
echo ".env" >> .gitignore
echo ".env.*" >> .gitignore

# Create example template
cp .env .env.example
# Remove real values from .env.example
git add .env.example
```

Use secrets management:

```bash
# GitHub Secrets for Actions
# AWS Secrets Manager
# HashiCorp Vault
# Environment variables in deployment
```

**How to fix if you've already done this:**
You must rotate the exposed credentials AND clean Git history:

```bash
# 1. IMMEDIATELY rotate all exposed secrets

# 2. Remove from Git history
git filter-repo --path config/secrets.yml --invert-paths

# Or use BFG Repo-Cleaner
java -jar bfg.jar --delete-files secrets.yml

# 3. Force push (coordinate with team)
git push --force --all
```

**Red flags to watch for:**
- API keys visible in GitHub repository
- Passwords in config files
- AWS credentials in code
- Security alerts from GitHub
- Unauthorized access to services

---

### Mistake 12: Not Using Branches for Experimentation

**What people do:**
Make experimental changes directly on their working branch or main, hoping it will work out.

**Why it's a problem:**
- Difficult to discard if experiment fails
- Mixes experimental and production code
- Hard to review what changed
- May break working code
- No easy way to compare approaches

**The right way:**
Create experimental branches freely:

```bash
# Create experiment branch from current branch
git checkout -b experiment/new-approach

# Try your idea
# Make commits as needed

# If it works, merge or create PR
git checkout main
git merge experiment/new-approach

# If it doesn't work, just delete it
git checkout main
git branch -D experiment/new-approach  # Gone, no harm done
```

**How to fix if you've already done this:**
If you've mixed experimental changes:

```bash
# Stash current changes
git stash

# Create experiment branch
git checkout -b experiment/my-test

# Apply stashed changes
git stash pop

# Commit experimental work
git commit -am "Experimental feature"

# Go back to main and continue clean work
git checkout main
```

**Red flags to watch for:**
- Commented-out code blocks everywhere
- Feature flags for experimental code
- Hesitation to commit changes
- Mixing multiple approaches in one file
- Difficulty explaining what the code does

---

## Advanced Pitfalls

### Mistake 13: Misusing Git Reset and Losing Work

**What people do:**
Use `git reset --hard` without understanding the implications, losing uncommitted or unpushed work.

**Why it's a problem:**
- Permanently deletes uncommitted changes
- No way to recover unless commits were made
- Can lose hours or days of work
- Easy to run by mistake
- Confuse reset modes (soft, mixed, hard)

**The right way:**
Understand reset modes and use appropriate one:

```bash
# Soft: Move HEAD, keep changes staged
git reset --soft HEAD~1

# Mixed (default): Move HEAD, unstage changes, keep in working dir
git reset HEAD~1

# Hard: Move HEAD, delete all changes (DANGEROUS)
git reset --hard HEAD~1  # Only if you're sure!

# Safe alternative: stash instead of reset
git stash
git stash list
git stash pop  # Recover when needed
```

**How to fix if you've already done this:**
If you used `reset --hard` and lost work:

```bash
# Check reflog immediately
git reflog

# Find your lost commit
# Look for entry before the reset
git reset --hard HEAD@{1}

# Or reset to specific commit
git reset --hard abc1234
```

**Red flags to watch for:**
- Panic after running `git reset --hard`
- Uncommitted changes disappeared
- Can't find previous work
- Confusion about different reset modes

---

### Mistake 14: Creating Messy Merge Commit History

**What people do:**
Constantly merge main into feature branches, creating a complex web of merge commits that's impossible to follow.

**Why it's a problem:**
- Git history becomes unreadable
- Difficult to use git bisect
- Hard to understand feature development
- Makes code review confusing
- Impossible to generate clean changelogs

**The right way:**
Use rebase to keep feature branches up-to-date:

```bash
# Instead of merging main into feature
git checkout feature/my-work
git merge main  # ❌ Creates merge commit

# Use rebase instead
git checkout feature/my-work
git rebase main  # ✅ Clean linear history
git push --force-with-lease origin feature/my-work
```

Or use rebase workflow:

```bash
git fetch origin
git rebase origin/main
# Resolve conflicts
git rebase --continue
git push --force-with-lease
```

**How to fix if you've already done this:**
Clean up messy history before merging PR:

```bash
# Interactive rebase to clean up
git rebase -i main
# Mark merge commits as 'drop'
# Squash related commits
# Reword commit messages

git push --force-with-lease
```

**Red flags to watch for:**
- Diamond-shaped merge patterns in git graph
- Many "Merge branch 'main' into feature" commits
- Can't follow feature development linearly
- Git graph looks like a tangled web

---

### Mistake 15: Not Understanding Rebase vs Merge

**What people do:**
Always use merge (even when rebase is better) or always use rebase (even on public branches), not understanding the trade-offs.

**Why it's a problem:**
- Merge: Creates complex history with many merge commits
- Rebase on public branches: Rewrites history others depend on
- Using wrong strategy for the situation
- Team conflicts about workflow
- Makes history hard to read or impossible to follow

**The right way:**
Use the right tool for the situation:

**Merge when:**

- Integrating a completed feature branch into main
- You want to preserve the feature branch history
- Branch is public and others are working on it

```bash
git checkout main
git merge feature/my-work  # Creates merge commit
```

**Rebase when:**

- Updating your feature branch with latest main
- Cleaning up local commits before pushing
- Want linear history

```bash
git checkout feature/my-work
git rebase main  # Replays your commits on top of main
```

**How to fix if you've already done this:**
If you rebased a public branch:

```bash
# Coordinate with team - they need to reset
git push --force-with-lease

# Team members need to:
git fetch origin
git reset --hard origin/feature-branch
```

**Red flags to watch for:**
- Team members complaining about diverged branches
- Inconsistent use of merge vs rebase
- Arguments about "the right way"
- Complex, unreadable git history

---

## Prevention Checklist

### Before Every Commit

- [ ] Run tests to ensure code works
- [ ] Check what you're committing: `git diff --staged`
- [ ] Verify no secrets or sensitive data
- [ ] Write clear, descriptive commit message
- [ ] Ensure no large binary files
- [ ] Check .gitignore is properly configured

### Before Every Push

- [ ] Pull latest changes first
- [ ] Verify you're on the correct branch
- [ ] Review commits you're pushing: `git log origin/main..HEAD`
- [ ] Ensure branch name is descriptive
- [ ] Check that you're not force pushing to shared branches
- [ ] Run tests one final time

### Daily Workflow

- [ ] Start day by pulling latest main
- [ ] Create feature branches for new work
- [ ] Commit frequently with clear messages
- [ ] Keep commits atomic and focused
- [ ] Regularly fetch remote changes
- [ ] Push work-in-progress to remote as backup

### Before Creating Pull Request

- [ ] Rebase on latest main to resolve conflicts
- [ ] Run full test suite
- [ ] Review all changed files
- [ ] Clean up commit history if needed (squash/reword)
- [ ] Update documentation if needed
- [ ] Add clear PR description
- [ ] Link related issues

### Weekly Best Practices

- [ ] Review and clean up old branches
- [ ] Check repository size and history
- [ ] Verify .gitignore is complete
- [ ] Update dependencies and test
- [ ] Sync with team about workflow
- [ ] Delete merged feature branches

### Emergency Procedures

- [ ] Know how to use `git reflog` for recovery
- [ ] Understand when to use `git reset` vs `git revert`
- [ ] Have backup strategy for important work
- [ ] Know team's process for force push situations
- [ ] Keep calm and document issue before making it worse
- [ ] Ask for help rather than experimenting blindly
