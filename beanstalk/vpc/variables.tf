variable "app_name" {
  type = string
  description = "Application name"
  default = "myapp"
}

variable "container_port" {
  type = number
  description = "Container port (if you have NGINX and use it in compose, please set this to 80)"
}

variable "region" {
  type = string
  default = "ap-southeast-1"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "app_instance_subnets" {
  type = map(string)

  default = {
    "ap-southeast-1a" = "10.0.1.0/24"
    "ap-southeast-1b" = "10.0.2.0/24"
  }
}

variable "app_elb_subnets" {
  type = map(string)

  default = {
    "ap-southeast-1a" = "10.0.3.0/24"
    "ap-southeast-1b" = "10.0.4.0/24"
  }
}
