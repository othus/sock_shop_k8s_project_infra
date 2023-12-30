#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo apt-get update -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible python3-pip -y
sudo pip3 install boto3 boto botocore
sudo bash -c ' echo "strictHostKeyChecking No" >> /etc/ssh/ssh_config'

echo "${private_key}" >> /home/ubuntu/sockshop-key
sudo chmod 400 /home/ubuntu/sockshop-key
sudo chown ubuntu:ubuntu /home/ubuntu/sockshop-key

sudo chown -R ubuntu:ubuntu /etc/ansible 
sudo chmod 777 /etc/ansible/hosts
sudo hostnamectl set-hostname Ansible

sudo echo HAPROXY1: "${haproxymain_ip}" > /home/ubuntu/ha-ip.yml
sudo echo HAPROXY2: "${haproxybackup_ip}" >> /home/ubuntu/ha-ip.yml

sudo echo "[HAPROXY1]" > /etc/ansible/hosts
sudo echo "${haproxymain_ip} ansible_ssh_private_key_file=/home/ubuntu/sockshop-key" >> /etc/ansible/hosts
sudo echo "[HAPROXY2]" >> /etc/ansible/hosts
sudo echo "${haproxybackup_ip} ansible_ssh_private_key_file=/home/ubuntu/sockshop-key" >> /etc/ansible/hosts

sudo echo "[main_master]" >> /etc/ansible/hosts
sudo echo "${main_master_ip} ansible_ssh_private_key_file=/home/ubuntu/sockshop-key" >> /etc/ansible/hosts
sudo echo "[member_maestr]" >> /etc/ansible/hosts
sudo echo "${master1_ip} ansible_ssh_private_key_file=/home/ubuntu/sockshop-key" >> /etc/ansible/hosts
sudo echo "${master2_ip} ansible_ssh_private_key_file=/home/ubuntu/sockshop-key" >> /etc/ansible/hosts
sudo echo "[Worker]" >> /etc/ansible/hosts
sudo echo "${worker1_ip} ansible_ssh_private_key_file=/home/ubuntu/sockshop-key" >> /etc/ansible/hosts
sudo echo "${worker2_ip} ansible_ssh_private_key_file=/home/ubuntu/sockshop-key" >> /etc/ansible/hosts
sudo echo "${worker3_ip} ansible_ssh_private_key_file=/home/ubuntu/sockshop-key" >> /etc/ansible/hosts 

sudo su -c "ansible-playbook /home/ubuntu/playbooks/install.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/ha-keepalivd.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/main_master.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/member_master.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/worker.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/ha-kubectl.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/monitoring.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/monitoring2.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/stage.yml" ubuntu
sudo su -c "ansible-playbook /home/ubuntu/playbooks/prod.yml" ubuntu
