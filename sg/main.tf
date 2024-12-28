# Name: sg/main.tf
# Description: Create a security group that allows inbound SSH (port 22) and 
# HTTP (port 80) traffic AND Allows all outbound traffic.
# Author: Frank Ekwomadu. C

variable "vpc_id" {
  description = "The VPC ID where the security group will be created."
}

resource "aws_security_group" "my_sg" {
  name        = "MySecurityGroup"
  description = "Allow SSH and HTTP access"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Lab4_SG"
  }
}

# Outputs for the SG resource

output "my_sg_id" {
  value = aws_security_group.my_sg.id
}

output "my_sg" {
  value = aws_security_group.my_sg
}

