#!/bin/bash

FILEBASE="../"
S3BUCKET="centralsa-labs"
S3PREFIX="gpe"

aws s3 sync $FILEBASE/bastion s3://$S3BUCKET/$S3PREFIX/bastion --profile shared
aws s3 sync $FILEBASE/cloudformation s3://$S3BUCKET/$S3PREFIX/cloudformation --profile shared
aws s3 sync $FILEBASE/deployment-scripts s3://$S3BUCKET/$S3PREFIX/deployment-scripts --profile shared
aws s3 sync $FILEBASE/powershell s3://$S3BUCKET/$S3PREFIX/powershell --profile shared
