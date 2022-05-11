#!/usr/bin/env bash

# config for work_nodes only
kubeadm join --token 123456.1234567890123456 \
             --discovery-token-unsafe-skip-ca-verification 192.168.1.10:6443

# kubeadm을 이용해 쿠버네티스 마스터 노드에 접속.
# 간단한 구성을 위해 인증을 무시하고(discovery-token-unsafe-skip-ca-verification), API 서버 주소인 192.168.1.10:6443에 접속하도록 설정