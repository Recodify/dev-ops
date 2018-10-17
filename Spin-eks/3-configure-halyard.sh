#!/bin/bash

# Get from AWS console
AWS_ACCOUNT_ID=
AWS_KEY_ID=

#Can be anything unique
AWS_ACCOUNT_NAME=recodify
ECS_ACCOUNT_NAME=recodify-ecs
USER_NAME=kubernetes-master


## INSTALL Halyard
curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh
sudo bash InstallHalyard.sh
export PATH=/usr/share:$PATH
echo 'PATH=/usr/share:$PATH' >> ~/.bashrc

# Configure Halyard kube provider
hal config provider kubernetes enable
hal config provider kubernetes account add $USER_NAME --provider-version v2 --context $(kubectl config current-context)
hal config features edit --artifacts true

# Configure Halyard aws provider
hal config provider aws account add ${AWS_ACCOUNT_NAME} --account-id ${AWS_ACCOUNT_ID} --assume-role role/spinnakerManaged
hal config provider aws enable

# Configure Halyard ecs provider
hal config provider ecs account add ${ECS_ACCOUNT_NAME} --aws-account ${AWS_ACCOUNT_NAME}
hal config provider ecs enable

# Configure Halyard to use s3 storage
hal config storage s3 edit \
    --access-key-id ${AWS_KEY_ID} \
    --secret-access-key \
    --region us-west-2

hal config storage edit --type s3

# Configure Halyard to deploy via kube
hal config deploy edit --type distributed --account-name kubernetes-master

# Set Version
hal config version edit --version 1.9.5

