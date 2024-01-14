# AWS_Snowflake

![flow] (image/flow.png)
### Feature 1

##### F1.1 Set up Local Machine Environment (31/03/2022 - 13/04/2022)

- Install Docker: hosting localstack(AWS)

- Install Python

- Install Terraform

**Output 1**: hosting localstack.

**Output 2**: Create Lambda function/dynamodb/s3/IAM/... by terraform, count number of row in csv file, write the result into dynamodb {"row": 3}.

##### F1.2

- Research Snowflake

- Mini project:

- Host an aws free tier account

- Integration Snowflake with AWS S3

- Pull data from s3 (optional dataset)

- Using task and stream to use SCD, Tranfomations

- Unload data to S3.

- Connect visualization tool (any  tool) to Snowflake or S3 to visualize

**Output**: runbook.MD

### Freature 2 and 3

##### F2.0:
1. Create a Rest API / finding a API with mock data to push to kinesis data stream.
- Create lambda function to fetch data from API (GET method)
- Create HTTP Post -> post data to api-gateway (POST method)
2. Create a lambda function to push to data to Kinesis Datastream

##### F2.1:
1. Parse events in Kinesis Data Stream
2. Parse event and normalize events into flatten  data object
3. Error handling

##### F2.2:
1. Create Firehose Delivery Stream (Buffer) to store flatten data as Parquet format S3 bucket - column stored - compressed
2. Create infra to push flatten data to Firehose Delivery Stream.
3. Create a table catalog

##### F3.0:
1. Transforming Data with Slowly Changing Dimension
2. Create a dimensional model with flatten data.
3. Store Fact to S3
4. Dim Data to DynamoDB (SCD1)
5. Dim Data to s3 from DynamoDb

##### F3.1:
1. Enriching Data with Data Processing method as Lambda Architect
2. Integrate data pipeline with new Data source (Dim Data)
3. Overwrite Dim data with new Data source



