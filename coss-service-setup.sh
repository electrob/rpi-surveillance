#!/usr/bin/env bash

user=jet
sudo nvpmodel -m 1
sudo journalctl --vacuum-size=500M

cd /home/"${user}"/Desktop/catalystos-surveillance/

sudo systemctl stop catalystos-surveillance.service
sudo systemctl stop nvargus-daemon.service
sudo systemctl disable catalystos-surveillance.service
sudo rm /etc/systemd/system/nvargus-daemon.service
sudo rm /lib/systemd/system/catalystos-surveillance.service
sudo systemctl reset-failed

sudo cp ./nvargus-daemon.service /etc/systemd/system/

echo "[Unit]
Description=CatalystOS Surveillance Service
StartLimitIntervalSec=900
StartLimitAction=reboot
After=network.target
Requires=nvargus-daemon.service
BindsTo=nvargus-daemon.service

[Service]
Type=simple
ExecStart=/bin/sh /home/"${user}"/catalystos-survellance/catalystos_surveillance.sh
restart
User="${user}"

[Install]
WantedBy=multi-user.target" | sudo tee -a /lib/systemd/system/catalystos.service

echo "[Unit]
Description=CatalystOS Surveillance Service Update
After=network.target

[Service]
Type=simple
User="${user}"
Restart=always
RestartSec=600
ExecStart=/bin/sh -c /home/"${user}"/catalystos-surveillance/catalystos-surveillance-update.sh

[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/catalystos-surveillance-update.service

sudo systemctl daemon-reload

sudo systemctl enable catalystos-surveillance.service
sudo systemctl start catalystos-surveillance.service

