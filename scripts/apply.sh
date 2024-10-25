#!/bin/bash

ACCOUNT=$1
DEFAULT_ACCOUNT=$(cat ACCOUNT)
ACCOUNT_ID=${ACCOUNT:-$DEFAULT_ACCOUNT}

if [ -z "$ACCOUNT_ID" ]
then
    echo "ACCOUNT_ID is required"
    exit 1
fi

sed -i "" "s/__ACCOUNT__ID/$ACCOUNT_ID/g" apps/redshift-copier/redshift-copier.py

( cd terraform ; terraform init; terraform apply )

aws redshift modify-cluster-iam-roles \
    --cluster-identifier redshift \
    --add-iam-roles arn:aws:iam::$ACCOUNT_ID:role/redshift-redshift-cluster > /dev/null

aws redshift-data execute-statement \
    --cluster-identifier redshift \
    --database redshift \
    --db-user someone \
    --sql "create table daily_price( Symbol VARCHAR, Date DATE, close_ real NULL, Volume	integer	NULL, open_ real NULL, high real NULL, low real NULL );" > /dev/null

sed -i "" "s/$ACCOUNT_ID/__ACCOUNT__ID/g" apps/redshift-copier/redshift-copier.py