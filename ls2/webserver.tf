provider "aws" {
  region = "eu-north-1"
}


# lookup & search lastest aws amazon ami #
data "aws_ami" "lastest_Amazon_Linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_instance" "myWEBServer" {
  ami                    = data.aws_ami.lastest_Amazon_Linux.id
  instance_type          = t3.micro
  key_name               = "alexb-AWS-Stockholm"
  iam_instance_profile   = "AmazonS3ReadOnlyAccess"
  vpc_security_group_ids = [aws_security_group.webServerSecurityGroup.id]
  //  user_data              = file("c:/Terraform/include/bootS3.sh")
  tags = {
    Name    = "RedHatwebsrv"
    Owner   = "root"
    Project = "Terraform"
  }
}
resource "aws_security_group" "webServerSecurityGroup" {
  name        = "webServer"
  description = "webServer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"

  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"

  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
