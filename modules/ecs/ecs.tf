data "aws_iam_policy_document" "assume_role_execution_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "execution_role" {
  name               = "role-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_execution_role.json
}

data "aws_iam_policy_document" "execution_role" {
  statement {
    effect = "Allow"

    actions = [
      "logs:*",
      "ecr:*","s3:ListBucket","s3:GetObject","s3:PutObject"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "execution_role" {
  role   = aws_iam_role.execution_role.name
  policy = data.aws_iam_policy_document.execution_role.json
}

resource "aws_ecs_task_definition" "service" {
  count = length(var.service_name)
  family                   = "${var.service_name[count.index]}-task"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.execution_role.arn
  cpu                      = 1024
  memory                   = 3072
  requires_compatibilities = ["FARGATE"]
  container_definitions    = <<-EOF
  [
  {
    "image": "${var.aws_account_id}.dkr.ecr.ap-northeast-2.amazonaws.com/${var.service_name[count.index]}:latest",
    "cpu": 512,
    "memory": 2048,
    "name": "${var.service_name[count.index]}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "healthCheck": {
      "command": [
        "CMD-SHELL",
        "curl -fLs http://localhost:8080/ > /dev/null || exit 1"
      ],
      "interval": 30,
      "timeout": 10,
      "retries": 2,
      "startPeriod": 60
    },
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "equus-log-cluster",
        "awslogs-region": "ap-northeast-2",
        "awslogs-create-group": "true",
        "awslogs-stream-prefix": "role"
      }
    }
  },
  {
    "image": "${var.aws_account_id}.dkr.ecr.ap-northeast-2.amazonaws.com/sidecar-proxy-stag:latest",
    "cpu": 256,
    "memory": 512,
    "name": "equus-sidecar-proxy",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 8888,
        "hostPort": 8888
      }
    ],
    "healthCheck": {
      "command": [
        "CMD-SHELL",
        "curl -fLs http://localhost:8888/ > /dev/null || exit 1"
      ],
      "interval": 30,
      "timeout": 10,
      "retries": 2,
      "startPeriod": 60
    },
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "equus-proxy-cluster",
        "awslogs-region": "ap-northeast-2",
        "awslogs-create-group": "true",
        "awslogs-stream-prefix": "role"
      }
    }
  },
  {
    "image" : "public.ecr.aws/datadog/agent:latest",
    "cpu": 256,
    "memory": 512,
    "environment": [
      {
        "name": "DD_API_KEY",
        "value": "${var.DD_API_KEY}"
      },
      {
        "name": "DD_SITE",
        "value": "us5.datadoghq.com"
      }
    ],
    "name": "datadog-agent",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 8126,
        "hostPort": 8126
      }
    ],
    "healthCheck": {
      "retries": 3,
      "command": [
        "CMD-SHELL",
        "agent health"
      ],
      "timeout": 10,
      "interval": 60,
      "startPeriod": 60
    },
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "equus-datadog-cluster",
        "awslogs-region": "ap-northeast-2",
        "awslogs-create-group": "true",
        "awslogs-stream-prefix": "role"
      }
    }
  }
]
EOF
}

resource "aws_ecs_cluster" "equus" {
  name = "entry-stag-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "equus_workers" {
  cluster_name = aws_ecs_cluster.equus.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_service" "equus_service" {
  count = length(var.service_name)
  name            = "entry-${var.service_name[count.index]}-service"
  cluster         = aws_ecs_cluster.equus.id
  task_definition = aws_ecs_task_definition.service[count.index].arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_task.id]
    subnets          = var.subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.equus_tg[count.index].arn
    container_name   = "equus-sidecar-proxy"
    container_port   = var.container_port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.equus[count.index].arn
    container_name = var.service_name[count.index]
  }
}

resource "aws_service_discovery_service" "equus" {
  count = length(var.service_name)
  name = lower("${var.service_name[count.index]}-discovery")

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.equus.id
    dns_records {
      ttl  = 60
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }
}

resource "aws_service_discovery_private_dns_namespace" "equus" {
  name = var.namespace_id
  vpc  = var.vpc_id
}