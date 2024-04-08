# Set up VPC
resource "aws_vpc" "app_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.app_name}-vpc"
  }
}

# Set up SUBNETS
resource "aws_subnet" "app_public_subnet_list" {
  vpc_id = aws_vpc.app_vpc.id
  for_each = var.app_instance_subnets

  cidr_block = each.value
  availability_zone = each.key

  tags = {
    Name = "${var.app_name}-public-1${substr(each.key, -1, 1)}"
  }
}

resource "aws_subnet" "app_elb_subnet_list" {
  vpc_id = aws_vpc.app_vpc.id
  for_each = var.app_elb_subnets

  cidr_block = each.value
  availability_zone = each.key

  tags = {
    Name = "${var.app_name}-elb-1${substr(each.key, -1, 1)}"
  }
}

#Set up GATEWAY
resource "aws_internet_gateway" "app_internet_gateway" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.app_name}-igw"
  }
}

# Set up route table
resource "aws_route_table" "app_public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_internet_gateway.id
  }
  tags = {
    Name = "${var.app_name}-public-rt"
  }
}

resource "aws_route_table" "app_private_rt" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.app_name}-private-rt"
  }
}

resource "aws_route_table_association" "app_public_associate-table" {
  for_each = aws_subnet.app_public_subnet_list

  route_table_id = aws_route_table.app_public_rt.id
  subnet_id      = each.value.id
}
resource "aws_route_table_association" "app_elb_associate-table" {
  for_each = aws_subnet.app_elb_subnet_list

  route_table_id = aws_route_table.app_public_rt.id
  subnet_id      = each.value.id
}

# Set up security group
resource "aws_security_group" "app_beanstalk_sg" {
  name   = "${var.app_name}-beanstalk-sg"
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description      = "Allow access from load balancer"
    from_port        = var.container_port
    to_port          = var.container_port
    protocol         = "tcp"
    security_groups  = [aws_security_group.app_beanstalk_elb_sg.id]
  }

  ingress {
    description = "Allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all out traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.app_name}-beanstalk-sg"
  }
}

# Set up security group
resource "aws_security_group" "app_beanstalk_elb_sg" {
  name   = "${var.app_name}-beantalk-elb-sg"
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description      = "Allow http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "Allow all out traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.app_name}-beanstalk-elb-sg"
  }
}
