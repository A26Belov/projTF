output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
}

output "webserver_public_ip" {
  value       = aws_eip.my_static_ip.public_ip
  description = "Elastic Public IP"
}


output "dbserver_instance_id" {
  value = aws_instance.my_dbserver.id
}

output "appserver_instance_id" {
  value = aws_instance.my_appserver.id
}

output "webserver_sg_id" {
  value = aws_security_group.webServerSecurityGroup.id
}
output "webserver_sg_arn" {
  value = aws_security_group.webServerSecurityGroup.arn
}
