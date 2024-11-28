resource "aws_cloudwatch_event_rule" "this" {
  name        = var.event_rule_name
  description = var.event_rule_description
  event_bus_name = var.event_bus_name

  event_pattern = var.event_pattern
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  arn       = var.target_lambda_arn
  target_id = "EventTarget"
  event_bus_name = var.event_bus_name
}

resource "aws_lambda_permission" "event_target_permission" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.target_lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}