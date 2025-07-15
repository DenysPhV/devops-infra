resource "aws_cloudwatch_metric_alarm" "high_cpu_frontend" {
  alarm_name          = "high_cpu_frontend"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when frontend CPU exceeds 80%"

  dimensions = {
    AutoScalingGroupName = var.frontend_asg_name
  }
}

# TODO Trigger for  RAM 
resource "aws_cloudwatch_metric_alarm" "high_memory_frontend" {
  alarm_name          = "high_memory_frontend"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when frontend memory usage exceeds 80%"

  dimensions = {
    AutoScalingGroupName = var.frontend_asg_name
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_backend" {
  alarm_name          = "high-cpu-backend"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when backend CPU exceeds 80%"

  dimensions = {
    AutoScalingGroupName = var.backend_asg_name
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "high-memory-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "High RAM usage detected"

  dimensions = {
    AutoScalingGroupName = var.frontend_asg_name
  }
  
  alarm_actions = [var.alarm_action_arn]
}