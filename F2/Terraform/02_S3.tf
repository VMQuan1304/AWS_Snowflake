resource "aws_s3_bucket" "bucketS3" {
  bucket = "kinesis-bucket"
  force_destroy = true
}


# S3 trigger put data aws lambda 
resource "aws_s3_bucket_notification" "Lambda_notification" {
  bucket = "${aws_s3_bucket.bucketS3.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.put_data_aws.arn}"
    events              = ["s3:ObjectCreated:*"]
  }

   depends_on = [
    aws_lambda_permission.allow_bucket_trigger_put_data_aws,
   ]
}



