output "output_url" {
  value = aws_elastic_beanstalk_environment.app_beanstalk_env.endpoint_url
}

output "cname" {
  value = aws_elastic_beanstalk_environment.app_beanstalk_env.cname
}

output "zone" {
  value = data.aws_elastic_beanstalk_hosted_zone.current.id
}

output "beanstalk_env" {
  value = aws_elastic_beanstalk_environment.app_beanstalk_env
}
