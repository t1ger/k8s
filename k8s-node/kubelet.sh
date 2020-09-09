#!/bin/bash
#create static pod directory
mkdir -p /etc/kubernetes/manifests

DNS_SERVER_IP=${1:-"10.10.0.2"}
HOSTNAME=${2:-"`hostname`"}
CLUETERDOMAIN=${3:-"cluster.local"}
cat<<EOF>/opt/kubernetes/cfg/kubelet.conf
KUBELET_OPTS="--logtostderr=false \\
--v=2 \\
--hostname-override=${HOSTNAME} \\
--kubeconfig=/opt/kubernetes/cfg/kubelet.kubeconfig \\
--bootstrap-kubeconfig=/opt/kubernetes/cfg/bootstrap.kubeconfig \\
--config=/opt/kubernetes/cfg/kubelet-config.yml \\
--cert-dir=/opt/kubernetes/ssl \\
--network-plugin=cni \\
--cni-conf-dir=/etc/cni/net.d \\
--cni-bin-dir=/opt/cni/bin \\
--pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.2"
EOF

cat<<EOF>/opt/kubernetes/cfg/kubelet-config.yml
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    cacheTTL: 0s
    enabled: true
  x509:
    clientCAFile: /opt/kubernetes/ssl/ca.pem
authorization:
  mode: Webhook
  webhook:
    cacheAuthorizedTTL: 0s
    cacheUnauthorizedTTL: 0s
clusterDNS:
- ${DNS_SERVER_IP}
clusterDomain: ${CLUETERDOMAIN}
cpuManagerReconcilePeriod: 0s
evictionPressureTransitionPeriod: 0s
fileCheckFrequency: 0s
healthzBindAddress: 127.0.0.1
healthzPort: 10248
httpCheckFrequency: 0s
imageMinimumGCAge: 0s
kind: KubeletConfiguration
nodeStatusReportFrequency: 0s
nodeStatusUpdateFrequency: 0s
rotateCertificates: true
runtimeRequestTimeout: 0s
staticPodPath: /etc/kubernetes/manifests
streamingConnectionIdleTimeout: 0s
syncFrequency: 0s
volumeStatsAggPeriod: 0s
featureGates: 
  RotateKubeletServerCertificate: true
  RotateKubeletClientCertificate: true
EOF

cat<<EOF>/usr/lib/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
After=docker.service
Requires=docker.service
[Service]
EnvironmentFile=-/opt/kubernetes/cfg/kubelet.conf
ExecStart=/opt/kubernetes/bin/kubelet \$KUBELET_OPTS
Restart=on-failure
KillMode=process
RestartSec=10
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kubelet
systemctl restart kubelet

