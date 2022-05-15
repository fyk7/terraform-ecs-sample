# Cluster
resource "aws_ecs_cluster" "your_app_name" {
  name = "${var.ecs_cluster_name}"
}

# Task Definition
resource "aws_ecs_task_definition" "your_app_name" {
  family                   = "${var.ecs_task_definition_family}"
  cpu                      = "${var.ecs_cpu}"
  memory                   = "${var.ecs_memory}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions.json")
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
}

# Service
resource "aws_ecs_service" "your_app_name" {
  name                              = "${var.ecs_service_name}"
  cluster                           = aws_ecs_cluster.your_app_name.arn
  task_definition                   = aws_ecs_task_definition.your_app_name.arn
  desired_count                     = 2
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups  = [module.nginx_sg.security_group_id]

    subnets = [
      aws_subnet.private_0.id,
      aws_subnet.private_1.id,
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.your_app_name.arn
    container_name   = "example" # container_definition.jsonに合わせる
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

# Cloud Watch
resource "aws_cloudwatch_log_group" "for_ecs" {
  name              = "${var.ecs_cloud_watch_log_group_name}" # container_definition.jsonに合わせる
  retention_in_days = 180
}


# IAM ECS Execution Roles
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
data "aws_iam_policy_document" "ecs_task_execution" {
  source_policy_documents = [data.aws_iam_policy.ecs_task_execution_role_policy.policy]

  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }
}
module "ecs_task_execution_role" {
  source     = "./iam_role"
  name       = "ecs-task-execution"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution.json
}

# Security Groups
module "nginx_sg" {
  source      = "./security_group"
  name        = "nginx-sg"
  vpc_id      = aws_vpc.your_app_name.id
  port        = 80
  cidr_blocks = [aws_vpc.your_app_name.cidr_block]
}
