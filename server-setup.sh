#!/bin/bash

# Installing nginx via Ansible
sudo apt update
sudo apt install python-pip -y
pip install ansible

ansible-galaxy install nginxinc.nginx

# Minimal nginx configuration
echo "---
- hosts: localhost
  become: true
  roles:
    - role: nginxinc.nginx" | tee -a playbook.yml

ansible-playbook playbook.yml
