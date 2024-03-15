
resource "aws_ecs_cluster" "nginx_cluster" {
  name = "nginx-cluster"
}

resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.test_ecs_execution_role.arn
  task_role_arn            = aws_iam_role.test_ecs_task_role.arn

  container_definitions = jsonencode([{
    name  = "nginx-container"
    image = "nginx:latest"

    portMappings = [{
      containerPort = 80,
      hostPort      = 80,
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-create-group"  = "true"
        "awslogs-group"         = aws_cloudwatch_log_group.test_ecs_log_group.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "awslogs-nginx"
      }
    }
  }])
}

# Sometimes awkward to make the container update correctly with ECS
# We can use a data source to look for the current running version
data "aws_ecs_task_definition" "nginx_task" {
  task_definition = aws_ecs_task_definition.nginx_task.family
}

resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.nginx_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = aws_subnet.test_public_subnets[*].id
    assign_public_ip = true
    security_groups  = [aws_security_group.test_ecs_instance.id]
  }
}
