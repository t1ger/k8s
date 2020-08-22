#!/bin/bash

HOSTNAME=${1:-"`hostname`"}

cat<<EOF>/opt/kubernetes/cfg/kube-proxy.conf
KUBE_PROXY_OPTS="--logtostderr=true \\
--v=2 \\
--config=/opt/kubernetes/cfg/kube-proxy-config.yml"
EOF

cat<<EOF>/opt/kubernetes/cfg/kube-proxy-config.yml
apiVersion: kubeproxy.config.k8s.io/v1alpha1
bindAddress: 0.0.0.0
clientConnection:
  acceptContentTypes: ""
  burst: 10
  contentType: application/vnd.kubernetes.protobuf
  kubeconfig: /opt/kubernetes/cfg/kube-proxy.kubeconfig
  qps: 5
clusterCIDR: 10.10.0.0/16
configSyncPeriod: 15m0s
enableProfiling: false
healthzBindAddress: 0.0.0.0:10256
hostnameOverride: ${HOSTNAME}
iptables:
  masqueradeAll: false
  masqueradeBit: 14
  minSyncPeriod: 0s
  syncPeriod: 30s
ipvs:
  excludeCIDRs: null
  minSyncPeriod: 0s
  scheduler: ""
  syncPeriod: 30s
kind: KubeProxyConfiguration
metricsBindAddress: 0.0.0.0:10249
mode: ipvs
nodePortAddresses: null
oomScoreAdj: -999
portRange: ""
EOF

cat<<EOF>/usr/lib/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Proxy
After=network.target
[Service]
EnvironmentFile=-/opt/kubernetes/cfg/kube-proxy.conf
ExecStart=/opt/kubernetes/bin/kube-proxy \$KUBE_PROXY_OPTS
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-proxy
systemctl restart kube-proxy
