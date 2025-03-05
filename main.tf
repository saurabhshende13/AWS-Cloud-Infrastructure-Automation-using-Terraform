# creating VPC
module "vpc" {
  source                              = "./modules/vpc"
  region                              = var.region
  vpc_cidr                            = var.vpc_cidr
  preferred_number_of_public_subnets  = var.preferred_number_of_public_subnets
  preferred_number_of_private_subnets = var.preferred_number_of_private_subnets
  tags                                = var.tags
  environment                         = var.environment
}

#Module for Application Load balancer, this will create Extenal Load balancer and internal load balancer
module "elb" {
  source             = "./modules/elb"
  ext_lb_name        = "external-lb"
  int_lb_name        = "internal-lb"
  vpc_id             = module.vpc.vpc_id
  public-sg          = module.security.ALB-sg
  private-sg         = module.security.IALB-sg
  public-sbn-1       = module.vpc.public_subnets-1
  public-sbn-2       = module.vpc.public_subnets-2
  private-sbn-1      = module.vpc.private_subnets-1
  private-sbn-2      = module.vpc.private_subnets-2
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
}

module "security" {
  source = "./modules/Security"
  vpc_id = module.vpc.vpc_id
}

module "autoscaling" {
  source            = "./modules/autoscaling"
  ami-web           = var.ami-web
  ami-bastion       = var.ami-bastion
  ami-nginx         = var.ami-nginx
  desired_capacity  = 1
  min_size          = 1
  max_size          = 1
  web-sg            = [module.security.web-sg]
  bastion-sg        = [module.security.bastion-sg]
  nginx-sg          = [module.security.nginx-sg]
  wordpress-alb-tgt = module.elb.wordpress-tgt
  nginx-alb-tgt     = module.elb.nginx-tgt
  instance_profile  = module.vpc.instance_profile
  public_subnets    = [module.vpc.public_subnets-1, module.vpc.public_subnets-2]
  private_subnets   = [module.vpc.private_subnets-1, module.vpc.private_subnets-2]
  keypair           = var.keypair
}

# Module for Elastic Filesystem; this module will creat elastic file system isn the webservers availablity
# zone and allow traffic fro the webservers

module "efs" {
  source       = "./modules/efs"
  efs-subnet-1 = module.vpc.private_subnets-3
  efs-subnet-2 = module.vpc.private_subnets-4
  efs-sg       = [module.security.datalayer-sg]
  account_no   = var.account_no
}

# RDS module; this module will create the RDS instance in the private subnet

module "rds" {
  source          = "./modules/rds"
  db-password     = var.master-password
  db-username     = var.master-username
  db-sg           = [module.security.datalayer-sg]
  private_subnets = [module.vpc.private_subnets-3, module.vpc.private_subnets-4]
}

# The Module creates instances for Nginx, Webserver and Bastion
module "compute" {
  source                  = "./modules/compute"
  ami-web                 = var.ami-web
  subnets-compute-public  = [module.vpc.public_subnets-1, module.vpc.public_subnets-2]
  subnets-compute-private = [module.vpc.private_subnets-1, module.vpc.private_subnets-2]
  sg-compute              = [module.security.compute-sg]
  keypair                 = var.keypair
}