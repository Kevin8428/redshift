"""
Copy from s3 to redshift. This is very rough and just for use as a POC.
"""

import uuid
import json

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
    query = f'COPY redshift.public.tickdata FROM \'{source}\' IAM_ROLE \'arn:aws:iam::__ACCOUNT__ID:role/redshift-redshift-cluster\' FORMAT AS CSV DELIMITER \',\' QUOTE \'"\' REGION AS \'us-west-2\''
    response = client.execute_statement(
        ClusterIdentifier='redshift',
        Database='redshift',
        DbUser='someone',
        StatementName=str(uuid.uuid4()),
        Sql=query,
    )
    print('response: ', response)
    return json.dumps(response, default=str)
