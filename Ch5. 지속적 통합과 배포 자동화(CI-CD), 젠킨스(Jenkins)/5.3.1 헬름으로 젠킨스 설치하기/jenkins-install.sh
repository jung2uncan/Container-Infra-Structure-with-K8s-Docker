#!/usr/bin/env bash
jkopt1="--sessionTimeout=1440" # 세션 유효시간 설정 (하루 1440분)
jkopt2="--sessionEviction=86400" # 세션 정리하는 시간 설정 (하루 86400초)
jvopt1="-Duser.timezone=Asia/Seoul" # 시간대 설정
jvopt2="-Dcasc.jenkins.config=https://raw.githubusercontent.com/sysnet4admin/_Book_k8sInfra/main/ch5/5.3.1/jenkins-config.yaml" # 젠킨스 에이전트 노드 설정 정보(jenkins-config.yaml) 내려받기

helm install jenkins edu/jenkins \  # edu 저장소의 jenkins 차트를 사용하여 jenkins 릴리스 설치
--set persistence.existingClaim=jenkins \ # PVC 동적 프로비저닝을 사용할 수 없는 가상 머신 기반의 환경이기 때문에 미리 만들어둔 jenkins 이름의 PVC를 사용하도록 설정
--set master.adminPassword=admin \  # 젠킨스 접속시 사용할 관리자 비밀번호 설정 (설정안하면 임의의 값이 부여됨)
--set master.nodeSelector."kubernetes\.io/hostname"=m-k8s \ # 젠킨스 컨트롤러 파드를 마스터 노드 m-k8s에 배치하도록 선택함
--set master.tolerations[0].key=node-role.kubernetes.io/master \  # tolerations의 키(Key) 설정
--set master.tolerations[0].effect=NoSchedule \ # effect가 NoSchedule인 테인트가 존재할 때(Exists) 테인트를 예외 처리해 마스터 노드에 Pod를 배치할 수 있도록 함.
--set master.tolerations[0].operator=Exists \   
--set master.runAsUser=1000 \   # 젠킨스를 구동하는 파드가 실행될 때 가질 사용자 ID 설정
--set master.runAsGroup=1000 \  # 젠킨스를 구동하는 파드가 실행될 때 가질 그룹 ID 설정
--set master.tag=2.249.3-lts-centos7 \  # 젠킨스 버전에 따른 UI 변경을 마기 위한 젠킨스 버전 고정
--set master.serviceType=LoadBalancer \ # 서비스 타입 설정(LoadBalancer)을 통한 외부 IP 할당
--set master.servicePort=80 \   #  젠킨스가 http 상에서 구동되도록 포트를 80으로 지정
--set master.jenkinsOpts="$jkopt1 $jkopt2" \  # 젠킨스 추가 설정. 2~3번째 줄에 설정한 변수 적용
--set master.javaOpts="$jvopt1 $jvopt2"       # 젠킨스를 구동하기 위한 환경 설정. 4~5번째 줄에 설정한 변수 적용 부분으로 변수들을 호출하여 젠킨스 실행환경(JVM)에 적용

------------------------------------------------------------------------
# nodeSelector란?
# : 뒤에 따라오는 문자열과 일치라는 레이블을 가진 노드에 파드를 스케줄링 하겠다는 설정
