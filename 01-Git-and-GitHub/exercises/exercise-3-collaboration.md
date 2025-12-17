# Exercise 3: GitHub Collaboration

## 🎯 Objectives

- Fork a repository
- Create pull requests
- Conduct code reviews
- Work with issues
- Understand collaborative workflows

**Time:** 45-60 minutes

## 📋 Prerequisites

- Completed Exercises 1 and 2
- GitHub account
- Understanding of branches and merging

## 🚀 Instructions

### Part 1: Fork and Clone a Repository

For this exercise, you'll work with a practice repository.

**1. Fork the practice repository**

*Note: For this exercise, you can fork any small public repository or create a practice one. We'll use a hypothetical example.*

```
1. Visit https://github.com/octocat/Hello-World (or any simple repository)
2. Click "Fork" button (top right)
3. Select your account as the destination
4. Wait for fork to complete
```

You now have a copy at: `github.com/YOUR-USERNAME/Hello-World`

**2. Clone your fork**

```bash
# Clone YOUR fork (not the original)
git clone https://github.com/YOUR-USERNAME/Hello-World.git
cd Hello-World
```

**3. Add upstream remote**

```bash
# Add original repository as "upstream"
git remote add upstream https://github.com/octocat/Hello-World.git

# Verify remotes
git remote -v
```

You should see:
```
origin    https://github.com/YOUR-USERNAME/Hello-World.git (fetch)
origin    https://github.com/YOUR-USERNAME/Hello-World.git (push)
upstream  https://github.com/octocat/Hello-World.git (fetch)
upstream  https://github.com/octocat/Hello-World.git (push)
```

### Part 2: Make Changes and Create Pull Request

**4. Create a feature branch**

```bash
git checkout -b add-your-name
```

**5. Make your contribution**

```bash
# Add your name to a contributors file
cat >> CONTRIBUTORS.md << 'EOF'
- Your Name (@your-github-username)
EOF

git add CONTRIBUTORS.md
git commit -m "docs: Add [Your Name] to contributors"
```

**6. Push to your fork**

```bash
git push -u origin add-your-name
```

**7. Create Pull Request on GitHub**

```
1. Go to your fork on GitHub
2. Click "Compare & pull request" button
3. Ensure base repository is the original (upstream)
4. Fill in PR details:

Title: Add [Your Name] to contributors

Description:
## Changes
Added my name to the contributors list.

## Checklist
- [x] Added name to CONTRIBUTORS.md
- [x] Used proper markdown formatting
- [x] Verified no typos

5. Click "Create pull request"
```

### Part 3: Simulate Code Review

Since you can't review your own PR, let's practice review skills locally.

**8. Create a practice repository for code review**

```bash
cd ..
mkdir code-review-practice
cd code-review-practice
git init

# Create a simple Python script with issues
cat > calculator.py << 'EOF'
def add(a,b):
    return a+b

def subtract(a, b):
    result = a-b
    return result

def multiply(x, y):
    return x * y

def divide(a,b):
    return a/b

# Main
if __name__ == '__main__':
    print(add(2, 3))
    print(subtract(10,5))
    print(multiply(4, 5))
    print(divide(10, 2))
EOF

git add calculator.py
git commit -m "Add calculator"
```

**9. Create a PR-style branch**

```bash
git checkout -b improve-calculator

# Improve the code (fix issues you noticed)
cat > calculator.py << 'EOF'
"""Simple calculator module."""

def add(a, b):
    """Add two numbers."""
    return a + b


def subtract(a, b):
    """Subtract b from a."""
    return a - b


def multiply(a, b):
    """Multiply two numbers."""
    return a * b


def divide(a, b):
    """Divide a by b."""
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b


if __name__ == '__main__':
    print(f"2 + 3 = {add(2, 3)}")
    print(f"10 - 5 = {subtract(10, 5)}")
    print(f"4 * 5 = {multiply(4, 5)}")
    print(f"10 / 2 = {divide(10, 2)}")
EOF

git add calculator.py
git commit -m "refactor: Improve calculator code quality

- Add docstrings to all functions
- Add proper spacing (PEP 8)
- Add zero division check
- Improve output formatting"
```

**10. Review your changes**

```bash
# View the diff
git diff main improve-calculator

# View commit
git show HEAD
```

### Part 4: Working with Issues

**11. Create Issues locally (simulated)**

Create issue templates:

```bash
cat > .github/ISSUE_TEMPLATE/bug_report.md << 'EOF'
---
name: Bug Report
about: Report a bug
title: '[BUG] '
labels: bug
---

## Describe the bug
A clear description of the bug.

## To Reproduce
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. See error

## Expected behavior
What you expected to happen.

## Screenshots
If applicable, add screenshots.

## Environment
- OS: [e.g. Ubuntu 22.04]
- Browser: [e.g. Chrome 120]
- Version: [e.g. 1.0.0]
EOF

mkdir -p .github/ISSUE_TEMPLATE

cat > .github/ISSUE_TEMPLATE/feature_request.md << 'EOF'
---
name: Feature Request
about: Suggest a feature
title: '[FEATURE] '
labels: enhancement
---

## Feature Description
Clear description of the feature.

## Problem It Solves
What problem does this solve?

## Proposed Solution
How should it work?

## Alternatives Considered
Other solutions you considered.
EOF

git add .github
git commit -m "docs: Add issue templates"
```

### Part 5: Keeping Your Fork Updated

**12. Fetch upstream changes**

```bash
# Fetch from original repository
git fetch upstream

# View branches
git branch -a
```

**13. Merge upstream changes**

