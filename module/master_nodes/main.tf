# Create master node
resource "aws_instance" "sockshop_master-node" {
  ami                         = var.ubuntu
  instance_type               = var.instance_type
  subnet_id                   = element(var.subnet-id, count.index) 
  vpc_security_group_ids      = [var.master_worker_sg]
  key_name                    = var.keypair_name
  count                       = var.instance_count

  tags = {
    Name = "${var.master_instance_name}${count.index}"
  }
}