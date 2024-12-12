## Infrastructure Information

- Single Region Setting (Architecture)

  ※ draw.io 파일 추가하기

## Terraform install

- terraform repository 등록

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

- terraform 설치

```bash
sudo apt update
sudo apt-get install terraform
terraform -install-autocomplete
```

- terraform alias 등록

```bash
echo "alias tf='terraform'" >> ~/.bashrc
echo "alias tfp='terraform plan'" >> ~/.bashrc
echo "alias tfi='terraform init'" >> ~/.bashrc
echo "alias tfa='terraform apply'" >> ~/.bashrc
echo "alias tfaa='terraform apply --auto-approve'" >> ~/.bashrc
source ~/.bashrc
```

## EKS TOOLS INSTALL

- kubectl install

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mkdir -p $HOME/bin && mv ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --client
```

<!-- - eksctl install

```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
``` -->

- helm install

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh 
helm version
```

## EKS SETTING

- eks kubeconfig update

```bash
aws eks update-kubeconfig --name sample-env-eks-cluster --region ap-northeast-2
```

- core dns 생성 과정에 pending 현상 발생 시 다음 명령어 실행

```bash
# https://hazel-developer.tistory.com/278 (참고내용)
kubectl rollout restart -n kube-system deployment coredns
```
