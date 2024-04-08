app_name             = "example"
key_directory        = "~/.ssh/id_ed25519.pub"
instance_port        = 80
min_size             = 1
max_size             = 2
is_ecs               = true
ec2_instance_profile = "beanstalkEC2Instance"
service_role         = "service-role/aws-elasticbeanstalk-service-role"
db_allocated_storage = "10"
db_engine            = "postgres"
db_engine_version    = "14.5"
db_instance_class    = "db.t3.micro"
db_password          = "password"
db_username          = "myname"
db_is_multi_az       = false
dns_zone             = "mysite.com"
app_instance_subnets = {
  "ap-southeast-1a" = "10.0.1.0/24"
  "ap-southeast-1b" = "10.0.2.0/24"
}
app_elb_subnets = {
  "ap-southeast-1a" = "10.0.3.0/24"
  "ap-southeast-1b" = "10.0.4.0/24"
}
