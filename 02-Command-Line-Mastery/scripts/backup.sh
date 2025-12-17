#!/bin/bash

################################################################################
# Backup Script - Automated backup system
#
# This script creates backups of specified directories and manages retention.
# Can be run manually or via cron for scheduled backups.
#
# Usage: ./backup.sh
# Cron example: 0 2 * * * /path/to/backup.sh
################################################################################

set -e
set -u
set -o pipefail

# Configuration
BACKUP_NAME="myapp"
SOURCE_DIRS=(
    "/opt/applications/myapp"
    "/etc/myapp"
)
BACKUP_ROOT="/var/backups"
BACKUP_DIR="${BACKUP_ROOT}/${BACKUP_NAME}"
RETENTION_DAYS=30
LOG_FILE="${BACKUP_ROOT}/backup.log"

# Create backup directory if it doesn't exist
mkdir -p "${BACKUP_DIR}"

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "${LOG_FILE}" >&2
}

# Check if source directories exist
check_sources() {
    log "Checking source directories..."
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ ! -d "$dir" ]; then
            log_error "Source directory does not exist: $dir"
            return 1
        fi
        log "  ✓ $dir"
    done
}

# Create backup
create_backup() {
    local timestamp=$(date +'%Y%m%d_%H%M%S')
    local backup_file="${BACKUP_DIR}/${BACKUP_NAME}_${timestamp}.tar.gz"
    
    log "Creating backup: ${backup_file}"
    
    # Create tar archive
    tar -czf "${backup_file}" "${SOURCE_DIRS[@]}" 2>/dev/null || {
        log_error "Backup creation failed"
        return 1
    }
    
    # Calculate and log backup size
    local size=$(du -h "${backup_file}" | cut -f1)
    log "Backup created successfully (Size: ${size})"
    
    # Create checksum
    local checksum_file="${backup_file}.sha256"
    sha256sum "${backup_file}" > "${checksum_file}"
    log "Checksum created: ${checksum_file}"
    
    echo "${backup_file}"
}

# Verify backup integrity
verify_backup() {
    local backup_file=$1
    local checksum_file="${backup_file}.sha256"
    
    log "Verifying backup integrity..."
    
    if [ ! -f "${checksum_file}" ]; then
        log_error "Checksum file not found"
        return 1
    fi
    
    cd "$(dirname "${backup_file}")"
    if sha256sum -c "${checksum_file}" > /dev/null 2>&1; then
        log "Backup verification successful"
        return 0
    else
        log_error "Backup verification failed"
        return 1
    fi
}

# Clean old backups
cleanup_old_backups() {
    log "Cleaning up old backups (keeping last ${RETENTION_DAYS} days)..."
    
    # Find and delete backups older than retention period
    local deleted=0
    while IFS= read -r file; do
        rm -f "$file" "${file}.sha256"
        log "Deleted old backup: $(basename "$file")"
        ((deleted++))
    done < <(find "${BACKUP_DIR}" -name "${BACKUP_NAME}_*.tar.gz" -type f -mtime +${RETENTION_DAYS})
    
    if [ $deleted -eq 0 ]; then
        log "No old backups to delete"
    else
        log "Deleted $deleted old backup(s)"
    fi
}

# List recent backups
list_backups() {
    log "Recent backups:"
    find "${BACKUP_DIR}" -name "${BACKUP_NAME}_*.tar.gz" -type f -printf "%T@ %Tc %s %p\n" | \
        sort -rn | \
        head -10 | \
        while read -r timestamp date size path; do
            local size_mb=$((size / 1024 / 1024))
            log "  $(basename "$path") - ${size_mb}MB"
        done
}

# Send notification (optional)
send_notification() {
    local status=$1
    local message=$2
    
    # This is a placeholder - implement your notification method
    # Examples: email, Slack, etc.
    log "Notification: [$status] $message"
    
    # Example: Send to Slack (if webhook URL is configured)
    # if [ -n "${SLACK_WEBHOOK_URL:-}" ]; then
    #     curl -X POST -H 'Content-type: application/json' \
    #         --data "{\"text\":\"[$status] $message\"}" \
    #         "${SLACK_WEBHOOK_URL}"
    # fi
}

# Main execution
main() {
    log "========================================="
    log "Starting backup process"
    log "========================================="
    
    # Check sources
    if ! check_sources; then
        send_notification "FAILED" "Backup failed: source check"
        exit 1
    fi
    
    # Create backup
    backup_file=$(create_backup)
    if [ $? -ne 0 ]; then
        send_notification "FAILED" "Backup creation failed"
        exit 1
    fi
    
    # Verify backup
    if ! verify_backup "${backup_file}"; then
        send_notification "FAILED" "Backup verification failed"
        exit 1
    fi
    
    # Cleanup old backups
    cleanup_old_backups
    
    # List recent backups
    list_backups
    
    log "========================================="
    log "Backup process completed successfully"
    log "========================================="
    
    send_notification "SUCCESS" "Backup completed: $(basename "${backup_file}")"
}

# Run main function
main "$@"
