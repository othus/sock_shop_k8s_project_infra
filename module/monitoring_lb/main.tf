resource "aws_lb" "prometheus-lb" {
  name               = var.prometheus_lb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.k8s_sg]
  enable_deletion_protection = false
  tags = {
    Name = var.prometheus_lb_name
  }
}

resource "aws_lb_target_group" "prometheus-tg" {
  name     = var.prometheus_tg
  port     = 31090
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 5
    timeout = 5
    interval = 30
    path = "/graph"
  }
}

resource "aws_lb_listener" "prometheus-lb_listener" {
  load_balancer_arn = aws_lb.prometheus-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "prometheus-lb_tg_grp" {
  target_group_arn = aws_lb_target_group.prometheus-tg.arn
  target_id        = element(split(",", join(",", "${var.instance}")), count.index)
  port             = 31090
}

resource "aws_lb" "grafana-lb" {
  name               = var.grafana_lb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.k8s_sg]
  enable_deletion_protection = false
  tags = {
    Name = var.grafana_lb_name
  }
}

resource "aws_lb_target_group" "grafana-tg" {
  name     = var.grafana_tg
  port     = 31300
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 5
    timeout = 5
    interval = 30
    path = "/graph"
  }
}

resource "aws_lb_listener" "grafana-lb_listener" {
  load_balancer_arn = aws_lb.grafana-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "grafana-lb_tg_att" {
  target_group_arn = aws_lb_target_group.grafana-tg.arn
  target_id        = element(split(",", join(",", "${var.instance}")), count.index)
  port             = 31300
}

