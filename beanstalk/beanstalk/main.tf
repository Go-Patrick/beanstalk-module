# Get data of current Beanstalk
data "aws_elastic_beanstalk_hosted_zone" "current" {}

# Set up key pair
resource "aws_key_pair" "app_key_pair" {
  key_name   = "${var.app_name}-bean-key"
  public_key = file(var.key_directory)
}

data "aws_elastic_beanstalk_solution_stack" "docker_stack" {
  most_recent = true
  name_regex = var.is_ecs_platform ? "^64bit Amazon Linux (.*) running ECS$" : "^64bit Amazon Linux (.*) running Docker$"
}

resource "aws_elastic_beanstalk_application" "app_beanstalk" {
  name = var.app_name
}

resource "aws_elastic_beanstalk_environment" "app_beanstalk_env" {
  name                = "${var.app_name}-env"
  application         = aws_elastic_beanstalk_application.app_beanstalk.name
#  solution_stack_name = var.is_ecs_platform ? "64bit Amazon Linux 2023 v4.0.1 running ECS" : "64bit Amazon Linux 2023 v4.1.0 running Docker"
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.docker_stack.name

  // Set up auto-scaling instances
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Minsize"
    value     = var.min_size
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Maxsize"
    value     = var.max_size
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableIMDSv1"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = aws_key_pair.app_key_pair.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     =  var.ec2_instance_profile
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = join(",", [var.app_security_group_id])
  }

  // Trigger the scaling
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Percent"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "40"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "70"
  }

  // Set up EC2 instance
  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = var.instances_type
  }

  // Set up VPC
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.beanstalk_subnet_list)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.elb_subnet_list)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  // Set up cloudwatch logs
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     =  "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     =  "true"
  }

  #Cloud watchaws:elasticbeanstalk:cloudwatch:logs:health
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "HealthStreamingEnabled"
    value     =  "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "DeleteOnTerminate"
    value     =  "true"
  }

  // Set up environment
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "ServiceRole"
    value = var.service_role
  }

  # Set up loadbalancer and target group
  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = var.certificate_arn == "none" ? true : false
  }

  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "Protocol"
    value     = "HTTP"
  }

  dynamic "setting" {
    for_each = var.certificate_arn == "none" ? [] : [1]
    content {
      namespace = "aws:elbv2:listener:443"
      name      = "ListenerEnabled"
      value     = true
    }
  }

  dynamic "setting" {
    for_each = var.certificate_arn == "none" ? [] : [1]
    content {
      namespace = "aws:elbv2:listener:443"
      name      = "Protocol"
      value     = "HTTPS"
    }
  }

  dynamic "setting" {
    for_each = var.certificate_arn == "none" ? [] : [1]
    content {
      namespace = "aws:elbv2:listener:443"
      name      = "SSLCertificateArns"
      value     = var.certificate_arn
    }
  }

  dynamic "setting" {
    for_each = var.certificate_arn == "none" ? [] : [1]
    content {
      namespace = "aws:elbv2:listener:443"
      name      = "SSLPolicy"
      value     = "ELBSecurityPolicy-2016-08"
    }
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Port"
    value     = 80
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Protocol"
    value     = "HTTP"
  }

   // Database set up
    dynamic "setting" {
      for_each = var.rds_enabled ? [1] : []
      content {
        namespace = "aws:rds:dbinstance"
        name = "DBEngine"
        value = var.db_engine
      }
    }

    dynamic "setting" {
      for_each = var.rds_enabled ? [1] : []
      content {
        namespace = "aws:rds:dbinstance"
        name = "DBInstanceClass"
        value = var.db_instance_class
      }
    }

    dynamic "setting" {
      for_each = var.rds_enabled ? [1] : []
      content {
        namespace = "aws:rds:dbinstance"
        name      = "DBEngineVersion"
        value     =  var.db_engine_version
      }
    }

    dynamic "setting" {
      for_each = var.rds_enabled ? [1] : []
      content {
        namespace = "aws:rds:dbinstance"
        name      = "DBAllocatedStorage"
        value     = var.db_allocated_storage
      }
    }

    dynamic "setting" {
      for_each = var.rds_enabled ? [1] : []
      content {
        namespace = "aws:rds:dbinstance"
        name      = "DBDeletionPolicy"
        value     = "Delete"
      }
    }

    dynamic "setting" {
      for_each = var.rds_enabled ? [1] : []
      content {
        namespace = "aws:rds:dbinstance"
        name      = "HasCoupledDatabase"
        value     = "true"
      }
    }

    dynamic "setting" {
      for_each = var.rds_enabled ? [1] : []
      content {
        namespace = "aws:rds:dbinstance"
        name = "DBPassword"
        value = var.db_password
      }
    }

    dynamic "setting" {
      for_each = var.rds_enabled ? [1] : []
      content {
        namespace = "aws:rds:dbinstance"
        name = "DBUser"
        value = var.db_username
      }
    }

    dynamic "setting" {
      for_each = var.rds_enabled ? [1] : []
      content {
        namespace = "aws:rds:dbinstance"
        name      = "MultiAZDatabase"
        value     = var.db_is_multi_az
      }
    }

  // Set up environment variable
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "RAILS_ENV"
    value = "production"
  }
}

resource "aws_lb_listener" "https_redirect" {
  count = var.certificate_arn == "none" ? 0 : 1
  load_balancer_arn = aws_elastic_beanstalk_environment.app_beanstalk_env.load_balancers[0]
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

data "aws_lb" "eb_lb" {
  arn = aws_elastic_beanstalk_environment.app_beanstalk_env.load_balancers[0]
}

data "aws_iam_role" "elasticbeanstalk_role" {
  name = "aws-elasticbeanstalk-service-role"
}
