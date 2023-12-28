output "prometheus_lb_dns" {
  value = aws_lb.prometheus-lb.dns_name
}
output "grafana-lb" {
    value = aws_lb.grafana-lb.dns_name
}