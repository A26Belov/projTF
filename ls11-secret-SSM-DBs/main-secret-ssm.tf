provider "aws" {
  region  = var.region
  profile = "default"
}


#=====GENERATE PWD =======
resource "random_string" "rds_pwd" {
  length           = 12
  special          = true
  override_special = "=-#"
  keepers={
    keeper=var.nameOwnerRDS
  }
}

#=====CREATE PWD TO PARAMETER STORE SMM =======
resource "aws_ssm_parameter" "rds_passwd" {
name = "/prod/mysql"
  description = "Master pwd for RDS MySQL"
  type = "SecureString"
  value = random_string.rds_pwd.result
  overwrite = true
  tags = {
    name = "RDS pwd"
  }
}

#=====GET SMM PARAMETER STORE=================
 data "aws_ssm_parameter" "my_rds_pwd"{
   name ="/prod/mysql"
   depends_on = [aws_ssm_parameter.rds_passwd]
 }
#=====DB MySQL=================

 resource "aws_db_instance" "db" {
  identifier ="rds-1"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "prodDB"
  username             = "administrator"
  password             = data.aws_ssm_parameter.my_rds_pwd.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately= true
}
