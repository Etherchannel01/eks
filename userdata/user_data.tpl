#!/bin/bash

# Exit on any error
set -e

# DISA STIG Log Volume Setup for AWS EKS Nodes
echo "Starting STIG log volume setup..."

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
    
    
    # Get UUID for fstab
    uuid=$(blkid -s UUID -o value "$device")
    
    # Add to fstab with STIG-compliant mount options
    echo "UUID=$uuid $mount_point ext4 defaults,nodev,noexec,nosuid 0 2" >> /etc/fstab
    
    # Mount the volume
    mount "$mount_point"
    
    
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

# Setup volumes
setup_log_volume /dev/xvdf /var/log
setup_log_volume /dev/xvdg /var/log/audit
setup_log_volume /dev/xvdh /tmp
setup_log_volume /dev/xvdi /var/tmp

echo "STIG log volume setup completed"

# Restart services that write to logs
systemctl restart auditd || service auditd restart

echo "Log services restarted"