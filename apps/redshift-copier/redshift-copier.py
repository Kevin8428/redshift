"""
Copy from s3 to redshift. This is very rough and just for use as a POC.
"""

import uuid
import json
import time

import boto3

client = boto3.client('redshift-data')

def main(event, context):
    """
    Lambd Handler
    Args:
        event (dict): Event data containing records to be copied.
        context (LambdaContext): Runtime information of the Lambda function.
    Returns:
        dict: redshift-data response dict
    """
    bucket = event.get('Records')[0].get('s3', '').get('bucket', '').get('name', '')
    key = event.get('Records')[0].get('s3', '').get('object', '').get('key', '')
    source = f's3://{bucket}/{key}'
    query = f'COPY redshift.public.daily_price FROM \'{source}\' IAM_ROLE \'arn:aws:iam::__ACCOUNT__ID:role/redshift-redshift-cluster\' FORMAT AS CSV DELIMITER \',\' QUOTE \'"\' REGION AS \'us-west-2\' DATEFORMAT \'YYYY-MM-DD\''
    response = client.execute_statement(
        ClusterIdentifier='redshift',
        Database='redshift',
        DbUser='someone',
        StatementName=str(uuid.uuid4()),
        Sql=query,
    )
    print('response: ', response)
    sid = response.get('Id')
    time.sleep(4)
    response = client.list_statements()
    print('list_statements: ', response)
    response = client.describe_statement(Id=sid)
    print('describe_statement: ', response)
    return json.dumps(response, default=str)