```bash
# Switch to main
git checkout main

# Merge upstream/main
git merge upstream/main

# Push to your fork
git push origin main
```

### Part 6: Practice PR Workflow

**14. Simulate a complete PR workflow**

```bash
# Create new feature
git checkout -b feature/add-modulo

cat >> calculator.py << 'EOF'


def modulo(a, b):
    """Return remainder of a divided by b."""
    if b == 0:
        raise ValueError("Cannot perform modulo with zero")
    return a % b
EOF

git add calculator.py
git commit -m "feat: Add modulo function"

# Add tests
cat > test_calculator.py << 'EOF'
"""Tests for calculator module."""
from calculator import add, subtract, multiply, divide, modulo

def test_add():
    assert add(2, 3) == 5

def test_subtract():
    assert subtract(10, 5) == 5

def test_multiply():
    assert multiply(4, 5) == 20

def test_divide():
    assert divide(10, 2) == 5

def test_modulo():
    assert modulo(10, 3) == 1

print("All tests passed!")
EOF

git add test_calculator.py
git commit -m "test: Add tests for calculator functions"

# Run tests
python test_calculator.py
```

**15. Simulate review feedback**

Make improvements based on feedback:

```bash
# Add documentation
cat > README.md << 'EOF'
# Calculator Module

A simple calculator module with basic arithmetic operations.

## Functions

- `add(a, b)` - Add two numbers
- `subtract(a, b)` - Subtract b from a
- `multiply(a, b)` - Multiply two numbers
- `divide(a, b)` - Divide a by b
- `modulo(a, b)` - Return remainder of a divided by b

## Usage

```python
from calculator import add, multiply

result = add(2, 3)        # 5
result = multiply(4, 5)   # 20
```

## Testing

```bash
python test_calculator.py
```
EOF

git add README.md
git commit -m "docs: Add comprehensive README"
```

**16. Merge to main**

```bash
git checkout main
git merge feature/add-modulo
git branch -d feature/add-modulo
```

### Part 7: Create PR Template

**17. Add PR template**

```bash
git checkout -b add-pr-template

cat > .github/pull_request_template.md << 'EOF'
## Description
[Describe your changes here]

## Type of Change
- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## How Has This Been Tested?
[Describe the tests you ran]

## Checklist
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes

## Related Issues
Closes #[issue number]
EOF

git add .github/pull_request_template.md
git commit -m "docs: Add pull request template"
git push origin add-pr-template
```

## ✅ Verification

Check that you've completed:

- [ ] Forked a repository
- [ ] Cloned your fork locally
- [ ] Added upstream remote
- [ ] Created a feature branch
- [ ] Made commits with good messages
- [ ] Pushed branch to fork
- [ ] Created pull request (or simulated the process)
- [ ] Created issue templates
- [ ] Created PR template
- [ ] Updated fork from upstream

## 🎯 Challenges (Optional)

### Challenge 1: Contribute to Real Open Source

Find a real open source project and contribute:

1. Search for "good first issue" on GitHub
2. Find a project you're interested in
3. Read CONTRIBUTING.md
4. Fork, fix, and submit a real PR!

**Suggested beginner-friendly projects:**
- Documentation improvements
- Test coverage
- Bug fixes with detailed issues
- Projects tagged "good first issue"

### Challenge 2: Code Review Practice

Partner with a friend:
1. Both fork the same repository
2. Make different changes
3. Review each other's pull requests
4. Practice giving constructive feedback

### Challenge 3: Complex PR Workflow

Simulate a complex workflow:
1. Create PR
2. Receive feedback (simulate)
3. Make changes in response
4. Handle merge conflicts
5. Squash commits before merge

### Challenge 4: Multi-Person Workflow

With 2-3 people:
1. Create a shared repository
2. Each person creates a feature branch
3. Submit PRs to each other
4. Review and request changes
5. Merge after approval

## 📝 Reflection Questions

1. **Why do we fork instead of cloning the original repository?**

2. **What's the purpose of the upstream remote?**

3. **When should you create an issue vs a pull request?**

4. **How do you handle feedback on your pull request?**

5. **What makes a good code review comment?**

## 🆘 Troubleshooting

### Issue: Can't push to original repository

**Solution:** This is normal! You should push to your fork:
```bash
git remote -v
# Should push to origin (your fork), not upstream
```

### Issue: Fork is behind upstream

**Solution:** Sync your fork:
```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

### Issue: PR shows wrong commits

**Solution:** Make sure you created branch from main:
```bash
git checkout main
git pull upstream main
git checkout -b new-branch
```

### Issue: Merge conflict in PR

**Solution:** Update your branch:
```bash
git fetch upstream
git rebase upstream/main
# Resolve conflicts
git push --force origin your-branch
```

## 🎓 What You Learned

- ✅ Forking workflow
- ✅ Creating pull requests
- ✅ Code review practices
- ✅ Working with issues
- ✅ PR and issue templates
- ✅ Keeping forks updated
- ✅ Collaborative Git workflows

## 🚀 Next Steps

1. Find and contribute to real open source projects
2. Start using PRs in your own projects
3. Practice code review skills
4. Explore GitHub features (Actions, Projects, Wiki)

**Pro Tip:** Contributing to open source is one of the best ways to:
- Build your portfolio
- Learn from experienced developers
- Practice collaboration
- Give back to the community

Start small (documentation, tests) and work your way up!

---

**Congratulations!** You've completed all Git and GitHub exercises. You now have practical experience with professional development workflows!

[Back to Module 01](../README.md) | Continue to [Module 02: Command Line Mastery](../../02-Command-Line-Mastery/)
