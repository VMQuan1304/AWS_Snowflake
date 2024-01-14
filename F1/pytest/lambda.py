import json
import boto3

print('Loading function')

s3 = boto3.client('s3', endpoint_url="http://host.docker.internal:4566")

dynamodb = boto3.client('dynamodb', endpoint_url="http://host.docker.internal:8000")

def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = "uploadcsv"
    key = "airports.csv"
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        data = response['Body'].read().splitlines()
        row_count=len(data)-1
        dynamodb.put_item(TableName='countcsv', Item={"rows": {"N": str(row_count)}})
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e
    return {"rows": row_count}
