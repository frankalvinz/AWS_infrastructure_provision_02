# Name: vpc/main.tf
# Description: Create a VPC with private, public subnets and NAT Gateway.
# Author: Frank Ekwomadu. C

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "MyVPC"
  cidr                 = var.vpc_cidr_block
  azs                  = ["us-east-1a"]
  public_subnets       = [var.public_subnet_cidr]
  private_subnets      = [var.private_subnet_cidr]
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  single_nat_gateway = true  # Enable single NAT Gateway
  enable_nat_gateway = true 
  
  # enable_default_security_group = false  # Avoid creating default SG

  tags = { Name = "Lab4_VPC"  }
  nat_gateway_tags = {  Name = "Lab4_NAT" }
  public_subnet_tags = { "Name" = "Public-Subnet" }
  private_subnet_tags = { "Name" = "Private-Subnet" }
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}


# Outputs for the VPC module
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}