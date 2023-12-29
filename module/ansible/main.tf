# Create EC2 Instance for Ansible 
resource "aws_instance" "sockshop_ansible" {
  ami                    = var.ubuntu
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = [var.ansible-SG]
  key_name               = var.key_name
  user_data              = templatefile("../module/ansible/ansible.sh", {
    private_key          = var.private_key,
    haproxymain_ip       = var.haproxymain_ip,
    haproxybackup_ip     = var.haproxybackup_ip,
    main_master_ip       = var.main_master_ip,
    master1_ip           = var.master1_ip,
    master2_ip           = var.master2_ip,
    worker1_ip           = var.worker1_ip,
    worker2_ip           = var.worker2_ip,
    worker3_ip           = var.worker3_ip
  })
  tags = {
    Name = var.ansible-name
  }
}

# Create null resource to help copy the playbook directory into ansible server
resource "null_resource" "copy-playbook-disable_api_termination" {
  connection {
    type = "ssh"
    host = aws_instance.sockshop_ansible.private_ip
    user = "ubuntu"
    private_key = var.private_key
    bastion_host = var.bastion_host
    bastion_user = "ubuntu"
    bastion_private_key = var.private_key
  }
  provisioner "file" {
    source = "./module/ansible/playbooks"
    destination = "/home/ubuntu/playbooks"
  }
}