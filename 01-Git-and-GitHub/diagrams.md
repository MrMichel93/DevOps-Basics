# Module 01: Git and GitHub - Diagrams

This document contains visual diagrams to help understand Git workflows, branching strategies, and collaboration processes.

## 1. Git Workflow Visualization

This diagram shows the fundamental Git workflow from working directory to remote repository:

```text
┌──────────────┐    git add    ┌──────────────┐    git commit    ┌──────────────┐    git push    ┌──────────────┐
│   Working    │──────────────>│   Staging    │─────────────────>│    Local     │───────────────>│    Remote    │
│  Directory   │               │     Area     │                  │  Repository  │                │  Repository  │
└──────────────┘               └──────────────┘                  └──────────────┘                └──────────────┘
      │                                                                  │                                │
      │                                                                  │                                │
      │<─────────────────────────────────────────────────────────────────┘                                │
      │                           git checkout / git reset                                                │
      │                                                                                                   │
      │<──────────────────────────────────────────────────────────────────────────────────────────────────┘
      │                                          git pull / git fetch
```

**Stages Explained:**

- **Working Directory**: Where you edit and modify files
- **Staging Area**: Files marked to be included in the next commit
- **Local Repository**: Your local Git history with all commits
- **Remote Repository**: Shared repository on GitHub for collaboration

**Common Commands:**

- `git add <file>` - Move changes from working directory to staging area
- `git commit -m "message"` - Save staged changes to local repository
- `git push` - Upload local commits to remote repository
- `git pull` - Download and merge remote changes to local repository

## 2. Branching Strategy

This diagram illustrates how feature branches work with the main branch:

```text
main    ─────●─────────●─────────●─────────●─────>
              │                   │
              │ create branch     │ merge
              │                   │
feature       └─────●─────●─────●─┘
                  commit commit commit
```

**Branch Workflow:**

1. Create a new feature branch from main
2. Make commits on the feature branch
3. Create a pull request to merge changes back to main
4. After review, merge the feature branch into main

**More Complex Example with Multiple Features:**

```text
main        ─────●─────────●─────────────●─────────●─────>
                  │         │             │
feature-1         └─●─●─●───┘             │
                                          │
feature-2         ────────────────────────└─●─●─●───
```

**Commands:**

- `git branch feature-name` - Create a new branch
- `git checkout feature-name` - Switch to the branch
- `git checkout -b feature-name` - Create and switch in one command
- `git merge feature-name` - Merge branch into current branch

## 3. Pull Request Flow

This diagram shows the complete lifecycle of a pull request:

```text
┌─────────────────┐
│ Create Feature  │
│     Branch      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Make Changes   │
│  and Commits    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Push Branch    │
│   to Remote     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Open Pull     │
│    Request      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  CI/CD Tests    │
│      Run        │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌───▼───┐
│ Pass  │ │ Fail  │
└───┬───┘ └───┬───┘
    │         │
    │    ┌────▼─────┐
    │    │   Fix    │
    │    │  Issues  │
    │    └────┬─────┘
    │         │
    └────┬────┘
         │
         ▼
┌─────────────────┐
│  Code Review    │
│   Requested     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Reviewer      │
│   Comments      │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼────┐ ┌──▼──────┐
│Approved│ │ Changes │
│        │ │Requested│
└───┬────┘ └──┬──────┘
    │         │
    │    ┌────▼─────┐
    │    │  Update  │
    │    │   Code   │
    │    └────┬─────┘
    │         │
    └────┬────┘
         │
         ▼
┌─────────────────┐
│  Merge to Main  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Delete Feature  │
│     Branch      │
└─────────────────┘
```

**Best Practices:**

- Write clear PR descriptions explaining what and why
- Keep PRs small and focused on one feature or fix
- Respond promptly to review feedback
- Ensure all tests pass before requesting review

## 4. Merge Conflict Resolution Process

This decision tree helps you resolve merge conflicts:

```text
                    ┌─────────────┐
                    │ Attempt to  │
                    │    Merge    │
                    └──────┬──────┘
                           │
                      ┌────▼─────┐
                      │ Conflict?│
                      └────┬─────┘
                           │
                      ┌────┴────┐
                      │         │
                 ┌────▼───┐ ┌───▼────┐
                 │   No   │ │  Yes   │
                 │        │ │        │
                 └────┬───┘ └───┬────┘
                      │         │
                      │         ▼
                      │    ┌────────────┐
                      │    │Open Files  │
                      │    │with <<<>>> │
                      │    │  Markers   │
                      │    └─────┬──────┘
                      │          │
                      │          ▼
                      │    ┌────────────┐
                      │    │  Examine   │
                      │    │  Conflicts │
                      │    └─────┬──────┘
                      │          │
                      │    ┌─────▼──────┐
                      │    │   Decide:  │
                      │    │Keep Current│
                      │    │Keep Incoming│
                      │    │   or Both  │
                      │    └─────┬──────┘
                      │          │
                      │          ▼
                      │    ┌────────────┐
                      │    │   Remove   │
                      │    │  Conflict  │
                      │    │  Markers   │
                      │    └─────┬──────┘
                      │          │
                      │          ▼
                      │    ┌────────────┐
                      │    │   Test     │
                      │    │   Code     │
                      │    └─────┬──────┘
                      │          │
                      │     ┌────▼────┐
                      │     │ Works?  │
                      │     └────┬────┘
                      │          │
                      │     ┌────┴────┐
                      │     │         │
                      │ ┌───▼───┐ ┌───▼───┐
                      │ │  Yes  │ │  No   │
                      │ └───┬───┘ └───┬───┘
                      │     │         │
                      │     │    ┌────▼────┐
                      │     │    │  Debug  │
                      │     │    │   and   │
                      │     │    │   Fix   │
                      │     │    └────┬────┘
                      │     │         │
                      │     └────┬────┘
                      │          │
                      │          ▼
                      │    ┌────────────┐
                      │    │  git add   │
                      │    │<resolved>  │
                      │    └─────┬──────┘
                      │          │
                      │          ▼
                      │    ┌────────────┐
                      │    │ git commit │
                      │    └─────┬──────┘
                      │          │
                      └──────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │Merge Complete│
                    └─────────────┘
```

**Conflict Markers Explained:**

```text
<<<<<<< HEAD (Current Change)
Your code changes
=======
Incoming code changes
>>>>>>> branch-name (Incoming Change)
```

**Resolution Steps:**

1. Identify conflicting files using `git status`
2. Open each file and locate conflict markers
3. Decide which changes to keep (yours, theirs, or both)
4. Remove all conflict markers
5. Test the code to ensure it works
6. Stage resolved files with `git add`
7. Complete the merge with `git commit`
