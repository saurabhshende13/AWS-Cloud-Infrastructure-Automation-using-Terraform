locals {
  Name = "SS-Project"
}

# ----------------------------
#External Load balancer for reverse proxy nginx
#---------------------------------

resource "aws_lb" "ext-alb" {
  name            = var.ext_lb_name
  internal        = false
  security_groups = [var.public-sg]

  subnets = [var.public-sbn-1,
  var.public-sbn-2, ]

  tags = merge(
    var.tags,
    {
      Name = "${local.Name}-External-ALB-01"
    },
  )

  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
}

#--- create a target group for the external load balancer
resource "aws_lb_target_group" "nginx-tgt" {
  health_check {
    interval            = var.health_check_interval
    path                = var.health_check_path
    protocol            = var.health_check_protocol
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
  
  name        = "nginx-target-group"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_group_type
  vpc_id      = var.vpc_id
}

#--- create a listener for the load balancer

resource "aws_lb_listener" "nginx-listner" {
  load_balancer_arn = aws_lb.ext-alb.arn
  port              = var.target_group_port
  protocol          = var.target_group_protocol
  certificate_arn   = aws_acm_certificate_validation.my_project_validation.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-tgt.arn
  }
}



# ----------------------------
#Internal Load Balancers for webservers
#---------------------------------

resource "aws_lb" "ialb" {
  name     = "ialb"
  internal = true

  security_groups = [var.private-sg]

  subnets = [var.private-sbn-1,
  var.private-sbn-2, ]

    tags = merge(
    var.tags,
    {
      Name = "${local.Name}-Internal-ALB-01"
    },
  )

  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
}


# --- target group  for wordpress -------

resource "aws_lb_target_group" "wordpress-tgt" {
  health_check {
  interval            = var.health_check_interval
  path                = var.health_check_path
  protocol            = var.health_check_protocol
  timeout             = var.health_check_timeout
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold
  }
  
  name        = "wordpress-target-group"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_group_type
  vpc_id      = var.vpc_id
  }


resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.ialb.arn
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  certificate_arn   = aws_acm_certificate_validation.my_project_validation.certificate_arn


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tgt.arn
  }
}














