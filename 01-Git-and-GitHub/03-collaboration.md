# GitHub Collaboration

## 🎯 Learning Objectives

- Fork repositories and understand forking workflow
- Create and manage pull requests
- Conduct code reviews
- Work with issues and project boards
- Collaborate effectively with teams

**Time: 90 minutes**

## 🤝 Why Collaboration Matters

Modern software development is rarely a solo activity. You'll work with:
- Other developers on your team
- Open source contributors worldwide
- Code reviewers ensuring quality
- Project managers tracking progress

GitHub provides tools for all of this.

## 🍴 Forking Workflow

### What is a Fork?

A fork is your personal copy of someone else's repository. You can:
- Make changes without affecting the original
- Experiment freely
- Submit improvements back via pull requests

**Think of it like:** Photocopying a book, adding notes, then showing your annotated version to the author.

### When to Fork

✅ Contributing to open source projects  
✅ You don't have write access to a repository  
✅ You want to experiment with someone's code  
✅ Creating your own version of a project  

### Forking Process

**1. Fork on GitHub:**
```
1. Visit repository (e.g., https://github.com/octocat/hello-world)
2. Click "Fork" button (top right)
3. Choose your account
4. GitHub creates your copy: github.com/YOUR-USERNAME/hello-world
```

**2. Clone your fork:**
```bash
# Clone your fork (not the original)
git clone https://github.com/YOUR-USERNAME/hello-world.git
cd hello-world
```

**3. Add upstream remote:**
```bash
# Add original repo as "upstream"
git remote add upstream https://github.com/octocat/hello-world.git

# Verify remotes
git remote -v
```

**Output:**
```
origin    https://github.com/YOUR-USERNAME/hello-world.git (fetch)
origin    https://github.com/YOUR-USERNAME/hello-world.git (push)
upstream  https://github.com/octocat/hello-world.git (fetch)
upstream  https://github.com/octocat/hello-world.git (push)
```

**4. Keep your fork updated:**
```bash
# Fetch updates from original
git fetch upstream

# Merge updates into your main
git checkout main
git merge upstream/main

# Push updates to your fork
git push origin main
```

## 🔀 Pull Requests (PRs)

### What is a Pull Request?

A pull request is a proposal to merge your changes into another repository. It:
- Shows what you changed (diff)
- Allows discussion and code review
- Enables automated testing
- Provides merge controls

### Creating a Pull Request

**Complete workflow:**

```bash
# 1. Fork and clone (see above)
git clone https://github.com/YOUR-USERNAME/hello-world.git
cd hello-world

# 2. Create feature branch
git checkout -b fix-typo-in-readme

# 3. Make changes
echo "Fixed typo" >> README.md
git add README.md
git commit -m "Fix typo in README"

# 4. Push to your fork
git push origin fix-typo-in-readme
```

**5. Create PR on GitHub:**
```
1. Go to your fork on GitHub
2. Click "Compare & pull request" button
3. Fill in PR details:
   - Title: "Fix typo in README"
   - Description: Explain what and why
4. Click "Create pull request"
```

### Pull Request Best Practices

#### Good PR Title and Description

**Good:**
```
Title: Fix authentication bug in login endpoint

Description:
## Problem
Users couldn't log in when using special characters in passwords.

## Solution
- Added proper URL encoding for passwords
- Updated validation regex
- Added tests for special characters

## Testing
- Manual testing with various password formats
- All existing tests pass
- Added new test cases

Fixes #123
```

**Bad:**
```
Title: fix stuff

Description:
changed some code
```

#### PR Checklist

Before submitting:
- ✅ Code works and is tested
- ✅ Follows project's style guide
- ✅ Includes tests (if applicable)
- ✅ Documentation updated
- ✅ Commit messages are clear
- ✅ PR description explains the change
- ✅ Linked to relevant issues

### Responding to PR Feedback

**Maintainer requests changes:**

```bash
# 1. Make requested changes locally
# Edit files as requested

# 2. Commit changes
git add .
git commit -m "Address review feedback: improve error handling"

# 3. Push to same branch
git push origin fix-typo-in-readme
```

**The PR automatically updates!** No need to create a new PR.

**If many small commits, consider squashing:**
```bash
# Combine last 3 commits into one
git rebase -i HEAD~3

# In editor, change 'pick' to 'squash' for commits to combine
# Save and exit
# Edit commit message
# Force push (be careful!)
git push --force origin fix-typo-in-readme
```

