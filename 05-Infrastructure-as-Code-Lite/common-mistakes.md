# Common Mistakes in Infrastructure as Code Lite

## Beginner Mistakes

### Mistake 1: Hardcoding Values Instead of Using Variables

**What people do:**
Put specific values like server IPs, domain names, and passwords directly in IaC templates instead of using variables.

**Why it's a problem:**
- Can't reuse templates for different environments
- Credentials exposed in version control
- Difficult to maintain and update
- No separation between code and configuration
- Templates break when values change

**The right way:**
Use variables and parameter files:

```yaml
# Bad ❌ - Hardcoded values
resource:
  server:
    ip_address: "192.168.1.100"
    admin_password: "MyPassword123"
    domain: "production.example.com"

# Good ✅ - Variables
resource:
  server:
    ip_address: "${var.server_ip}"
    admin_password: "${var.admin_password}"
    domain: "${var.domain_name}"

# variables.tf or config file
variable "server_ip" {
  description = "Server IP address"
  type        = string
}

variable "admin_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}
```

**How to fix if you've already done this:**
Extract hardcoded values to variables:

```bash
# Create variables file
# Move all hardcoded values
# Use environment-specific tfvars or parameter files
# Add sensitive files to .gitignore
```

**Red flags to watch for:**
- Same template can't be used for staging and production
- Passwords visible in code
- Frequent template editing for simple changes
- No variables section in templates
- Configuration in version control

---

### Mistake 2: No State Management Strategy

**What people do:**
Store Terraform/IaC state files locally or commit them to version control without backend configuration.

**Why it's a problem:**
- State conflicts in team environments
- Lost state means lost infrastructure tracking
- Secrets exposed in state files
- Can't collaborate effectively
- Risk of infrastructure drift
- Concurrent modification errors

**The right way:**
Use remote state backend:

```hcl
# terraform backend configuration
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Or for Terraform Cloud
terraform {
  cloud {
    organization = "my-org"
    workspaces {
      name = "production"
    }
  }
}
```

**How to fix if you've already done this:**
Migrate to remote backend:

```bash
# Remove state from git
echo "*.tfstate*" >> .gitignore
git rm --cached *.tfstate*

# Configure backend
# Run terraform init -migrate-state
# Verify state in remote backend
```

**Red flags to watch for:**
- terraform.tfstate in git repository
- State conflicts between team members
- Lost infrastructure when laptop dies
- No state locking
- Can't see who made changes

---

### Mistake 3: Not Using Version Control for IaC

**What people do:**
Make infrastructure changes through manual edits or GUI without tracking in version control.

**Why it's a problem:**
- Can't track who made what changes
- No rollback capability
- Infrastructure drift
- Lost history of infrastructure evolution
- Can't review changes before applying
- No audit trail

**The right way:**
Version control everything:

```bash
# Initialize git repository
git init
git add .
git commit -m "Initial infrastructure setup"

# Use branches for changes
git checkout -b add-database-server
# Make changes
git add database.tf
git commit -m "Add PostgreSQL database server"
git push origin add-database-server
# Create pull request for review

# Tag releases
git tag -a v1.0.0 -m "Production release v1.0.0"
git push origin v1.0.0
```

**How to fix if you've already done this:**
Start tracking infrastructure:

```bash
# Document current state
# Create git repository
# Commit all IaC files
# Use branches for future changes
# Implement review process
```

**Red flags to watch for:**
- No git repository for infrastructure
- Making changes directly in cloud console
- Can't explain what changed and when
- No peer review of infrastructure changes
- Unable to rollback bad changes

---

### Mistake 4: Inconsistent Naming Conventions

**What people do:**
Use random or inconsistent names for resources without following a naming pattern.

**Why it's a problem:**
- Difficult to identify resource purpose
- Can't filter or group resources
- Billing and cost tracking harder
- Poor organization
- Confusion in large infrastructures
- Difficult to automate

**The right way:**
Follow consistent naming convention:

```hcl
# Good naming pattern: <project>-<environment>-<service>-<resource>
resource "aws_instance" "web" {
  tags = {
    Name = "myapp-prod-web-server-01"
    Project = "myapp"
    Environment = "production"
    Service = "web"
    ManagedBy = "terraform"
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "myapp-prod-logs-bucket"
  # Naming: <project>-<env>-<purpose>-bucket
}

# Use locals for consistent naming
locals {
  common_tags = {
    Project     = "myapp"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
  
  name_prefix = "${var.project}-${var.environment}"
}

resource "aws_instance" "app" {
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-app-server"
  })
}
```

**How to fix if you've already done this:**
Standardize naming:

```bash
# Document naming convention
# Create naming standard
# Rename resources following pattern
# Use tags for metadata
# Automate naming with locals/variables
```

**Red flags to watch for:**
- Resources named "test", "server1", "new-thing"
- Can't identify environment from name
- Inconsistent separators (dash vs underscore)
- No tags on resources
- Difficulty finding specific resources

---

### Mistake 5: Creating Monolithic Configuration Files

