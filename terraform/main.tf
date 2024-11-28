# main.tf

provider "aws" {
  region = "us-east-1"
}

module "landing_page_lambda" {
  source          = "./modules/lambda/landing-page"
  function_name   = "Landing_Page"
  runtime         = "python3.10"
  handler         = "main.handler"
  filename        = "${path.module}/modules/lambda/landing-page/landingPage.zip"
  source_code_hash = filebase64sha256("${path.module}/modules/lambda/landing-page/landingPage.zip")
}

module "image_metadata_lambda" {
  source          = "./modules/lambda/image-data"
  function_name   = "Image_Metadata_Reader"
  runtime         = "python3.10"
  handler         = "main.handler"
  filename        = "${path.module}/modules/lambda/image-data/imageData.zip"
  source_code_hash = filebase64sha256("${path.module}/modules/lambda/image-data/imageData.zip")
}

module "upload_photo_lambda" {
  source                         = "./modules/lambda/upload-photo"
  function_name                  = "Upload_Photo_Lambda"
  runtime                        = "python3.10"
  handler                        = "main.handler"
  filename                       = "${path.module}/modules/lambda/upload-photo/getSignedUrl.zip"
  source_code_hash               = filebase64sha256("${path.module}/modules/lambda/upload-photo/getSignedUrl.zip")
  images_bucket                  = "pixplore-s3"
  default_signedurl_expiry_seconds = "3600"
}

resource "aws_cloudwatch_event_bus" "image_content_bus" {
  name = "ImageContentBus"
}

module "image_analysis_lambda" {
  source                         = "./modules/lambda/image-analyse"
  function_name                  = "Image_Analysis_Lambda"
  runtime                        = "python3.10"
  handler                        = "main.handler"
  filename                       = "${path.module}/modules/lambda/image-analyse/imageAnalysis.zip"
  source_code_hash               = filebase64sha256("${path.module}/modules/lambda/image-analyse/imageAnalysis.zip")
  region                         = "us-east-1"
  images_bucket                  = "pixplore-s3"
  event_bus                      = aws_cloudwatch_event_bus.image_content_bus.name
  default_max_call_attempts      = "3"
}


# EventBridge
module "eventbridge" {
  source               = "./modules/eventbridge"
  event_bus_name       = "ImageContentBus"
  event_rule_name      = "pixplore-imagerule"
  event_rule_description = "The event from image analyzer to store the data"
  event_pattern        = jsonencode({
    resources = [
      module.image_analysis_lambda.lambda_arn
    ]
  })
  target_lambda_arn    = module.image_metadata_lambda.lambda_arn
  target_lambda_name   = module.image_metadata_lambda.lambda_name

}

module "image_queue_lambda" {
  source                         = "./modules/lambda/image-queue"
  function_name                  = "Image_Queue_Lambda"
  runtime                        = "python3.10"
  handler                        = "main.handler"
  region                         = "us-east-1"
  filename                       = "${path.module}/modules/lambda/image-queue/imageQueue.zip"
  source_code_hash               = filebase64sha256("${path.module}/modules/lambda/image-queue/imageQueue.zip")
  queue_name                     = "pixplore-sqs"
}