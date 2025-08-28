# IAM Role for EC2 to access SSM and CloudWatch
resource "aws_iam_role" "ec2_ssm_cloudwatch_role" {
  name = "ec2-ssm-cloudwatch-role-${var.project_name}-${var.name}"

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
    Name = "EC2SSMCloudWatchRole-${var.name}"
  }
}

resource "aws_ssm_parameter" "cwagent_config" {
  name        = "/${var.project_name}/${var.name}/AmazonCloudWatch-linux/config"
  type        = "String"
  description = "CloudWatch Agent configuration"
  
  value       = var.cwagent_config_json
  lifecycle {
    create_before_destroy = true
    ignore_changes = [value]
  }
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
  name = "ec2-ssm-cloudwatch-profile-${var.project_name}-${var.name}"
  role = aws_iam_role.ec2_ssm_cloudwatch_role.name
}




