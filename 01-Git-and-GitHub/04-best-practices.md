# Git Best Practices

## 🎯 Learning Objectives

- Write professional commit messages
- Use `.gitignore` effectively
- Choose appropriate branching strategies
- Maintain clean repository history
- Follow industry standards

**Time: 60 minutes**

## 📝 Commit Messages

### Why Good Commit Messages Matter

Six months from now:
- You won't remember why you made a change
- Someone else needs to understand your code
- A bug needs to be traced back to its source
- The project history needs to tell a story

**Bad commit message:**
```bash
git commit -m "fix"
```

**Future you:** "Fix what? Where? Why?"

**Good commit message:**
```bash
git commit -m "Fix null pointer exception in user login

The login handler didn't check if email was null before
calling toLowerCase(). Added null check and test case."
```

**Future you:** "Ah, that makes sense!"

### Commit Message Format

**Standard format:**
```
<type>: <subject>

<body>

<footer>
```

**Example:**
```
feat: Add user authentication endpoint

Implements JWT-based authentication for the API.
Users can now register and login to receive access tokens.

- Added /register endpoint
- Added /login endpoint  
- Added JWT token generation
- Added password hashing with bcrypt

Closes #123
```

### Commit Types

**Common prefixes:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks
- `perf:` - Performance improvements

**Examples:**
```bash
feat: Add dark mode toggle
fix: Resolve memory leak in image loader
docs: Update API documentation
style: Format code with prettier
refactor: Extract validation logic to separate module
test: Add unit tests for authentication
chore: Update dependencies
perf: Optimize database queries
```

### Writing the Subject Line

**Rules:**
1. ✅ Start with capital letter
2. ✅ Use imperative mood ("Add" not "Added")
3. ✅ Keep under 50 characters
4. ✅ No period at the end
5. ✅ Be specific but concise

**Good:**
```
Add user profile page
Fix login button alignment
Update Python dependencies
Remove deprecated API endpoints
```

**Bad:**
```
added stuff
fixed things
work in progress
final version
asdf
```

### Writing the Body

**When to include a body:**
- Complex changes needing explanation
- Important context about WHY
- Breaking changes
- Multiple related changes

**Format:**
- Wrap at 72 characters
- Explain WHAT and WHY (not HOW - code shows how)
- Separate from subject with blank line

**Example:**
```
Refactor authentication middleware

The old authentication approach was tightly coupled to Express,
making it difficult to test and reuse. This refactor:

- Extracts auth logic into pure functions
- Makes middleware testable in isolation
- Adds comprehensive unit tests
- Improves error messages

This is preparation for adding OAuth support in #245.
```

### Linking to Issues

**Closes/Fixes:**
```
fix: Resolve database connection timeout

The connection pool wasn't being cleaned up properly,
causing timeouts after prolonged use.

Fixes #123
```

**References:**
```
feat: Add pagination to user list

Related to #456
See also #789
```

**Keywords that auto-close issues:**
- `close`, `closes`, `closed`
- `fix`, `fixes`, `fixed`
- `resolve`, `resolves`, `resolved`

## 🚫 .gitignore

### What is .gitignore?

A file telling Git which files/directories to ignore. Never commit:
- Build artifacts
- Dependencies
- Sensitive data (passwords, API keys)
- IDE-specific files
- Operating system files
- Logs and temporary files

### Creating .gitignore

```bash
# Create in repository root
touch .gitignore
```

### Common Patterns

**Python project:**
```gitignore
# Virtual environment
venv/
env/
.venv/

# Byte-compiled files
__pycache__/
*.pyc
*.pyo
*.pyd

# Distribution
dist/
build/
*.egg-info/

# IDE
.vscode/
.idea/
*.swp

# Environment variables
.env
.env.local

# Logs
*.log

# OS files
.DS_Store
Thumbs.db
```

**Node.js project:**
```gitignore
# Dependencies
node_modules/
npm-debug.log

# Build output
dist/
build/

# Environment variables
.env
.env.local

# IDE
.vscode/
.idea/

# OS files
.DS_Store

# Test coverage
coverage/
```

**General:**
```gitignore
# Logs
*.log
logs/

# Temporary files
*.tmp
*.temp
.cache/

# IDE
.vscode/
.idea/
*.swp
*~

# OS files
.DS_Store
Thumbs.db
Desktop.ini

# Environment
.env
.env.local
```

