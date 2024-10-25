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
    --sql "create table tickdata( Date timestamp without time zone, bid_level_1	real NULL, bid_level_2	real NULL, ask_level_1	real NULL, ask_level_2	real NULL, Volume	integer	NULL );" > /dev/null

sed -i "" "s/$ACCOUNT_ID/__ACCOUNT__ID/g" apps/redshift-copier/redshift-copier.py