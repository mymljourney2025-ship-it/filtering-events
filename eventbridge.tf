resource "aws_cloudwatch_event_rule" "health_events" {
name = "${var.project_name}-health-events"
description = "Catch all AWS Health events and forward to preprocessor"
event_pattern = jsonencode({
source = ["aws.health"],
"detail-type" = ["AWS Health Event"]
})
}


resource "aws_cloudwatch_event_target" "preprocessor_target" {
rule = aws_cloudwatch_event_rule.health_events.name
target_id = "preprocessor-lambda"
arn = aws_lambda_function.preprocessor.arn
}


# Grant EventBridge permission to invoke lambda (already in main.tf for preprocessor)