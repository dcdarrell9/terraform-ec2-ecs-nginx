
resource "aws_security_group" "test_ec2_instance" {
  name        = "test_ec2_sg"
  description = "EC2 Security Group"
  vpc_id      = aws_vpc.test_vpc.id
}

resource "aws_security_group_rule" "ec2_ingress_http" {
  security_group_id = aws_security_group.test_ec2_instance.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # This should be more restrictive, but left for now.

  description = "Allow all ingress traffic from HTTPS"
}

resource "aws_security_group_rule" "ec2_ingress_https" {
  security_group_id = aws_security_group.test_ec2_instance.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # This should be more restrictive, but left for now.

  description = "Allow all ingress traffic from HTTPS"
}

resource "aws_security_group_rule" "ec2_egress_all" {
  security_group_id = aws_security_group.test_ec2_instance.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

  description = "Allow all egress traffic"
}


resource "aws_security_group" "test_ecs_instance" {
  name        = "test_ecs_sg"
  description = "EC2 Security Group"
  vpc_id      = aws_vpc.test_vpc.id
}

resource "aws_security_group_rule" "ecs_ingress_http" {
  security_group_id = aws_security_group.test_ecs_instance.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # This should be more restrictive, but left for now.

  description = "Allow all ingress traffic from HTTPS"
}

resource "aws_security_group_rule" "ecs_ingress_https" {
  security_group_id = aws_security_group.test_ecs_instance.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # This should be more restrictive, but left for now.

  description = "Allow all ingress traffic from HTTPS"
}

resource "aws_security_group_rule" "ecs_egress_all" {
  security_group_id = aws_security_group.test_ecs_instance.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

  description = "Allow all egress traffic"
}
