# Exercise 2: Branching and Merging

## 🎯 Objectives

- Create and switch between branches
- Make commits on different branches
- Merge branches
- Resolve merge conflicts
- Understand branching workflows

**Time:** 45 minutes

## 📋 Prerequisites

- Completed Exercise 1
- Understanding of basic Git commands
- Git repository on GitHub

## 🚀 Instructions

### Part 1: Create Feature Branch

**1. Start with a fresh repository or use your existing one**

```bash
# If creating new:
mkdir git-branching-practice
cd git-branching-practice
git init

# Create initial file
echo "# Git Branching Practice" > README.md
git add README.md
git commit -m "Initial commit"

# If using existing repo:
cd my-first-git-repo
git checkout main
git pull
```

**2. Create a feature branch**

```bash
git checkout -b feature/add-math-functions
```

✅ **Checkpoint:** Run `git branch` and verify you see both `main` and `feature/add-math-functions` with an asterisk next to the feature branch.

**3. Create a math module**

```bash
cat > math_utils.py << 'EOF'
"""Math utility functions."""

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
EOF

git add math_utils.py
git commit -m "feat: Add basic math functions"
```

**4. Create tests**

```bash
cat > test_math.py << 'EOF'
"""Tests for math utilities."""
from math_utils import add, subtract, multiply, divide

def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0

def test_subtract():
    assert subtract(5, 3) == 2
    assert subtract(3, 5) == -2

def test_multiply():
    assert multiply(2, 3) == 6
    assert multiply(-2, 3) == -6

def test_divide():
    assert divide(6, 2) == 3
    assert divide(5, 2) == 2.5

print("All tests passed!")
EOF

git add test_math.py
git commit -m "test: Add tests for math functions"
```

**5. Test your code**

```bash
python test_math.py
```

### Part 2: Create Another Branch

**6. Switch back to main**

```bash
git checkout main
```

📝 **Question:** Run `ls`. Do you see `math_utils.py`? Why or why not?

**7. Create another feature branch from main**

```bash
git checkout -b feature/add-documentation
```

**8. Create documentation**

```bash
cat > USAGE.md << 'EOF'
# Usage Guide

## Installation

```bash
git clone <repository-url>
cd <repository-name>
```

## Running Tests

```bash
python test_math.py
```

## Examples

```python
from math_utils import add, subtract, multiply, divide

result = add(10, 5)        # 15
result = subtract(10, 5)   # 5
result = multiply(10, 5)   # 50
result = divide(10, 5)     # 2.0
```
EOF

git add USAGE.md
git commit -m "docs: Add usage guide"
```

**9. Update README**

```bash
cat >> README.md << 'EOF'

## Documentation

See [USAGE.md](./USAGE.md) for detailed usage instructions.

## Features

- Basic arithmetic operations
- Comprehensive test suite
- Easy to use API
EOF

git add README.md
git commit -m "docs: Update README with documentation link"
```

### Part 3: Merge Branches

**10. View all branches**

```bash
git branch -a
git log --oneline --graph --all
```

**11. Merge first feature branch**

```bash
# Switch to main
git checkout main

# Merge math functions
git merge feature/add-math-functions
```

This should be a **fast-forward merge** (no merge commit needed).

**12. Verify files**

```bash
ls
# Should now see math_utils.py and test_math.py
```

**13. Merge documentation branch**

```bash
git merge feature/add-documentation
```

This creates a **merge commit** because main has moved forward.

### Part 4: Create and Resolve Merge Conflict

**14. Create two branches that conflict**

```bash
# First, ensure you're on main
git checkout main

# Create branch A
git checkout -b feature/modify-readme-a

# Modify README
cat > README.md << 'EOF'
# Git Branching Practice

This project demonstrates Git branching workflows.

## Overview
A comprehensive example of branch management.

## Documentation
See [USAGE.md](./USAGE.md) for detailed usage instructions.

## Features
- Basic arithmetic operations
- Comprehensive test suite
- Easy to use API
EOF

git add README.md
git commit -m "docs: Improve README overview"
```

**15. Create conflicting branch**

```bash
# Go back to main
git checkout main

# Create branch B
git checkout -b feature/modify-readme-b

# Make different change to same section
cat > README.md << 'EOF'
# Git Branching Practice

This project shows advanced Git techniques.

## About This Project
An educational repository for learning Git.

## Documentation
See [USAGE.md](./USAGE.md) for detailed usage instructions.

## Features
- Basic arithmetic operations
- Comprehensive test suite
- Easy to use API
EOF

git add README.md
git commit -m "docs: Add project description"
```

**16. Merge first branch (no conflict)**

```bash
git checkout main
git merge feature/modify-readme-a
```

**17. Try to merge second branch (conflict!)**

```bash
git merge feature/modify-readme-b
```

You should see: `CONFLICT (content): Merge conflict in README.md`

**18. View the conflict**

```bash
cat README.md
```

