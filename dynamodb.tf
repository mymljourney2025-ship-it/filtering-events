resource "aws_dynamodb_table" "actionable" {
name = var.actionable_table_name
billing_mode = "PAY_PER_REQUEST"
hash_key = "eventArn"


attribute {
name = "eventArn"
type = "S"
}


tags = {
Project = var.project_name
}
}