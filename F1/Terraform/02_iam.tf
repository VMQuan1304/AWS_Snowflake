# Creating a s3 stream role.
resource "aws_iam_role" "s3_role" {
 name = "s3_role"
 # Setting up the trust relationship.
 assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
            "Sid": "ReadCode",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "logs:DescribeLogGroups",
                "s3:GetObjectVersion"
            ],
            "Resource": ["arn:aws:s3:us-east-1:{var.accountId}:bucketS3/kinesis-bucket"]
        }
    ]
 })
}

#create lambda role
resource "aws_iam_role" "lambda_role" {
 name = "lambda_role"
 # Setting up the trust relationship.
 assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "arn:aws:lambda:us-east-1:{var.accountId}:count/*"
            ]
        }
    ]
 })
}

