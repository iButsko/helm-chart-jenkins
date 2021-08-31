#!/bin/bash
apt update -y && apt upgrade -y
apt install curl -y
apt install wget -y 
apt install gnupg2 -y
apt install golang -y
apt install unzip -y
apt install git -y

curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
unzip awscliv2.zip
./aws/install
aws --version
echo Installation Completed

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl --version

curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d  -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
mv kops-linux-amd64 /usr/local/bin/kops
kops version

kops export kubecfg --state s3://ibutsko --name ivan.k8s.local --admin

git clone https://github.com/mozilla/sops.git
wget https://github.com/mozilla/sops/releases/download/v3.7.1/sops_3.7.1_amd64.deb
dpkg -i sops_3.7.1_amd64.deb

gpg --import sops/pgp/sops_functional_tests_key.asc

sops -d -i helms/db/values.yaml
sops -d -i helms/web/values.yaml
sops -d -i helms/words/values.yaml

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

curl -sL https://istio.io/downloadIstioctl | sh -
chmod 777 istio-1.11.1
cd istio-1.11.1
chmod 700 bin
export PATH=$PATH:$HOME/.istioctl/bin"
kubectl get ns
istioctl install -y
kubectl get ns
kubectl label namespace default istio-injection=enabled
cd -

curl -sL https://istio.io/downloadIstio | sh -
cd istio-1.11.1
export PATH=$PWD/bin:$PATH
kubectl get ns
istioctl install -y
kubectl get ns
kubectl label namespace default istio-injection=enabled
cd -

helm install db helms/db/
helm install web helms/web/
helm install words helms/words/

kubectl get pod
