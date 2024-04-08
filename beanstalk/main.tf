module "vpc" {
  source = "./vpc"
  app_name = var.app_name
  container_port = var.instance_port
  app_instance_subnets = var.app_instance_subnets
  app_elb_subnets = var.app_elb_subnets
}

module "certificate" {
  source = "./certificate"
  count = var.dns_zone == "none" ? 0 : 1
  cname  = module.beanstalk.cname
  dns_zone = var.dns_zone
  zone = module.beanstalk.zone
}

module "beanstalk" {
  source = "./beanstalk"
  app_name = var.app_name
  app_security_group_id = module.vpc.beanstalk_sg.id
  beanstalk_subnet_list = module.vpc.public_subnet_list
  elb_security_group_id = module.vpc.elb_sg.id
  elb_subnet_list = module.vpc.elb_subnet_list
  instance_port = var.instance_port
  key_directory = var.key_directory
  max_size = var.max_size
  min_size = var.min_size
  vpc_id = module.vpc.vpc.id
  ec2_instance_profile = var.ec2_instance_profile
  is_ecs_platform = var.is_ecs
  service_role = var.service_role
  db_allocated_storage  = var.db_allocated_storage
  db_engine             = var.db_engine
  db_engine_version     = var.db_engine_version
  db_instance_class     = var.db_instance_class
  db_password           = var.db_password
  db_username           = var.db_username
  db_is_multi_az           = var.db_is_multi_az
  certificate_arn = try(module.certificate.certificate_arn, "none")
  rds_enabled = var.rds_enabled
}
