# IAM Role for EC2 to access SSM and CloudWatch
resource "aws_iam_role" "ec2_ssm_cloudwatch_role" {
  name = "ec2-ssm-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "EC2SSMCloudWatchRole"
  }
}

resource "aws_ssm_parameter" "cwagent_config" {
  name        = "/AmazonCloudWatch-linux/config"
  type        = "String"
  description = "CloudWatch Agent configuration"

  value       = jsonencode({
    agent = {
      metrics_collection_interval = 60,
      logfile                     = "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
    },
    metrics = {
      namespace = "CWAgent"
      metrics_collected = {
        mem = {
          measurement = [
            "mem_used_percent"
          ]
          metrics_collection_interval = 60
        }
      }
    }
  })

  lifecycle {
    ignore_changes = [value]
  }
}

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
}

# Attach managed policies to the IAM role
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_ssm_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2_ssm_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Instance profile to be used in the launch template
resource "aws_iam_instance_profile" "ec2_ssm_cloudwatch_profile" {
  name = "ec2-ssm-cloudwatch-profile"
  role = aws_iam_role.ec2_ssm_cloudwatch_role.name
}
