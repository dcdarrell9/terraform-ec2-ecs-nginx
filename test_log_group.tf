
locals {
  log_group_ec2_prefix = "/ec2/services"
  log_group_ecs_prefix = "/ecs/services"
}

resource "aws_cloudwatch_log_group" "test_ec2_log_group" {
  name = "${local.log_group_ec2_prefix}/test-ec2"
}

resource "aws_cloudwatch_log_group" "test_ecs_log_group" {
  name = "${local.log_group_ecs_prefix}/test-ecs"
}
