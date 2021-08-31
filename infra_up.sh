#!/bin/bash

#apt-get update
#apt-get install curl -y
#apt-get install unzip -y
#apt-get install openssh-client -y

#curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
#chmod +x ./kubectl
#sudo mv ./kubectl /usr/local/bin/kubectl

#curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
#unzip awscliv2.zip
#./aws/install
#aws --version

#curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
#chmod +x kops-linux-amd64
#sudo mv kops-linux-amd64 /usr/local/bin/kops
#kops version
export KOPS_STATE_STORE=s3://ibutsko
export NAME_CLUSTER="ivan.k8s.local" 
export MASTER_INSTANCE_TYPE="t3.medium"
export NODE_INSTANCE_TYPE="t3.medium"
export NODE_COUNT=3
export MASTER_COUNT=3
ssh-keygen -f ~/.ssh/id_rsa

#kops create secret --name $NAME_CLUSTER sshpublickey admin -i ~/.ssh/id_rsa.pub

kops create cluster \
--zones "eu-central-1a,eu-central-1b,eu-central-1c" \
--master-size $MASTER_INSTANCE_TYPE \
--master-count $MASTER_COUNT \
--node-size $NODE_INSTANCE_TYPE \
--node-count $NODE_COUNT \
--networking cilium \
--topology private \
--bastion \
--name=$NAME_CLUSTER \
--yes \

echo "Creating  a secret for using bastion..."
kops create secret --name $NAME_CLUSTER sshpublickey admin -i ~/.ssh/id_rsa.pub

echo "Export kubeconfig file for validate command..."
#kops export kubecfg --admin
kops export kubecfg $NAME_CLUSTER --admin

echo "Validate cluster..."
kops validate cluster --name $NAME_CLUSTER --wait 20m
#kops update cluster --name="ivan.k8s.local" --state="s3://ibutsko" --yes
#kops export kubecfg --state s3://ibutsko --name ivan.k8s.local --admin
#kops validate cluster --name ivan.k8s.local --state s3://ibutsko --wait 10m
