#!/bin/bash -xe
source /home/ec2-user/.bash_profile
cd /home/ec2-user/app/release

# Query the EC2 metadata service for this instance's region
#REGION=`curl -s http://169.254.169.254/latest/dynamic/instanceidentity/
#document | jq .region -r`
#ugly workaround because ip call gets 401
LONG_REGION=$(ec2-metadata --availability-zone)
REGION="${LONG_REGION##*:}"

# Query the EC2 metadata service for this instance's instance-id
export INSTANCE_ID=`less /var/lib/cloud/data/instance-id`
# Query EC2 describeTags method and pull our the CFN Logical ID for this
instance
export STACK_NAME=`aws --region $REGION ec2 describe-tags \
	--filters "Name=resource-id,Values=${INSTANCE_ID}" \
				"Name=key,Values=aws:cloudformation:stack-name" \
	| jq -r ".Tags[0].Value"`

npm run start