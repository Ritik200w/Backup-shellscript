#!/bin/bash

<< readme
This is a script for backup 

usage:
./backup.sh <path to your source> <path to backup folder>
readme

function display_usage {
    echo "usage: ./backup.sh <path to your source> <path to backup folder>"
}

if [ $# -lt 0 ]; then
    display_usage
    exit 1
fi

source_dir=$1
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
backups_dir=$2

function create_backups {
    zip -r "${backups_dir}/backup_${timestamp}.zip" "${source_dir}"

    if [ $? -eq 0 ]; then
        echo "Backup generated successfully for ${timestamp}"
    else
        echo "Error: Backup failed for ${timestamp}"
    fi
}

function perform_rotation {
    # List backups sorted by time, newest first
    backups=($(ls -t "${backups_dir}/backup_"*.zip 2>/dev/null))
    
    if [ ${#backups[@]} -gt 5 ]; then
        echo "Performing rotation to keep only the 5 most recent backups"

        # Remove backups exceeding the limit
        backups_to_remove=("${backups[@]:5}")
        echo "Backups to remove: ${backups_to_remove[@]}"

        for backup in "${backups_to_remove[@]}"; do
            rm -rf "${backup}"
        done
    fi
}

create_backups
perform_rotation
