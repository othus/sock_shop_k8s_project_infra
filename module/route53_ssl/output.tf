output "ns_records" {
  value = data.aws_route53_zone.sockshop_zone.name_servers
}
output "cert-arn" {
   value = aws_acm_certificate.sockshop-certificate.arn
}