data "archive_file" "zip_the_python_code" {
type        = "zip"
source_file  = "${path.module}/../src/lambda.py"
output_path = "${path.module}/../src/lambda.zip"
}

resource "aws_lambda_function" "count" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = "${path.module}/../src/lambda.zip"
  function_name = "count"
  role          =  aws_iam_role.lambda_role.arn
  handler       = "lambda.lambda_handler"
  runtime = "python3.9"
}