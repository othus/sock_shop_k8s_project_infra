resource "aws_instance" "sockshop_Bastion" {
  ami                         = var.ubuntu
  instance_type               = var.instance_type
  subnet_id                   = var.subnets
  vpc_security_group_ids      = [var.bastion-sg]
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = templatefile("./module/Bastion/bastion.sh", {
    private-key               = var.private-key
})
  
  tags = {
    Name = var.bastion-name
  }
}