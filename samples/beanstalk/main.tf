module "beanstalk" {
  source = "../../modules/beanstalk"
  app_name = "test-app"
  ec2_instance_profile = var.ec2_instance_profile
  instance_port = 80
  service_role = var.service_role
  rds_enabled = false
  is_ecs = false
}