**What people do:**
Put all infrastructure configuration in a single massive file.

**Why it's a problem:**
- Difficult to navigate and maintain
- Can't work on different parts simultaneously
- Poor organization
- Merge conflicts in teams
- Hard to reuse components
- Difficult to test individual parts

**The right way:**
Organize into logical modules:

```bash
# Good structure
infrastructure/
├── main.tf              # Main configuration
├── variables.tf         # Variable definitions
├── outputs.tf           # Output values
├── versions.tf          # Provider versions
├── modules/
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── database/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   ├── prod/
│   │   ├── main.tf
│   │   └── terraform.tfvars
│   └── staging/
│       ├── main.tf
│       └── terraform.tfvars
```

**How to fix if you've already done this:**
Refactor into modules:

```bash
# Split large file into logical modules
# Create module directories
# Move related resources together
# Use module calls in main.tf
# Test each module independently
```

**Red flags to watch for:**
- Single file over 500 lines
- All resources in main.tf
- Can't find specific configuration
- Frequent merge conflicts
- Long time to apply changes

---

### Mistake 6: Not Validating and Testing Before Apply

**What people do:**
Run terraform apply or deployment commands directly without planning, validating, or testing.

**Why it's a problem:**
- Unexpected infrastructure changes
- Accidentally delete resources
- Syntax errors break deployment
- No preview of changes
- Can't catch mistakes early
- Production outages from untested changes

**The right way:**
Always plan and validate:

```bash
# Terraform workflow
terraform fmt        # Format code
terraform validate   # Check syntax
terraform plan       # Preview changes
# Review plan output carefully
terraform apply      # Apply only after review

# Use saved plans for production
terraform plan -out=tfplan
# Review tfplan
terraform apply tfplan

# Test in non-production first
cd environments/staging
terraform plan
terraform apply
# Test thoroughly
# Then deploy to production
cd ../production
terraform plan
terraform apply
```

**How to fix if you've already done this:**
Implement validation workflow:

```bash
# Add pre-commit hooks
# Require terraform plan before apply
# Use CI/CD for validation
# Peer review plans
# Test in staging first
```

**Red flags to watch for:**
- Unexpected resource deletions
- Terraform errors during apply
- Surprises in production
- No plan review process
- Direct apply without planning

---

### Mistake 7: Not Using Modules and Reusable Components

**What people do:**
Copy and paste infrastructure code for similar resources instead of creating reusable modules.

**Why it's a problem:**
- Code duplication everywhere
- Updates require changing multiple places
- Inconsistencies between similar resources
- More code to maintain
- Harder to enforce standards
- Missed updates and drift

**The right way:**
Create reusable modules:

```hcl
# modules/web-server/main.tf
variable "server_name" {}
variable "instance_type" {}
variable "environment" {}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  tags = {
    Name        = var.server_name
    Environment = var.environment
  }
}

output "instance_id" {
  value = aws_instance.web.id
}

# Use module
module "web_server_1" {
  source        = "./modules/web-server"
  server_name   = "web-01"
  instance_type = "t2.micro"
  environment   = "production"
}

module "web_server_2" {
  source        = "./modules/web-server"
  server_name   = "web-02"
  instance_type = "t2.micro"
  environment   = "production"
}
```

**How to fix if you've already done this:**
Extract to modules:

```bash
# Identify repeated patterns
# Create module structure
# Extract to module
# Replace duplicates with module calls
# Test thoroughly
```

**Red flags to watch for:**
- Copy-pasted code blocks
- Similar resources with slight variations
- Updating same pattern in multiple files
- Inconsistencies between similar resources

---

## Intermediate Mistakes

### Mistake 8: Ignoring State Locking

**What people do:**
Work on infrastructure simultaneously without state locking, causing state corruption.

**Why it's a problem:**
- State file corruption
- Lost infrastructure changes
- Race conditions
- Conflicting modifications
- Difficult to debug issues
- Production outages

**The right way:**
Enable state locking:

```hcl
# For Terraform with DynamoDB
terraform {
  backend "s3" {
    bucket         = "terraform-state"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"  # Enables locking
    encrypt        = true
  }
}

# Always use consistent backend configuration
# Don't bypass locking mechanisms
```

**How to fix if you've already done this:**
Configure locking:

```bash
# Set up locking backend
# Enable lock table
# Update all team members
# Verify locking works
```

**Red flags to watch for:**
- "State locked" errors
- State corruption
- Concurrent modifications
- Lost changes
- State conflicts

---

### Mistake 9: Not Managing Secrets Properly

**What people do:**
Store secrets in plain text variables, commit them to version control, or embed them in IaC code.

**Why it's a problem:**
- Security breach from exposed secrets
- Credentials in git history
- Non-compliant with security standards
- Difficult to rotate secrets
- Secrets visible to all with code access

**The right way:**
Use secrets management:

