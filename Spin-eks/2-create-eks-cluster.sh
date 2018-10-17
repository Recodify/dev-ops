#!/bin/bash

SPIN_MANAGING_INF=spin-managing-inf
SPIN_CLUSTER_NAME=spin-2
SPIN_NODES=spin-nodes
#KEY(pem) file name
KEY_NAME=recodify

aws cloudformation deploy --stack-name $SPIN_MANAGING_INF --template-file cf-create-eks-cluster.yaml --parameter-overrides UseAccessKeyForAuthentication=false EksClusterName=$SPIN_CLUSTER_NAME --capabilities CAPABILITY_NAMED_IAM

VPC_ID=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`VpcId`].OutputValue' --output text)
CONTROL_PLANE_SG=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`SecurityGroups`].OutputValue' --output text)
AUTH_ARN=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`AuthArn`].OutputValue' --output text)
SUBNETS=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`SubnetIds`].OutputValue' --output text)
MANAGING_ACCOUNT_ID=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`ManagingAccountId`].OutputValue' --output text)
EKS_CLUSTER_ENDPOINT=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`EksClusterEndpoint`].OutputValue' --output text)
EKS_CLUSTER_NAME=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`EksClusterName`].OutputValue' --output text)
EKS_CLUSTER_CA_DATA=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`EksClusterCA`].OutputValue' --output text)
SPINNAKER_INSTANCE_PROFILE_ARN=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_MANAGING_INF --query 'Stacks[0].Outputs[?OutputKey==`SpinnakerInstanceProfileArn`].OutputValue' --output text)

~/.local/bin/aws cloudformation deploy --stack-name $SPIN_NODES --template-file cf-amazon-eks-nodegroup.yaml --parameter-overrides KeyName=$KEY_NAME NodeInstanceType=t2.small ClusterName=$EKS_CLUSTER_NAME NodeGroupName=spinnaker-cluster-nodes ClusterControlPlaneSecurityGroup=$CONTROL_PLANE_SG Subnets=$SUBNETS VpcId=$VPC_ID NodeImageId=ami-0c7a4976cb6fafd3a --capabilities CAPABILITY_NAMED_IAM

NODE_INSTANCE_ROLE=$(~/.local/bin/aws cloudformation describe-stacks --stack-name $SPIN_NODES --query 'Stacks[0].Outputs[?OutputKey==`NodeInstanceRole`].OutputValue' --output text)

echo "VPCId:" $VPC_ID
echo "ControlPlaneSG": $CONTROL_PLANE_SG
echo "AuthARN": $AUTH_ARN
echo "ManagingAccountId": $MANAGING_ACCOUNT_ID
echo "EKSClusterEndPoint:" $EKS_CLUSTER_ENDPOINT
echo "EKSClusterName:" $EKS_CLUSTER_NAME
echo "EKSClusterCAName:" $EKS_CLUSTER_CA_DATA
echo "NodeInstanceRole:" $NODE_INSTANCE_ROLE

