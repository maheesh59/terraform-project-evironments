# ==============================================================
# GENERAL
# ==============================================================

environment  = "test"
project_name = "platform"
aws_region   = "ap-south-1"

tags = {
  Environment = "test"
  ManagedBy   = "Terraform"
  Project     = "platform"
}


# ==============================================================
# VPC
# ==============================================================

vpc_cidr = "10.10.0.0/16"

public_subnet_cidrs = [
  "10.10.1.0/24",
  "10.10.2.0/24"
]

private_subnet_cidrs = [
  "10.10.11.0/24",
  "10.10.12.0/24"
]

public_subnet_azs = [
  "ap-south-1a",
  "ap-south-1b"
]

private_subnet_azs = [
  "ap-south-1a",
  "ap-south-1b"
]


# ==============================================================
# VPC ENDPOINTS
# ==============================================================

vpc_endpoints = {
  enable_s3             = true
  enable_dynamodb       = true
  enable_ecr            = true
  enable_secretsmanager = true
  enable_ssm            = true
  enable_ssmmessages    = true
  enable_ec2messages    = true

  name_prefix = "test-vpc"
}


# ==============================================================
# ECR
# ==============================================================

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


# ==============================================================
# EKS
# ==============================================================

eks = {
  cluster_name               = "test-eks-cluster-new"
  cluster_version            = "1.30"
  cluster_log_retention_days = 90

  node_groups = {
    test_nodes = {
      instance_types = ["t3.micro"]

      capacity_type = "ON_DEMAND"

      desired_size = 0
      min_size     = 0
      max_size     = 2
    }
  }

  eks_addons = {
    aws-ebs-csi-driver = {
      version = "v1.63.0-eksbuild.1"
    }

    vpc-cni = {
      version = "v1.22.4-eksbuild.3"
    }

    coredns = {
      version = "v1.11.4-eksbuild.53"
    }

    kube-proxy = {
      version = "v1.30.14-eksbuild.43"
    }
  }
}


# ==============================================================
# RDS
# ==============================================================

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

  backup_window      = "03:00-04:00"
  maintenance_window = "sun:04:00-sun:05:00"

  copy_tags_to_snapshot = true

  deletion_protection = false
  skip_final_snapshot = true

  monitoring_interval = 0

  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]

  parameters = []
}


# ==============================================================
# AWS LOAD BALANCER CONTROLLER
# ==============================================================

load_balancer_controller = {
  enabled       = true
  replica_count = 2
  chart_version = "3.1.0"

  enable_waf    = false
  enable_wafv2  = false
  enable_shield = false

  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
}


# ==============================================================
# PLATFORM
# ==============================================================

platform = {
  enable_jenkins   = true
  enable_nexus     = true
  enable_sonarqube = true

  target_type          = "instance"
  listener_action_type = "forward"

  # ------------------------------------------------------------
  # ALB
  # ------------------------------------------------------------

  alb = {
    name                = "test-platform-alb"
    internal            = false
    load_balancer_type  = "application"
    deletion_protection = false

    security_group_name        = "test-platform-alb-sg"
    security_group_description = "Public HTTP access to platform ALB"

    ingress_rules = {
      jenkins = {
        description = "Jenkins HTTP access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"

        cidr_blocks = [
          "0.0.0.0/0"
        ]
      }

      nexus = {
        description = "Nexus UI"
        from_port   = 8081
        to_port     = 8081
        protocol    = "tcp"

        cidr_blocks = [
          "0.0.0.0/0"
        ]
      }

      sonarqube = {
        description = "SonarQube UI"
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"

        cidr_blocks = [
          "0.0.0.0/0"
        ]
      }
    }

    egress = {
      description = "ALB outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"

      cidr_blocks = [
        "0.0.0.0/0"
      ]
    }
  }


  # ------------------------------------------------------------
  # Jenkins
  # ------------------------------------------------------------

  jenkins = {
    name = "test-jenkins"

    # null = automatically select latest matching AL2023 AMI
    ami_id = null

    ami_most_recent      = true
    ami_owner            = "137112412989"
    ami_name_pattern     = "al2023-ami-*-x86_64"
    ami_architecture     = "x86_64"
    ami_root_device_type = "ebs"

    instance_type = "t3.medium"

    java_version = 21

    root_volume_size      = 30
    root_volume_type      = "gp3"
    root_volume_encrypted = true

    associate_public_ip_address = false

    port     = 8080
    protocol = "tcp"

    listener_port     = 80
    listener_protocol = "HTTP"

    target_group_name     = "test-jenkins-tg"
    target_group_protocol = "HTTP"

    security_group_description = "Security group for Jenkins"
    ingress_description        = "Jenkins from ALB"

    egress_description = "Outbound internet access"
    egress_from_port   = 0
    egress_to_port     = 0
    egress_protocol    = "-1"

    egress_cidr_blocks = [
      "0.0.0.0/0"
    ]

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


  # ------------------------------------------------------------
  # Nexus
  # ------------------------------------------------------------

  nexus = {
    name             = "test-nexus"
    instance_type    = "t3.micro"
    root_volume_size = 30
    ami_id           = null

    java_version = "17"

    listener_port     = 8081
    listener_protocol = "HTTP"

    port = 8081

    target_group_name     = "test-nexus-tg"
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


  # ------------------------------------------------------------
  # SonarQube
  # ------------------------------------------------------------

  sonarqube = {
    name             = "test-sonarqube"
    instance_type    = "t3.medium"
    root_volume_size = 30
    ami_id           = null

    sonarqube_version = "25.1.0.102122"
    java_version      = 17

    database_name     = "sonarqube"
    database_username = "sonarqube"
    database_password = "speshway"
    database_port     = 5432

    listener_port     = 9000
    listener_protocol = "HTTP"

    port = 9000

    target_group_name     = "test-sonarqube-tg"
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

