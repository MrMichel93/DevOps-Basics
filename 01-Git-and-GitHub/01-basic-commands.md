# Git Basic Commands

## 🎯 Learning Objectives

- Initialize Git repositories
- Stage and commit changes
- View repository history
- Work with remote repositories (GitHub)
- Understand the Git workflow

**Time: 90 minutes**

## 🔍 The Git Workflow

Before diving into commands, understand the Git workflow:

```
Working Directory  →  Staging Area  →  Local Repository  →  Remote Repository
(your files)         (git add)        (git commit)        (git push)
```

**Working Directory**: Files you're actively editing  
**Staging Area**: Changes you want to include in next commit  
**Local Repository**: Committed changes (your history)  
**Remote Repository**: Shared repository (GitHub)  

## 📚 Essential Commands

### 1. git init - Create a New Repository

**What it does:** Initializes a new Git repository in the current directory.

```bash
# Create a new project directory
mkdir my-first-project
cd my-first-project

# Initialize Git
git init
```

**Expected output:**

```
Initialized empty Git repository in /path/to/my-first-project/.git/
```

**What happened:**

- Git created a hidden `.git` directory
- This directory contains all version control data
- Your project is now a Git repository!

**When to use:**

- Starting a new project
- Adding version control to an existing project

### 2. git status - Check Repository State

**What it does:** Shows which files have changed and their status.

```bash
git status
```

**Example output:**

```
On branch main

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

**After creating a file:**

```bash
echo "# My Project" > README.md
git status
```

**Output:**

```
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        README.md

nothing added to commit but untracked files present (use "git add" to track)
```

**When to use:**

- Constantly! Use it to see what's changed
- Before committing to verify what you're committing
- When you forget what you were doing

**Pro tip:** Make it a habit to run `git status` frequently.

### 3. git add - Stage Changes

**What it does:** Adds files to the staging area (prepares them for commit).

```bash
# Add a specific file
git add README.md

# Add all files in current directory
git add .

# Add all files with specific extension
git add *.js

# Add specific directory
git add src/
```

**After adding:**

```bash
git status
```

**Output:**

```
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   README.md
```

**Why staging exists:**

- You might not want to commit all changes at once
- Allows you to review changes before committing
- Enables atomic commits (one logical change per commit)

**Example scenario:**

```bash
# You modified 3 files but they're for 2 different features
# Commit them separately:

git add feature1.js
git commit -m "Add feature 1"

git add feature2.js config.js
git commit -m "Add feature 2 and config"
```

### 4. git commit - Save Changes

**What it does:** Saves staged changes to the local repository with a message.

```bash
# Commit with a message
git commit -m "Add README file"

# Commit with multi-line message
git commit -m "Add README file" -m "This provides project documentation and setup instructions"

# Open editor for longer message
git commit
```

**Expected output:**

```
[main (root-commit) a1b2c3d] Add README file
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
```

**Anatomy of a good commit message:**

```
Short summary (50 characters or less)

More detailed explanation if needed. Wrap at 72 characters.
Explain WHAT and WHY, not HOW (code shows how).

- Bullet points are okay
- Use imperative mood: "Add feature" not "Added feature"
```

**Good commit messages:**

```bash
git commit -m "Fix login button alignment"
git commit -m "Add user authentication endpoint"
git commit -m "Update dependencies to fix security vulnerability"
```

**Bad commit messages:**

```bash
git commit -m "fix stuff"
git commit -m "changes"
git commit -m "asdflkjasdflkj"
git commit -m "final version"  # There's never a final version!
```

### 5. git log - View History

**What it does:** Shows commit history.

```bash
# Basic log
git log

# One line per commit (easier to read)
git log --oneline

# Show last N commits
git log -3

# Show commits with diffs
git log -p

# Show commits in a graph (useful for branches)
git log --oneline --graph --all

# Show commits by specific author
git log --author="John Doe"
```

**Example output:**

```bash
git log --oneline
```

```
a1b2c3d (HEAD -> main) Add README file
```

**Understanding the output:**

- `a1b2c3d` - Commit hash (unique identifier)
- `(HEAD -> main)` - Current branch and position
- `Add README file` - Commit message

### 6. git clone - Copy a Repository

**What it does:** Downloads a repository from GitHub (or other remote) to your computer.

```bash
# Clone a repository
git clone https://github.com/username/repository.git

# Clone to specific directory
git clone https://github.com/username/repository.git my-folder

# Clone specific branch
git clone -b develop https://github.com/username/repository.git
```

**What happens:**

1. Downloads entire repository history
2. Creates a local copy
3. Sets up remote connection (named "origin")

**Example:**

```bash
git clone https://github.com/github/gitignore.git
cd gitignore
git log --oneline | head -5
```

### 7. git remote - Manage Remote Repositories

**What it does:** Manages connections to remote repositories.

```bash
# List remotes
git remote -v

# Add a remote
git remote add origin https://github.com/username/repository.git

# Remove a remote
git remote remove origin

# Rename a remote
git remote rename origin upstream

# Change remote URL
git remote set-url origin https://github.com/username/new-repo.git
```

**Example output:**

```bash
git remote -v
```

```
origin  https://github.com/username/repository.git (fetch)
origin  https://github.com/username/repository.git (push)
```

### 8. git push - Upload Changes

**What it does:** Uploads your local commits to a remote repository.

```bash
# Push to remote (after first setup)
git push

# Push and set upstream (first time)
git push -u origin main

# Push specific branch
git push origin feature-branch

# Push all branches
git push --all

# Force push (dangerous! Overwrites remote)
git push --force
```

**First push workflow:**

```bash
# Create repository on GitHub first, then:
git remote add origin https://github.com/username/repository.git
git branch -M main
git push -u origin main
```

**Expected output:**

```
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Writing objects: 100% (3/3), 242 bytes | 242.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To https://github.com/username/repository.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

