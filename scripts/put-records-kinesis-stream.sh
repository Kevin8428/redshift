#!/bin/bash

filename='data/large_cap_daily.csv'
# filename='data/sample.txt'
echo publishing $filename to kinesis
while read p; do 
    aws kinesis put-record \
        --cli-binary-format raw-in-base64-out \
        --stream-name redshift \
        --data "$p" \
        --partition-key 1
done < "$filename"