```hcl
# Use secrets manager
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/db/password"
}

resource "aws_db_instance" "main" {
  password = data.aws_secretsmanager_secret_version.db_password.secret_string
}

# Or environment variables
variable "db_password" {
  type      = string
  sensitive = true
}

# Set via environment
# export TF_VAR_db_password="secret"

# Never commit secrets
# .gitignore
*.tfvars
.env
secrets.auto.tfvars
```

**How to fix if you've already done this:**
Migrate to secrets manager:

```bash
# Rotate all exposed secrets
# Remove from version control
# Use secrets manager or env vars
# Mark variables as sensitive
# Update .gitignore
```

**Red flags to watch for:**
- Passwords in .tf files
- API keys in version control
- Plain text secrets
- No sensitive variable marking
- Secrets in state file viewable

---

### Mistake 10: Not Planning for Disaster Recovery

**What people do:**
Don't backup state files, have no recovery process, or can't rebuild infrastructure from code.

**Why it's a problem:**
- Lost infrastructure if state corrupted
- No recovery from mistakes
- Long downtime during disasters
- Can't recreate infrastructure
- No tested restore process

**The right way:**
Implement disaster recovery:

```hcl
# State backup
terraform {
  backend "s3" {
    bucket         = "terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    versioning     = true  # Keep state versions
  }
}

# Document recovery process
# Test infrastructure rebuild regularly
# Keep runbooks for disaster scenarios
# Backup critical data separately
```

**How to fix if you've already done this:**
Create DR plan:

```bash
# Enable state versioning
# Document recovery steps
# Test infrastructure rebuild
# Create runbooks
# Regular backup verification
```

**Red flags to watch for:**
- No state backups
- Untested recovery process
- Can't rebuild infrastructure
- No disaster recovery documentation
- State file is single point of failure

---

## Advanced Pitfalls

### Mistake 11: Not Following the DRY Principle

**What people do:**
Repeat configuration across environments instead of parameterizing.

**Why it's a problem:**
- Code duplication
- Inconsistent environments
- Updates miss some environments
- More code to maintain
- Higher chance of errors

**The right way:**
Use workspaces or separate directories with shared modules:

```hcl
# Shared module
module "app_infrastructure" {
  source = "../../modules/app"
  
  environment     = var.environment
  instance_count  = var.instance_count
  instance_type   = var.instance_type
}

# environments/prod/terraform.tfvars
environment    = "production"
instance_count = 10
instance_type  = "t3.large"

# environments/staging/terraform.tfvars
environment    = "staging"
instance_count = 2
instance_type  = "t3.small"
```

**How to fix if you've already done this:**
Refactor to shared modules:

```bash
# Extract common configuration
# Create shared modules
# Use tfvars for environment differences
# Test all environments
```

**Red flags to watch for:**
- Identical code in multiple files
- Manual syncing between environments
- Forgetting to update all copies
- Environment drift

---

### Mistake 12: Inadequate Documentation

**What people do:**
Don't document infrastructure architecture, decisions, or runbooks.

**Why it's a problem:**
- New team members can't understand setup
- Decisions forgotten over time
- No troubleshooting guides
- Difficult to maintain
- Operational knowledge in heads

**The right way:**
Document thoroughly:

```markdown
# infrastructure/README.md

## Architecture Overview
High-level infrastructure design and components

## Prerequisites
- Terraform v1.5+
- AWS credentials configured
- Required permissions

## Deployment
```bash
cd environments/production
terraform init
terraform plan
terraform apply
```

## Modules
- networking: VPC, subnets, routing
- compute: EC2 instances, auto-scaling
- database: RDS PostgreSQL

## Disaster Recovery
Steps to rebuild infrastructure...

## Troubleshooting
Common issues and solutions...
```

**How to fix if you've already done this:**
Create documentation:

```bash
# Add README files
# Document architecture
# Create runbooks
# Add inline comments
# Keep docs updated
```

**Red flags to watch for:**
- No README in repository
- Team members can't deploy without asking
- Undocumented dependencies
- No architecture diagrams
- Knowledge gaps when people leave

---

## Prevention Checklist

### Before Writing IaC

- [ ] Plan infrastructure architecture
- [ ] Define naming conventions
- [ ] Set up remote state backend
- [ ] Create module structure
- [ ] Plan for multiple environments
- [ ] Design secrets management strategy

### During Development

- [ ] Use variables instead of hardcoded values
- [ ] Create reusable modules
- [ ] Follow consistent naming
- [ ] Add meaningful comments
- [ ] Use version control
- [ ] Validate and format code

### Before Deployment

- [ ] Run terraform validate
- [ ] Review terraform plan output
- [ ] Test in non-production first
- [ ] Peer review changes
- [ ] Document changes
- [ ] Check for secrets exposure

### Operations

- [ ] Monitor infrastructure drift
- [ ] Regular state backups
- [ ] Update documentation
- [ ] Review and update modules
- [ ] Security audit
- [ ] Cost optimization review

### Security

- [ ] No secrets in code
- [ ] State file encrypted
- [ ] Access control configured
- [ ] Audit logging enabled
- [ ] Regular security scans
- [ ] Compliance checks