### 9. git pull - Download Changes

**What it does:** Downloads changes from remote repository and merges them.

```bash
# Pull changes from remote
git pull

# Pull from specific remote and branch
git pull origin main

# Pull and rebase instead of merge
git pull --rebase
```

**What happens:**

1. Downloads new commits from remote
2. Merges them into your current branch

**When to use:**

- Before starting work each day
- Before pushing your changes
- When collaborating with others

## 🔄 Complete Workflow Example

Let's create a project from scratch and push it to GitHub:

### Step 1: Create a New Repository on GitHub

1. Go to <https://github.com>
2. Click the "+" icon → "New repository"
3. Name: `my-devops-project`
4. Description: "Learning DevOps basics"
5. Keep it **public**
6. **Don't** initialize with README (we'll create it locally)
7. Click "Create repository"

### Step 2: Create Local Repository

```bash
# Create project directory
mkdir my-devops-project
cd my-devops-project

# Initialize Git
git init

# Create README
echo "# My DevOps Project" > README.md
echo "Learning Git and GitHub basics" >> README.md

# Check status
git status
```

### Step 3: Make First Commit

```bash
# Stage the file
git add README.md

# Verify it's staged
git status

# Commit
git commit -m "Initial commit: Add README"

# View history
git log
```

### Step 4: Connect to GitHub

```bash
# Add remote (replace username with yours)
git remote add origin https://github.com/username/my-devops-project.git

# Verify remote
git remote -v

# Rename branch to main (if needed)
git branch -M main
```

### Step 5: Push to GitHub

```bash
# Push and set upstream
git push -u origin main
```

**Verify:** Visit your GitHub repository URL in a browser. You should see your README!

### Step 6: Make More Changes

```bash
# Create a new file
echo "print('Hello, DevOps!')" > hello.py

# Stage and commit
git add hello.py
git commit -m "Add hello world script"

# Push
git push
```

**Refresh GitHub** - Your new file should appear!

## ⚙️ Common Workflows

### Daily Work Cycle

```bash
# 1. Start of day: Get latest changes
git pull

# 2. Do your work, edit files

# 3. Check what changed
git status
git diff

# 4. Stage changes
git add .

# 5. Commit
git commit -m "Descriptive message"

# 6. Push to remote
git push
```

### Checking Changes Before Commit

```bash
# See what changed (unstaged)
git diff

# See what changed (staged)
git diff --staged

# See specific file changes
git diff README.md
```

### Undoing Changes

```bash
# Unstage a file (keep changes)
git reset HEAD file.txt

# Discard changes in working directory (dangerous!)
git checkout -- file.txt

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes - very dangerous!)
git reset --hard HEAD~1
```

## 🐛 What Could Go Wrong?

### Issue: "Nothing to commit, working tree clean"

**Problem:** You forgot to create/modify files before committing.

**Solution:** Create or modify some files first:

```bash
echo "content" > file.txt
git add file.txt
git commit -m "Add file"
```

### Issue: "fatal: not a git repository"

**Problem:** You're not in a directory with Git initialized.

**Solution:**

```bash
# Initialize Git
git init

# Or navigate to a Git repository
cd path/to/git/repo
```

### Issue: "fatal: refusing to merge unrelated histories"

**Problem:** Local and remote repositories have different histories.

**Solution:**

```bash
git pull origin main --allow-unrelated-histories
```

### Issue: Authentication Failed

**Problem:** GitHub requires authentication.

**Solution:** Use Personal Access Token or SSH keys.

**For HTTPS:**

```bash
# Use token as password
# Get token from: https://github.com/settings/tokens
```

**For SSH:**

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to GitHub: https://github.com/settings/keys
# Change remote URL
git remote set-url origin git@github.com:username/repository.git
```

## 📝 Practice Exercise

Create a simple project to practice:

```bash
# 1. Create a calculator project
mkdir calculator-project
cd calculator-project
git init

# 2. Create calculator.py
cat > calculator.py << 'EOF'
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

if __name__ == "__main__":
    print("Calculator ready!")
    print(f"2 + 3 = {add(2, 3)}")
    print(f"5 - 2 = {subtract(5, 2)}")
EOF

# 3. Create README
cat > README.md << 'EOF'
# Calculator Project

A simple calculator to practice Git.

## Usage
python calculator.py
EOF

# 4. Stage and commit
git add .
git commit -m "Initial commit: Add calculator and README"

# 5. Create .gitignore
cat > .gitignore << 'EOF'
__pycache__/
*.pyc
.vscode/
EOF

git add .gitignore
git commit -m "Add gitignore for Python"

# 6. View your history
git log --oneline
```

## ✅ Self-Check Questions

Before moving on, make sure you can answer:

1. What's the difference between `git add` and `git commit`?
2. How do you see what files have changed?
3. What command shows your commit history?
4. How do you upload changes to GitHub?
5. What's the difference between `git clone` and `git init`?

**Answers:**

1. `git add` stages changes; `git commit` saves them to history
2. `git status` and `git diff`
3. `git log`
4. `git push`
5. `clone` copies existing repo; `init` creates new repo

## 🚀 Next Steps

Great work! You now understand Git basics.

**Next:** Learn about [Branching](./02-branching.md) - Git's killer feature that enables parallel development.

**Practice more:**

- Create several test repositories
- Practice the daily workflow
- Try making mistakes and fixing them
- Complete [Exercise 1](./exercises/exercise-1-first-repo.md)

Remember: **Mastery comes from practice, not reading.** Use Git daily and it will become second nature!
