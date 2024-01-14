#schedule
resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  schedule_expression ="rate(1 minutes)"
  name = "lambda_schedule"
  description = "Schedule to trigger put_kinesis function."
  is_enabled = true
}

resource "aws_cloudwatch_event_target" "lambda_event_target" {
  rule = aws_cloudwatch_event_rule.lambda_schedule.name
  target_id = "InvokeLambda"
  arn = aws_lambda_function.push_data.arn
}



