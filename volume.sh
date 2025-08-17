#!/bin/bash

# Simple DISA STIG Log Volume Setup for AWS UserData
# This script creates separate volumes for system logs per DISA STIG requirements

# Exit on any error
set -e

# Wait for EBS volumes to be available
sleep 30

# Function to setup log volume
setup_log_volume() {
    local device=$1
    local mount_point=$2
    
    # Wait for device to be available
    while [ ! -b "$device" ]; do
        echo "Waiting for $device..."
        sleep 5
    done
    
    # Create filesystem
    mkfs.ext4 -F "$device"
    
    # Create mount point if it doesn't exist
    mkdir -p "$mount_point"
    
    # Move existing data if any
    if [ "$(ls -A $mount_point 2>/dev/null)" ]; then
        mkdir -p /tmp/backup_$(basename $mount_point)
        mv "$mount_point"/* /tmp/backup_$(basename $mount_point)/
    fi
    
    # Get UUID for fstab
    uuid=$(blkid -s UUID -o value "$device")
    
    # Add to fstab with STIG-compliant mount options
    echo "UUID=$uuid $mount_point ext4 defaults,nodev,noexec,nosuid 0 2" >> /etc/fstab
    
    # Mount the volume
    mount "$mount_point"
    
    # Restore data if backed up
    if [ -d "/tmp/backup_$(basename $mount_point)" ]; then
        mv /tmp/backup_$(basename $mount_point)/* "$mount_point"/
        rmdir /tmp/backup_$(basename $mount_point)
    fi
    
    # Set proper permissions
    case $mount_point in
        "/var/log")
            chmod 755 "$mount_point"
            ;;
        "/var/log/audit")
            chmod 700 "$mount_point"
            ;;
        "/tmp")
            chmod 1777 "$mount_point"
            ;;
        "/var/tmp")
            chmod 1777 "$mount_point"
            ;;
    esac
    
    echo "Configured $mount_point on $device"
}

# Main execution
echo "Starting STIG log volume setup..."

# Setup volumes - adjust device names as needed for your AWS setup
# These assume you've attached EBS volumes at these device paths

# Uncomment and modify the lines below based on your EBS volume attachments:

# /var/log volume (adjust /dev/xvdf to your actual device)
 setup_log_volume /dev/xvdf /var/log

# /var/log/audit volume (adjust /dev/xvdg to your actual device)  
 setup_log_volume /dev/xvdg /var/log/audit

# /tmp volume (adjust /dev/xvdh to your actual device)
 setup_log_volume /dev/xvdh /tmp

# /var/tmp volume (adjust /dev/xvdi to your actual device)
 setup_log_volume /dev/xvdi /var/tmp



echo "STIG log volume setup completed"

# Restart services that write to logs
systemctl restart rsyslog || service rsyslog restart
systemctl restart auditd || service auditd restart

echo "Log services restarted"