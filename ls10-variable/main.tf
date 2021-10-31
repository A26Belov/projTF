provider "aws" {
  region  = var.region
  profile = "default"
}



data "aws_availability_zones" "working" {}
data "aws_vpc" "myVPC" {}

# lookup & search lastest aws amazon ami #
data "aws_ami" "lastest_Amazon_Linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create Security Group #
resource "aws_security_group" "inbound_web" {
  name = "Dynamic Security Group"
  tags = {
    Name  = "Dynamic Security Group"
    owner = "Me"
  }

  dynamic "ingress" {
    for_each = var.allow_ports
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
    description = "ALLOW SSH"

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Launch Configuration and Installing Apache from the user data template #
resource "aws_launch_configuration" "web" {
  name_prefix          = "webServer-LC-"
  image_id             = data.aws_ami.lastest_Amazon_Linux.id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = "AmazonS3ReadOnlyAccess"
  security_groups      = [aws_security_group.inbound_web.id]

  user_data = templatefile("c:/Terraform/include/cu.sh.tpl", {
    user_name = "web",
    passwd    = "web.49-41#ki"
  })

  #  user_data = templatefile("c:/Terraform/include/siteS3-sh.tpl", {})


  lifecycle {
    #prevent_destroy = true
    create_before_destroy = true
    ignore_changes        = [user_data]
  }

}


resource "aws_autoscaling_group" "web" {
  name                 = "AGS-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  max_size             = 2
  min_size             = 2
  min_elb_capacity     = 2
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  load_balancers       = [aws_elb.web.name]
  health_check_type    = "ELB"

  dynamic "tag" {
    for_each = {
      Name   = "WebSever in AutoScaling"
      Owner  = "root"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    #prevent_destroy = true
    create_before_destroy = true
  }

}

resource "aws_elb" "web" {
  name               = "webServer-LB"
  availability_zones = [data.aws_availability_zones.working.names[0], data.aws_availability_zones.working.names[1]]
  security_groups    = [aws_security_group.inbound_web.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:acm:eu-central-1:758966954281:certificate/8117dd05-b33f-4a35-a578-05ba2f4c510e"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  tags = {
    Name = "LB-terraform-elb"
  }
}


resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}


# data "aws_elb_hosted_zone_id" "main" {}

data "aws_route53_zone" "selected" {
  zone_id      = "Z0431526Z7XW81CGI5T6"
  private_zone = true
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = aws_elb.web.dns_name
    zone_id                = aws_elb.web.zone_id
    evaluate_target_health = true
  }
}
