#!/bin/bash

display_usage() {
    echo "Usage: ./backup.sh <source_dir> <backup_dir>"
}

# Check arguments
if [ $# -lt 2 ]; then
    display_usage
    exit 1
fi

source_dir=$1
backup_dir=$2
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')

create_backup() {
    zip -r "${backup_dir}/backup_${timestamp}.zip" "$source_dir" >/dev/null

    if [ $? -eq 0 ]; then
        echo "Backup generated successfully: ${backup_dir}/backup_${timestamp}.zip"
    else
        echo "Backup failed"
        exit 1
    fi
}

perform_rotation() {
    backups=($(ls -t "${backup_dir}/backup_"*.zip 2>/dev/null))

    if [ "${#backups[@]}" -gt 5 ]; then
        echo "Performing rotation: keeping last 5 backups"

        backups_to_remove=("${backups[@]:5}")

        for backup in "${backups_to_remove[@]}"; do
            rm -f "$backup"
        done
    fi
}

create_backup
perform_rotation

