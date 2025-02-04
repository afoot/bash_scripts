#!/usr/bin/env bash

# 1. Log Rotation and Cleanup Script
log_rotation_cleanup() {
    # Challenge: Create a script that:
    # - Rotates log files larger than 100MB
    # - Keeps only the last 5 rotated logs
    # - Compresses old logs
    
    LOG_DIR="/var/log/myapp"
    MAX_SIZE=100  # 100MB
    MAX_ROTATIONS=5

    for log_file in "$LOG_DIR"/*.log; do
        if [ -f "$log_file" ] && [ $(du -m "$log_file" | cut -f1) -gt "$MAX_SIZE"]; then
            timestamp=$(date +%Y:%m:%d_%H%M%S)
            compressed_log="${timestamp}.${log_file}.gz"
            gzip -c "$log_file" > "$compressed_log"

            # Truncate the original log file
            : > "$log_file"
        fi
    done

    # Remove old rotated logs, keeping only the last 5
    find "$LOG_DIR" -type f -name "*.gz" 2>/dev/null | sort | head -n -"$MAX_ROTATIONS" | xargs rm -f
}