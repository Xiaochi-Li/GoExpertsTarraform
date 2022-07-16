resource "aws_ecs_cluster" "ecs" {
  name = "${var.application_name}-ecs-cluster"

  setting {
    // Enable Container Insights for monitorring, troubleshooting, and setting alarms for all your Amazon ECS resources
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.application_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  // QUESTION: what is the diff between task_role and execution_role
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    cpu    = 1024
    memory = 2048
    image  = "${var.image}"
    portMappings = [
      {
        protocol      = "tcp"
        containerPort = var.container_port
        hostPort      = var.container_port
      }
    ]
    // log Configuration is for showing container running output, for monitorring and troubleshooting
    logConfiguration : {
      logDriver : "awslogs",
      options : {
        awslogs-group = aws_cloudwatch_log_group.esc.name
        awslogs-region : "ap-southeast-2",
        awslogs-stream-prefix : "streaming"
      }
    },
    secrets : [
      var.db_connection
    ]
    name = "${var.application_name}-cont"
  }])
}

resource "aws_ecs_service" "service" {
  name                               = var.application_name
  cluster                            = aws_ecs_cluster.ecs.id
  task_definition                    = aws_ecs_task_definition.task.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  // QUESTION:what does this do?
  scheduling_strategy = "REPLICA"

  // network_configuration is a must when communicating with terr
  network_configuration {
    subnets          = aws_subnet.private.*.id
    security_groups  = aws_security_group.ecs_tasks.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    // name should be the same as aws_ecs_task_definition -> container_definitions -> name
    container_name = "${var.application_name}-cont"
    container_port = var.container_port
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}
