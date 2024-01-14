//Lambda function to put data to kinesis stream 
data "archive_file" "zip_put_record" {
type        = "zip"
source_file  = "${path.module}/../src/put_record.py"
output_path = "${path.module}/../src/put_record.zip"
}

//Lambda function to get data to normalize
data "archive_file" "zip_flatten" {
type        = "zip"
source_file  = "${path.module}/../src/flatten_data.py"
output_path = "${path.module}/../src/flatten_data.zip"
}

//Lambda function to get data to normalize
data "archive_file" "zip_put_data" {
type        = "zip"
source_file  = "${path.module}/../src/put_data_aws.py"
output_path = "${path.module}/../src/put_data_aws.zip"
}