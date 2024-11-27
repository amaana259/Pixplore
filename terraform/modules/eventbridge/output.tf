output "event_bus_name" {
  value = aws_cloudwatch_event_bus.this.name
}

output "event_rule_arn" {
  value = aws_cloudwatch_event_rule.this.arn
}