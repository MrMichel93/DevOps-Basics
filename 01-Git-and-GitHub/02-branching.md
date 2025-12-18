# Git Branching

## 🎯 Learning Objectives

- Understand what branches are and why they're essential
- Create and switch between branches
- Merge branches
- Resolve merge conflicts
- Use rebase (and know when not to)

**Time: 90 minutes**

## 🌳 What Are Branches?

A branch is an independent line of development. Think of it as a parallel universe where you can make changes without affecting the main codebase.

```
main:      A---B---C---D
                \
feature:         E---F
```

**Real-world analogy:**
Imagine writing a book. The `main` branch is your published chapters. When you want to add a new chapter without disrupting the published version, you create a `new-chapter` branch. Once the chapter is ready and reviewed, you merge it back to `main`.

## 🤔 Why Use Branches?

### 1. Isolated Development

Work on features without breaking the main code.

```bash
# Main code keeps working
main: stable code

# You experiment in a branch
feature-branch: experimental code
```

### 2. Parallel Work

Multiple developers can work simultaneously.

```
main:        A---B---E---F (merge feature1) ---G (merge feature2)
              \   /       \                  /
feature1:      C---D       |                |
feature2:                  H---I---J--------/
```

### 3. Safe Experimentation

Try ideas without risk. If it doesn't work, just delete the branch.

### 4. Code Review

Create branch → Make changes → Submit for review → Merge when approved

This is the workflow at Google, Facebook, Microsoft, and pretty much every tech company.

## 📚 Branch Commands

### 1. View Branches

```bash
# List local branches
git branch

# List all branches (including remote)
git branch -a

# List remote branches only
git branch -r

# Show current branch with details
git status
```

**Example output:**

```
$ git branch
* main
  feature-new-login
  bugfix-header
```

The `*` indicates your current branch.

### 2. Create a Branch

```bash
# Create a new branch
git branch feature-name

# Create and switch to new branch
git checkout -b feature-name

# Modern alternative (Git 2.23+)
git switch -c feature-name
```

**Example:**

```bash
# Create feature branch
git checkout -b feature-user-auth

# Verify
git branch
```

**Output:**

```
* feature-user-auth
  main
```

### 3. Switch Branches

```bash
# Switch to existing branch
git checkout branch-name

# Modern alternative
git switch branch-name

# Go back to previous branch
git checkout -

# Switch and create if doesn't exist
git checkout -b feature-name
```

**Example:**

```bash
# Switch to main
git checkout main

# Switch to feature branch
git checkout feature-user-auth

# Quick toggle between branches
git checkout -  # Goes back to main
git checkout -  # Goes back to feature-user-auth
```

### 4. Delete a Branch

```bash
# Delete local branch (safe - won't delete if unmerged)
git branch -d branch-name

# Force delete (even if unmerged)
git branch -D branch-name

# Delete remote branch
git push origin --delete branch-name
```

**Example:**

```bash
# After merging a feature
git checkout main
git merge feature-user-auth
git branch -d feature-user-auth  # Safe deletion
```

## 🔀 Merging Branches

### Fast-Forward Merge

When there are no new commits on main:

```
Before merge:
main:     A---B
           \
feature:    C---D

After merge (fast-forward):
main:     A---B---C---D
```

```bash
git checkout main
git merge feature-branch
```

**Output:**

```
Updating a1b2c3d..e4f5g6h
Fast-forward
 file.txt | 10 ++++++++
 1 file changed, 10 insertions(+)
```

### Three-Way Merge

When both branches have new commits:

```
Before merge:
main:     A---B---E---F
           \
feature:    C---D

After merge:
main:     A---B---E---F---M (merge commit)
           \           /
feature:    C---D------/
```

```bash
git checkout main
git merge feature-branch
```

**Output:**

```
Merge made by the 'recursive' strategy.
 file.txt | 5 +++++
 1 file changed, 5 insertions(+)
```

## ⚔️ Merge Conflicts

Conflicts happen when the same lines are changed in both branches.

### Example Conflict Scenario

**1. Create a conflict:**

