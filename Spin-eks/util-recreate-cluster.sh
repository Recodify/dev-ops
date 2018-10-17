#!/bin/bash

SPIN_MANAGING_INF=spin-managing-inf
SPIN_CLUSTER_NAME=spin-2
#KEY(pem) file name
KEY_NAME=recodify

curl -O https://d3079gxvs8ayeg.cloudfront.net/templates/managing.yaml
aws cloudformation deploy --stack-name $SPIN_MANAGING_INF --template-file managing.yaml --parameter-overrides UseAccessKeyForAuthentication=false EksClusterName=$SPIN_CLUSTER_NAME --capabilities CAPABILITY_NAMED_IAM

VPC_ID=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`VpcId`].OutputValue' --output text)
CONTROL_PLANE_SG=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`SecurityGroups`].OutputValue' --output text)
AUTH_ARN=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`AuthArn`].OutputValue' --output text)
SUBNETS=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`SubnetIds`].OutputValue' --output text)
MANAGING_ACCOUNT_ID=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`ManagingAccountId`].OutputValue' --output text)
EKS_CLUSTER_ENDPOINT=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`EksClusterEndpoint`].OutputValue' --output text)
EKS_CLUSTER_NAME=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`EksClusterName`].OutputValue' --output text)
EKS_CLUSTER_CA_DATA=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`EksClusterCA`].OutputValue' --output text)
SPINNAKER_INSTANCE_PROFILE_ARN=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`SpinnakerInstanceProfileArn`].OutputValue' --output text)

aws eks update-kubeconfig --name $SPIN_CLUSTER_NAME

echo "VPCId:" $VPC_ID
echo "ControlPlaneSG": $CONTROL_PLANE_SG
echo "AuthARN": $AUTH_ARN
echo "ManagingAccountId": $MANAGING_ACCOUNT_ID
echo "EKSClusterEndPoint:" $EKS_CLUSTER_ENDPOINT
echo "EKSClusterName:" $EKS_CLUSTER_NAME
echo "EKSClusterCAName:" $EKS_CLUSTER_CA_DATA
echo "NodeInstanceRole:" $NODE_INSTANCE_ROLE