## 👀 Code Review

### As a Reviewer

**Good code reviews:**
- ✅ Are constructive and kind
- ✅ Explain why something should change
- ✅ Suggest alternatives
- ✅ Praise good code
- ✅ Catch bugs and security issues

**Review checklist:**
- Does code solve the stated problem?
- Is it readable and maintainable?
- Are there tests?
- Could it break existing functionality?
- Are there security concerns?
- Does it follow project conventions?

**Good review comments:**

✅ "This works, but we can simplify it using the builtin `filter()` function. Example: `list(filter(lambda x: x > 0, numbers))`"

✅ "Great use of error handling! Consider also catching `ValueError` here since the input could be non-numeric."

✅ "This is a clever solution! I like how you avoided the nested loop."

**Bad review comments:**

❌ "This is wrong."
❌ "Why would you do it this way?"
❌ "Terrible code."

### As a PR Author

**Receiving feedback:**
- Don't take it personally
- Ask for clarification if needed
- Explain your reasoning
- Be open to suggestions
- Thank reviewers

**Example response:**
```
Thanks for the feedback! You're right about the error handling.
I've added ValueError catching and updated the tests.

Regarding the filter() suggestion - I considered it but went with
the explicit loop for readability since this codebase avoids lambda.
Let me know if you feel strongly about changing it.
```

## 📋 Issues

### What are Issues?

GitHub Issues are:
- Bug reports
- Feature requests
- Tasks
- Questions
- Discussions

### Creating Good Issues

**Bug report template:**
```markdown
## Description
Brief description of the bug.

## Steps to Reproduce
1. Go to login page
2. Enter email: test@example.com
3. Enter password: test123
4. Click login button

## Expected Behavior
User should be logged in.

## Actual Behavior
Error message: "Invalid credentials"

## Environment
- Browser: Chrome 120
- OS: Windows 11
- App version: 1.2.3

## Screenshots
[Attach screenshot if relevant]

## Additional Context
This only happens with some email addresses.
```

**Feature request template:**
```markdown
## Feature Description
Add dark mode to the application.

## Problem It Solves
Users working at night find the bright interface straining.

## Proposed Solution
- Add dark mode toggle in settings
- Store preference in localStorage
- Apply dark theme CSS

## Alternatives Considered
- Auto dark mode based on system preference
- Scheduled dark mode (dark at night, light during day)

## Additional Context
Many competitors have this feature. 67% of users in our survey requested it.
```

### Working with Issues

```bash
# Reference issue in commit
git commit -m "Add dark mode toggle (closes #42)"

# Link PR to issue
# In PR description:
# "Fixes #42" or "Closes #42" or "Resolves #42"
```

When PR merges, linked issue automatically closes!

### Issue Labels

Common labels:
- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Documentation improvements
- `good first issue` - Easy for newcomers
- `help wanted` - Need community help
- `priority: high` - Urgent
- `wontfix` - Won't work on this

## 🎯 Complete Collaboration Example

Let's contribute to an open source project:

### Step 1: Find a Project

Look for:
- `good first issue` label
- Active maintainers
- Clear contribution guidelines
- Welcoming community

### Step 2: Fork and Set Up

```bash
# Fork on GitHub, then:
git clone https://github.com/YOUR-USERNAME/project.git
cd project
git remote add upstream https://github.com/original/project.git
```

### Step 3: Create Feature Branch

```bash
# Update your fork
git checkout main
git pull upstream main
git push origin main

# Create feature branch
git checkout -b fix-issue-42
```

### Step 4: Make Changes

```bash
# Make your changes
# Test thoroughly
# Follow project style

# Commit
git add .
git commit -m "Fix login validation (fixes #42)"

# Push
git push origin fix-issue-42
```

### Step 5: Create Pull Request

On GitHub:
1. Go to original repository
2. Click "Pull requests" → "New pull request"
3. Click "compare across forks"
4. Select your fork and branch
5. Fill in details:

```markdown
## Description
Fixes the login validation bug reported in #42.

## Changes
- Added email format validation
- Updated error messages
- Added unit tests

## Testing
- All existing tests pass
- Added 3 new test cases
- Manually tested with various email formats

Fixes #42
```

