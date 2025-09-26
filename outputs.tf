output "api_endpoint" {
value = aws_apigatewayv2_api.http_api.api_endpoint
}


output "non_actionable_bucket" {
value = aws_s3_bucket.non_actionable.bucket
}


output "actionable_table_name" {
value = aws_dynamodb_table.actionable.name
}


output "sagemaker_endpoint" {
value = aws_sagemaker_endpoint.endpoint.name
}