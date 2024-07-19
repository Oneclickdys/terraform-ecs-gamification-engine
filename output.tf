output "service_name" {
  value = local.service_name
}

output "target_group_arn_suffix" {
  value = aws_alb_target_group.tg.arn_suffix
}