### Patterns Syntax

```gitignore
# Comment

# Ignore specific file
secret.txt

# Ignore all files with extension
*.log

# Ignore directory
node_modules/

# Ignore directory anywhere
**/temp/

# Ignore except specific file
*.log
!important.log

# Ignore files only in root
/config.local

# Ignore in specific directory
docs/*.pdf
```

### Testing .gitignore

```bash
# Check if file would be ignored
git check-ignore -v filename.txt

# List all ignored files
git status --ignored
```

### Retroactively Ignoring Files

If you already committed files that should be ignored:

```bash
# Remove from Git but keep locally
git rm --cached filename

# Remove directory
git rm -r --cached directory/

# Commit the removal
git commit -m "Remove ignored files from repository"

# Add to .gitignore
echo "filename" >> .gitignore
git add .gitignore
git commit -m "Update .gitignore"
```

### .gitignore Templates

GitHub provides templates:
https://github.com/github/gitignore

```bash
# Quick way to get template
curl https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore > .gitignore
```

## 🌿 Branching Strategies

### Strategy 1: GitHub Flow (Simple)

**Best for:** Web apps with continuous deployment

```
main: A---B---C (always deployable)
       \     /
feature: D---E
```

**Rules:**
1. `main` branch is always deployable
2. Create descriptive feature branches
3. Commit often, push regularly
4. Open PR when ready
5. Merge after review and tests pass
6. Deploy immediately after merge

**Example:**
```bash
# Create feature
git checkout -b feature/add-dark-mode

# Work and commit
git add .
git commit -m "feat: Add dark mode toggle"

# Push and create PR
git push origin feature/add-dark-mode

# After merge, main is deployed
```

### Strategy 2: Git Flow (Complex)

**Best for:** Scheduled releases, multiple versions

```
main:     A-------F-------K (production)
           \     /       /
release:    B---E-------J
           /   /       /
develop:  C---D---G---H---I
           \     /   /
features:   F---G   H
```

**Branches:**
- `main` - Production code
- `develop` - Integration branch
- `feature/*` - New features
- `release/*` - Release preparation
- `hotfix/*` - Emergency fixes

**Example:**
```bash
# Start feature
git checkout develop
git checkout -b feature/user-profile

# Complete feature
git checkout develop
git merge feature/user-profile

# Prepare release
git checkout -b release/1.2.0
# Test, fix bugs

# Release
git checkout main
git merge release/1.2.0
git tag 1.2.0

# Back-merge to develop
git checkout develop
git merge release/1.2.0
```

### Strategy 3: Trunk-Based Development

**Best for:** High-frequency releases, mature teams

```
main: A---B---C---D---E---F (always green)
       \  /  \  /  \  /
Short-lived branches
```

**Rules:**
1. Very short-lived feature branches (< 1 day)
2. Small, frequent merges
3. Feature flags for incomplete features
4. Heavy automated testing
5. Continuous integration

**Example:**
```bash
# Small feature
git checkout -b quick-fix
# ... make small change ...
git commit -m "fix: Adjust button padding"
git push origin quick-fix
# Immediately create and merge PR

# For incomplete features
if feature_flags['new-ui']:
    show_new_ui()
else:
    show_old_ui()
```

### Branch Naming Conventions

**Good branch names:**
```
feature/user-authentication
fix/login-button-alignment
refactor/database-layer
docs/api-documentation
test/add-integration-tests
```

**Bad branch names:**
```
mybranch
test
fix
john
asdf
```

**Convention:**
```
<type>/<description>

Types: feature, fix, refactor, docs, test, chore
```

## 🎯 When to Commit

### Commit Frequency

**Good practices:**
- ✅ Commit when you complete a logical unit of work
- ✅ Commit before switching tasks
- ✅ Commit at end of work session
- ✅ Commit after tests pass
- ✅ Commit before risky refactoring

**Avoid:**
- ❌ Committing broken code
- ❌ Committing half-finished features
- ❌ Giant commits with unrelated changes
- ❌ Going days without committing

### Atomic Commits

**One commit = one logical change**

**Good:**
```bash
# Commit 1
git add authentication.py tests/test_auth.py
git commit -m "feat: Add JWT authentication"

# Commit 2  
git add docs/api.md
git commit -m "docs: Document authentication endpoints"
```

