#!/bin/bash

aws redshift modify-cluster-iam-roles \
    --cluster-identifier redshift \
    --add-iam-roles arn:aws:iam::830370670734:role/redshift-redshift-cluster