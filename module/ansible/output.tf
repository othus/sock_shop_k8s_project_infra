output "ansible_IP" {
  value       = aws_instance.sockshop_ansible.private_ip
  description = "Ansible Private IP"
}