resource "aws_lb" "prod-lb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.lb-subnet1, var.lb-subnet2, var.lb-subnet3]
  security_groups = [var.sg_lb]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "prod-target_grp" {
  name     = var.prod_tg
  target_type = var.lb_target-type
  port     = 30001
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 4
    interval = 45
  }
}

resource "aws_lb_listener" "prod-lb_listener" {
  load_balancer_arn = aws_lb.prod-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod-target_grp.arn
  }
}

resource "aws_lb_target_group_attachment" "prod-lb_tg_grp" {
  target_group_arn = aws_lb_target_group.prod-target_grp.arn
  target_id        = var.instance_id
  port             = 30001
}

resource "aws_lb" "stg-lb" {
  name               = var.stg_lb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.lb-subnet1, var.lb-subnet2, var.lb-subnet3]
  security_groups = [var.sg_lb]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "stg-target_grp" {
  name     = var.stg_tg
  target_type = var.lb_target-type
  port     = 30001
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 4
    interval = 45
  }
}

resource "aws_lb_listener" "stg-lb_listener" {
  load_balancer_arn = aws_lb.stg-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stg-target_grp.arn
  }
}

resource "aws_lb_target_group_attachment" "stg-lb_tg_grp" {
  target_group_arn = aws_lb_target_group.stg-target_grp.arn
  target_id        = var.instance_id
  port             = 30001
}
