I. S3 CLI CONTROLLER 

1. Assign awsls
   function awsls {aws --endpoint-url=http://localhost:4566 $args}


2. List S3 bucket
   awsls s3 ls

3. Delete S3 bucket
   awsls s3api delete-bucket --bucket <bucket-name> --region us-east-1
   awsls s3api delete-bucket --bucket uploadcsv --region us-east-1

4. List uploaded object in S3
   awsls s3api list-objects --bucket <bucket-name>
   awsls s3api list-objects --bucket uploadcsv

5. Delete file in bucket
   awsls s3 rm s3://<bucket-name>/<file-in-bucket-name>
   awsls s3 rm s3://uploadcsv/airports_copy.csv

II. DYNAMODB CLI CONTROLLER 

1. Test table name
    awsls dynamodb describe-table --table-name <table-name>
    awsls dynamodb describe-table --table-name countcsv

III. LAMBDA FUNCTION 
1. aws lambda invoke --function-name count --cli-binary-format raw-in-base64-out --region us-east-1 --endpoint-url=http://localhost:4566 response.txt
2. Terrform import 
terraform import aws_s3_bucket_notification.trigger uploadcsv

3. DynamoDb UI
docker run -p 8000:8000 -it --rm instructure/dynamo-local-admin

http://localhost:8000/

ref: https://github.com/instructure/dynamo-local-admin-docker

# Snowflake 
- Snowflake Inc. is a cloud computing–based data warehousing company based in Bozeman, Montana. The firm offers a cloud-based data storage and analytics service, generally termed "data warehouse-as-a-service".
- Snowflake’s Data Cloud is powered by an advanced data platform provided as Software-as-a-Service (SaaS). Snowflake enables data storage, processing, and analytic solutions that are faster, easier to use, and far more flexible than traditional offerings.
- Snowflake combines a completely new SQL query engine with an innovative architecture natively designed for the cloud. 