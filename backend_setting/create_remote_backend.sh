#!/bin/bash
aws s3 mb s3://sample-env-bucket-tf-backend --region ap-northeast-2
aws dynamodb create-table --table-name sample-env-dynamodb-tf-state-table \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region ap-northeast-2
