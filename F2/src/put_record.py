import boto3
import json 
import urllib3
import logging 
from botocore.exceptions import ClientError


region= 'us-east-1'
endpoint_url = "http://host.docker.internal:4566"
name_stream = "terraform-kinesis-test"
kinesis_client=boto3.client("kinesis",endpoint_url = endpoint_url)

logger = logging.getLogger(__name__)


def get_data():
    BASE_URL = "https://api.openweathermap.org/data/2.5/weather?q={}&appid={}" 
    city = 'Quang Ngai'
    API_KEY = "96adb69d5ebd1cc4c3c919e60b2ddc01"
    # upadting the URL

    URL = BASE_URL.format(city, API_KEY)
    try:
    # checking the status code of the request
        http = urllib3.PoolManager()
        response = http.request('GET', URL)
        web_data = response.data
        data = json.loads(web_data)
        res = json.dumps(data, indent=2).encode('utf-8')
        return res
    except ConnectionError as connection:
        print("Cannot connection")




def put_data_kinesis(kinesis_client, data):
    try:
        kinesis_client.put_record(StreamName=name_stream, Data=data, PartitionKey="PartitionKey1")
        return kinesis_client
    except ClientError as err:
        if err.response['Error']['Code'] == 'ResourceNotFoundException':
            logger.info('stream does not exist.')
        else:
            logger.error('error', err.response['Error']['Code'])



def handler(event=None,context=None):
    # kinesis_client=call_kinesis()
    data = get_data()
    try:
        put_data_kinesis(kinesis_client, data)
        logger.info("Put record in stream",name_stream )
        return  "succeed"
    except ClientError:
         logger.exception("Couldn't put record in stream")

