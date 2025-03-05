locals {
  Name = "SS-Project"
}

# create instance for Bastion
resource "aws_instance" "Bastion" {
  count = 2
  ami                         = var.ami-web
  instance_type               = "t2.medium"
  availability_zone           = element(["us-east-1a", "us-east-1b"], count.index)
  subnet_id                   = element(var.subnets-compute-public, count.index)
  vpc_security_group_ids      = var.sg-compute
  associate_public_ip_address = true
  key_name                    = var.keypair


  tags = merge(
    var.tags,
    {
      Name = "${local.Name}-Bastion-${count.index + 1}"
    },
  )
}

resource "aws_instance" "Nginx" {
  count = 2
  ami                         = var.ami-web
  instance_type               = "t2.medium"
  availability_zone           = element(["us-east-1a", "us-east-1b"], count.index)
  subnet_id                   = element(var.subnets-compute-public, count.index)
  vpc_security_group_ids      = var.sg-compute
  associate_public_ip_address = true
  key_name                    = var.keypair
  user_data = file("${path.module}/nginx_setup.sh")
  tags = merge(
    var.tags,
    {
      Name = "${local.Name}-Nginx-${count.index + 1}"
    },
  )
}


# create instance for Web Server
resource "aws_instance" "Web-Server" {
  count = 2
  ami                         = var.ami-web
  instance_type               = "t2.micro"
  availability_zone           = element(["us-east-1a", "us-east-1b"], count.index)
  subnet_id                   = element(var.subnets-compute-public, count.index)
  vpc_security_group_ids      = var.sg-compute
  associate_public_ip_address = true
  key_name                    = var.keypair
  user_data = file("${path.module}/wordpress_setup.sh")
 tags = merge(
    var.tags,
    {
      Name = "${local.Name}-Web-Server-${count.index + 1}"
    },
  )
}

