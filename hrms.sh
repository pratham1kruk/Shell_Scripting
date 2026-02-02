#!/bin/bash

set -e

REPO_URL="https://github.com/pratham1kruk/HR-management-system.git"
APP_DIR="HR-management-system"

code_clone() {
    if [ ! -d "$APP_DIR" ]; then
        echo "Cloning the HR-management-system app..."
        git clone "$REPO_URL"
    else
        echo "Repository already exists."
    fi
}

install_requirements() {
    echo "Installing dependencies..."
    sudo apt-get update -y
    sudo apt-get install -y docker.io nginx
}

enable_services() {
    echo "Enabling and starting docker and nginx services..."
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker ubuntu

    sudo systemctl enable nginx
    sudo systemctl start nginx
}

sync_env_secrets() {
    BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
    PROJECT_DIR="$BASE_DIR/$APP_DIR"
    SECRET_FILE="$BASE_DIR/secret.txt"

    if [ ! -f "$SECRET_FILE" ]; then
        echo "Error: secret.txt not found at $SECRET_FILE"
        exit 1
    fi

    if [ ! -d "$PROJECT_DIR" ]; then
        echo "Error: Project directory not found at $PROJECT_DIR"
        exit 1
    fi

    cd "$PROJECT_DIR" || exit 1

    cp .env.sample .env

    sed -i '/^BREVO_API_KEY=/d' .env
    sed -i '/^BREVO_SENDER_EMAIL=/d' .env
    sed -i '/^SECRET_KEY=/d' .env

    grep -E 'BREVO_API_KEY|BREVO_SENDER_EMAIL|SECRET_KEY' "$SECRET_FILE" >> .env

    chmod 600 .env

    echo ".env synced with secrets successfully"
}

deploy() {
    echo "Deployment step managed by systemd service, no manual commands needed here."
}

echo "****************** Deployment started *********************"

gode_clone
install_requirements
enable_services

sync_env_secrets   # <--- sync secrets before deploy

deploy

echo "****************** Deployment completed *********************"


