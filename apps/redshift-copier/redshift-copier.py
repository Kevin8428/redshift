import uuid
import time

import boto3

client = boto3.client('redshift-data')

def main(event, context):
    statement = str(uuid.uuid4())
    # print('event: ', event)
    # print('context: ', context)
    bucket = event.get('Records')[0].get('s3', '').get('bucket', '').get('name', '')
    key = event.get('Records')[0].get('s3', '').get('object', '').get('key', '')
    source = f's3://{bucket}/{key}'
    query = f'COPY redshift.public.tickdata FROM \'{source}\' IAM_ROLE \'arn:aws:iam::830370670734:role/redshift-redshift-cluster\' FORMAT AS CSV DELIMITER \',\' QUOTE \'"\' REGION AS \'us-west-2\''
    print('source location: ', source)
    print('query: ', query)
    response = client.execute_statement(
        ClusterIdentifier='redshift',
        Database='redshift',
        DbUser='someone',
        StatementName=statement,
        # Sql=f'COPY redshift.public.tickdata FROM \'{source}\' IAM_ROLE \'arn:aws:iam::830370670734:role/service-role/AmazonRedshift-CommandsAccessRole-20241024T114820\' FORMAT AS CSV DELIMITER \',\' QUOTE \'"\' REGION AS \'us-west-2\'',
        Sql=query,
    )
    print('response: ', response)
    # TODO: given this is async, not worried about large upload size
    # but, also need a process to monitor uploading. This is where step funciton
    # can come in - state one uploads, state 2 loops, checking status until done
    sid = response.get('Id')
    time.sleep(4)
    response = client.list_statements()
    print('list_statements: ', response)
    response = client.describe_statement(Id=sid)
    print('describe_statement: ', response)
