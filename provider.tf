# Name: /provider.tf
# Description: Defined the AWS region (us-east-1) and ensured compatibility with
# AWS provider.
# Author: Frank Ekwomadu. C

provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

variable "region" {
  default = "us-east-1"
}