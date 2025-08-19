resource "aws_iam_role" "ssm_role" {
  name = "${var.project_name}-ssm-role"
  description = "IAM role of EC2, to work with AWS SSM"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
   Project = var.project_name
   ManagedBy = "Terraform"
   Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.project_name}-ssm-profile"
  role = aws_iam_role.ssm_role.name

  tags = {
   Project = var.project_name
   ManagedBy   = "Terraform"
  }
}


resource "aws_ssm_parameter" "cwagent_config" {
  name        = "/${var.project_name}/cwagent-config"
  type        = "String"
  value       = var.cwagent_config_json
  description = "CloudWatch agent config for RAM monitoring"

  tags = {
   Project = var.project_name
  }

  lifecycle {
    ignore_changes = [value] # щоб не змінювати при кожному apply, якщо конфіг не змінився
  }
}