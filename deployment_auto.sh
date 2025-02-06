#!/usr/bin/env bash

# 3. Deployment Automation Script
    # - Create a deployment script that:
    # - Pulls latest code from Git
    # - Installs dependencies
    # - Runs tests
    # - Performs zero-downtime deployment
deployment_script() {
    
    REPO_URL="https://github.com/company/myapp.git"
    APP_DIR="/var/www/myapp"
    CURRENT_DIR="$APP_DIR/current"
    NEW_DIR="$APP_DIR/releases/release_$(date +"%Y%m%d_%H%M%S")"
    
    # Clone repository
    git clone "$REPO_URL" "$NEW_DIR"
    
    # Change to new directory
    cd "$NEW_DIR"
    
    # Install dependencies
    npm install
    
    # Run tests
    if ! npm test; then
        echo "Tests failed. Deployment aborted."
        rm -rf "$NEW_DIR"
        exit 1
    fi
    
    # Create symlink for zero-downtime deployment
    ln -sfn "$NEW_DIR" "$CURRENT_DIR"
    
    # Restart application
    pm2 restart all
    
    # Cleanup old releases (keep last 3)
    cd "$APP_DIR/releases"
    ls -t | tail -n +4 | xargs rm -rf
}