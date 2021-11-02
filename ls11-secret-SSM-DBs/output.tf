output "data_rds_pwd"{
  value = data.aws_ssm_parameter.my_rds_pwd.value
   sensitive = true  
}
