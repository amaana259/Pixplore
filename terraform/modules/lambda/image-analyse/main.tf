resource "aws_iam_role" "lambda_execution_role" {
  name = "image_analysis_lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "rekognition_access_policy" {
  name = "image_analysis_rekognition_access_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "rekognition:DetectLabels",
          "rekognition:DetectFaces"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "events:PutEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "rekognition_policy_attachment" {
  name       = "image_analysis_rekognition_policy_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = aws_iam_policy.rekognition_access_policy.arn
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  runtime          = var.runtime
  handler          = var.handler
  role             = aws_iam_role.lambda_execution_role.arn
  filename         = var.filename
  source_code_hash = var.source_code_hash

  environment {
    variables = {
      IMAGES_BUCKET             = var.images_bucket
      REGION                    = var.region
      DEFAULT_MAX_CALL_ATTEMPTS = var.default_max_call_attempts
      EVENT_BUS                 = var.event_bus
    }
  }
}
