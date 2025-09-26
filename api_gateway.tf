resource "aws_apigatewayv2_api" "http_api" {
name = "${var.project_name}-api"
protocol_type = "HTTP"
}


resource "aws_apigatewayv2_integration" "dynamo_integration" {
api_id = aws_apigatewayv2_api.http_api.id
integration_type = "AWS_PROXY"
integration_uri = aws_lambda_function.actionable.invoke_arn
integration_method = "POST"
}


resource "aws_apigatewayv2_route" "get_actionables_route" {
api_id = aws_apigatewayv2_api.http_api.id
route_key = "GET /actionable-events"
target = "integrations/${aws_apigatewayv2_integration.dynamo_integration.id}"
}


resource "aws_apigatewayv2_stage" "default" {
api_id = aws_apigatewayv2_api.http_api.id
name = "$default"
auto_deploy = true
}


resource "aws_lambda_permission" "apigw_invoke" {
statement_id = "AllowAPIGatewayInvoke"
action = "lambda:InvokeFunction"
function_name = aws_lambda_function.actionable.function_name
principal = "apigateway.amazonaws.com"
source_arn = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.http_api.id}/*/GET/actionable-events"
}