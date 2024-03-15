
resource "aws_cloudwatch_dashboard" "nginx_dashboard" {
  dashboard_name = "nginx-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 24
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              "${aws_instance.test_instance_public.id}"
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "${aws_instance.test_instance_public.id} - CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 24
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "NetworkIn",
              "InstanceId",
              "${aws_instance.test_instance_public.id}"
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "${aws_instance.test_instance_public.id} - NetworkIn"
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 0
        width  = 24
        height = 6

        properties = {
          query   = "SOURCE '${aws_cloudwatch_log_group.test_ec2_log_group.name}' | fields @timestamp, @message, @logStream, @log\n| sort @timestamp desc\n| limit 1000"
          region  = var.aws_region
          stacked = false
          view    = "table"
        }
      }
    ]
  })
}