```bash
# Start from main
git checkout main
echo "Hello World" > greeting.txt
git add greeting.txt
git commit -m "Add greeting"

# Create feature branch
git checkout -b feature-spanish
echo "Hola Mundo" > greeting.txt
git add greeting.txt
git commit -m "Add Spanish greeting"

# Go back to main and make different change
git checkout main
echo "Hello Universe" > greeting.txt
git add greeting.txt
git commit -m "Update greeting to Universe"

# Try to merge - conflict!
git merge feature-spanish
```

**Output:**

```
Auto-merging greeting.txt
CONFLICT (content): Merge conflict in greeting.txt
Automatic merge failed; fix conflicts and then commit the result.
```

### Resolving Conflicts

**2. View conflict:**

```bash
cat greeting.txt
```

**Shows:**

```
<<<<<<< HEAD
Hello Universe
=======
Hola Mundo
>>>>>>> feature-spanish
```

**Explanation:**

- `<<<<<<< HEAD` - Current branch (main)
- `=======` - Separator
- `>>>>>>> feature-spanish` - Incoming branch

**3. Resolve conflict:**

Edit `greeting.txt` to keep what you want:

```bash
# Option 1: Keep both
echo "Hello Universe" > greeting.txt
echo "Hola Mundo" >> greeting.txt

# Option 2: Keep only one
echo "Hello Universe" > greeting.txt

# Option 3: Write something new
echo "Greetings, World!" > greeting.txt
```

**4. Complete merge:**

```bash
# Stage resolved file
git add greeting.txt

# Check status
git status

# Complete merge
git commit
```

Git will open editor with default merge message. Save and exit.

**5. Verify:**

```bash
git log --oneline --graph
```

### Conflict Resolution Tools

```bash
# Use visual merge tool
git mergetool

# Common tools:
# - VS Code (built-in)
# - kdiff3
# - meld
# - Beyond Compare
```

**In VS Code:**

1. Open conflicted file
2. VS Code highlights conflicts
3. Click "Accept Current Change", "Accept Incoming Change", or "Accept Both Changes"
4. Save file
5. `git add` and `git commit`

## 🔄 Rebasing

Rebase re-applies your commits on top of another branch.

### When to Use Rebase

**Use rebase when:**

- ✅ Updating feature branch with latest main
- ✅ Cleaning up local commits before pushing
- ✅ Maintaining linear history

**Don't rebase when:**

- ❌ Branch is already pushed and others are using it
- ❌ On public/shared branches
- ❌ You're unsure (merge is safer)

### Rebase Example

```
Before rebase:
main:     A---B---E---F
           \
feature:    C---D

After rebase:
main:     A---B---E---F
                     \
feature:              C'---D'
```

```bash
# On feature branch
git checkout feature-branch

# Rebase onto main
git rebase main
```

**If conflicts occur during rebase:**

```bash
# Fix conflicts in files
# Then:
git add .
git rebase --continue

# Or abort rebase:
git rebase --abort
```

### Rebase vs Merge

**Merge:**

- ✅ Preserves complete history
- ✅ Safer for shared branches
- ❌ Creates merge commits (cluttered history)

**Rebase:**

- ✅ Linear, clean history
- ✅ Easier to understand
- ❌ Rewrites history (dangerous on shared branches)

## 🏗️ Branching Strategies

### 1. Feature Branch Workflow

```
main:     A---B---E (merge feature1) ---F (merge feature2)
           \       /                  /
feature1:  C------D                 |
feature2:                    G------H
```

**How it works:**

1. Create branch for each feature
2. Develop feature independently
3. Submit pull request
4. Code review
5. Merge to main
6. Delete feature branch

```bash
# Start feature
git checkout -b feature-user-profile
# ... make changes ...
git add .
git commit -m "Add user profile page"
git push -u origin feature-user-profile
# Create pull request on GitHub
# After merge, delete branch
git checkout main
git pull
git branch -d feature-user-profile
```

### 2. GitFlow (Traditional)

```
main:        A---B-------G (release)
              \         /
develop:       C---D---E---F
                \     /
feature:         H---I
```

**Branches:**

- `main` - Production code
- `develop` - Integration branch
- `feature/*` - New features
- `release/*` - Release preparation
- `hotfix/*` - Production fixes

**For large, scheduled releases.**