**Bad:**
```bash
# One giant commit
git add .
git commit -m "Add authentication, fix bugs, update docs, refactor code"
```

### Commit Early, Commit Often

**Benefits:**
- Easy to revert specific changes
- Better history for debugging
- Easier code review
- Safer experimentation

**Example workflow:**
```bash
# Write test
git add tests/test_login.py
git commit -m "test: Add login validation test"

# Implement feature
git add login.py
git commit -m "feat: Add login validation"

# Update documentation
git add docs/login.md
git commit -m "docs: Document login validation"
```

## 🧹 Keeping Repository Clean

### Remove Sensitive Data

If you accidentally committed secrets:

```bash
# Install BFG Repo Cleaner
# https://rtyley.github.io/bfg-repo-cleaner/

# Remove passwords file
bfg --delete-files passwords.txt

# Clean repository
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

**Prevention is better:**
1. Use environment variables
2. Never hardcode secrets
3. Use `.gitignore`
4. Review commits before pushing

### Keep Commits Focused

**Bad:**
```bash
git commit -m "Fix login bug, add dark mode, update dependencies"
```

**Good:**
```bash
git commit -m "fix: Resolve login timeout issue"
git commit -m "feat: Add dark mode toggle"
git commit -m "chore: Update security dependencies"
```

### Rewriting History (Local Only!)

**Amend last commit:**
```bash
# Forgot to add file
git add forgotten_file.py
git commit --amend --no-edit

# Fix commit message
git commit --amend -m "Better message"
```

**Interactive rebase:**
```bash
# Clean up last 3 commits
git rebase -i HEAD~3

# Options:
# pick - keep commit
# reword - change message
# squash - combine with previous
# drop - delete commit
```

**⚠️ WARNING:** Only rewrite history on unpushed commits!

## 📋 Repository Structure

### Good project structure:
```
my-project/
├── .git/
├── .gitignore
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows/
├── docs/
├── src/
├── tests/
└── scripts/
```

### Essential files:

**README.md:**
```markdown
# Project Name

Brief description

## Installation
...

## Usage
...

## Contributing
...

## License
...
```

**LICENSE:**
- MIT, Apache 2.0, GPL, etc.
- Required for open source

**CONTRIBUTING.md:**
- How to contribute
- Coding standards
- PR process

## 🎯 Quick Reference Checklist

Before pushing:
- [ ] Commits have good messages
- [ ] No sensitive data committed
- [ ] .gitignore covers necessary files
- [ ] Tests pass
- [ ] Code follows project style
- [ ] Documentation updated

Before merging PR:
- [ ] PR description is clear
- [ ] Tests pass
- [ ] Code reviewed
- [ ] Conflicts resolved
- [ ] Branch up to date

## 📝 Practice Exercise

Create a well-structured repository:

```bash
# 1. Create repository
mkdir best-practices-demo
cd best-practices-demo
git init

# 2. Create .gitignore
cat > .gitignore << 'EOF'
# Virtual environment
venv/
.env

# IDE
.vscode/

# Python
__pycache__/
*.pyc

# OS
.DS_Store
EOF

git add .gitignore
git commit -m "chore: Add .gitignore"

# 3. Create README
cat > README.md << 'EOF'
# Best Practices Demo

Demonstrating Git best practices.

## Setup
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
EOF

git add README.md
git commit -m "docs: Add README with setup instructions"

# 4. Create main program
echo "print('Hello, DevOps!')" > main.py
git add main.py
git commit -m "feat: Add main program"

# 5. Add requirements
echo "requests==2.31.0" > requirements.txt
git add requirements.txt
git commit -m "chore: Add dependencies"

# 6. View clean history
git log --oneline
```

## ✅ Self-Check

Ensure you understand:

1. How to write professional commit messages
2. What belongs in .gitignore
3. Different branching strategies
4. When and how to commit
5. How to keep repository clean

## 🚀 Congratulations!

You've completed the Git and GitHub module! You now have:
- Solid understanding of version control
- Essential Git skills
- GitHub collaboration knowledge
- Professional best practices

**Next:** Move on to [Module 02: Command-Line Mastery](../02-Command-Line-Mastery/) to become proficient with the terminal.

**Keep practicing:**
- Use Git for all your projects
- Contribute to open source
- Review others' code
- Maintain clean repositories

Remember: **Git mastery comes from daily use, not from reading.** Make it a habit!
