# ===========================================================
# metrics
# ===========================================================

# by CPUs
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-${var.name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 40
  alarm_description   = "Alarm when frontend CPU exceeds 80%"
  alarm_actions = [var.scale_out_policy_arn]

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  tags = {
    Environment = "${var.environment}"
    Project = "${var.project_name}"
    Provisioner="cloudwatch"
    Name = "${var.name}.memory"
  }
}

# by RAM
resource "aws_cloudwatch_metric_alarm" "ram_high_alarm" {
  alarm_name          = "${var.project_name}-${var.name}-ram-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "Alarm when RAM usage exceeds 75%"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
  alarm_actions = [var.scale_out_policy_arn]

   tags = {
    Environment = "${var.environment}"
    Project = "${var.project_name}"
    Provisioner="cloudwatch"
    Name = "${var.name}.memory"
  }

}


