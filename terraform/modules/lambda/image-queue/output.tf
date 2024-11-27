output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "lambda_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "role_arn" {
  description = "IAM Role ARN for the Lambda execution"
  value       = aws_iam_role.lambda_execution_role.arn
}