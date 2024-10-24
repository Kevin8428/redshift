import time
import uuid

import boto3

client = boto3.client('redshift-data')

def main(event, context):
    statement = str(uuid.uuid4())
    print('event: ', event)
    print('context: ', context)
    print('statement name: ', statement)
    response = client.execute_statement(
        ClusterIdentifier='redshift',
        Database='redshift',
        DbUser='someone',
        StatementName=statement,
        Sql='COPY redshift.public.tickdata FROM \'s3://redshift-e3j5sx/2024/10/\' IAM_ROLE \'arn:aws:iam::830370670734:role/service-role/AmazonRedshift-CommandsAccessRole-20241024T114820\' FORMAT AS CSV DELIMITER \',\' QUOTE \'"\' REGION AS \'us-west-2\'',
    )
    sid = response.get('Id')
    print('response: ', response)
    response = client.list_statements()
    print('list_statements: ', response)
    response = client.describe_statement(Id=sid)
    print('describe_statement: ', response)
