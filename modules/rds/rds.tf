locals {
  Name = "SS-Project"
}


# This section will create the subnet group for the RDS  instance using the private subnet
resource "aws_db_subnet_group" "my-sub-rds" {
  name       = "my-rds"
  subnet_ids = var.private_subnets

 tags = merge(
    var.tags,
    {
      Name = "${local.Name}-rds"
    },
  )
}

# create the RDS instance with the subnets group
resource "aws_db_instance" "my-rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0.32"
  instance_class         = "db.t4g.large"
  #name                   = "daviddb"
  username               = var.db-username
  password               = var.db-password
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.my-sub-rds.id
  skip_final_snapshot    = true
  vpc_security_group_ids = var.db-sg
  multi_az               = "true"
}