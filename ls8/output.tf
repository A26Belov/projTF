#============================#
output "data_aws_53_zone" {
  value = data.aws_route53_zone.selected.name
}

#========================#
output "load_balancer_url" {
  value = aws_elb.web.dns_name
}

#========================#
output "load_balancer_zone_id" {
  value = aws_elb.web.zone_id
}

#============================#
output "data_aws_vpcs" {
  value = data.aws_vpc.myVPC.id
}

#============================#
output "data_aws_vpcs_cidr_block" {
  value = data.aws_vpc.myVPC.cidr_block
}

#============================#
output "data_aws_availability_zone" {
  value = data.aws_availability_zones.working.names[0]
}

#============================#
output "aws_id" {
  value = data.aws_ami.lastest_Amazon_Linux.id
}

#============================#
output "aws_name" {
  value = data.aws_ami.lastest_Amazon_Linux.name
}
