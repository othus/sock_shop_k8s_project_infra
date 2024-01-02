# TLS RSA Public & Private key Resource
resource "tls_private_key" "Keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Local Private key File of the TLS key Resource
resource "local_file" "Keypair" {
  content         = tls_private_key.Keypair.private_key_pem
  file_permission = "600"
  filename        = "keypair.pem"
}

# AWS Keypair Resource
resource "aws_key_pair" "project_key" {
  key_name   = "keypair"
  public_key = tls_private_key.Keypair.public_key_pem
}

# Bastion Security Group Resource
resource "aws_security_group" "bastion-ansible-sg" {
  name        = var.bastion_ansible_sg
  description = "Allow inbound SSH traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "SSH ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = var.bastion_ansible_sg
  }
}

#Security group for Masters/worker node
resource "aws_security_group" "master_worker_sg" {
  name = var.k8s_SG
  description = "Allow inbound Traffic"
  vpc_id = var.vpc_id

  ingress {
    description = "Http Proxy"
    from_port = var.port_proxy
    to_port = var.port_proxy
    protocol = "tcp"
    cidr_blocks =[var.all-cidr]
  }
   ingress {
    description = "Http80"
    from_port = var.port_proxy3
    to_port = var.port_proxy3
    protocol = "tcp"
    cidr_blocks =[var.all-cidr]
  }
  ingress {
    description = "ssh access"
    from_port = var.port_ssh
    to_port = var.port_ssh
    protocol = "tcp"
    cidr_blocks =[var.all-cidr]
  }

  ingress {
    from_port = var.port_proxy2
    to_port = var.port_proxy2
    protocol = "tcp"
    cidr_blocks =[var.all-cidr]
  }

    ingress { 
    from_port = var.port_app
    to_port = var.port_app
    protocol = "tcp"
    cidr_blocks =[var.all-cidr]
  }

   ingress { 
    from_port = var.port_https
    to_port = var.port_https
    protocol = "tcp"
    cidr_blocks =[var.all-cidr]
  }

    ingress { 
    from_port = var.port_graf
    to_port = var.port_graf
    protocol = "tcp"
    cidr_blocks =[var.all-cidr]
  }

    ingress { 
    from_port = var.port_prom
    to_port = var.port_prom
    protocol = "tcp"
    cidr_blocks =[var.all-cidr]
  }
    ingress { 
    from_port = var.port_etcd
    to_port = var.port_prom
    protocol = "tcp"
    cidr_blocks =[var.all-cidr]
  }
    ingress { 
    from_port = var.port_etcd_client
    to_port = var.port_prom
    protocol = "tcp"
    cidr_blocks =[var.all-cidr]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.all-cidr]
  }

  tags = {
    Name = var.k8s_SG
  }
}
