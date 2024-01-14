import json
import boto3

bucket = "uploadcsv"
key = "airports.csv"


def count_row(bucket,key):
    try:
        s3 = boto3.client('s3', endpoint_url="http://host.docker.internal:4566")
    except Exception as e:
        print("error1:",e)
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        data = response['Body'].read().splitlines()
        row_count = len(data)-1
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e
    return row_count


def put_item():
    row_count=count_row(bucket,key)
    try:
        dynamodb = boto3.client('dynamodb', endpoint_url="http://host.docker.internal:8000")
    except Exception as e:
        print("error2:",e)
    try:
        table=dynamodb.put_item(TableName='countcsv', Item={"rows": {"N": str(row_count)}})
        return "succeeded"
    except Exception as e:
        print(e)
        raise e



def lambda_handler(event=None, context=None):
    #print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    row_count = count_row(bucket,key)
    put_item()
    return {"rows": row_count}






    