### 3. Trunk-Based Development (Modern)

```
main:     A---B---C---D---E---F
           \  /  \  /  \  /
          Short-lived feature branches
```

**How it works:**

- Main branch is always deployable
- Small, frequent merges
- Feature flags for incomplete features
- Continuous deployment

**Used by:** Google, Facebook, Netflix

## 🔥 Advanced Branch Operations

### Cherry-Pick (Apply Specific Commits)

```bash
# Apply specific commit from another branch
git cherry-pick <commit-hash>

# Example:
git log feature-branch --oneline  # Find commit hash
git checkout main
git cherry-pick a1b2c3d
```

**When to use:** You need one commit from a branch without merging entire branch.

### Stash (Temporary Storage)

```bash
# Save current changes temporarily
git stash

# List stashes
git stash list

# Apply most recent stash
git stash pop

# Apply specific stash
git stash apply stash@{0}

# Stash with message
git stash save "Work in progress on feature X"
```

**When to use:** Switch branches without committing incomplete work.

**Example:**

```bash
# Working on feature branch
# Suddenly need to fix bug on main

git stash  # Save current work
git checkout main
# ... fix bug ...
git checkout feature-branch
git stash pop  # Restore work
```

## 🎯 Complete Workflow Example

Let's build a feature with proper branching:

```bash
# 1. Update main
git checkout main
git pull

# 2. Create feature branch
git checkout -b feature-login-page

# 3. Make changes
echo "<!DOCTYPE html><html><body><h1>Login</h1></body></html>" > login.html
git add login.html
git commit -m "Add login page structure"

echo "<form>...</form>" >> login.html
git add login.html
git commit -m "Add login form"

# 4. Push feature branch
git push -u origin feature-login-page

# 5. Create pull request on GitHub
# (We'll cover this in collaboration section)

# 6. After approval, merge via GitHub or locally:
git checkout main
git pull  # Get latest
git merge feature-login-page
git push

# 7. Clean up
git branch -d feature-login-page
git push origin --delete feature-login-page
```

## 🐛 Common Issues

### Issue: "Cannot switch branch - uncommitted changes"

**Solution 1: Commit changes**

```bash
git add .
git commit -m "Work in progress"
git checkout other-branch
```

**Solution 2: Stash changes**

```bash
git stash
git checkout other-branch
# Later, come back
git checkout original-branch
git stash pop
```

### Issue: "Deleted branch but it still shows up"

**Problem:** Remote branch not deleted.

```bash
# Delete remote branch
git push origin --delete branch-name

# Clean up local references
git fetch --prune
```

### Issue: "Can't merge - divergent branches"

**Solution:**

```bash
# Option 1: Merge
git merge origin/main

# Option 2: Rebase
git rebase origin/main
```

## 📝 Practice Exercise

```bash
# 1. Create repository
mkdir branch-practice
cd branch-practice
git init

# 2. Create main content
echo "# Branch Practice" > README.md
git add README.md
git commit -m "Initial commit"

# 3. Create feature branch
git checkout -b feature-documentation

# 4. Add documentation
echo "## Features" >> README.md
echo "- Feature 1" >> README.md
git add README.md
git commit -m "Add features section"

# 5. Switch to main and make different change
git checkout main
echo "## About" >> README.md
echo "Learning branches" >> README.md
git add README.md
git commit -m "Add about section"

# 6. Try to merge - you'll get a conflict!
git merge feature-documentation

# 7. Resolve conflict
# Edit README.md to include both sections
git add README.md
git commit -m "Merge feature-documentation"

# 8. View history
git log --oneline --graph --all
```

## ✅ Self-Check

Before continuing, ensure you can:

1. Create and switch between branches
2. Merge branches
3. Identify and resolve conflicts
4. Explain when to use rebase vs merge
5. Clean up merged branches

## 🚀 Next Steps

Excellent! You now understand Git's most powerful feature.

**Next:** Learn [Collaboration](./03-collaboration.md) - working with others using GitHub workflows.

**Practice:**

- Create multiple branches in a test repo
- Intentionally create and resolve conflicts
- Try different merge strategies
- Complete [Exercise 2](./exercises/exercise-2-branching.md)
