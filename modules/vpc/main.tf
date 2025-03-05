locals {
  Name = "SS-Project"
}

# Get list of availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(
    var.tags,
    {
      Name = "${local.Name}-VPC-01"
    }
  )
}


# Create public subnets
resource "aws_subnet" "public" {
  count                   = var.preferred_number_of_public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    var.tags,
    {
      Name = "${local.Name}-Public-Subnet-0${count.index + 1}"
    }
  )
}


# Create private subnets
resource "aws_subnet" "private" {
  count                   = 4
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 3)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    var.tags,
    {
      Name = "${local.Name}-Private-Subnet-0${count.index + 3}"
    }
  )
}