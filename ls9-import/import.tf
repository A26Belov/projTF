provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

resource "aws_instance" "webServer-1" {
  ami                    = "ami-058e6df85cfc7760b"
  instance_type          = "t2.micro"
  iam_instance_profile   = "AmazonS3ReadOnlyAccess"
  hibernation            = false
  vpc_security_group_ids = [aws_security_group.newSG.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.webServer-1.private_ip} >> private_ips.txt"
  }

  tags = {
    Name = "webServerLinux-1"
  }

  tags_all = {
    Name = "webServerLinux-1"
  }

  lifecycle {
    ignore_changes = [user_data]
  }

}


resource "aws_instance" "webServer-win" {
  ami                    = "ami-01e7a91c6b39e0efb"
  instance_type          = "t2.micro"
  iam_instance_profile   = "EC2SystemManager-SSM"
  vpc_security_group_ids = [aws_security_group.newSG.id]

  tags = {
    Name        = "win2012R2"
    Owner       = "758966954281"
    Project     = "Terraform"
    Patch_Group = "DB"
  }

  tags_all = {
    Name = "Win2012R2"

  }
}


resource "aws_security_group" "newSG" {
  description = "AllowMyRDP"
  tags = {
    Name    = "Allow-SSH-RDP"
    Owner   = "758966954281"
    Project = "Terraform"
  }

  tags_all = {
    Name = "Allow-SSH-RDP"
  }
}
