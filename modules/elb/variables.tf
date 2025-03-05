# ============================ #
# Security group and subnet vars
# ============================ #

# Security group for external load balancer
variable "public-sg" {
  description = "Security group for external ALB."
}

# Public subnets for external load balancer
variable "public-sbn-1" {
  description = "First public subnet for external ALB."
}

variable "public-sbn-2" {
  description = "Second public subnet for external ALB."
}

# VPC ID
variable "vpc_id" {
  type        = string
  description = "VPC ID for ALB and target groups."
}

# Security group for internal load balancer
variable "private-sg" {
  description = "Security group for internal ALB."
}

# Private subnets for internal load balancer
variable "private-sbn-1" {
  description = "First private subnet for internal ALB."
}

variable "private-sbn-2" {
  description = "Second private subnet for internal ALB."
}

# ==================== #
# Load balancer settings
# ==================== #

# IP address type for the load balancer
variable "ip_address_type" {
  type        = string
  description = "IP address type for ALB (ipv4, dualstack)."
}

# Load balancer type
variable "load_balancer_type" {
  type        = string
  description = "Type of ALB (application or network)."
}

# Tags for resources
variable "tags" {
  description = "Tags for all resources."
  type        = map(string)
  default     = {}
}

# External and internal load balancer names
variable "ext_lb_name" {
  type        = string
  description = "Name of the external ALB."
}

variable "int_lb_name" {
  type        = string
  description = "Name of the internal ALB."
}

# =========================== #
# Variables for target groups
# =========================== #

# Health check settings
variable "health_check_interval" {
  description = "Interval (in seconds) for health checks."
  default     = 10
}

variable "health_check_path" {
  description = "Path for health check requests."
  default     = "/healthstatus"
}

variable "health_check_protocol" {
  description = "Protocol for health check requests."
  default     = "HTTPS"
}

variable "health_check_timeout" {
  description = "Timeout (in seconds) for health check."
  default     = 5
}

variable "healthy_threshold" {
  description = "Consecutive successes for healthy check."
  default     = 5
}

variable "unhealthy_threshold" {
  description = "Consecutive failures for unhealthy check."
  default     = 2
}

# Target group settings
variable "target_group_port" {
  description = "Port for the target group."
  default     = 443
}

variable "target_group_protocol" {
  description = "Protocol for the target group."
  default     = "HTTPS"
}

variable "target_group_type" {
  description = "Type of the target group (instance, ip, or lambda)."
  default     = "instance"
}
