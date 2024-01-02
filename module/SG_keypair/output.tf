output "bastion_ansible_sg" {
  value = aws_security_group.bastion-ansible-sg.id
}
output "sockshop_k8s_sg" {
  value = aws_security_group.master_worker_sg.id
}
output "key_name" {
  value = aws_key_pair.project_key.id
}