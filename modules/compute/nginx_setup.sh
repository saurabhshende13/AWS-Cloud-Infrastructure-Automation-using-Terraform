#!/bin/bash
# Update the package list
sudo apt-get update

# Install Nginx
sudo apt-get install -y nginx

# Start Nginx service
sudo systemctl start nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Print the Nginx version
nginx -v

# Print a message indicating successful installation
echo "Nginx has been successfully installed and started!"