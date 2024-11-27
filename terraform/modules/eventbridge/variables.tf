variable "event_bus_name" {
  description = "Name of the EventBridge Event Bus"
  type        = string
}

variable "event_rule_name" {
  description = "Name of the EventBridge Rule"
  type        = string
}

variable "event_rule_description" {
  description = "Description of the EventBridge Rule"
  type        = string
}

variable "event_pattern" {
  description = "Event pattern for the rule"
  type        = string
}

variable "target_lambda_arn" {
  description = "ARN of the target Lambda function"
  type        = string
}

variable "target_lambda_name" {
  description = "Name of the target Lambda function"
  type        = string
}