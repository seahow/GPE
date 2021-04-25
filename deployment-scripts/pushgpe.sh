#!/bin/bash

# NOTE:  You must create a profile called shared under ~/.aws
# arguments (all are optional):
#
# --a = AD Domain
#      [default: example.local]
#
# --b = NETBIOS for AD
#      [default: EXAMPLE]
#
# --y = AD Password
#      [default: Aws2020@]
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
# --x = CIDR BASE /24.  Choose from the following list for a base VPC CIDR block of that as a /24.  All subnets carved out will be /27s
#        192.168.10.0
#        192.168.11.0
#        192.168.12.0
#        192.168.13.0
#        10.1.10.0
#        10.1.11.0
#        10.1.12.0
#        10.1.13.0
#        172.17.10.0
#        172.17.11.0
#        172.17.12.0
#        172.17.13.0
#
#       [default: 192.168.10.0]
#
# ./pushgpe.sh --r us-west-2 --c "GPE v1.1a" --i g4dn.xlarge --t Central --k l0-testing-oregon --b centralsa-labs --p gpe --n LAB --o allow
# ./pushgpe.sh --r us-east-1 --c "GPE v1.1a" --i g4dn.xlarge --t Central --k l0-testing --b centralsa-labs --p gpe --n LAB --o allow --x 172.17.10.0
#
# multi-region harness:
# ./pushgpe.sh --r us-east-1 --c "GPE v1.1a" --i g4dn.xlarge --t Central --k l0-testing --b centralsa-labs --p gpe --n EAST --o allow --x 172.17.10.0 --a east1.byod --b EAST1 --y Aws2020@
# ./pushgpe.sh --r us-west-2 --c "GPE v1.1a" --i g4dn.xlarge --t Central --k l0-testing-oregon --b centralsa-labs --p gpe --n WEST --o allow --x 172.17.11.0 --a west2.byod --b WEST2 --y Aws2020@

FILEBASE="../"
S3BUCKET="centralsa-labs"
S3PREFIX="gpe"

# Set your defaults here

a=${a:-example.local}
b=${b:-EXAMPLE}
y=${y:-Password123}
r=${r:-us-east-1}
t=${t:-Eastern}
c=${c:-nocomment}
i=${i:-t3a.2xlarge}
k=${k:-l0-testing}
b=${b:-centralsa-labs}
p=${p:-gpe}
n=${n:-LAB}
o=${o:-suppress}
x=${x:-192.168.10.0}

while [ $# -gt 0 ]; do

     if [[ $1 == *"--"* ]]; then
          param="${1/--/}"
          declare $param="$2"
     fi

     shift
done

RANDNAME=$(openssl rand -hex 1 | tr [:lower:] [:upper:])
JSON=$(cat gpeparams.cf.json | sed "s/DOMAINDNSNAMEPLACEHOLDER/$a/g; s/DOMAINNETBIOSNAMEPLACEHOLDER/$b/g; s/DOMAINADMINPASSWORDPLACEHOLDER/$y/g; s/NAMESALTPLACEHOLDER/$RANDNAME/g; s/BASECIDRPLACEHOLDER/$x/g; s/S3BUCKETPLACEHOLDER/$b/g; s/KEYPAIRPLACEHOLDER/$k/g; s/S3PATHPLACEHOLDER/$p/g; s/INSTANCETYPEPLACEHOLDER/$i/g; s/INSTANCETYPEPLACEHOLDER/$t/g; s/TIMEZONEPLACEHOLDER/$t/g")

if [[ $o == "suppress" ]]; then
     aws cloudformation create-stack --capabilities "CAPABILITY_NAMED_IAM" "CAPABILITY_IAM" --tags Key="comment",Value="$c" --stack-name "$n-GPE-$RANDNAME" --cli-input-json "$JSON" --region $r --template-url https://s3.amazonaws.com/$S3BUCKET/$S3PREFIX/cloudformation/gpe.yaml --profile=shared >>./mylog.log
     echo "ENV-$n-$RANDNAME"
else
     aws cloudformation create-stack --capabilities "CAPABILITY_NAMED_IAM" "CAPABILITY_IAM" --tags Key="comment",Value="$c" --stack-name "$n-GPE-$RANDNAME" --cli-input-json "$JSON" --region $r --template-url https://s3.amazonaws.com/$S3BUCKET/$S3PREFIX/cloudformation/gpe.yaml --profile=shared
fi
