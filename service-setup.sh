#!/usr/bin/env bash

user=jet

# Specific to Jetson Nano
# Defaulting to 5Watts mode  
sudo nvpmodel -m 1

# Constant journal logs for all the services combined
sudo journalctl --vacuum-size=500M

cd /home/"${user}"/Desktop/rpi-surveillance/

# Stopping and disabling the related services
sudo systemctl stop rpi-surveillance.service
sudo systemctl stop nvargus-daemon.service
sudo systemctl disable rpi-surveillance.service
sudo rm /etc/systemd/system/nvargus-daemon.service
sudo rm /lib/systemd/system/rpi-surveillance.service
sudo systemctl reset-failed

sudo cp ./nvargus-daemon.service /etc/systemd/system/

# Defining the service UNIT file 
echo "[Unit]
Description=RPI Surveillance Service

# This is for restarting the whole device if the software doesnt work
# Uncomment if you need this kind of feature 
# SartLimitIntervalSec=900
# StartLimitAction=reboot

After=network.target
Requires=nvargus-daemon.service
BindsTo=nvargus-daemon.service

[Service]
Type=simple
ExecStart=/bin/sh /home/"${user}"/rpi-surveillance/rpi-surveillance.sh
restart
User="${user}"

[Install]
WantedBy=multi-user.target" | sudo tee -a /lib/systemd/system/rpi-surveillance.service

# Describing the UNIT file for the updation script
echo "[Unit]
Description=RPI Surveillance Service Update
After=network.target

[Service]
Type=simple
User="${user}"
Restart=always
RestartSec=600
ExecStart=/bin/sh -c /home/"${user}"/catalystos-surveillance/rpi-surveillance-update.sh

[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/rpi-surveillance-update.service

# Reloading the linux service daemon and restarting the related services
sudo systemctl daemon-reload

sudo systemctl enable rpi-surveillance.service
sudo systemctl start rpi-surveillance.service

