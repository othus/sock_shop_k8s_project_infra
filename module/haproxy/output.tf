output "prod_HAProxy_IP" {
    value = aws_instance.haproxy1.private_ip
}