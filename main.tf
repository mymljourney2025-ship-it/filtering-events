resource "random_id" "bucket_suffix" {
}


module "iam" {
source = "./iam.tf"
}


# S3 bucket for non-actionables and for sagemaker training data
resource "aws_s3_bucket" "non_actionable" {
bucket = local.non_actionable_bucket
acl = "private"
tags = {
Project = var.project_name
}
}


# Optional: S3 prefix for training data
resource "aws_s3_bucket_object" "training_placeholder" {
bucket = aws_s3_bucket.non_actionable.id
key = "training/placeholder.txt"
content = "placeholder"
depends_on = [aws_s3_bucket.non_actionable]
}


# Lambda functions
resource "aws_lambda_function" "preprocessor" {
filename = "./lambda/preprocessor_router.zip"
function_name = "${var.project_name}-preprocessor"
role = aws_iam_role.lambda_exec.arn
handler = "preprocessor_router.lambda_handler"
runtime = "python3.9"
source_code_hash = filebase64sha256("./lambda/preprocessor_router.zip")
environment {
variables = {
ACTIONABLE_TABLE = var.actionable_table_name
NON_ACTIONABLE_BUCKET = aws_s3_bucket.non_actionable.bucket
SAGEMAKER_ENDPOINT = var.sagemaker_endpoint_name
}
}
}


resource "aws_lambda_function" "actionable" {
filename = "./lambda/actionable.zip"
function_name = "${var.project_name}-actionable-handler"
role = aws_iam_role.lambda_exec.arn
handler = "actionable_handler.lambda_handler"
runtime = "python3.9"
source_code_hash = filebase64sha256("./lambda/actionable.zip")
environment {
variables = {
ACTIONABLE_TABLE = var.actionable_table_name
}
}
}


resource "aws_lambda_function" "non_actionable" {
filename = "./lambda/non_actionable.zip"
function_name = "${var.project_name}-non-actionable-handler"
role = aws_iam_role.lambda_exec.arn
handler = "non_actionable_handler.lambda_handler"
runtime = "python3.9"
source_code_hash = filebase64sha256("./lambda/non_actionable.zip")
environment {
variables = {
NON_ACTIONABLE_BUCKET = aws_s3_bucket.non_actionable.bucket
}
}
}


# Permissions for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge_preprocessor" {
statement_id = "AllowExecutionFromEventBridgePreprocessor"
action = "lambda:InvokeFunction"
function_name = aws_lambda_function.preprocessor.function_name
principal = "events.amazonaws.com"
}