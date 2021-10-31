provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "myWEBServer" {
  #  count                  = 0
  ami                    = "ami-07df274a488ca9195"
  instance_type          = "t2.micro"
  key_name               = "alexb-Franfurt-Linux"
  iam_instance_profile   = "AmazonS3ReadOnlyAccess"
  vpc_security_group_ids = [aws_security_group.webServerSecurityGroup.id]
  user_data              = file("c:/Terraform/include/bootS3.sh")
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
