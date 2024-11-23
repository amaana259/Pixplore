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
  images_bucket                  = "Pixplore-S3"
  default_signedurl_expiry_seconds = "3600"
}

module "image_analysis_lambda" {
  source                         = "./modules/lambda/image-analyse"
  function_name                  = "Image_Analysis_Lambda"
  runtime                        = "python3.10"
  handler                        = "main.handler"
  filename                       = "${path.module}/modules/lambda/image-analyse/imageAnalysis.zip"
  source_code_hash               = filebase64sha256("${path.module}/modules/lambda/image-analyse/imageAnalysis.zip")
  region                         = "us-east-1"
  default_max_call_attempts      = "3"
}

module "image_massage_lambda" {
  source                         = "./modules/lambda/image-massage"
  function_name                  = "Image_Massage_Lambda"
  runtime                        = "python3.10"
  handler                        = "main.handler"
  filename                       = "${path.module}/modules/lambda/image-massage/imageMassage.zip"
  source_code_hash               = filebase64sha256("${path.module}/modules/lambda/image-massage/imageMassage.zip")
  queue_name                     = "Pixplore-SQS"
}