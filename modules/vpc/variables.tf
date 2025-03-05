# Region for the AWS resources
variable "region" {
  description = "AWS region to deploy resources."
}

# CIDR block for the VPC
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

# Number of public subnets
variable "preferred_number_of_public_subnets" {
  type        = number
  description = "Preferred number of public subnets."
}

# Number of private subnets
variable "preferred_number_of_private_subnets" {
  type        = number
  description = "Preferred number of private subnets."
}

# Destination CIDR block for routing
variable "destination_cidr_block" {
  type        = string
  description = "CIDR block for default routing."
  default     = "0.0.0.0/0"
}

# Tags for the resources
variable "tags" {
  description = "A mapping of tags to assign to resources."
  type        = map(string)
  default     = {}
}

# Environment type
variable "environment" {
  type        = string
  description = "Environment for deployment (e.g., Prod, Dev)."
}
