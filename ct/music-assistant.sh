#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2025
# Author: Your Name
# License: MIT
# https://github.com/yourusername/proxmox-ve-helper-scripts

function header_info {
clear
cat <<"EOF"
    __  ___           _        ___              _      __              __ 
   /  |/  /_  _______(_)____  /   |  __________(_)____/ /_____ _____  / /_
  / /|_/ / / / / ___/ / ___/ / /| | / ___/ ___/ / ___/ __/ __ `/ __ \/ __/
 / /  / / /_/ (__  ) / /__  / ___ |(__  |__  ) (__  ) /_/ /_/ / / / / /_  
/_/  /_/\__,_/____/_/\___/ /_/  |_/____/____/_/____/\__/\__,_/_/ /_/\__/  
                                                                           
EOF
}
header_info
echo -e "Loading..."
APP="Music Assistant"
var_disk="4"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/music-assistant ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating ${APP}"
systemctl stop music-assistant
source /opt/music-assistant/bin/activate
pip install --upgrade music-assistant
systemctl start music-assistant
msg_ok "Updated ${APP}"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:8095${CL} \n"