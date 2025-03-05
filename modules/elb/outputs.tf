# ==================== #
# Outputs for Load Balancer and Target Groups
# ==================== #

output "alb_dns_name" {
  value       = aws_lb.ext-alb.dns_name
  description = "The DNS name of the external Application Load Balancer (ALB)."
}

output "nginx-tgt" {
  description = "The ARN of the target group for the Nginx application on the external load balancer."
  value       = aws_lb_target_group.nginx-tgt.arn
}

output "wordpress-tgt" {
  description = "The ARN of the target group for the WordPress application."
  value       = aws_lb_target_group.wordpress-tgt.arn
}