# DevOps Basics: A Practical Course 🚀

[![GitHub Actions](https://img.shields.io/badge/CI/CD-GitHub%20Actions-blue)](https://github.com/features/actions)
[![Docker](https://img.shields.io/badge/Docker-Required-blue)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> Master modern DevOps practices using only GitHub, VS Code, and your command line. No cloud services required!

## 📚 What is DevOps?

DevOps is a set of practices that combines software **Dev**elopment and IT **Op**erations. It aims to shorten the development lifecycle and provide continuous delivery with high software quality. DevOps is complementary with Agile software development; several DevOps aspects came from the Agile methodology.

### Core DevOps Principles

- **Automation**: Automate repetitive tasks (testing, deployment, infrastructure)
- **Collaboration**: Break down silos between development and operations teams
- **Continuous Improvement**: Always iterate and improve processes
- **Monitoring & Feedback**: Measure everything and learn from metrics
- **Infrastructure as Code**: Manage infrastructure through code and version control

### Why Learn DevOps?

- **High Demand**: DevOps engineers are among the highest-paid tech professionals
- **Modern Development**: These are essential skills for any developer in 2024+
- **Career Growth**: DevOps skills open doors to senior engineering and architect roles
- **Efficiency**: Automate away tedious work and focus on building features
- **Quality**: Catch bugs early, deploy confidently, and recover quickly

## 🎯 Course Overview

This is a **hands-on, practical course** designed to teach you real-world DevOps skills without requiring expensive cloud services. Everything runs locally on your machine or on GitHub's free tier.

**Time Commitment**: 6-8 weeks (3-4 hours per week)  
**Skill Level**: Beginner to Intermediate  
**Cost**: 100% Free

### What You'll Learn

✅ Version control with Git and GitHub collaboration workflows  
✅ Command-line proficiency for automation and scripting  
✅ Docker for containerization and environment consistency  
✅ CI/CD pipelines with GitHub Actions  
✅ Infrastructure as Code concepts  
✅ Logging, monitoring, and observability basics  
✅ Security best practices (DevSecOps)  

### What You Won't Need

❌ AWS, Azure, or GCP accounts (no cloud services required)  
❌ Paid tools or subscriptions  
❌ High-end computer (Docker Desktop will run on most modern machines)  

## 🗺️ Learning Path

```
┌─────────────────────────────────────────────────────────────────┐
│                    Your DevOps Journey                          │
└─────────────────────────────────────────────────────────────────┘

Week 1-2: Foundations
├─ 00-Setup → Get your environment ready
├─ 01-Git-and-GitHub → Master version control
└─ 02-Command-Line-Mastery → Become a CLI wizard

Week 3-4: Containerization
├─ 03-Docker-Fundamentals → Package applications
└─ Project 1: Containerize an existing app

Week 5-6: Automation
├─ 04-CI-CD-with-GitHub-Actions → Automate everything
├─ 05-Infrastructure-as-Code-Lite → Declarative infrastructure
└─ Project 2: Build a complete CI/CD pipeline

Week 7-8: Production Ready
├─ 06-Monitoring-and-Logging → Observe your systems
├─ 07-Security-Basics → Secure your applications
└─ Capstone Project: Full DevOps workflow
```

## 📋 Prerequisites

**Required Knowledge:**

- Basic programming skills in any language (Python, JavaScript, Java, etc.)
- Comfort with using your computer's file system
- Willingness to use the command line (we'll teach you!)

**Nice to Have (but not required):**

- Basic understanding of web applications
- Some experience with Git (even just basic add/commit/push)

## 🚀 Quick Start

1. **Clone this repository**

```bash
git clone https://github.com/MrMichel93/DevOps-Basics.git
cd DevOps-Basics
```

1. **Start with Setup**

```bash
cd 00-Setup
# Follow the setup guide for your operating system
```

1. **Follow the modules in order**

- Each module builds on the previous one
- Complete exercises before moving forward
- Don't skip the hands-on practice!

## 📖 Course Modules

### [00-Setup](./00-Setup/)

Get your development environment ready with Git, Docker Desktop, VS Code, and terminal configuration.

### [01-Git-and-GitHub](./01-Git-and-GitHub/)

Master version control, branching strategies, collaboration workflows, and GitHub features. Includes practical exercises for forking, pull requests, and code reviews.

### [02-Command-Line-Mastery](./02-Command-Line-Mastery/)

Become proficient with the command line, learn shell scripting, and automate common tasks. Includes real automation scripts.

### [03-Docker-Fundamentals](./03-Docker-Fundamentals/)

Learn containerization from basics to multi-container applications. Includes Dockerfile best practices, Docker Compose, and real application examples.

### [04-CI-CD-with-GitHub-Actions](./04-CI-CD-with-GitHub-Actions/)

Build automated testing and deployment pipelines. Learn GitHub Actions with functional workflows you can use immediately.

### [05-Infrastructure-as-Code-Lite](./05-Infrastructure-as-Code-Lite/)

Understand IaC concepts using Docker Compose and Makefiles for reproducible environments.

### [06-Monitoring-and-Logging](./06-Monitoring-and-Logging/)

Implement observability with structured logging, container health checks, and monitoring stacks.

### [07-Security-Basics](./07-Security-Basics/)

Learn DevSecOps practices: secrets management, container security, and dependency scanning.

## 🛠️ Projects

Hands-on projects to integrate your learning:

1. **[Containerize an Existing App](./Projects/01-containerize-existing-app.md)** - Take a simple application and dockerize it
2. **[Full-Stack with Docker Compose](./Projects/02-full-stack-with-compose.md)** - Build frontend + backend + database setup
3. **[Complete CI/CD Pipeline](./Projects/03-ci-cd-pipeline.md)** - Implement automated testing and deployment
4. **[Capstone Project](./Projects/04-capstone-project.md)** - Comprehensive DevOps workflow for a real application

## 📚 Resources

- **[Glossary](./Resources/glossary.md)** - DevOps terminology explained
- **[Best Practices](./Resources/best-practices.md)** - Industry-standard patterns
- **[Troubleshooting](./Resources/troubleshooting.md)** - Common issues and solutions
- **[Cheatsheets](./Resources/cheatsheets/)** - Quick reference guides
- **[Further Learning](./Resources/further-learning.md)** - Next steps after this course

## 🌟 DevOps Culture

DevOps isn't just about tools—it's about **culture and mindset**:

### **Collaboration Over Silos**

Traditional IT had developers "throwing code over the wall" to operations. DevOps breaks down these barriers. Developers understand operations concerns (uptime, monitoring), and operations teams understand development needs (fast iteration, testing).

### **Automation Over Manual Work**

If you do it more than twice, automate it. Manual processes are:

- Error-prone
- Time-consuming
- Not scalable
- Difficult to reproduce

### **Measurement Over Guesswork**

You can't improve what you don't measure. DevOps emphasizes:

- Metrics (response time, error rates, deployment frequency)
- Logging (what happened and when)
- Monitoring (is it working right now?)
- Feedback loops (learn and iterate)

### **Continuous Everything**

- **Continuous Integration**: Merge code frequently, test automatically
- **Continuous Delivery**: Always keep code in a deployable state
- **Continuous Deployment**: Automatically deploy to production
- **Continuous Improvement**: Always iterate on processes

## 👨‍💻 Day in the Life of a DevOps Engineer

**9:00 AM** - Check monitoring dashboards, review overnight logs  
**9:30 AM** - Daily standup with development team  
**10:00 AM** - Review pull requests, suggest infrastructure improvements  
**11:00 AM** - Debug failing CI pipeline, optimize Docker build times  
**12:00 PM** - Lunch & learning (reading about new tools)  
**1:00 PM** - Write Terraform code for new service infrastructure  
**2:30 PM** - Pair programming session: help developer with container issues  
**3:30 PM** - Improve monitoring: add new Grafana dashboard  
**4:30 PM** - Document the new deployment process  
**5:00 PM** - Review metrics, plan tomorrow's improvements  

**Real Skills You'll Use:**

- Writing automation scripts (40% of time)
- Troubleshooting issues (30% of time)
- Code reviews and collaboration (15% of time)
- Documentation (10% of time)
- Meetings and planning (5% of time)

## 🎓 Learning Tips

1. **Practice, Don't Just Read**: Type every command yourself. Break things and fix them.

2. **Understand the "Why"**: Don't just memorize commands. Understand what problems each tool solves.

3. **Build Real Projects**: The projects in this course simulate real scenarios. Take them seriously.

4. **Google is Your Friend**: Professional DevOps engineers Google things constantly. You'll need to as well.

5. **Join Communities**:
   - [DevOps subreddit](https://reddit.com/r/devops)
   - [Docker Community Forums](https://forums.docker.com/)
   - [GitHub Community](https://github.community/)

6. **Iterate**: Your first solution won't be perfect. That's okay! DevOps is about continuous improvement.

## 🏆 After This Course

You'll be ready to:

- Work as a Junior DevOps Engineer
- Implement CI/CD in your development team
- Containerize and deploy applications
- Move on to advanced topics (Kubernetes, Cloud Platforms, Advanced Networking)

### Next Steps

1. **Cloud Platforms**: Learn AWS, Azure, or GCP
2. **Kubernetes**: Container orchestration at scale
3. **Advanced Monitoring**: Prometheus, Grafana, ELK stack
4. **Configuration Management**: Ansible, Chef, Puppet
5. **Advanced IaC**: Terraform, CloudFormation

## 🤝 Contributing

Found a typo? Have a suggestion? Contributions are welcome!

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Make your changes
4. Submit a pull request

## 📄 License

This course is released under the MIT License. Feel free to use it for learning and teaching!

## 🙏 Acknowledgments

This course synthesizes best practices from the DevOps community. Thanks to everyone sharing knowledge!

---

**Ready to start?** Head to [00-Setup](./00-Setup/) and let's begin your DevOps journey! 🚀
