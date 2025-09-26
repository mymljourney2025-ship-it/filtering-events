variable "aws_region" {
type = string
default = "ap-south-1"
}


variable "project_name" {
type = string
default = "aws-health-filter"
}


variable "actionable_table_name" {
type = string
default = "ActionableEvents"
}


variable "non_actionable_bucket_prefix" {
type = string
default = "aws-health-non-actionable-events"
}


variable "sagemaker_instance_type" {
type = string
default = "ml.t2.medium"
}


variable "sagemaker_model_name" {
type = string
default = "aws-health-classifier-model"
}


variable "sagemaker_endpoint_name" {
type = string
default = "aws-health-classifier-endpoint"
}