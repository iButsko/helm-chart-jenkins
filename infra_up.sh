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

ssh-keygen -f ~/.ssh/id_rsa

kops create cluster \
--name="ivan.k8s.local" \
--state="s3://ibutsko" \
--master-count 3 \
--master-size="t3.medium" \
--node-count 4 \
--node-size="t3.medium" \
--zones "eu-central-1a,eu-central-1b" \
--cloud="aws" \
--networking cilium \
--topology=private \
--bastion=true
kops create secret --name ivan.k8s.local --state s3://ibutsko sshpublickey admin -i ~/.ssh/ivan.k8s.local.pub
#kops update cluster --name="ivan.k8s.local" --state="s3://ibutsko" --yes
kops export kubecfg --state s3://ibutsko --name ivan.k8s.local --admin
kops validate cluster --name ivan.k8s.local --state s3://ibutsko --wait 10m
