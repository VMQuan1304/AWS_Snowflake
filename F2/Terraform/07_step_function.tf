
resource "aws_sfn_state_machine" "stateMachine" {
  name     = "stateMachine"
  role_arn = aws_iam_role.step_function_role.arn

  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "put_record_to_kinesis",
  "States": {
    "put_record_to_kinesis": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.push_data.arn}",
      "Catch": [
        {
          "ErrorEquals": ["States.TaskFailed"],
          "Next": "ReservedTypeFallback1"
        }
      ],
      "Next": "flatten_data_from_firehose"
    },
    "flatten_data_from_firehose": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.flatten_data.arn}",
      "Catch": [
        {
          "ErrorEquals": ["States.TaskFailed"],
          "Next": "ReservedTypeFallback2"
        }
      ],
      "Next": "put_data_to_free_tier"
    },
    "put_data_to_free_tier": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.put_data_aws.arn}",
      "Catch": [
        {
          "ErrorEquals": ["States.TaskFailed"],
          "Next": "ReservedTypeFallback3"
        }
      ],
      "End": true
    },
     "ReservedTypeFallback1": {
         "Type": "Pass",
         "Result": "This is a fallback from a reserved error code in lambda1",
         "End": true
      },
      "ReservedTypeFallback2": {
         "Type": "Pass",
         "Result": "This is a fallback from a reserved error code in lambda2",
         "End": true
      },
      "ReservedTypeFallback3": {
         "Type": "Pass",
         "Result": "This is a fallback from a reserved error code in lambda3",
         "End": true
      } 
  }
}

EOF
}
