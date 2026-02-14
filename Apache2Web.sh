#!/bin/bash

# Update system packages
sudo apt update -y

# Install Apache web server
sudo apt install -y apache2

# Start Apache service
sudo systemctl start apache2

# Enable Apache to start on boot
sudo systemctl enable apache2

# Create a simple HTML file to verify the web server is running
# Includes the dynamic hostname
echo "<html><h1>Welcome to Apache Web Server on Ubuntu - $(hostname)!</h1></html>" | sudo tee /var/www/html/index.html

