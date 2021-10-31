provider "aws" {
  region = "eu-central-1"
}


resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
}

resource "aws_instance" "my_webserver" {
  # count                  = 1
  depends_on             = [aws_instance.my_dbserver]
  ami                    = "ami-07df274a488ca9195"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webServerSecurityGroup.id]
  user_data = templatefile("c:/Terraform/include/cu.sh.tpl", {
    user_name = "web",
    passwd    = "web.49-41#ki"
  })

  tags = {
    Name    = "WEBServer"
    Owner   = "root"
    Project = "Terraform"
  }

  lifecycle {
    #prevent_destroy = true
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
}


resource "aws_instance" "my_appserver" {
  # count                  = 1
  depends_on             = [aws_instance.my_dbserver]
  ami                    = "ami-07df274a488ca9195"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webServerSecurityGroup.id]
  user_data = templatefile("c:/Terraform/include/cu.sh.tpl", {
    user_name = "app",
    passwd    = ""

  })

  tags = {
    Name    = "APPServer"
    Owner   = "root"
    Project = "Terraform"
  }

  lifecycle {
    #prevent_destroy = true
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
}

resource "aws_instance" "my_dbserver" {
  ami                    = "ami-07df274a488ca9195"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webServerSecurityGroup.id]
  user_data = templatefile("c:/Terraform/include/cu.sh.tpl", {
    user_name = "db",
    passwd    = ""

  })

  tags = {
    Name    = "DBServer"
    Owner   = "root"
    Project = "Terraform"
  }

  lifecycle {
    #prevent_destroy = true
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
}

resource "aws_security_group" "webServerSecurityGroup" {
  name = "dynamic Securyty group"
  tags = {
    "Name" = "SG_ports 80-443-8080-22"
  }

  dynamic "ingress" {
    for_each = [80, 443]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "ALLOW port: ${ingress.value}"
    }
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["93.125.107.0/24"]
    description = "SSH"

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
