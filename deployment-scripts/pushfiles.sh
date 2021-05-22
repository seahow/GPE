#!/bin/bash

FILEBASE="../"
S3BUCKET="centralsa-labs"
S3PREFIX="gpe"

aws s3 sync $FILEBASE/bastion s3://$S3BUCKET/$S3PREFIX/bastion --profile=seahowmilitary
aws s3 sync $FILEBASE/cloudformation s3://$S3BUCKET/$S3PREFIX/cloudformation --profile=seahowmilitary
aws s3 sync $FILEBASE/deployment-scripts s3://$S3BUCKET/$S3PREFIX/deployment-scripts --profile=seahowmilitary
aws s3 sync $FILEBASE/powershell s3://$S3BUCKET/$S3PREFIX/powershell --profile=seahowmilitary
aws s3 sync $FILEBASE/diagrams s3://$S3BUCKET/$S3PREFIX/diagrams --profile=seahowmilitary
