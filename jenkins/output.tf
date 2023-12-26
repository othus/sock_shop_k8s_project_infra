output "vpc-id" {
  value = aws_vpc.vpc.id
}
output "pubsub1-id" {
  value = aws_subnet.pubsub1.id
}
output "pubsub2-id" {
  value = aws_subnet.pubsub2.id
}
output "pubsub3-id" {
  value = aws_subnet.pubsub3.id
}
output "prvtsub1-id" {
  value = aws_subnet.prvtsub1.id
}
output "prvtsub2-id" {
  value = aws_subnet.prvtsub2.id
}
output "prvtsub3-id" {
  value = aws_subnet.prvtsub3.id
}
output "jenkins-server-ip" {
  value = aws_instance.jenkins_server.public_ip
}