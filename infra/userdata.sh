#!/bin/bash
set -e # Exit immediately if a command fails

# 1. Update and install dependencies
sudo apt update -y
sudo apt install -y git nodejs npm

# 2. Create the app directory
mkdir -p /opt/webapp
cd /opt/webapp

# 3. Clone the repo's contents directly into the current directory (.)
# This ensures server.js is at /opt/webapp/server.js
git clone https://github.com/ar4487/node-basic-api.git .

# 4. Install npm dependencies
npm install

# 5. Fix permissions: Give the 'ubuntu' user ownership of the app
sudo chown -R ubuntu:ubuntu /opt/webapp

# 6. Create the systemd service file
# The paths are now correct because of step 3
cat <<EOF | sudo tee /etc/systemd/system/webapp.service
[Unit]
Description=WebApp
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/webapp
ExecStart=/usr/bin/node /opt/webapp/index.js
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 7. Start the service
sudo systemctl daemon-reload
sudo systemctl enable webapp
sudo systemctl start webapp