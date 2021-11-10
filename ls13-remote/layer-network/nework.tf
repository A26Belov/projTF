provider "aws" {
  region  = var.region
  profile = "default"
}
terraform {
  backend "s3" {
    bucket = "0-terraform-project"
    key    = "dev/network/terraform.tfstate"
    region = "eu-north-1"
  }
}

/*
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "MyVPC"
  }

}
*/
