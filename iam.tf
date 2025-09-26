# Lambda execution role
Effect = "Allow",
Action = [
"sagemaker:InvokeEndpoint"
],
Resource = [
"arn:aws:sagemaker:${var.aws_region}:${data.aws_caller_identity.current.account_id}:endpoint/${var.sagemaker_endpoint_name}"
]
},
{
Effect = "Allow",
Action = [
"logs:CreateLogGroup",
"logs:CreateLogStream",
"logs:PutLogEvents"
],
Resource = "*"
}
]
})
}


# Role for SageMaker to access S3 (model artifacts / training data)
resource "aws_iam_role" "sagemaker_exec_role" {
name = "${var.project_name}-sagemaker-exec-role"
assume_role_policy = jsonencode({
Version = "2012-10-17",
Statement = [
{
Effect = "Allow",
Principal = { Service = "sagemaker.amazonaws.com" },
Action = "sts:AssumeRole"
}
]
})
}


resource "aws_iam_role_policy" "sagemaker_policy" {
name = "${var.project_name}-sagemaker-policy"
role = aws_iam_role.sagemaker_exec_role.id


policy = jsonencode({
Version = "2012-10-17",
Statement = [
{
Effect = "Allow",
Action = [
"s3:GetObject",
"s3:PutObject",
"s3:ListBucket"
],
Resource = [
aws_s3_bucket.non_actionable.arn,
"${aws_s3_bucket.non_actionable.arn}/*"
]
},
{
Effect = "Allow",
Action = [
"logs:CreateLogStream",
"logs:PutLogEvents"
],
Resource = "*"
}
]
})
}


data "aws_caller_identity" "current" {}