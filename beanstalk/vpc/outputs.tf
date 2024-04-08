output "public_subnet_list" {
  value = values(aws_subnet.app_public_subnet_list)[*].id
}

output "elb_subnet_list" {
  value = values(aws_subnet.app_elb_subnet_list)[*].id
}

output "vpc" {
  value = aws_vpc.app_vpc
}

output "beanstalk_sg" {
  value = aws_security_group.app_beanstalk_sg
}

output "elb_sg" {
  value = aws_security_group.app_beanstalk_elb_sg
}
