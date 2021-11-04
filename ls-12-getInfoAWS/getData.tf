provider "aws" {
  region  = var.region
  profile = "default"
}

data "aws_availability_zones" "working" {}
data "aws_vpc" "myVPC" {}

data "aws_ami" "lastest_Amazon_Linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_route53_zone" "selected" {
  zone_id      = "Z0431526Z7XW81CGI5T6"
  private_zone = true
}


// 0-terraform-project
//region=eu-north-1
