
# CREATE A BUCKET NAME <UPLOADCSV> TO SAVE CSV FILE
resource "aws_s3_bucket" "uploadcsv" {
  bucket = "uploadcsv"
  force_destroy = true
}

#UPLOAD FILE <AIRPORT.CSV> TO BUCKET <UPLOADCSV>
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.uploadcsv.id
  key    = "airports.csv"
  source = "${path.module}/../src/data/airports.csv"
  etag = filemd5("${path.module}/../src/data/airports.csv")
}


resource "aws_s3_bucket_notification" "s3_trigger" {
  bucket = "${aws_s3_bucket.uploadcsv.id}"
  lambda_function {
    lambda_function_arn = "${aws_lambda_function.count.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".txt"
  }
}

