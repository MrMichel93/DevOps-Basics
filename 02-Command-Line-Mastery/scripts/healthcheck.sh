#!/bin/bash

################################################################################
# Health Check Script - Monitor service health
#
# This script checks the health of various services and system resources.
# Can be used for monitoring, alerting, or as a pre-deployment check.
#
# Usage: ./healthcheck.sh [service_name]
# Example: ./healthcheck.sh all
################################################################################

set -u
set -o pipefail

# Configuration
APP_NAME="myapp"
APP_PORT=3000
APP_HEALTH_ENDPOINT="http://localhost:${APP_PORT}/health"
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=85
LOG_FILE="/var/log/healthcheck.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Status tracking
OVERALL_STATUS="HEALTHY"
ISSUES=()

# Logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $*" | tee -a "${LOG_FILE}"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" | tee -a "${LOG_FILE}"
    ISSUES+=("WARNING: $*")
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $*" | tee -a "${LOG_FILE}"
    OVERALL_STATUS="UNHEALTHY"
    ISSUES+=("FAILURE: $*")
}

# Check if process is running
check_process() {
    log "Checking if ${APP_NAME} process is running..."
    
    if pgrep -f "${APP_NAME}" > /dev/null; then
        local pid=$(pgrep -f "${APP_NAME}")
        local cpu=$(ps -p $pid -o %cpu= || echo "0")
        local mem=$(ps -p $pid -o %mem= || echo "0")
        log_pass "Process is running (PID: $pid, CPU: ${cpu}%, MEM: ${mem}%)"
        return 0
    else
        log_fail "Process is not running"
        return 1
    fi
}

# Check HTTP endpoint
check_http_endpoint() {
    log "Checking HTTP endpoint: ${APP_HEALTH_ENDPOINT}"
    
    local response=$(curl -s -o /dev/null -w "%{http_code}" -m 5 "${APP_HEALTH_ENDPOINT}" 2>/dev/null)
    
    if [ "$response" = "200" ]; then
        log_pass "HTTP endpoint returned 200 OK"
        return 0
    elif [ "$response" = "000" ]; then
        log_fail "Cannot connect to HTTP endpoint"
        return 1
    else
        log_fail "HTTP endpoint returned ${response}"
        return 1
    fi
}

# Check port is listening
check_port() {
    log "Checking if port ${APP_PORT} is listening..."
    
    if netstat -tuln 2>/dev/null | grep -q ":${APP_PORT} " || ss -tuln 2>/dev/null | grep -q ":${APP_PORT} "; then
        log_pass "Port ${APP_PORT} is listening"
        return 0
    else
        log_fail "Port ${APP_PORT} is not listening"
        return 1
    fi
}

# Check CPU usage
check_cpu() {
    log "Checking CPU usage..."
    
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    cpu_usage=$(printf "%.0f" "$cpu_usage")
    
    if [ "$cpu_usage" -ge "$CPU_THRESHOLD" ]; then
        log_warn "CPU usage is high: ${cpu_usage}% (threshold: ${CPU_THRESHOLD}%)"
        return 1
    else
        log_pass "CPU usage is OK: ${cpu_usage}%"
        return 0
    fi
}

# Check memory usage
check_memory() {
    log "Checking memory usage..."
    
    local mem_usage=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
    
    if [ "$mem_usage" -ge "$MEMORY_THRESHOLD" ]; then
        log_warn "Memory usage is high: ${mem_usage}% (threshold: ${MEMORY_THRESHOLD}%)"
        return 1
    else
        log_pass "Memory usage is OK: ${mem_usage}%"
        return 0
    fi
}

# Check disk usage
check_disk() {
    log "Checking disk usage..."
    
    local disk_usage=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    if [ "$disk_usage" -ge "$DISK_THRESHOLD" ]; then
        log_warn "Disk usage is high: ${disk_usage}% (threshold: ${DISK_THRESHOLD}%)"
        return 1
    else
        log_pass "Disk usage is OK: ${disk_usage}%"
        return 0
    fi
}

# Check log file size
check_log_size() {
    log "Checking log file sizes..."
    
    local log_dir="/var/log/${APP_NAME}"
    
    if [ ! -d "$log_dir" ]; then
        log_warn "Log directory does not exist: ${log_dir}"
        return 0
    fi
    
    local large_logs=$(find "$log_dir" -type f -size +100M)
    
    if [ -n "$large_logs" ]; then
        log_warn "Large log files found (>100MB):"
        echo "$large_logs" | while read -r file; do
            local size=$(du -h "$file" | cut -f1)
            log "  - $file (${size})"
        done
        return 1
    else
        log_pass "Log file sizes are OK"
        return 0
    fi
}

# Check database connection (example)
check_database() {
    log "Checking database connection..."
    
    # Example for PostgreSQL
    # Adjust for your database
    if command -v psql > /dev/null; then
        if PGPASSWORD="${DB_PASSWORD:-password}" psql -h localhost -U "${DB_USER:-postgres}" -d "${DB_NAME:-myapp}" -c "SELECT 1" > /dev/null 2>&1; then
            log_pass "Database connection OK"
            return 0
        else
            log_fail "Cannot connect to database"
            return 1
        fi
    else
        log "Database check skipped (psql not found)"
        return 0
    fi
}

# Generate report
generate_report() {
    log ""
    log "========================================="
    log "Health Check Summary"
    log "========================================="
    log "Overall Status: ${OVERALL_STATUS}"
    log ""
    
    if [ ${#ISSUES[@]} -eq 0 ]; then
        log "✓ All checks passed"
    else
        log "Issues found:"
        for issue in "${ISSUES[@]}"; do
            log "  - $issue"
        done
    fi
    
    log "========================================="
}

# Main execution
main() {
    local check_type="${1:-all}"
    
    log "========================================="
    log "Starting health check: ${check_type}"
    log "========================================="
    log ""
    
    case "$check_type" in
        process)
            check_process
            ;;
        http)
            check_http_endpoint
            ;;
        port)
            check_port
            ;;
        cpu)
            check_cpu
            ;;
        memory)
            check_memory
            ;;
        disk)
            check_disk
            ;;
        database)
            check_database
            ;;
        all)
            check_process
            check_port
            check_http_endpoint
            check_cpu
            check_memory
            check_disk
            check_log_size
            # check_database  # Uncomment if you have a database
            ;;
        *)
            echo "Usage: $0 [process|http|port|cpu|memory|disk|database|all]"
            exit 1
            ;;
    esac
    
    log ""
    generate_report
    
    # Exit with appropriate code
    if [ "$OVERALL_STATUS" = "HEALTHY" ]; then
        exit 0
    else
        exit 1
    fi
}

# Run main function
main "$@"
