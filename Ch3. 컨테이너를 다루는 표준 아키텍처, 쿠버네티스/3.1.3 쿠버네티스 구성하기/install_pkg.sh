#!/usr/bin/env bash

# 클러스터를 구성하기 위해서 가상 머신에 설치돼야 하는 의존성 패키지를 명시한 스크립트
# install packages
yum install epel-release -y # [-y] 옵션을 지정하면 설치중 y/n 선택 없이 all yes로 yum 업데이트가 가능
yum install vim-enhanced -y
yum install git -y

# install docker 및 구동
yum install docker -y && systemctl enable --now docker

# install kubernetes cluster
yum install kubectl-$1 kubelet-$1 kubeadm-$1 -y
systemctl enable --now kubelet #kubelet 등록 및 활성화

# git clone _Book_k8sInfra.git
if [ $2 = 'Main' ]; then
  git clone https://github.com/sysnet4admin/_Book_k8sInfra.git
  mv /home/vagrant/_Book_k8sInfra $HOME
  find $HOME/_Book_k8sInfra/ -regex ".*\.\(sh\)" -exec chmod 700 {} \;
fi