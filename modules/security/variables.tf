# VPC ID
variable "vpc_id" {
  type        = string
  description = "the vpc id"
}

# Tags
variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}