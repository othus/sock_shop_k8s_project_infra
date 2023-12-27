output "bastion_public_ip" {
  value = aws_instance.sockshop_Bastion.public_ip
}