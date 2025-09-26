# This deploys a SageMaker Model and Endpoint. It assumes you have a model artifact (tar.gz) in S3
# For an MVP, you can create a small script that acts as a containerized inference wrapper and host it as a SageMaker model.


# S3 location for model artifacts - reuse same bucket
variable "sagemaker_model_s3_key" {
type = string
default = "sagemaker/model/artifacts/model.tar.gz" # update if you upload model
}


resource "aws_sagemaker_model" "model" {
name = var.sagemaker_model_name
execution_role_arn = aws_iam_role.sagemaker_exec_role.arn


primary_container {
# If you have a prebuilt container image in ECR, put image here and model data url
image = "382416733822.dkr.ecr.${var.aws_region}.amazonaws.com/xgboost:latest" # example xgboost image; may change by region
model_data_url = "s3://${aws_s3_bucket.non_actionable.bucket}/${var.sagemaker_model_s3_key}"
}
}


resource "aws_sagemaker_endpoint_configuration" "endpoint_config" {
name = "${var.sagemaker_endpoint_name}-config"


production_variants {
variant_name = "AllTraffic"
model_name = aws_sagemaker_model.model.name
initial_instance_count = 1
instance_type = var.sagemaker_instance_type
}
}


resource "aws_sagemaker_endpoint" "endpoint" {
name = var.sagemaker_endpoint_name
endpoint_config_name = aws_sagemaker_endpoint_configuration.endpoint_config.name
}


# Note: training job resources are intentionally omitted. For production, create aws_sagemaker_training_job