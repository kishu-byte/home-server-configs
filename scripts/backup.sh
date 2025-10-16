#!/bin/bash

# Homelab Backup Script
BACKUP_ROOT="/home/ubuntu/homelab/backups"
DATE=$(date +%Y%m%d_%H%M%S)
CONFIG_ROOT="/home/ubuntu/homelab/config"
NAS_BACKUP_PATH="/mnt/nas/Backups/homelab"

# Create backup directories
mkdir -p ${BACKUP_ROOT}/{configs,databases,logs}
mkdir -p ${NAS_BACKUP_PATH}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a ${BACKUP_ROOT}/backup.log
}

# Function to backup configurations
backup_configs() {
    log "Starting configuration backup..."
    tar -czf ${BACKUP_ROOT}/configs/homelab_configs_${DATE}.tar.gz -C ${CONFIG_ROOT} .
    log "Configuration backup completed"
}

# Function to backup databases
backup_databases() {
    log "Starting database backup..."
    
    # Backup MariaDB databases
    docker exec nextcloud-db mysqldump -u root -p${DB_ROOT_PASSWORD} --all-databases > ${BACKUP_ROOT}/databases/nextcloud_db_${DATE}.sql
    docker exec bookstack-db mysqldump -u root -p${DB_ROOT_PASSWORD} --all-databases > ${BACKUP_ROOT}/databases/bookstack_db_${DATE}.sql
    
    log "Database backup completed"
}

# Function to sync to NAS
sync_to_nas() {
    log "Syncing backups to NAS..."
    rsync -av --delete ${BACKUP_ROOT}/ ${NAS_BACKUP_PATH}/
    log "NAS sync completed"
}

# Function to clean old backups
cleanup_old_backups() {
    log "Cleaning up old backups..."
    find ${BACKUP_ROOT} -name "*.tar.gz" -mtime +7 -delete
    find ${BACKUP_ROOT} -name "*.sql" -mtime +7 -delete
    log "Cleanup completed"
}

# Function to send notification
send_notification() {
    if [ -n "$TELEGRAM_BOT_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ]; then
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
             -d chat_id="$TELEGRAM_CHAT_ID" \
             -d text="🔄 Homelab backup completed: $DATE"
    fi
}

# Main backup execution
main() {
    log "=== Starting Homelab Backup ==="
    
    backup_configs
    backup_databases
    sync_to_nas
    cleanup_old_backups
    send_notification
    
    log "=== Backup completed successfully ==="
}

# Execute main function
main
