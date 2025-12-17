#!/bin/bash

################################################################################
# Deploy Script - Example deployment automation
# 
# This script demonstrates a typical application deployment process.
# Use this as a template for your own deployment scripts.
#
# Usage: ./deploy.sh [environment]
# Example: ./deploy.sh production
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

# Configuration
APP_NAME="myapp"
APP_DIR="/opt/applications/${APP_NAME}"
BACKUP_DIR="/var/backups/${APP_NAME}"
LOG_DIR="/var/log/${APP_NAME}"
DEPLOY_LOG="${LOG_DIR}/deploy.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "${DEPLOY_LOG}"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" | tee -a "${DEPLOY_LOG}"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*" | tee -a "${DEPLOY_LOG}"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*" | tee -a "${DEPLOY_LOG}"
}

check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check if running as correct user
    if [ "$(whoami)" = "root" ]; then
        log_error "This script should not be run as root"
        exit 1
    fi
    
    # Check required commands
    for cmd in git npm node; do
        if ! command -v $cmd &> /dev/null; then
            log_error "$cmd is not installed"
            exit 1
        fi
    done
    
    # Check if directories exist
    if [ ! -d "${APP_DIR}" ]; then
        log_error "Application directory ${APP_DIR} does not exist"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

create_backup() {
    log "Creating backup..."
    
    local backup_name="${APP_NAME}_$(date +'%Y%m%d_%H%M%S').tar.gz"
    local backup_path="${BACKUP_DIR}/${backup_name}"
    
    mkdir -p "${BACKUP_DIR}"
    
    tar -czf "${backup_path}" -C "${APP_DIR}" . 2>/dev/null || {
        log_error "Backup failed"
        exit 1
    }
    
    log_success "Backup created: ${backup_path}"
    
    # Keep only last 5 backups
    cd "${BACKUP_DIR}"
    ls -t | tail -n +6 | xargs -r rm --
    log "Cleaned old backups (keeping last 5)"
}

pull_latest_code() {
    log "Pulling latest code..."
    
    cd "${APP_DIR}"
    
    # Stash any local changes
    git stash
    
    # Pull latest code
    git pull origin main || {
        log_error "Failed to pull latest code"
        exit 1
    }
    
    local commit=$(git rev-parse --short HEAD)
    log_success "Pulled latest code (commit: ${commit})"
}

install_dependencies() {
    log "Installing dependencies..."
    
    cd "${APP_DIR}"
    
    # Install npm dependencies
    npm ci --production || {
        log_error "Failed to install dependencies"
        exit 1
    }
    
    log_success "Dependencies installed"
}

run_tests() {
    log "Running tests..."
    
    cd "${APP_DIR}"
    
    # Run test suite
    npm test || {
        log_warning "Tests failed - deployment aborted"
        return 1
    }
    
    log_success "All tests passed"
}

stop_application() {
    log "Stopping application..."
    
    # Stop using PM2, systemd, or pkill
    if command -v pm2 &> /dev/null; then
        pm2 stop "${APP_NAME}" || true
    else
        pkill -f "node.*${APP_NAME}" || true
    fi
    
    sleep 2
    log_success "Application stopped"
}

start_application() {
    log "Starting application..."
    
    cd "${APP_DIR}"
    
    # Start using PM2 or nohup
    if command -v pm2 &> /dev/null; then
        pm2 start ecosystem.config.js || {
            log_error "Failed to start application"
            exit 1
        }
    else
        nohup node server.js > "${LOG_DIR}/app.log" 2>&1 &
    fi
    
    sleep 3
    log_success "Application started"
}

verify_deployment() {
    log "Verifying deployment..."
    
    # Check if process is running
    if pgrep -f "node.*${APP_NAME}" > /dev/null; then
        log_success "Process is running"
    else
        log_error "Process is not running"
        return 1
    fi
    
    # Health check
    local max_attempts=10
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        log "Health check attempt $attempt/$max_attempts..."
        
        if curl -f http://localhost:3000/health > /dev/null 2>&1; then
            log_success "Application is healthy"
            return 0
        fi
        
        sleep 2
        ((attempt++))
    done
    
    log_error "Health check failed after $max_attempts attempts"
    return 1
}

rollback() {
    log_error "Deployment failed - rolling back..."
    
    stop_application
    
    # Find latest backup
    local latest_backup=$(ls -t "${BACKUP_DIR}" | head -1)
    
    if [ -n "${latest_backup}" ]; then
        log "Restoring from backup: ${latest_backup}"
        
        # Safety check before deletion
        if [ -z "${APP_DIR}" ] || [ "${APP_DIR}" = "/" ]; then
            log_error "APP_DIR is not set properly or is root. Aborting."
            exit 1
        fi
        
        rm -rf "${APP_DIR:?}"/*
        tar -xzf "${BACKUP_DIR}/${latest_backup}" -C "${APP_DIR}"
        
        start_application
        
        if verify_deployment; then
            log_success "Rollback completed successfully"
        else
            log_error "Rollback failed - manual intervention required"
        fi
    else
        log_error "No backup found for rollback"
    fi
}

main() {
    log "========================================="
    log "Starting deployment of ${APP_NAME}"
    log "========================================="
    
    # Check prerequisites
    check_prerequisites
    
    # Create backup before deployment
    create_backup
    
    # Pull latest code
    pull_latest_code
    
    # Install dependencies
    install_dependencies
    
    # Run tests
    if ! run_tests; then
        rollback
        exit 1
    fi
    
    # Stop application
    stop_application
    
    # Start application
    start_application
    
    # Verify deployment
    if ! verify_deployment; then
        rollback
        exit 1
    fi
    
    log "========================================="
    log_success "Deployment completed successfully!"
    log "========================================="
}

# Run main function
main "$@"
