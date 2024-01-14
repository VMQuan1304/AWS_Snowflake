import base64

mock_json_data_output = {
    'coord':{
        'lon':108.8,
        'lat':15.1167
    },
    'weather':[
        {
            'id':804,
            'main':'Clouds',
            'description':'overcast clouds',
            'icon':'04d'
        }
    ],
    'base':'stations',
    'main':{
        'temp':297.19,
        'feels_like':297.71,
        'temp_min':297.19,
        'temp_max':297.19,
        'pressure':1013,
        'humidity':79,
        'sea_level':1013,
        'grnd_level':1012
    },
    'visibility':10000,
    'wind':{
        'speed':3.89,
        'deg':326,
        'gust':6.6
        },
        'clouds':{
            'all':100
        },
        'dt':1651629980,
        'sys':{
            'country':'VN',
            'sunrise':1651616422,
            'sunset':1651662166
        },
        'timezone':25200,
        'id':1568770,
        'name':'Quang Ngai',
        'cod':200
}

mock_byte_data_output = b'{\n  "coord_lon": 108.8,\n  "coord_lat": 15.1167,\n  "weather_id": 804,\n  "weather_main": "Clouds",\n  "weather_description": "overcast clouds",\n  "weather_icon": "04d",\n  "base": "stations",\n  "main_temp": 297.19,\n  "main_feels_like": 297.71,\n  "main_temp_min": 297.19,\n  "main_temp_max": 297.19,\n  "main_pressure": 1013,\n  "main_humidity": 79,\n  "main_sea_level": 1013,\n  "main_grnd_level": 1012,\n  "visibility": 10000,\n  "wind_speed": 3.89,\n  "wind_deg": 326,\n  "wind_gust": 6.6,\n  "clouds_all": 100,\n  "dt": 1651629980,\n  "sys_country": "VN",\n  "sys_sunrise": 1651616422,\n  "sys_sunset": 1651662166,\n  "timezone": 25200,\n  "id": 1568770,\n  "name": "Quang Ngai",\n  "cod": 200\n}'

mock_data_input = b'{"coord":{"lon":108.8,"lat":15.1167},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"base":"stations","main":{"temp":297.19,"feels_like":297.71,"temp_min":297.19,"temp_max":297.19,"pressure":1013,"humidity":79,"sea_level":1013,"grnd_level":1012},"visibility":10000,"wind":{"speed":3.89,"deg":326,"gust":6.6},"clouds":{"all":100},"dt":1651629980,"sys":{"country":"VN","sunrise":1651616422,"sunset":1651662166},"timezone":25200,"id":1568770,"name":"Quang Ngai","cod":200}'
mock_event_input = base64.b64encode(mock_data_input)

mock_policy = """
{
    "Version"="2012-10-17"
    "Statement"=[
        {
            "Action"="sts:AssumeRole"
            "Effect"="Allow"
            "Principal"={
                "Service"="firehose.amazonaws.com"
            }
        }
    ]
}"""

mock_firehose_event = { 
    "Records": [ 
        { 
            "kinesis": 
            { 
                "kinesisSchemaVersion": "1.0", 
                "partitionKey": "PartitionKey1", 
                "sequenceNumber": "49590338271490256608559692538361571095921575989136588898", 
                "data": b'eyJjb29yZCI6eyJsb24iOjEwOC44LCJsYXQiOjE1LjExNjd9LCJ3ZWF0aGVyIjpbeyJpZCI6ODA0LCJtYWluIjoiQ2xvdWRzIiwiZGVzY3JpcHRpb24iOiJvdmVyY2FzdCBjbG91ZHMiLCJpY29uIjoiMDRkIn1dLCJiYXNlIjoic3RhdGlvbnMiLCJtYWluIjp7InRlbXAiOjI5Ny4xOSwiZmVlbHNfbGlrZSI6Mjk3LjcxLCJ0ZW1wX21pbiI6Mjk3LjE5LCJ0ZW1wX21heCI6Mjk3LjE5LCJwcmVzc3VyZSI6MTAxMywiaHVtaWRpdHkiOjc5LCJzZWFfbGV2ZWwiOjEwMTMsImdybmRfbGV2ZWwiOjEwMTJ9LCJ2aXNpYmlsaXR5IjoxMDAwMCwid2luZCI6eyJzcGVlZCI6My44OSwiZGVnIjozMjYsImd1c3QiOjYuNn0sImNsb3VkcyI6eyJhbGwiOjEwMH0sImR0IjoxNjUxNjI5OTgwLCJzeXMiOnsiY291bnRyeSI6IlZOIiwic3VucmlzZSI6MTY1MTYxNjQyMiwic3Vuc2V0IjoxNjUxNjYyMTY2fSwidGltZXpvbmUiOjI1MjAwLCJpZCI6MTU2ODc3MCwibmFtZSI6IlF1YW5nIE5nYWkiLCJjb2QiOjIwMH0=', 
                "approximateArrivalTimestamp": 1545084650.987 
            }, 
            "eventSource": "aws:kinesis", 
            "eventVersion": "1.0", 
            "eventID": "shardId-000000000006:49590338271490256608559692538361571095921575989136588898", 
            "eventName": "aws:kinesis:record", 
            "invokeIdentityArn": "arn:aws:iam::123456789012:role/lambda-role", 
            "awsRegion": "us-east-2", 
            "eventSourceARN": "arn:aws:kinesis:us-east-1:000000000000:stream/terraform-kinesis-test" 
        }
    ] 
}
