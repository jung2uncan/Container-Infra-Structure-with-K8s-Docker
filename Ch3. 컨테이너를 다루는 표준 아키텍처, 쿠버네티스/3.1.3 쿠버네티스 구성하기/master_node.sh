#!/usr/bin/env bash

# 쿠버네티스 클러스터를 구성할 때 꼭 선택해야하는 컨테이너 네트워크 인터페이스(CNI, Container Network Interface)도 함께 구성하는 스크립트
# init kubernetes
kubeadm init --token 123456.1234567890123456 --token-ttl 0 \
--pod-network-cidr=172.16.0.0/16 --apiserver-advertise-address=192.168.1.10

# config for master node only
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config #-i 옵션은 복사한 대상이 이미 있으면 사용자에게 확인을 요청
chown $(id -u):$(id -g) $HOME/.kube/config

# config for kubernetes's network
kubectl apply -f \
https://raw.githubusercontent.com/sysnet4admin/IaC/master/manifests/172.16_net_calico.yaml


# ttl(time to live) : 유지되는 시간. 0으로 설정하면 Default 값인 24시간 후에 토큰이 계속 유지됨
# chown USER[:GROUP] FILE(s): 파일의 소유자나 소유그룹을 변경하기 위한 명령어