//Lambda function to put data to kinesis stream 
resource "aws_lambda_function" "push_data" {
  filename      = "${path.module}/../src/put_record.zip"
  function_name = "put_record"
  role          = aws_iam_role.kinesis_producer_role.arn
  handler       = "put_record.handler"
  runtime       = "python3.9"
  timeout       = 400
}


//Lambda function to get data to normalize
resource "aws_lambda_function" "flatten_data" {
  filename      = "${path.module}/../src/flatten_data.zip"
  function_name = "flatten_data"
  role          = aws_iam_role.lambda_kinesis_firehose_role.arn
  handler       = "flatten_data.handler"
  runtime       = "python3.9"
  timeout       = 400

}

//Lambda function to send data to aws
resource "aws_lambda_function" "put_data_aws" {
  filename      = "${path.module}/../src/put_data_aws.zip"
  function_name = "put_data_aws"
  role          = aws_iam_role.lambda_putdata_aws_role.arn
  handler       = "put_data_aws.send_data_to_free_tie"
  runtime       = "python3.9"
  timeout       = 400
}


//permission for cloudwatch trigger put_record lambda 
resource "aws_lambda_permission" "scheduled_lambda_cloudwatch_permission" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.push_data.arn
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.lambda_schedule.arn
}

//permission for s3 trigger put_data_aws lambda
resource "aws_lambda_permission" "allow_bucket_trigger_put_data_aws" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.put_data_aws.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucketS3.arn
}


//event source mapping for flatten data 
resource "aws_lambda_event_source_mapping" "kinesis_lambda_cons_lambda_event_trigger" {
  event_source_arn                   = aws_kinesis_stream.test_stream.arn
  function_name                      = aws_lambda_function.flatten_data.arn
  batch_size                         = 10
  maximum_batching_window_in_seconds = 60
  maximum_retry_attempts             = 5
  starting_position                  = "LATEST"
}
