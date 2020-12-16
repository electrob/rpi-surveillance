#!/bin/bash

sudo apt update
sudo apt install python-pip -y
pip install ansible

ansible-galaxy install nginxinc.nginx

echo "---
- hosts: localhost
  become: true
  roles:
    - role: nginxinc.nginx" | tee -a playbook.yml

ansible-playbook playbook.yml
