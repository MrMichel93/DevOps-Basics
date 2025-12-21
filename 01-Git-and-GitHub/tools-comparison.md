# Version Control Tool Comparison

## This Course Uses: Git + GitHub

## Why We Chose Git/GitHub for This Course

- Industry standard - Most companies use Git
- Free tier sufficient for learning
- Extensive documentation and community support
- Integration with other tools and services
- GitHub Actions for CI/CD learning
- Large ecosystem of third-party integrations

## Alternative Version Control Systems

### GitLab

**When to Consider:**

- Need built-in CI/CD with advanced features
- Want self-hosted option with full control
- Require comprehensive DevOps platform (CI/CD, container registry, security scanning)
- Enterprise needs with on-premise deployment

**Pros:**

- All-in-one platform (Git + CI/CD + Registry + Security)
- Strong CI/CD capabilities out of the box
- Can be self-hosted or cloud-hosted
- Built-in container registry
- Integrated security scanning

**Cons:**

- Heavier resource usage for self-hosted instances
- Steeper learning curve for full platform
- Smaller community than GitHub
- UI can be overwhelming with all features

**Migration:**

- Similar Git commands (100% compatible)
- Different web UI and terminology (Merge Request vs Pull Request)
- CI/CD configuration in `.gitlab-ci.yml` instead of `.github/workflows/`
- Import repositories directly from GitHub

### Bitbucket

**When to Consider:**

- Using Atlassian tools (Jira, Confluence, Trello)
- Enterprise Atlassian license already in place
- Need tight integration with Jira for project management
- Small teams (free tier supports up to 5 users)

**Pros:**

- Excellent Atlassian ecosystem integration
- Built-in CI/CD with Pipelines
- Free for small teams
- Good code review tools

**Cons:**

- Limited free tier (5 users max)
- Smaller community than GitHub/GitLab
- Fewer third-party integrations
- Less suitable for open source projects

**Migration:**

- Git commands identical
- Pull Requests work similarly
- Pipelines configuration different from Actions
- Can import from GitHub

### Gitea / Forgejo

**When to Consider:**

- Need lightweight self-hosted solution
- Privacy-focused requirements
- Limited server resources
- Want open-source alternative without vendor lock-in

**Pros:**

- Very lightweight and fast
- Easy to self-host
- Fully open source
- Low resource requirements
- Simple, clean interface

**Cons:**

- Fewer integrations than major platforms
- Smaller community and ecosystem
- Limited built-in CI/CD features
- Manual setup and maintenance required

**Migration:**

- Standard Git operations work the same
- Can mirror repositories from GitHub
- Simpler feature set, may miss some GitHub features

## Skills Transfer

Everything you learn about Git in this course applies to ALL platforms.
Platform-specific features (Actions, Pipelines, etc.) have equivalents:

| Feature | GitHub | GitLab | Bitbucket |
|---------|--------|--------|-----------|
| CI/CD | Actions | CI/CD | Pipelines |
| Code Review | Pull Request | Merge Request | Pull Request |
| Issue Tracking | Issues | Issues | Issues |
| Wikis | Wiki | Wiki | Wiki |
| Container Registry | Packages | Container Registry | - |
| Security Scanning | Dependabot | Security Dashboard | - |

**Core Git Skills (Transferable):**

- `git clone`, `git commit`, `git push`, `git pull`
- Branching and merging strategies
- Conflict resolution
- Git workflows (feature branches, GitFlow, etc.)
- `.gitignore` and repository structure
- Commit message conventions

**Platform-Specific Skills (Need Learning):**

- Web UI and navigation
- CI/CD configuration syntax
- Marketplace/integrations
- Permissions and access control
- API and webhooks

## Practical Exercise

Try the same workflow on different platforms:

1. **Create repository on GitHub** (this course)
   - Create a new repository
   - Clone it locally
   - Make commits and push
   - Create a Pull Request

2. **Mirror to GitLab** (practice alternative)
   - Create GitLab account (free)
   - Create new project
   - Add GitLab as remote: `git remote add gitlab <url>`
   - Push to GitLab: `git push gitlab main`
   - Create a Merge Request

3. **Compare the workflows**
   - Note similarities in Git commands
   - Observe differences in web UI
   - Compare Pull Request vs Merge Request
   - Try basic CI/CD on both platforms

**Learning Goal:** Understand that Git knowledge is portable, but platform features vary.

## Choosing the Right Tool

**For Learning DevOps:**

- ✅ GitHub - Best for this course and building portfolio

**For Personal Projects:**

- GitHub - Open source, portfolio building
- GitLab - Self-hosted, privacy-focused
- Gitea - Minimal resources, maximum control

**For Enterprise:**

- GitHub Enterprise - Largest ecosystem, best integrations
- GitLab - All-in-one platform, self-hosted option
- Bitbucket - Already using Atlassian tools

## Key Takeaways

1. **Git is universal** - Learn it once, use it everywhere
2. **Platforms add features** - But core Git remains the same
3. **Choose based on needs** - Not all projects need all features
4. **Skills are transferable** - Git knowledge works across all platforms
5. **Start with GitHub** - Best for learning and open source

---

**Next Steps:**

- Master Git fundamentals in this module
- Create GitHub account and repositories
- Later, experiment with other platforms to see differences
- Focus on Git skills that transfer, not platform-specific features
