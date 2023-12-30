output "bastion_ansible_sg" {
  value = aws_security_group.bastion-ansible-sg.id
}
output "sockshop_k8s_sg" {
  value = aws_security_group.sockshop_mas_work_sg.id
}
output "key_name" {
  value = aws_key_pair.project_key.id
}