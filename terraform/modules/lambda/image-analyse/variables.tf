variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.10"
}

variable "handler" {
  description = "Handler for the Lambda function"
  type        = string
}

variable "filename" {
  description = "Path to the Lambda deployment package"
  type        = string
}

variable "source_code_hash" {
  description = "Base64-encoded SHA256 hash of the deployment package"
  type        = string
}

variable "images_bucket" {
  description = "S3 bucket where images will be uploaded"
  type        = string
}

variable "event_bus" {
  description = "Cloudwatch event bus for EventBridge."
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "default_max_call_attempts" {
  description = "Maximum retry attempts for AWS calls"
  type        = string
  default     = "1"
}
