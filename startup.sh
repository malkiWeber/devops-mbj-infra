#!/bin/bash
# Update package lists
sudo apt-get update -y
# Retry update if necessary
if [ $? -ne 0 ]; then
  sudo apt-get update --fix-missing -y
fi
# Install Nginx
sudo apt-get install -y nginx
# Create the required directory for the web content
sudo mkdir -p /var/www/html
# Write "Hello World" to the index.html file
echo "Hello World" | sudo tee /var/www/html/index.html
# Restart Nginx to apply changes
sudo systemctl restart nginx