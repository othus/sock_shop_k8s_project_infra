output "lb-tg" {
    value = aws_lb_target_group.prod-target_grp.arn
}

output "lb-dns" {
    value = aws_lb.prod-lb.dns_name
}

output "lb-zone_id" {
    value = aws_lb.prod-lb.zone_id
}

output "lb-arn" {
    value = aws_lb.prod-lb.arn
}
output "stg-lb-tg" {
    value = aws_lb_target_group.stg-target_grp.arn
}

output "stg-lb-dns" {
    value = aws_lb.stg-lb.dns_name
}

output "stg-lb-zone_id" {
    value = aws_lb.stg-lb.zone_id
}

output "stg-lb-arn" {
    value = aws_lb.stg-lb.arn
}