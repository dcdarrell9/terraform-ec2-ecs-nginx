
locals {
  instance_ami = "ami-03c07bedab170b21a"
}

resource "aws_instance" "test_instance_public" {
  ami                         = local.instance_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.test_public_subnets[0].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.test_ec2_instance.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash
              # Install and configure the SSM agent
              sudo yum update -y
              sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
              sudo systemctl enable amazon-ssm-agent
              sudo systemctl start amazon-ssm-agent

              # Install Docker
              sudo yum install -y docker

              # Start Docker service
              sudo service docker start

              # Add ec2-user to the docker group
              sudo usermod -aG docker ec2-user

              # Start NGINX container
              sudo docker run -d \
                --log-driver awslogs \
                --log-opt awslogs-region=${var.aws_region} \
                --log-opt awslogs-group=${aws_cloudwatch_log_group.test_ec2_log_group.name} \
                -p 80:80 \
                --name nginx-container \
                nginx

              # Copy file from s3
              sudo aws s3 cp s3://${var.test_bucket_name}/index.html .

              # Copy into image
              sudo docker cp index.html nginx-container:/usr/share/nginx/html/

              # Restart docker
              sudo docker restart nginx-container
              EOF

  tags = {
    Name = "test-instance-public"
  }
}

output "public_ip" {
  value = aws_instance.test_instance_public.public_ip
}
