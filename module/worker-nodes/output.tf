output "Worker-Node_private_ip" {
  value       = aws_instance.sockshop_worker-node.*.private_ip
  description = "Worker-Node private IP"
}
output "Worker-Node_InstanceID" {
  value       = aws_instance.sockshop_worker-node.*.id
  description = "Worker-Node Instance ID"
}