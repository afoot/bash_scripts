#!/usr/bin/env bash

# Server Health Monitoring Script
# Challenge: Create a script that:
# - Checks disk space
# - Monitors CPU usage
# - Checks free memory
# - Generates an alert if any metric is critical

server_health_check () {

# Check disk usage
    disk_usage=$(df -h / | awk 'NR==2 {print $5}'| cut -d'%' -f1)

# Check memory usage
    memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

# Check CPU usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Generate report
    report_file="/tmp/server_health_$(date +"%Y%m%d").log"

    {
        echo "Server Health Report - $(date)"
        echo "----------------------------"
        echo "Disk Usage: $disk_usage%"
        echo "CPU Usage: $cpu_usage%"
        echo "Memory Usage: ${memory_usage%.*}%"
        
        # Set critical thresholds
        if [ "$disk_usage" -gt 90 ]; then
            echo "CRITICAL: Disk space is over 90%"
        fi
        
        if [ "${cpu_usage%.*}" -gt 80 ]; then
            echo "CRITICAL: CPU usage is over 80%"
        fi
        
        if [ "${memory_usage%.*}" -gt 90 ]; then
            echo "CRITICAL: Memory usage is over 90%"
        fi
    } > "$report_file"
    
    # Optional: Send email alert
    if grep -q "CRITICAL" "$report_file"; then
        mail -s "Server Health Alert" admin@company.com < "$report_file"
    fi
}