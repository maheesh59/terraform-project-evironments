environment  = "prod"
project_name = "platform"
aws_region   = "ap-south-1"

tags = {
  Environment = "prod"
  ManagedBy   = "Terraform"
  Project     = "platform"
}


vpc_cidr = "10.20.0.0/16"

public_subnet_cidrs = [
  "10.20.1.0/24",
  "10.20.2.0/24"
]

private_subnet_cidrs = [
  "10.20.11.0/24",
  "10.20.12.0/24"
]

public_subnet_azs = [
  "ap-south-1a",
  "ap-south-1b"
]

private_subnet_azs = [
  "ap-south-1a",
  "ap-south-1b"
]


vpc_endpoints = {
  enable_s3             = true
  enable_dynamodb       = true
  enable_ecr            = true
  enable_secretsmanager = true
  enable_ssm            = true
  enable_ssmmessages    = true
  enable_ec2messages    = true

  name_prefix = "prod-vpc"
}


ecr = {
  repositories = {
    my_test_ecr = {
      repository_name            = "my-test-ecr"
      image_tag_mutability       = "MUTABLE"
      scan_on_push               = true
      untagged_image_expiry_days = 7
      tagged_image_max_count     = 10
      tagged_prefixes            = ["latest"]
    }
  }
}


eks = {
  cluster_name               = "prod-eks-cluster"
  cluster_version            = "1.30"
  cluster_log_retention_days = 90

  node_groups = {
    system = {
      instance_types = ["t3.medium"]

      capacity_type = "ON_DEMAND"

      desired_size = 2
      min_size     = 2
      max_size     = 3
    }
  }

  eks_addons = {
    aws-ebs-csi-driver = {
      version                  = "REPLACE_WITH_YOUR_EBS_CSI_VERSION"
      service_account_role_arn = "REPLACE_WITH_YOUR_PROD_EBS_CSI_ROLE_ARN"
    }

    vpc-cni = {
      version = "REPLACE_WITH_YOUR_VPC_CNI_VERSION"
    }

    coredns = {
      version = "REPLACE_WITH_YOUR_COREDNS_VERSION"
    }

    kube-proxy = {
      version = "REPLACE_WITH_YOUR_KUBE_PROXY_VERSION"
    }
  }
}


rds = {
  allowed_cidr_blocks = []

  security_group_description         = "RDS security group"
  security_group_ingress_description = "Allow EKS nodes to access RDS"
  cidr_ingress_description           = "RDS CIDR access"
  ingress_protocol                   = "tcp"

  egress_cidr        = "0.0.0.0/0"
  egress_protocol    = "-1"
  egress_description = "RDS outbound access"

  engine                 = "mysql"
  engine_version         = "8.0"
  parameter_group_family = "mysql8.0"
  instance_class         = "db.t3.micro"

  db_name  = "appdb"
  username = "admin"

  port     = 3306
  password = "REPLACE_WITH_SECURE_PASSWORD"

  allocated_storage     = 20
  max_allocated_storage = 100

  storage_type      = "gp3"
  storage_encrypted = true

  kms_key_arn                 = null
  secrets_manager_kms_key_arn = null

  kms_deletion_window_in_days    = 7
  kms_enable_key_rotation        = true
  secret_recovery_window_in_days = 7

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  copy_tags_to_snapshot = true

  deletion_protection = false
  skip_final_snapshot = true

  monitoring_interval = 0

  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]

  parameters = {}
}


load_balancer_controller = {
  enabled       = true
  replica_count = 2
  chart_version = "REPLACE_WITH_YOUR_ALB_CONTROLLER_VERSION"

  enable_waf    = false
  enable_wafv2  = false
  enable_shield = false

  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
}


platform = {
  enable_jenkins   = true
  enable_nexus     = true
  enable_sonarqube = true

  target_type          = "instance"
  listener_action_type = "forward"

  alb = {
    name                = "prod-platform-alb"
    internal            = false
    load_balancer_type  = "application"
    deletion_protection = false

    security_group_name        = "prod-platform-alb-sg"
    security_group_description = "Public HTTP access to platform ALB"

    ingress_rules = {
      jenkins = {
        description = "Jenkins HTTP access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      nexus = {
        description = "Nexus UI"
        from_port   = 8081
        to_port     = 8081
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      sonarqube = {
        description = "SonarQube UI"
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }

    egress = {
      description = "ALB outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  jenkins = {
    name = "prod-jenkins"

    ami_id               = null
    ami_most_recent      = true
    ami_owner            = "137112412989"
    ami_name_pattern     = "al2023-ami-*-x86_64"
    ami_architecture     = "x86_64"
    ami_root_device_type = "ebs"

    instance_type = "t3.medium"

    root_volume_size      = 30
    root_volume_type      = "gp3"
    root_volume_encrypted = true

    associate_public_ip_address = false

    port     = 8080
    protocol = "tcp"

    listener_port     = 80
    listener_protocol = "HTTP"

    target_group_name     = "prod-jenkins-tg"
    target_group_protocol = "HTTP"

    security_group_description = "Security group for Jenkins"
    ingress_description        = "Jenkins from ALB"

    egress_description = "Outbound internet access"
    egress_from_port   = 0
    egress_to_port     = 0
    egress_protocol    = "-1"
    egress_cidr_blocks = ["0.0.0.0/0"]

    ssm_policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

    health_check = {
      enabled             = true
      protocol            = "HTTP"
      path                = "/login"
      matcher             = "200-399"
      interval            = 30
      timeout             = 10
      healthy_threshold   = 3
      unhealthy_threshold = 3
    }
  }

  nexus = {
    name             = "prod-nexus"
    instance_type    = "t3.medium"
    root_volume_size = 100

    listener_port     = 8081
    listener_protocol = "HTTP"

    port = 8081

    target_group_name     = "prod-nexus-tg"
    target_group_protocol = "HTTP"

    health_check = {
      enabled             = true
      protocol            = "HTTP"
      path                = "/"
      matcher             = "200-399"
      interval            = 30
      timeout             = 10
      healthy_threshold   = 3
      unhealthy_threshold = 3
    }
  }

  sonarqube = {
    name             = "prod-sonarqube"
    instance_type    = "t3.medium"
    root_volume_size = 50

    listener_port     = 9000
    listener_protocol = "HTTP"

    port = 9000

    target_group_name     = "prod-sonarqube-tg"
    target_group_protocol = "HTTP"

    health_check = {
      enabled             = true
      protocol            = "HTTP"
      path                = "/api/system/status"
      matcher             = "200-399"
      interval            = 30
      timeout             = 10
      healthy_threshold   = 3
      unhealthy_threshold = 3
    }
  }
}
