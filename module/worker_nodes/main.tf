# Create Worker Node
resource "aws_instance" "sockshop_worker-node" {
  ami                         = var.ubuntu
  instance_type               = var.instance_type
  subnet_id                   = element(var.subnet-id, count.index)
  vpc_security_group_ids      = [var.master_worker_sg]
  key_name                    = var.keypair_name
  count                       = var.instance_count
  
  tags = {
    Name = "${var.worker_instance_name}${count.index}"
  }
}