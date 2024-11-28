output "event_bus_name" {
  value = var.event_bus_name
}

output "event_rule_arn" {
  value = aws_cloudwatch_event_rule.this.arn
}