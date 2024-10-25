#!/bin/bash

# data="{\"event\":\"cli_invoked_event\",\"value\":\"some-val\", \"ts\":\"something\"}"
filename='tickdata/sample.txt'
echo reading file
while read p; do 
    aws kinesis put-record \
        --cli-binary-format raw-in-base64-out \
        --stream-name redshift \
        --data "$p" \
        --partition-key 1
done < "$filename"
