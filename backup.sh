#!/usr/bin/env bash
# Backup and Disaster Recovery Script
# - Backup multiple directories
# - Encrypt backup
# - Store backup remotely
# - Verify backup integrity

backup_script() {
        
    BACKUP_DIRS=(
        "/etc"
        "/home"
        "/var/www"
    )
    BACKUP_DEST="/mnt/backup"
    REMOTE_DEST="user@backupserver:/remote/backup"
    ENCRYPTION_KEY="/path/to/encryption/key"
    
    # Create backup timestamp
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUP_DEST/full_backup_$TIMESTAMP.tar.gz.gpg"
    
    # Create tar archive of specified directories
    tar -czf - "${BACKUP_DIRS[@]}" | \
    gpg --encrypt --recipient-file "$ENCRYPTION_KEY" > "$BACKUP_FILE"
    
    # Verify backup integrity
    if gpg --decrypt "$BACKUP_FILE" | tar -tz > /dev/null; then
        echo "Backup integrity verified"
    else
        echo "Backup integrity check failed"
        exit 1
    fi
    
    # Copy to remote backup location
    scp "$BACKUP_FILE" "$REMOTE_DEST"
    
    # Cleanup local backups older than 7 days
    find "$BACKUP_DEST" -name "full_backup_*.tar.gz.gpg" -mtime +7 -delete
}
