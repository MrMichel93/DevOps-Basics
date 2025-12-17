# Exercise 1: Your First Repository

## 🎯 Objectives

- Create a Git repository from scratch
- Make commits with good messages
- Push to GitHub
- Understand the basic Git workflow

**Time:** 30 minutes

## 📋 Prerequisites

- Git installed and configured
- GitHub account created
- Basic understanding of command line

## 🚀 Instructions

### Part 1: Create Local Repository

**1. Create a new project directory**

```bash
mkdir my-first-git-repo
cd my-first-git-repo
```

**2. Initialize Git**

```bash
git init
```

✅ **Checkpoint:** Run `ls -la` and verify you see a `.git` directory

**3. Create a README file**

```bash
cat > README.md << 'EOF'
# My First Git Repository

This is my first project using Git and GitHub.

## About
Learning DevOps basics through hands-on practice.

## Author
[Your Name]
EOF
```

**4. Check repository status**

```bash
git status
```

📝 **Question:** What does Git say about README.md?

**5. Stage the README file**

```bash
git add README.md
git status
```

📝 **Question:** How did the status change?

**6. Make your first commit**

```bash
git commit -m "Initial commit: Add README"
```

**7. View your commit history**

```bash
git log
git log --oneline
```

### Part 2: Add More Content

**8. Create a Python script**

```bash
cat > hello.py << 'EOF'
#!/usr/bin/env python3

def greet(name):
    """Return a greeting message."""
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(greet("DevOps Engineer"))
EOF
```

**9. Create a .gitignore file**

```bash
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.venv/

# IDE
.vscode/
.idea/
*.swp

# OS
.DS_Store
Thumbs.db
EOF
```

**10. Stage and commit both files**

```bash
git add hello.py .gitignore
git status
git commit -m "Add hello script and gitignore"
```

**11. Create a requirements file**

```bash
echo "# Python dependencies" > requirements.txt
echo "# Add your dependencies here" >> requirements.txt
git add requirements.txt
git commit -m "Add requirements file"
```

### Part 3: Push to GitHub

**12. Create repository on GitHub**

1. Go to https://github.com
2. Click the "+" icon → "New repository"
3. Repository name: `my-first-git-repo`
4. Description: "Learning Git and GitHub"
5. Keep it **Public**
6. **Don't** initialize with README, .gitignore, or license
7. Click "Create repository"

**13. Add remote and push**

```bash
# Add remote (replace YOUR-USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR-USERNAME/my-first-git-repo.git

# Verify remote
git remote -v

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

✅ **Checkpoint:** Visit your repository on GitHub. You should see all your files!

### Part 4: Make Changes and Push Again

**14. Update the README**

```bash
cat >> README.md << 'EOF'

## Features
- Python greeting script
- Proper .gitignore setup
- Clean project structure

## Usage
```bash
python hello.py
```
EOF
```

**15. Test and commit**

```bash
# Test the script
python hello.py

# Check what changed
git diff

# Stage and commit
git add README.md
git commit -m "docs: Add features and usage sections"

# Push changes
git push
```

**16. Create a LICENSE file**

```bash
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2024 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

git add LICENSE
git commit -m "Add MIT license"
git push
```

### Part 5: Practice Making Changes

**17. Enhance the Python script**

```bash
cat > hello.py << 'EOF'
#!/usr/bin/env python3
import sys

def greet(name):
    """Return a greeting message."""
    return f"Hello, {name}!"

def main():
    if len(sys.argv) > 1:
        name = sys.argv[1]
    else:
        name = "DevOps Engineer"
    
    print(greet(name))

if __name__ == "__main__":
    main()
EOF

# Test with argument
python hello.py "Your Name"

# Commit
git add hello.py
git commit -m "feat: Add command line argument support"
git push
```

**18. View your complete history**

```bash
git log --oneline --graph --all
```

## ✅ Verification

Check that you've completed all steps:

- [ ] Created local Git repository
- [ ] Made multiple commits with good messages
- [ ] Created repository on GitHub
- [ ] Pushed code to GitHub
- [ ] Made additional changes and pushed again
- [ ] Can view history with `git log`

**Verify on GitHub:**
- [ ] Repository contains all files
- [ ] Commit history is visible
- [ ] README displays nicely

## 🎯 Challenges (Optional)

Try these to practice more:

### Challenge 1: Add More Features

Add a new file `calculator.py`:

```python
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

if __name__ == "__main__":
    print(f"2 + 3 = {add(2, 3)}")
    print(f"5 - 2 = {subtract(5, 2)}")
```

Commit and push it.

### Challenge 2: Update Requirements

Add actual Python dependencies:
```bash
echo "requests==2.31.0" >> requirements.txt
git add requirements.txt
git commit -m "chore: Add requests dependency"
git push
```

### Challenge 3: Create Contributing Guidelines

Create `CONTRIBUTING.md` with guidelines for others who want to contribute. Commit and push.

### Challenge 4: Add a GitHub Action

Create `.github/workflows/test.yml`:

```yaml
name: Test

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.x'
      - name: Run script
        run: python hello.py
```

Commit and push. Check the Actions tab on GitHub!

## 📝 Reflection Questions

After completing the exercise, answer these:

1. **What's the difference between staging and committing?**
   
2. **Why do we push to a remote repository?**
   
3. **What would happen if you made changes but forgot to commit before pushing?**
   
4. **How would you check what changed in a file before committing?**
   
5. **Why is .gitignore important?**

## 🆘 Troubleshooting

### Issue: "Permission denied (publickey)"

**Solution:** Use HTTPS instead of SSH:
```bash
git remote set-url origin https://github.com/YOUR-USERNAME/my-first-git-repo.git
```

Or set up SSH keys: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

### Issue: "Updates were rejected"

**Solution:** Pull first, then push:
```bash
git pull origin main
git push origin main
```

### Issue: "fatal: not a git repository"

**Solution:** Make sure you're in the right directory:
```bash
cd my-first-git-repo
git status
```

### Issue: Can't push to GitHub

**Solution:** Check if remote is set correctly:
```bash
git remote -v
# Should show your GitHub repository URL
```

## 🎓 What You Learned

- ✅ Initializing Git repositories
- ✅ Staging and committing changes
- ✅ Writing good commit messages
- ✅ Creating repositories on GitHub
- ✅ Pushing to remote repositories
- ✅ Basic Git workflow

## 🚀 Next Steps

1. Complete [Exercise 2: Branching](./exercise-2-branching.md)
2. Practice by creating more repositories
3. Try modifying files and committing changes
4. Explore your repository on GitHub

**Remember:** The best way to learn Git is by using it daily!