You'll see something like:
```
<<<<<<< HEAD
This project demonstrates Git branching workflows.

## Overview
A comprehensive example of branch management.
=======
This project shows advanced Git techniques.

## About This Project
An educational repository for learning Git.
>>>>>>> feature/modify-readme-b
```

**19. Resolve the conflict**

Edit `README.md` to combine both changes:

```bash
cat > README.md << 'EOF'
# Git Branching Practice

This project demonstrates advanced Git techniques and branching workflows.

## About This Project
A comprehensive educational repository for learning Git branch management.

## Documentation
See [USAGE.md](./USAGE.md) for detailed usage instructions.

## Features
- Basic arithmetic operations
- Comprehensive test suite
- Easy to use API
EOF
```

**20. Complete the merge**

```bash
# Stage the resolved file
git add README.md

# Verify status
git status

# Complete the merge
git commit -m "Merge feature/modify-readme-b: Resolve README conflicts"
```

**21. View the history**

```bash
git log --oneline --graph --all
```

You should see a merge commit!

### Part 5: Clean Up Branches

**22. Delete merged branches**

```bash
# List all branches
git branch

# Delete feature branches
git branch -d feature/add-math-functions
git branch -d feature/add-documentation
git branch -d feature/modify-readme-a
git branch -d feature/modify-readme-b

# Verify
git branch
```

### Part 6: Practice Rebasing (Optional)

**23. Create a new feature branch**

```bash
git checkout -b feature/add-power-function

cat >> math_utils.py << 'EOF'

def power(base, exponent):
    """Raise base to exponent power."""
    return base ** exponent
EOF

git add math_utils.py
git commit -m "feat: Add power function"
```

**24. Make changes on main**

```bash
# Switch to main
git checkout main

# Add a comment to README
echo "" >> README.md
echo "## License" >> README.md
echo "MIT License" >> README.md

git add README.md
git commit -m "docs: Add license section"
```

**25. Rebase feature branch**

```bash
# Switch back to feature branch
git checkout feature/add-power-function

# Rebase onto main
git rebase main
```

**26. Merge the rebased branch**

```bash
git checkout main
git merge feature/add-power-function

# Should be a fast-forward merge!
git log --oneline --graph
```

**27. Clean up**

```bash
git branch -d feature/add-power-function
```

## ✅ Verification

Check that you've completed:

- [ ] Created multiple feature branches
- [ ] Made commits on different branches
- [ ] Merged branches successfully
- [ ] Resolved a merge conflict
- [ ] Used `git log --oneline --graph` to visualize branches
- [ ] Deleted merged branches
- [ ] (Optional) Performed a rebase

## 🎯 Challenges (Optional)

### Challenge 1: Three-Way Merge

Create three branches from main, make different changes in each, and merge them all one by one. Observe the merge commits.

### Challenge 2: Complex Conflict

Create a conflict involving multiple files and resolve them all.

### Challenge 3: Interactive Rebase

Make several commits on a feature branch, then use `git rebase -i` to squash them into a single commit before merging.

```bash
git checkout -b feature/multiple-commits
# Make 3-4 small commits
git rebase -i HEAD~4
# Change 'pick' to 'squash' for commits you want to combine
```

### Challenge 4: Push Branches to GitHub

```bash
# Push a feature branch
git checkout -b feature/new-feature
# Make changes
git add .
git commit -m "feat: Add new feature"
git push -u origin feature/new-feature

# Create a Pull Request on GitHub
# Merge via GitHub interface
# Pull changes locally
git checkout main
git pull
```

## 📝 Reflection Questions

1. **What's the difference between merging and rebasing?**

2. **When would you use a feature branch?**

3. **How do you know if a merge will cause a conflict?**

4. **Why is it important to delete merged branches?**

5. **What does the `--graph` flag do in `git log`?**

## 🆘 Troubleshooting

### Issue: Can't switch branches - uncommitted changes

**Solution:** Either commit or stash:
```bash
# Option 1: Commit
git add .
git commit -m "WIP: Work in progress"

# Option 2: Stash
git stash
git checkout other-branch
# Later: git stash pop
```

### Issue: Merge conflict is too complex

**Solution:** Abort and try again:
```bash
git merge --abort
# Review changes more carefully
# Try smaller, incremental merges
```

### Issue: Deleted branch by mistake

**Solution:** Recover from reflog:
```bash
git reflog
# Find the commit where branch was
git checkout -b branch-name commit-hash
```

## 🎓 What You Learned

- ✅ Creating and switching between branches
- ✅ Fast-forward vs three-way merges
- ✅ Identifying and resolving merge conflicts
- ✅ Visualizing branch history
- ✅ Cleaning up merged branches
- ✅ (Optional) Rebasing branches

## 🚀 Next Steps

1. Complete [Exercise 3: Collaboration](./exercise-3-collaboration.md)
2. Practice branching in your own projects
3. Try creating branches for every new feature
4. Get comfortable with merge conflicts - they're normal!

**Pro Tip:** Professional developers create branches for every feature, no matter how small. Get in this habit early!
