output "frontend_cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.high_cpu_frontend
}

output "frontend_memory_alarm_name" {
  value = aws_cloudwatch_metric_alarm.high_memory_frontend
}

output "backend_cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.high_cpu_backend
}