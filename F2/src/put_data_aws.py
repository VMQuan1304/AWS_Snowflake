import boto3
import json
import logging 
from botocore.exceptions import ClientError
import os

logger = logging.getLogger(__name__)


bucket_name_localstack = "kinesis-bucket"
bucket_name_aws = "snowflake112358"
region= 'us-east-1'
endpoint_url = "http://host.docker.internal:4566"
aws_access_key_id=os.getenv('aws_access_key_id')
aws_secret_access_key=os.getenv('aws_secret_access_key')
client = boto3.resource('s3', region_name = region, endpoint_url = endpoint_url)
s3_client = boto3.client('s3',
                    aws_access_key_id=aws_access_key_id, 
                    aws_secret_access_key=aws_secret_access_key ,
                    region_name=region
                    )

def get_data_localstack(client):
    try:
        bucket = client.Bucket(bucket_name_localstack)

        for obj in bucket.objects.all():
            data_localstack = obj.get()['Body'].read()
        
    except ClientError as err:
         logger.error('error', err.response['Error']['Code'])
    except UnboundLocalError as unbound:
         logger.error('error ', unbound.response['Error']['Code'])
    return data_localstack


def put_data_to_free_tier(s3_client, byte_data):
    object= s3_client.put_object(Body = byte_data ,Bucket = bucket_name_aws, Key = "weather_data_localstack.json")
    return object


def send_data_to_free_tie(event=None, context=None):
    #save data to a file
    byte_data = get_data_localstack(client)

    #put data to s3
    put_data_to_free_tier(s3_client, byte_data)
    return "succeed"


