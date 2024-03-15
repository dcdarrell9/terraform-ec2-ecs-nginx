
# EC2
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  policy_arn = aws_iam_policy.ec2_s3_access_policy.arn
  role       = aws_iam_role.ec2_role.name
}

resource "aws_iam_policy" "ec2_s3_access_policy" {
  name        = "ec2_s3_access_policy"
  description = "Custom IAM policy for EC2 to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["*"]
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# ECS
resource "aws_iam_role" "test_ecs_task_role" {
  name = "test-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test_ecs_task_role_attachment" {
  policy_arn = aws_iam_policy.test_ecs_task_policy.arn
  role       = aws_iam_role.test_ecs_task_role.name
}

resource "aws_iam_policy" "test_ecs_task_policy" {
  name        = "test-ecs-task-policy"
  description = "Task policy for ECS task"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # This allows use of SSM to get onto the ecs instance with ecs-exec
      {
        Action = [
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
        Effect   = "Allow"
      },
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = ["*"]
      }
    ]
  })
}


resource "aws_iam_role" "test_ecs_execution_role" {
  name = "test-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test_ecs_execution_role_attachment" {
  policy_arn = aws_iam_policy.test_ecs_execution_policy.arn
  role       = aws_iam_role.test_ecs_execution_role.name
}

resource "aws_iam_policy" "test_ecs_execution_policy" {
  name        = "test-ecs-execution-policy"
  description = "Execution policy for ECS task execution"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          aws_cloudwatch_log_group.test_ecs_log_group.arn
        ]
        Effect = "Allow"
      }
    ]
  })
}
