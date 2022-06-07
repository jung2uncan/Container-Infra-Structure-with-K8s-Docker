nfsdir=/nfs_shared/$1
if [ $# -eq 0 ]; then
  echo "usage: nfs-exporter.sh <name>"; exit 0
fi

if [[ ! -d $nfsdir ]]; then
  mkdir -p $nfsdir  # NFS용 디렉토리 생성
  echo "$nfsdir 192.168.1.0/24(rw,sync,no_root_squash)" >> /etc/exports
  if [[ $(systemctl is-enabled nfs) -eq "disabled" ]]; then # NFS 서비스로 생성
    systemctl enable nfs
  fi
   systemctl restart nfs
fi
