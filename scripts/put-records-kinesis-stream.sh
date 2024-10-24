#!/bin/bash

# aws kinesis put-record --stream-name my-stream-name --data 'Data=jose|12' --partition-key `uuidgen`

# # data="one new message here published at - $(date)"
# # data="{\"LayerName\": \"${LAYER}\",\"Description\": \"Ta…"
# data="{\"event\":\"cli_invoked_event\",\"value\":\"some-val\", \"ts\":\"something\"}"
# data=some-record
# aws kinesis put-record \
#     --cli-binary-format raw-in-base64-out \
#     --stream-name redshift \
#     --data $data \
#     --partition-key 1

# filename='tickdata/spy_first_rate_datacom.txt'
filename='tickdata/sample.txt'
echo reading file
while read p; do 
    aws kinesis put-record \
        --cli-binary-format raw-in-base64-out \
        --stream-name redshift \
        --data "$p" \
        --partition-key 1
done < "$filename"
