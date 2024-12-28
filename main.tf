# Name: /main.tf
# Description: Wires the modules together by passing appropriate variables and 
# dependencies.
# Author: Frank Ekwomadu. C

module "vpc" {
  source               = "./vpc"
  vpc_cidr_block       = "10.0.0.0/16"
  public_subnet_cidr   = "10.0.1.0/24"
  private_subnet_cidr  = "10.0.2.0/24"
}

module "security_group" {
  source = "./sg"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source           = "./ec2"
  public_subnet_id = module.vpc.public_subnets[0]
  private_subnet_id = module.vpc.private_subnets[0]
  security_group_id = module.security_group.my_sg_id
  instance_type     = "t2.micro"
  
}