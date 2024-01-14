import sys
import os
import json
from urllib import response
import boto3
import pytest
import unittest
from moto import mock_kinesis, mock_s3, mock_firehose, mock_iam
import base64
from mock_data import *

sys.path.append('e:\\FAHCM.HCM22_FR_Data_01\\Project\\sprint 2')




@mock_kinesis
@mock_firehose
@mock_s3
@mock_iam
class Test_Lambda_Function(unittest.TestCase):
#TEST FILE PUT_RECORD.PY
    def test_1_get_data(self):
        print('\r\nTest lambda function get_data in file put_record.py...')
        from src.put_record import get_data
        response = json.loads(get_data()).get('cod')
        expected = 200
        self.assertEqual(response, expected)

    def test_2_put_data_kinesis(self):
        print('\r\nTest lambda function put_data_kinesis in file put_record.py...')
        pytest_kinesis = boto3.client('kinesis')
        stream_name = 'terraform-kinesis-test'
        pytest_kinesis.create_stream(
            StreamName = stream_name,
            ShardCount = 1,
            StreamModeDetails=
            {
                'StreamMode': 'PROVISIONED'
            }
        )
        from src.put_record import put_data_kinesis
        response = put_data_kinesis(pytest_kinesis, 'hello_world')
        self.assertEqual(response, pytest_kinesis)

#TEST FILE FLATTEN_DATA.PY
    def test_3_convert_data(self):
        print('\r\nTest lambda function convert_data in file flatten_data.py...')
        from src.flatten_data import convert_data
        response = convert_data(mock_event_input)
        expected = mock_json_data_output
        self.assertEqual(response, expected)

    def test_4_flatten_data(self):
        print('\r\nTest lambda function flatten_data in file flatten_data.py...')
        from src.flatten_data import flatten_data
        response = flatten_data(mock_event_input)
        expected = mock_byte_data_output
        self.assertEqual(response, expected)

    def test_5_put_data_kinesis_firehose(self):
        print('\r\nTest lambda function data_kinesis_firehose in file flatten_data.py...')
        pytest_iam = boto3.client('iam')
        pytest_s3 = boto3.client('s3')
        pytest_firehose = boto3.client('firehose')
        pytest_s3.create_bucket(Bucket="pytest_firehose_bucket")
        pytest_iam.create_role(
            RoleName="pytest_iam_role",
            AssumeRolePolicyDocument= mock_policy
        )
        pytest_firehose.create_delivery_stream(
            DeliveryStreamName='test_stream',
            S3DestinationConfiguration={
                'RoleARN': 'arn:aws:iam::000000000000:role/pytest_iam_role',
                'BucketARN': 'arn:aws:s3:::pytest_firehose_bucket',
                'CompressionFormat': 'UNCOMPRESSED',
            },
        )

        from src.flatten_data import put_data_kinesis_firehose
        response = put_data_kinesis_firehose(pytest_firehose, 'hello_world')
        expected = 200
        self.assertEqual(response['ResponseMetadata']['HTTPStatusCode'], expected)

#TEST FILE PUT_DATA_AWS.PY
    def test_6_get_data_localstack(self):
        print('\r\nTest lambda function get_data_localstack in file put_data_aws.py...')
        pytest_s3 = boto3.client('s3')
        pytest_s3.create_bucket(Bucket="kinesis-bucket")
        pytest_s3.put_object(Body='filetoupload', Bucket="kinesis-bucket", Key='flatten_byte_data')
        s3_resource = boto3.resource('s3')
        from src.put_data_aws import get_data_localstack
        response = get_data_localstack(s3_resource)
        expected = b'filetoupload'
        self.assertEqual(response, expected)

    def test_7_put_data_to_free_tier(self):
        print('\r\nTest lambda function put_data_to_free_tier in file put_data_aws.py...')
        pytest_s3 = boto3.client('s3')
        pytest_s3.create_bucket(Bucket="snowflake112358")
        from src.put_data_aws import put_data_to_free_tier
        response = put_data_to_free_tier(pytest_s3, 'hello_world')
        expected = 200
        self.assertEqual(response['ResponseMetadata']['HTTPStatusCode'], expected)

