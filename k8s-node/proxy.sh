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
  burst: 0
  contentType: ""
  kubeconfig: /opt/kubernetes/cfg/kube-proxy.kubeconfig
  qps: 0
clusterCIDR: 10.20.0.0/16
configSyncPeriod: 0s
conntrack:
  maxPerCore: null
  min: null
  tcpCloseWaitTimeout: null
  tcpEstablishedTimeout: null
enableProfiling: false
healthzBindAddress: ""
hostnameOverride: ${HOSTNAME}
iptables:
  masqueradeAll: false
  masqueradeBit: null
  minSyncPeriod: 0s
  syncPeriod: 0s
ipvs:
  excludeCIDRs: null
  minSyncPeriod: 0s
  scheduler: ""
  strictARP: false
  syncPeriod: 0s
kind: KubeProxyConfiguration
metricsBindAddress: ""
mode: "ipvs"
nodePortAddresses: null
oomScoreAdj: null
portRange: ""
udpIdleTimeout: 0s
winkernel:
  enableDSR: false
  networkName: ""
  sourceVip: ""
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
