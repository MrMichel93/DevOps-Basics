# Module 01: Git and GitHub

## 🎯 Learning Objectives

By the end of this module, you will be able to:

- ✅ Understand version control concepts and why they matter
- ✅ Use essential Git commands confidently
- ✅ Work with branches and manage merge conflicts
- ✅ Collaborate with others using GitHub workflows
- ✅ Write effective commit messages and follow best practices
- ✅ Participate in code reviews through pull requests

**Time Required**: 6-8 hours

## 📚 Why This Matters

### The Problem Git Solves

Imagine working on a project without version control:

- 📁 `project_final.zip`
- 📁 `project_final_v2.zip`
- 📁 `project_final_ACTUALLY_FINAL.zip`
- 📁 `project_final_USE_THIS_ONE.zip`

Sound familiar? This is chaos. Now add multiple developers and it becomes impossible.

**Git solves this by:**

- **Tracking every change** - See who changed what, when, and why
- **Enabling experimentation** - Try new features without breaking working code
- **Facilitating collaboration** - Multiple people can work simultaneously
- **Providing backups** - Never lose work (if you commit regularly)
- **Supporting rollback** - Undo mistakes by reverting to previous versions

### Real-World Scenarios

**Scenario 1: The Critical Bug**
> Production is down! A recent change broke everything. With Git, you can:
>
> 1. Identify the problematic commit with `git log`
> 2. See exactly what changed with `git diff`
> 3. Revert the bad commit with `git revert`
> 4. Deploy the fix in minutes, not hours

**Scenario 2: The Parallel Features**
> Two teams need to work on different features simultaneously. With Git:
>
> 1. Each team creates a feature branch
> 2. They work independently without conflicts
> 3. Features are reviewed via pull requests
> 4. Branches are merged when ready

**Scenario 3: The "Who Changed This?"**
> Some code is broken but you don't know why. With Git:
>
> 1. Use `git blame` to see who wrote each line
> 2. Find the relevant commit with `git log`
> 3. See the full context of the change
> 4. Contact the author if needed

## 🗺️ Module Structure

This module is organized into progressive lessons:

### 1. [Basic Commands](./01-basic-commands.md)

Start here! Learn the fundamental Git operations you'll use every day.

- Initializing repositories
- Adding and committing changes
- Viewing history
- Pushing to and pulling from remote repositories

### 2. [Branching](./02-branching.md)

Master Git's "killer feature" - branches enable fearless development.

- Creating and switching branches
- Merging branches
- Resolving conflicts
- Rebasing (when appropriate)

### 3. [Collaboration](./03-collaboration.md)

Learn GitHub workflows used by professional teams.

- Forking repositories
- Creating pull requests
- Code reviews
- Working with others

### 4. [Best Practices](./04-best-practices.md)

Write better commits, maintain cleaner history, and work like a pro.

- Commit message conventions
- `.gitignore` files
- Branching strategies
- When to commit

## 🏋️ Hands-On Exercises

Practice makes perfect. Complete these exercises:

### [Exercise 1: Your First Repository](./exercises/exercise-1-first-repo.md)

Create a repository, make commits, and push to GitHub.

### [Exercise 2: Branching and Merging](./exercises/exercise-2-branching.md)

Work with branches, handle merge conflicts, and understand Git's workflow.

### [Exercise 3: Collaboration](./exercises/exercise-3-collaboration.md)

Fork a repository, make changes, and create a pull request.

## 📖 Quick Reference

### [Git Cheatsheet](./cheatsheet.md)

Quick reference for common Git commands - bookmark this page!

## 🎓 How to Use This Module

1. **Read in order** - Start with basic commands, progress to advanced topics
2. **Type every command** - Don't copy-paste, build muscle memory
3. **Do the exercises** - Theory without practice is useless
4. **Experiment** - Try breaking things in test repositories
5. **Use the cheatsheet** - Reference it whenever you forget syntax

