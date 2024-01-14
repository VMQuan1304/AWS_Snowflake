resource "aws_iam_role" "kinesis_producer_role" {
  name = "kinesis_producer_role"
  description = "put data into kinesis"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_policy" "lambda_kinesis_stream" {
  name = "lambda_kinesis_stream"
  description = "Lamda to put data into kinesis"

  policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:PutRecord",
        "kinesis:PutRecords",
        "kinesis:ListShards",
        "kinesis:DescribeStreamSummary"
      ],
      "Resource": [
        "arn:aws:kinesis:::test_stream/terraform-kinesis-test"
      ]
    },
    {
      "Effect":"Allow",
      "Action":["cloudwatch:GetMetricData"],
      "Resource":"*"
    }
  ]
}   
)
}

resource "aws_iam_role_policy_attachment" "attach_producer_attachment_to_role" {
  role       = aws_iam_role.kinesis_producer_role.name
  policy_arn = aws_iam_policy.lambda_kinesis_stream.arn
}




# iam for lambda accessing firehose
resource "aws_iam_role" "lambda_kinesis_firehose_role" {
  name = "lambda_kinesis_firehose_role"
  description = "put data into kinesis"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_kinesis_firehose_policy" {
  name        = "lambda_kinesis_firehose_policy"
  description = "IAM policy for tranform data in kinesis firehose"

  policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": ""
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetRecords",
        "kinesis:GetShardIterator",
        "kinesis:DescribeStreamSummary",
        "kinesis:ListStreams"
      ],
      "Resource": "arn:aws:kinesis:::test_stream/terraform-kinesis-test",
      "Effect": "Allow"
    },
    {
      "Action": [
        "firehose:DeleteDeliveryStream",
        "firehose:PutRecord",
        "firehose:PutRecordBatch",
        "firehose:UpdateDestination"
      ]
      "Effect": "Allow",
      "Sid": "",
      "Resource":["arn:aws:firehose:::S3_stream/test_stream"]
    }
  ]
}
)
}

resource "aws_iam_role_policy_attachment" "attach_firehose_to_s3_role" {
  role       = aws_iam_role.lambda_kinesis_firehose_role.name
  policy_arn = aws_iam_policy.lambda_kinesis_firehose_policy.arn
}


#iam for lambda putting record to free tier
resource "aws_iam_role" "lambda_putdata_aws_role" {
  name = "lambda_putdata_aws_role"
  description = "put data into kinesis"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_policy" "lambda_putdata_aws_policy" {
  name        = "lambda_putdata_aws_policy"
  description = "IAM policy for put data to aws free tie"

  policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::bucketS3/kinesis-bucket",
        "arn:aws:s3:::snowflake112358/*"
      ]
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "attach_lambda_to_putdata_role" {
  role       = aws_iam_role.lambda_putdata_aws_role.name
  policy_arn = aws_iam_policy.lambda_putdata_aws_policy.arn
}

# iam for firehose put data to s3
resource "aws_iam_role" "firehose_flattendata_role" {
  name = "firehose_flattendata_role"
  description = "put data into kinesis"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "firehose_flattendata_policy" {
  name        = "firehose_flattendata_policy"
  description = "IAM policy for put data to aws free tie"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::bucketS3/kinesis-bucket"
      ]
    }
  ]
  }
)
}

resource "aws_iam_role_policy_attachment" "attach_firehose_flattendata_role" {
  role       = aws_iam_role.firehose_flattendata_role.name
  policy_arn = aws_iam_policy.firehose_flattendata_policy.arn
}

#iam role for step function
resource "aws_iam_role" "step_function_role" {
  name = "step_function_role"
  description = "step function error handling"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "states.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_policy" "step_function_policy" {
  name = "step_function_policy"
  description = "Create role for step function error handling"
  policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": ""
      "Effect": "Allow",
      "Action": [
          "states:StartExecution"
      ],
      "Resource": "arn:aws:states:::state_machine/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "states:DescribeExecution",
        "states:DescribeStateMachineForExecution",
        "states:GetExecutionHistory",
        "states:StopExecution"
      ],
      "Resource":"arn:aws:states:::execution/*"
    },
    {
        "Action": [
          "lambda:InvokeFunction"
        ],
        "Effect": "Allow",
        "Resource": [
              "${aws_lambda_function.push_data.arn}",
              "${aws_lambda_function.flatten_data.arn}",
              "${aws_lambda_function.put_data_aws.arn}"
                    ]
      },
      {
      "Effect": "Allow",
      "Action": [
        "states:DescribeStateMachine",
        "states:StartExecution",
        "states:DeleteStateMachine",
        "states:ListExecutions",
        "states:UpdateStateMachine"
      ],
      "Resource": [ 
        "arn:aws:states:*:*:stateMachine:state_machine/*" 
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "states:DescribeActivity",
        "states:DeleteActivity",
        "states:GetActivityTask",
        "states:SendTaskSuccess",
        "states:SendTaskFailure",
        "states:SendTaskHeartbeat"
      ],
      "Resource": [
        "arn:aws:states:*:*:activity:*"
      ]
    }
  ]
} 
)
}

resource "aws_iam_role_policy_attachment" "attach_step_function_role" {
  role       = aws_iam_role.step_function_role.name
  policy_arn = aws_iam_policy.step_function_policy.arn
}


#Create role for s3 trigger lambda 
#iam role for step function
resource "aws_iam_role" "S3_trigger_lambda_role" {
  name = "S3_trigger_lambda_role"
  description = "s3 to trigger lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "s3.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_policy" "S3_trigger_lambda_policy" {
  name        = "S3_trigger_lambda_policy"
  description = "IAM policy for S3 trigger lambda put data to free tie"

  policy = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "lambda-allow-s3-my-function",
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject"
      ],
        "Action": "lambda:InvokeFunction",
        "Resource":  "${aws_lambda_function.put_data_aws.arn}",
        }
     ]
})
}

resource "aws_iam_role_policy_attachment" "attach_s3_trigger_role" {
  role       = aws_iam_role.S3_trigger_lambda_role.name
  policy_arn = aws_iam_policy.S3_trigger_lambda_policy.arn
}
