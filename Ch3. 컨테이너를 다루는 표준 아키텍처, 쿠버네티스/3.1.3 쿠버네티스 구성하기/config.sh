#!/usr/bin/env bash
# vim configuration
echo 'alias vi=vim' >> /etc/profile #vi를 호출하면 vim을 호출하도록 프로파일에 입력

# kubeadm으로 쿠버네티스 설치를 위한 사전 조건을 설정하는 스크립트 파일

# swapoff -a to disable swapping (쿠버네티스의 설치 요구 조건을 맞추기 위해 스왑되지 않도록 설정)
swapoff -a
# sef to comment the swap partition in /etc/fstab (시스템이 다시 시작되도라도 스왑되지 않도록 설정)
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

gg_pkg="packages.cloud.google.com/yum/doc"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo #쿠버네티스를 내려 받을 레파지토리를 설정하는 구문
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://${gg_pkg}/yum-key.gpg https://${gg_pkg}/rpm-package-key.gpg
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# RHEL/CentOS 7 have reported traffic issues being routed incorrectly due to iptables bypassed
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
modprobe br_netfilter # 해당 커널 모듈을 사용하여 브리지로 네트워크를 구성함.

# local small dns & vagrant cannot parse and delivery shell code.
echo "192.168.1.10 m-k8s" >> /etc/hosts
for (( i=1; i<=$1; i++  )); do echo "192.168.1.10$i w$i-k8s" >> /etc/hosts; done # 노드간 통신을 이름으로 할 수 있도록 각 노드의 호스트 이름과 IP를 설정

# config DNS (외부와 통신할 수 있도록 DNS 서버 저장)
cat <<EOF > /etc/resolv.conf
nameserver 1.1.1.1 #cloudflare DNS
nameserver 8.8.8.8 #Google DNS
EOF
