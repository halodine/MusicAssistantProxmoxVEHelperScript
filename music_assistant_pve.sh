#!/usr/bin/env bash

# Copyright (c) 2025
# Author: Your Name
# License: MIT
# https://github.com/yourusername/proxmox-ve-helper-scripts

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y git
$STD apt-get install -y python3
$STD apt-get install -y python3-pip
$STD apt-get install -y python3-venv
$STD apt-get install -y alsa-utils
msg_ok "Installed Dependencies"

msg_info "Installing Music Assistant"
cd /opt
$STD python3 -m venv music-assistant
source /opt/music-assistant/bin/activate
$STD pip install --upgrade pip
$STD pip install music-assistant
msg_ok "Installed Music Assistant"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/music-assistant.service
[Unit]
Description=Music Assistant Server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/music-assistant
ExecStart=/opt/music-assistant/bin/mass --config /opt/music-assistant/data
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now music-assistant.service
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"

msg_info "Setting up Music Assistant Directories"
mkdir -p /opt/music-assistant/data
mkdir -p /mnt/music
msg_ok "Created Directories"

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:8095${CL} \n"