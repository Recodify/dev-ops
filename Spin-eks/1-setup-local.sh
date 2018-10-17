
#!/bin/bash

## INSTALL TOOLS

sudo apt-get update
apt install curl
apt install python-pip

## INSTALL AWS CLI
pip install awscli --upgrade --user

export PATH=~/.local/bin:$PATH
echo 'export PATH=~/.local/bin:$PATH' >> ~/.bashrc

AWS_COMPLETER=$(which aws_completer)
complete -C $AWS_COMPLETER aws
echo 'complete -C $AWS_COMPLETER aws' >> ~/.bashrc

## INSTALL Kubectl
snap install kubectl --classic

# Load the kubectl completion code for bash into the current shell
source <(kubectl completion bash)
# Write bash completion code to a file and source if from .bash_profile
kubectl completion bash > ~/.kube/completion.bash.inc
printf "# Kubectl shell completion source '$HOME/.kube/completion.bash.inc'" >> $HOME/.bash_profile
source $HOME/.bash_profile



## INSTALL IAM Authenticator
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator

if [ ! -d ~/bin ]; then
   mkdir bin
fi

cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH

export PATH=~/bin:$PATH
echo 'export PATH=~/bin:$PATH' >> ~/.bashrc


