# Name: ec2/main.tf
# Description: Launch a public EC2 instance in the public subnet and a private 
# EC2 instance in the private subnet. Associates both instances with the SG
# Author: Frank Ekwomadu. C

variable "public_subnet_id" {
  description = "The ID of the public subnet."
}

variable "private_subnet_id" {
  description = "The ID of the private subnet."
}

variable "security_group_id" {
  description = "The ID of the security group to associate with the EC2 instances."
}

data "aws_ami" "latest_ami" {
    most_recent = true
    owners      = ["amazon"]
    filter {
        name   = "name"
        values = ["amzn2-ami-*-x86_64-gp2"]
    }
}

variable "instance_type" {
  default     = "t2.micro"
  description = "The type of EC2 instance to launch."
}

resource "aws_instance" "public_instance" {
  ami           = data.aws_ami.latest_ami.id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  security_groups = [var.security_group_id]
  key_name       = "frankKeyPair"
  associate_public_ip_address = true

  tags = { Name = "PublicInstance"  }
  user_data     = <<-EOF
      #!/bin/bash
      yum update -y
      yum install httpd -y
      cd /var/www/html
      echo "Hello from $(hostname -f)" > index.html
      systemctl restart httpd
      systemctl enable httpd
  EOF
}

resource "aws_instance" "private_instance" {
  ami           = data.aws_ami.latest_ami.id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  security_groups = [var.security_group_id]
  key_name       = "frankKeyPair"
  associate_public_ip_address = false
  
  tags = { Name = "PrivateInstance"  }
  
  user_data     = <<-EOF
      #!/bin/bash
      yum update -y
      yum install httpd -y
      cd /var/www/html
      echo "Hello from $(hostname -f)" > index.html
      systemctl restart httpd
      systemctl enable httpd
  EOF
}

# Outputs for the EC2 resources

output "public_instance_id" {
  value = aws_instance.public_instance.id
}

output "private_instance_id" {
  value = aws_instance.private_instance.id
}

output "public_instance_public_ip" {
  value = aws_instance.public_instance.public_ip
}

output "private_instance_private_ip" {
  value = aws_instance.private_instance.private_ip
}