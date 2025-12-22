# Module 00: Prerequisites

## 🎯 Learning Objectives

By the end of this module, you will have:

- ✅ A development environment ready for network programming
- ✅ Essential tools installed (browser, text editor, command-line tools)
- ✅ Basic understanding of client-server architecture
- ✅ Familiarity with using a terminal/command line
- ✅ A GitHub account for version control

**Time Required**: 30-60 minutes

## 📚 Why This Matters

Before diving into networking and APIs, you need the right foundation. This module ensures you have the tools and basic knowledge to follow along with practical exercises.

## 🖥️ System Requirements

**Minimum Requirements:**

- **OS**: Windows 10/11, macOS 10.15+, or modern Linux distribution
- **RAM**: 4GB minimum (8GB recommended)
- **Disk**: 10GB free space
- **Internet**: Stable connection for downloading tools and accessing APIs

## 🔧 Tools You'll Need

### 1. Web Browser with DevTools

**Recommended**: Chrome, Firefox, or Edge (latest version)

**What it does**:
- Inspect network requests
- Debug web applications
- Test APIs directly in the browser

### 2. Text Editor or IDE

**Recommended**: VS Code (free)

**Alternatives**: Sublime Text, Atom, IntelliJ IDEA

**What you'll use it for**:
- Writing code examples
- Viewing JSON responses
- Creating test scripts

### 3. Command Line/Terminal

**What you'll need**:
- Windows: PowerShell or Windows Terminal
- macOS: Terminal (built-in)
- Linux: Bash or Zsh terminal

### 4. Git and GitHub

**What it does**:
- Version control for code
- Collaboration on projects
- Sharing code examples

## 📖 Core Concepts to Understand

### What is a Network?

A network is a collection of computers and devices connected together to share resources and communicate. The Internet is the largest network, connecting billions of devices worldwide.

### Client-Server Model

- **Client**: Requests resources or services (e.g., your web browser)
- **Server**: Provides resources or services (e.g., a web server hosting a website)

### What is an API?

**API** (Application Programming Interface) is a way for software applications to communicate with each other. Think of it as a menu at a restaurant - it shows what you can order and how to order it.

### Request and Response

- **Request**: Client asks for something from server
- **Response**: Server sends back the requested information or confirms an action

## ✅ Setup Checklist

### 1. Install a Modern Web Browser

```bash
# Verify your browser version
# Open browser and navigate to: chrome://version or about:support
```

### 2. Install VS Code (Recommended)

Download from: https://code.visualstudio.com/

Verify installation:
```bash
code --version
```

### 3. Set Up Command Line

**Windows**:
```powershell
# Open PowerShell
# Verify it works
Write-Host "Hello, World!"
```

**macOS/Linux**:
```bash
# Open Terminal
# Verify it works
echo "Hello, World!"
```

### 4. Create GitHub Account

1. Go to https://github.com
2. Sign up for a free account
3. Verify your email address

### 5. Install Git

Download from: https://git-scm.com/downloads

Verify installation:
```bash
git --version
```

Configure Git:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 🎨 Optional But Helpful

### Install Postman

Postman is a popular tool for testing APIs. Download from: https://www.postman.com/downloads/

### Install curl

Most systems have curl pre-installed. Verify:
```bash
curl --version
```

If not installed:
- **Windows**: Comes with Windows 10 1803+ or download from https://curl.se/windows/
- **macOS**: Pre-installed or `brew install curl`
- **Linux**: `sudo apt install curl` or `sudo yum install curl`

## 📝 Pre-Course Knowledge Check

### You should be comfortable with:

1. **Basic Computer Use**
   - Creating and organizing files and folders
   - Using a web browser
   - Installing software

2. **Basic Programming Concepts** (helpful but not required)
   - Variables and data types
   - Functions
   - Basic logic (if/else)

3. **Reading Technical Documentation**
   - Following step-by-step instructions
   - Googling error messages

### Don't worry if you're not familiar with:

- ❌ Network protocols (we'll learn these)
- ❌ HTTP methods and status codes (coming soon)
- ❌ JSON or XML formats (we'll cover these)
- ❌ Authentication mechanisms (we'll explain everything)
- ❌ Database concepts (included in the course)

## ✅ Setup Verification Checklist

Use this checklist to ensure your environment is ready:

```
┌─────────────────────────────────────────────────────────┐
│              Environment Setup Checklist                │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  [ ] Modern web browser installed (Chrome/Firefox)     │
│  [ ] Browser DevTools accessible (F12 works)           │
│  [ ] Text editor installed (VS Code recommended)       │
│  [ ] Command line/terminal accessible                  │
│  [ ] Git installed and configured                      │
│  [ ] GitHub account created and verified               │
│  [ ] curl command available                            │
│  [ ] Can execute: curl https://api.github.com/         │
│  [ ] Network tab visible in browser DevTools           │
│                                                         │
│  All checked? You're ready to start! 🚀                │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start Test

Let's verify your setup with a simple test:

1. **Open your terminal**
2. **Make a simple network request**:

```bash
curl https://api.github.com/
```

Expected: You should see JSON data about the GitHub API.

3. **Open browser DevTools**:
   - Open your browser
   - Press `F12` or `Ctrl+Shift+I` (Windows/Linux) or `Cmd+Option+I` (macOS)
   - Navigate to the "Network" tab
   - Visit any website and watch network requests appear

If both work, you're ready to proceed! 🎉

## 📖 Next Steps

Once your environment is set up:

1. ✅ Complete the verification tests above
2. 📚 Familiarize yourself with your text editor
3. 🌐 Open browser DevTools and explore
4. ➡️ Proceed to [Module 01: Internet Basics](../01-Internet-Basics/)

## 🔗 Additional Resources

- [What is an API? (Video)](https://www.youtube.com/watch?v=s7wmiS2mSXY)
- [Command Line Basics](https://tutorial.djangogirls.org/en/intro_to_command_line/)
- [Chrome DevTools Guide](https://developer.chrome.com/docs/devtools/)

## 🤔 Need Help?

If you encounter issues during setup:
1. Check the troubleshooting section in your OS-specific guide
2. Search for error messages online
3. Ask in the course discussion forum or GitHub issues

Remember: Setup is often the trickiest part. Once you're past this, the learning gets much smoother!