### Step 6: Respond to Feedback

```bash
# Make requested changes
# ... edit files ...

git add .
git commit -m "Address review: improve error messages"
git push origin fix-issue-42
```

### Step 7: After Merge

```bash
# Update your fork
git checkout main
git pull upstream main
git push origin main

# Delete feature branch
git branch -d fix-issue-42
git push origin --delete fix-issue-42
```

## 🏢 Team Workflows

### Workflow 1: Fork and PR (Open Source)

```
Maintainer's Repo
       ↓ (fork)
Your Fork
       ↓ (clone)
Local Machine
       ↓ (push)
Your Fork
       ↓ (PR)
Maintainer's Repo
```

### Workflow 2: Shared Repository (Team)

```
Team Repository
       ↓ (clone)
Local Machine
       ↓ (push feature branch)
Team Repository
       ↓ (PR)
Team Repository main branch
```

**No forking needed!** Team members push branches directly.

```bash
# Clone team repo
git clone https://github.com/company/project.git
cd project

# Create feature branch
git checkout -b feature-new-api

# Make changes, commit, push
git push origin feature-new-api

# Create PR on GitHub
# After review and merge, clean up
git checkout main
git pull
git branch -d feature-new-api
```

## 🔒 Protected Branches

Teams often protect the `main` branch:

**Protection rules:**
- ✅ Require pull request reviews
- ✅ Require status checks (tests must pass)
- ✅ Prevent force pushes
- ✅ Require signed commits

**Result:** Can't push directly to main. Must use PRs.

```bash
# This will fail if main is protected:
git checkout main
git push origin main

# Must use feature branches and PRs
```

## 🎯 GitHub Features for Teams

### 1. Code Owners

Create `.github/CODEOWNERS`:
```
# Auto-assign reviewers based on files changed
*.js @frontend-team
*.py @backend-team
/docs/ @docs-team
```

### 2. PR Templates

Create `.github/pull_request_template.md`:
```markdown
## Description
[Describe your changes]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Checklist
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Code follows style guidelines
```

### 3. Issue Templates

Create `.github/ISSUE_TEMPLATE/bug_report.md`:
```markdown
---
name: Bug Report
about: Report a bug
title: '[BUG] '
labels: bug
assignees: ''
---

## Describe the bug
[Clear description]

## To Reproduce
Steps to reproduce...

## Expected behavior
What should happen...
```

## 🐛 Common Collaboration Issues

### Issue: "Can't push to repository"

**Problem:** No write access.

**Solution:** Fork the repository and create a PR.

### Issue: "PR has conflicts"

**Problem:** Target branch changed after you created your branch.

**Solution:**
```bash
# Update your branch
git checkout main
git pull upstream main
git checkout your-feature-branch
git rebase main

# Resolve conflicts if any
# Force push (your branch only!)
git push --force origin your-feature-branch
```

### Issue: "Accidentally committed to main"

**Solution:**
```bash
# Create branch from current state
git checkout -b feature-branch

# Reset main to remote
git checkout main
git reset --hard origin/main

# Continue working on feature-branch
git checkout feature-branch
```

## 📝 Practice Exercise

**Find and contribute to a real open source project:**

1. **Find a project:**
   - Go to https://github.com/topics/good-first-issue
   - Or search: "good first issue" + your favorite language

2. **Read contribution guidelines:**
   - Look for `CONTRIBUTING.md`
   - Follow their process

3. **Make a small contribution:**
   - Fix a typo in documentation
   - Improve a comment
   - Add a test case

4. **Submit a PR:**
   - Follow the template
   - Be patient
   - Respond to feedback

**This is how you build your GitHub profile!**

## ✅ Self-Check

Before continuing, ensure you can:

1. Fork a repository and keep it updated
2. Create clear, focused pull requests
3. Conduct constructive code reviews
4. Work with issues and labels
5. Explain different collaboration workflows

## 🚀 Next Steps

Fantastic! You now know how professionals collaborate.

**Next:** Learn [Best Practices](./04-best-practices.md) to write better commits and maintain clean repositories.

**Practice:**
- Find an open source project and read their CONTRIBUTING.md
- Create a practice repo and invite a friend to collaborate
- Review some pull requests on GitHub (even just reading them helps)
- Complete [Exercise 3](./exercises/exercise-3-collaboration.md)
