output "Master_Node_IP" {
    value = aws_instance.sockshop_master-node.*.private_ip
  
}