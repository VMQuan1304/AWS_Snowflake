resource "aws_kinesis_stream" "test_stream" {
  name             = "terraform-kinesis-test"
  shard_count      = 1
  retention_period = 24


  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
  enforce_consumer_deletion = true
}

resource "aws_kinesis_firehose_delivery_stream" "S3_stream" {
  name        = "test_stream"
  destination = "s3"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_flattendata_role.arn
    bucket_arn         = aws_s3_bucket.bucketS3.arn
    buffer_size        = 10
    buffer_interval    = 400
    prefix             = "weather_data_localstack" 

  }
}

