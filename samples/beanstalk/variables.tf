variable "app_name" {
  type        = string
  description = "Application name"
}

variable "instance_port" {
  type        = number
  description = "Exposed port of container"
}

variable "key_directory" {
  type        = string
  description = "Directory where the key is stored in your computer"
}

# Subnet
variable "app_instance_subnets" {
  type = map(string)
}

variable "app_elb_subnets" {
  type = map(string)
}

variable "min_size" {
  type        = number
  description = "Min size of scaling"
}

variable "max_size" {
  type        = number
  description = "Max size of scaling"
}

variable "service_role" {
  type        = string
  description = "Service role for running"
}

variable "ec2_instance_profile" {
  type        = string
  description = "EC2 instance profile"
}

variable "is_ecs" {
  type        = bool
  description = "Whether if run type platform is ECS , if false it will be EC2"
}

// Database setting
variable "db_engine" {
  type        = string
  description = "Database engine (postgres, mysql,...)"
}

variable "db_instance_class" {
  type        = string
  description = "Database type (db.t3.micro,...)"
}

variable "db_engine_version" {
  type        = string
  description = "Database version (14.5,...)"
}

variable "db_allocated_storage" {
  type        = string
  description = "Storage (10GB,...)"
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_password" {
  type        = string
  description = "Database username"
}

variable "db_is_multi_az" {
  type        = bool
  description = "If database across multiple AZ, if then give more than 1 subnet"
}

//Certificate
variable "dns_zone" {
  type        = string
  description = "DNS zone of the url that request ssl"
}

