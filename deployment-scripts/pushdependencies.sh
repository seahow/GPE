#!/bin/bash

# NOTE:  You must create a profile called shared under ~/.aws
# arguments (all are optional):
#
# --r = AWS Region
#      [default: us-east-1]
#
# --t = Timezone
#      [default: Eastern]
#
# --c = Comment
#      [default: nocomment]
#
# --i = Instance type for bastion host
#      [default: t3a.large]
#
# --k = keypair
#
# --b = s3 bucket
#
# --p = s3 prefix
#
# --n = name/alias of whose environment this is
#
# --o = output - either suppress or allow
#      [default: suppress]
#
# --d = database instance name (NOTE: THIS IS MANDATORY AND MUST BE UNIQUE IN YOUR ACCT)
#
# --s = database storage size in GB.  Default = 100GB
#
# --x = CIDR BASE /24.  Choose 192.168.10.0 or 172.17.10.0 for a base VPC CIDR block of that as a /24.  All subnets carved out will be /27s
#       [default: 192.168.10.0/24]
#
# ./pushdependencies.sh --r us-west-2 --c "GPE v1.0" --i g4dn.xlarge --t Central --k l0-testing-oregon --b centralsa-labs --p gpe --n LAB --o allow --s 300
# ./pushdependencies.sh --r us-east-1 --c "GPE v1.0" --i g4dn.xlarge --t Central --k l0-testing --b centralsa-labs --p gpe --n LAB --o allow --s 250 --x 172.17.10.0

FILEBASE="../"
S3BUCKET="centralsa-labs"
S3PREFIX="gpe"

# Set your defaults here

r=${r:-us-east-1}
t=${t:-Eastern}
c=${c:-nocomment}
i=${i:-t3a.2xlarge}
k=${k:-l0-testing}
b=${b:-centralsa-labs}
p=${p:-gpe}
n=${n:-LAB}
o=${o:-suppress}
u=${u:-dbadmin}
s=${s:-100}
x=${x:-192.168.10.0}

while [ $# -gt 0 ]; do

     if [[ $1 == *"--"* ]]; then
          param="${1/--/}"
          declare $param="$2"
     fi

     shift
done

RANDNAME=$(openssl rand -hex 1 | tr [:lower:] [:upper:])
JSON=$(cat dependenciesparams.cf.json | sed "s/NAMESALTPLACEHOLDER/$RANDNAME/g; s/BASECIDRPLACEHOLDER/$x/g; s/S3BUCKETPLACEHOLDER/$b/g; s/KEYPAIRPLACEHOLDER/$k/g; s/S3PATHPLACEHOLDER/$p/g; s/INSTANCETYPEPLACEHOLDER/$i/g; s/INSTANCETYPEPLACEHOLDER/$t/g; s/TIMEZONEPLACEHOLDER/$t/g; s/DBINSTANCECLASSPLACEHOLDER/db.r5b.xlarge/g; s/DBPASSWORDPLACEHOLDER/Aws2020@/g; s/DBUSERPLACEHOLDER/$u/g; s/DBSTORAGEPLACEHOLDER/$s/g")

if [[ $o == "suppress" ]]; then
     aws cloudformation create-stack --capabilities "CAPABILITY_NAMED_IAM" "CAPABILITY_IAM" --tags Key="comment",Value="$c" --stack-name "$n-GPE-$RANDNAME" --cli-input-json "$JSON" --region $r --template-url https://s3.amazonaws.com/$S3BUCKET/$S3PREFIX/cloudformation/dependencies.yaml --profile=shared >>./mylog.log
     echo "ENV-$n-$RANDNAME"
else
     aws cloudformation create-stack --capabilities "CAPABILITY_NAMED_IAM" "CAPABILITY_IAM" --tags Key="comment",Value="$c" --stack-name "$n-GPE-$RANDNAME" --cli-input-json "$JSON" --region $r --template-url https://s3.amazonaws.com/$S3BUCKET/$S3PREFIX/cloudformation/dependencies.yaml --profile=shared
fi
