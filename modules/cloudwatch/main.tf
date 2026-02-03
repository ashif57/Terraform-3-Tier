resource "aws_cloudwatch_dashboard" "photoshare" {
  dashboard_name = "PhotoShare-Monitor"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x = 0
        y = 0
        width = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", var.ec2_instance_id]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "EC2 CPU Utilization"
        }
      },
      {
        type = "metric"
        x = 12
        y = 0
        width = 6
        height = 6

        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_function_name]
          ]
          view   = "singleValue"
          stat   = "Sum"
          region = "us-east-1"
          title  = "Lambda Invocations"
        }
      }
    ]
  })
}
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name = "PhotoShare-Lambda-Error-Alarm"

  namespace   = "AWS/Lambda"
  metric_name = "Errors"

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  statistic = "Sum"
  period    = 60
  evaluation_periods = 1

  threshold          = 0
  comparison_operator = "GreaterThanThreshold"

  alarm_description = "Triggers when Lambda reports errors"

  treat_missing_data = "notBreaching"
}
