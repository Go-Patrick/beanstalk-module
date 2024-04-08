variable "app_name" {
  type = string
  description = "Application name"
}

// Platform branch setting
variable "is_ecs_platform" {
  type = bool
  description = "Whether if run type platform is ECS , if false it will be EC2"
  default = true
}

// Setting up Launch instance
variable "key_directory" {
  type = string
  description = "The location on machine where the key is stored"
}

variable "app_security_group_id" {
  type = string
  description = "Security group id for app"
}

variable "elb_security_group_id" {
  type = string
  description = "Security group id for load balancer"
}

variable "instances_type" {
  type = string
  description = "Instance for beanstalk run type"
  default = "t3.micro"
}

variable "instance_port" {
  type = string
  description = "The exposed port of instances"
}

// Roles for running
variable "service_role" {
  type = string
  description = "Service role for running"
}

variable "ec2_instance_profile" {
  type = string
  description = "EC2 instance profile"
}

// Auto scaling settings
variable "min_size" {
  type = number
  description = "Min instance allowed"
}

variable "max_size" {
  type = number
  description = "Min instance allowed"
}

// Net work and load balancer
variable "vpc_id" {
  type = string
  description = "VPC id"
}

variable "beanstalk_subnet_list" {
  type = list(string)
  description = "Subnet list for beanstalk instances"
}

variable "elb_subnet_list" {
  type = list(string)
  description = "Subnet list for load balancers"
}

// Database setting
variable "rds_enabled" {
  type = bool
  description = "Whether if you want to use rds or not"
  default = true
}

variable "db_engine" {
  type = string
  description = "Database engine (postgres, mysql,...)"
  default = "postgres"
}

variable "db_instance_class" {
  type = string
  description = "Database type (db.t3.micro,...)"
  default = "db.t3.micro"
}

variable "db_engine_version" {
  type = string
  description = "Database version (14.5,...)"
  default = "14.5"
}

variable "db_allocated_storage" {
  type = string
  description = "Storage (10GB,...)"
  default = "10GB"
}

variable "db_username" {
  type = string
  description = "Database username"
  default = "postgres"
}

variable "db_password" {
  type = string
  description = "Database username"
  default = "pass"
}

variable "db_is_multi_az" {
  type = bool
  description = "If database across multiple AZ, if then give more than 1 subnet"
  default = false
}

// SSL certificate manage
variable "certificate_arn" {
  type = string
  description = "ARN of the SSL certificate"
}
