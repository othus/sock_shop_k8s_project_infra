output "prometheus_lb_dns" {
  value = aws_lb.prometheus-lb.dns_name
}
output "prometheus_zone_id" {
  value = aws_lb.prometheus-lb.zone_id
}
output "grafana-lb-dns" {
    value = aws_lb.grafana-lb.dns_name
}
output "grafana_zone_id" {
  value = aws_lb.grafana-lb.zone_id
}