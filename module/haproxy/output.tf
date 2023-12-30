output "haproxymain_ip" {
    value = aws_instance.haproxymain.public_ip
}
output "haproxybackup_ip" {
  value = aws_instance.haproxybackup.public_ip
}