# General variables
variable "app_name" {
  type = string
  description = "Application name"
}

variable "instance_port" {
  type = number
  description = "Exposed port of container"
}

variable "key_directory" {
  type = string
  description = "Directory where the key is stored in your computer"
  default = "~/.ssh/id_rsa.pub"
}

# Instance setting
variable "min_size" {
  type = number
  description = "Min size of scaling"
  default = 1
}

variable "max_size" {
  type = number
  description = "Max size of scaling"
  default = 2
}

variable "is_ecs" {
  type = bool
  description = "Whether if run type platform is ECS , if false it will be EC2"
  default = true
}

variable "app_instance_subnets" {
  type = map(string)
  description = "Subnet for running app instance"

  default = {
    "ap-southeast-1a" = "10.0.1.0/24"
    "ap-southeast-1b" = "10.0.2.0/24"
  }
}

variable "app_elb_subnets" {
  type = map(string)
  description = "Subnet for running app elb"

  default = {
    "ap-southeast-1a" = "10.0.3.0/24"
    "ap-southeast-1b" = "10.0.4.0/24"
  }
}
# IAM setting
variable "service_role" {
  type = string
  description = "Service role for running"
}

variable "ec2_instance_profile" {
  type = string
  description = "EC2 instance profile"
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
  default = "10"
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

// DNS of domain
variable "dns_zone" {
  type = string
  description = "The domain you want to host"
  default = "none"
}

