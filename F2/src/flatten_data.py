# check data in kinesis stream 
import boto3
import os
import json
import logging 
from botocore.exceptions import ClientError
import base64


logger = logging.getLogger(__name__)


region= 'us-east-1'
endpoint_url = "http://host.docker.internal:4566"
name_stream = "terraform-kinesis-test"
client = boto3.client('firehose', region_name = region, endpoint_url = endpoint_url)

def convert_data(byte_data):

    try:
        str_data=base64.b64decode(byte_data)
        data_json_format = json.loads(str_data)

        print(type(data_json_format))
    except SyntaxError as syntax:
        logging.exception(syntax)
    return data_json_format



def flatten_data(byte_data):
    json_data= convert_data(byte_data)
    output={}

    #function to flatten data
    def flatten(x, name=''):
        if type(x) is dict:
            for a in x:
                flatten(x[a], name + a + '_')
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name)
        else:
            output[name[:-1]]=x
    
    flatten(json_data)
    return json.dumps(output,indent = 2).encode('utf-8')


def put_data_kinesis_firehose(client, payload):

    try:
        response = client.put_record(
            DeliveryStreamName='test_stream',
            Record={
                'Data': payload
            }
        )
        return response
    except ClientError as err:
        if err.response['Error']['Code'] == 'ResourceNotFoundException':
            logger.info('stream does not exist.')
        else:
            logger.error('error', err.response['Error']['Code'])



def handler(event, context):
  
    logger.info(event, context)

    try:
        if event['Records']:
            records = event.get("Records")
            if records[0]['eventSourceARN'] == \
                'arn:aws:kinesis:us-east-1:000000000000:stream/terraform-kinesis-test'\
                    and records[0]['kinesis']['partitionKey'] == 'PartitionKey1':
                payload = flatten_data(records[0]["kinesis"]["data"])
                

                response=put_data_kinesis_firehose(client, payload)
                return {
                    'StatusCode': 200,
                    'body': 'Successfully',
                    "response": response
                }
        return {
            'StatusCode': 405,
            'body': 'Error',
        }
    except (TypeError, NameError) as err:
        return {
            'StatusCode': 404,
            'body': err,
        }



