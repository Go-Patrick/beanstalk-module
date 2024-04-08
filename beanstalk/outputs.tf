output "endpoint_url" {
  value = module.beanstalk.output_url
}

output "beanstalk_env" {
  value = module.beanstalk.beanstalk_env
}

output "public_subnet_list" {
  value = module.vpc.public_subnet_list
}

output "elb_subnet_list" {
  value = module.vpc.elb_subnet_list
}

output "vpc" {
  value = module.vpc.vpc
}

output "beanstalk_sg" {
  value = module.vpc.beanstalk_sg
}

output "elb_sg" {
  value = module.vpc.elb_sg
}