## 💡 Pro Tips

### Start Small

Don't try to memorize everything. Learn these first:

```bash
git init
git add .
git commit -m "message"
git push
git pull
git status
```

Everything else can be learned as needed.

### Make Mistakes in Test Repos

Before trying advanced Git operations on real projects:

```bash
mkdir ~/git-practice
cd ~/git-practice
git init
# Experiment here!
```

### Use Git for Everything

Even if you're the only developer:

- Personal projects
- Configuration files
- Scripts
- Notes and documentation

Version control is a habit. The more you use it, the more natural it becomes.

### Read Error Messages

Git's error messages are usually helpful! They often suggest the exact command you need.

## 🌟 By The End of This Module

You'll be comfortable with:

- Creating and managing Git repositories
- Making commits and understanding history
- Working with branches
- Collaborating via GitHub
- Following industry best practices

**These skills are essential for any developer in 2024.**

## 🔍 What is Version Control?

Version control (also called source control) is a system that records changes to files over time. You can:

- Recall specific versions later
- See who modified files and when
- Compare changes over time
- Revert files or entire projects to previous states

### Types of Version Control

**Local Version Control**

- Keep file copies in different folders
- Error-prone and confusing
- What most people do without version control

**Centralized Version Control (CVS, Subversion)**

- Single server contains all versions
- Developers check out files from server
- Problem: Single point of failure

**Distributed Version Control (Git, Mercurial)**

- Every developer has full repository history
- No single point of failure
- Can work offline
- **This is Git!**

## 📊 Git vs GitHub

### Git

- **Version control system** (software)
- Runs on your computer
- Tracks changes locally
- Can be used without internet
- Open source, created by Linus Torvalds

### GitHub

- **Hosting service** for Git repositories
- Stores repositories in the cloud
- Adds collaboration features (pull requests, issues, CI/CD)
- Web interface for Git
- Social coding platform

**Analogy:**

- Git is like a text editor (Word, Google Docs)
- GitHub is like a cloud storage service (Dropbox, Google Drive)

You can use Git without GitHub, but GitHub makes collaboration much easier.

### Alternatives to GitHub

- **GitLab** - Self-hosted or cloud, more DevOps features
- **Bitbucket** - Atlassian product, integrates with Jira
- **Gitea** - Lightweight self-hosted option

All use Git underneath. Once you learn Git, you can use any of them.

## 🎬 Before You Begin

Make sure you've completed [Module 00: Setup](../00-Setup/) and have:

- ✅ Git installed and configured
- ✅ GitHub account created
- ✅ SSH keys or personal access token set up (we'll verify this)

**Verify your Git configuration:**

```bash
git config --global user.name
git config --global user.email
git --version
```

If any of these don't return expected values, revisit the setup module.

## 🔒 Security Considerations

### Never Commit Secrets

- ❌ API keys, passwords, tokens in code
- ✅ Use .gitignore for sensitive files
- ✅ Use environment variables
- ✅ Tools: git-secrets, gitleaks

### Secure Your Repository

- Enable branch protection
- Require code reviews
- Enable Dependabot alerts
- Use signed commits (GPG)

### Practice Secure Collaboration

- Review permissions regularly
- Use least privilege principle
- Rotate access tokens quarterly
- Enable 2FA on GitHub account

### Hands-on Security Exercise

[Add exercise: Set up git-secrets and try to commit a fake API key]

## 🚀 Ready to Start?

Begin with [01: Basic Commands](./01-basic-commands.md) and work through each lesson in order.

Remember: **Everyone struggles with Git at first.** Even senior developers Google Git commands. Be patient with yourself and practice regularly.

Let's dive in! 🏊‍♂️

---

**Questions or stuck?**

- Check the [troubleshooting guide](../Resources/troubleshooting.md)
- Refer to the [cheatsheet](./cheatsheet.md)
- Search for your error message (Google is your friend!)
