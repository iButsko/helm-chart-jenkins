#!/bin/bash

ssh-keygen -f ~/.ssh/ivan.k8s.local

kops create secret --name ivan.k8s.local --state s3://ibutsko sshpublickey admin -i ~/.ssh/ivan.k8s.local.pub


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
kops update cluster --name="ivan.k8s.local" --state="s3://ibutsko" --yes
kops export kubecfg --state s3://ibutsko --name ivan.k8s.local --admin
#kops validate cluster --name ivan.k8s.local --state s3://ibutsko --wait 10m
