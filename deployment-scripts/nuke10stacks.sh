#!/bin/bash

#nuke o rama

# get a list of the UNIT stacks
USWEST2UNIT=$(aws cloudformation list-stacks --region=us-west-2 --profile=shared | grep "GPE" | grep "StackName")
USEAST1UNIT=$(aws cloudformation list-stacks --region=us-east-1 --profile=shared | grep "GPE" | grep "StackName")
USWEST2FORMATTED=$(echo $USWEST2UNIT | sed -e 's/"StackName": //g' | sed -e 's/"//g' | sed -e 's/,//g')
USEAST1FORMATTED=$(echo $USEAST1UNIT | sed -e 's/"StackName": //g' | sed -e 's/"//g' | sed -e 's/,//g')

for UNIT_STACK in $USWEST2FORMATTED; do
    aws cloudformation delete-stack --region=us-west-2 --profile=shared --stack-name=$UNIT_STACK
done

for UNIT_STACK in $USEAST1FORMATTED; do
    aws cloudformation delete-stack --region=us-east-1 --profile=shared --stack-name=$UNIT_STACK
done
