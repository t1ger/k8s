# k8s
# install k8s by binary
.directory
├── etcd
│   └── etcd.sh
├── k8s-master
│   ├── apiserver.sh
│   ├── controller-manager.sh
│   └── scheduler.sh
├── k8s-node
│   ├── kubelet.sh
│   └── proxy.sh
├── README.md
└── ssl
    ├── cert.sh
    └── kubeconfig.sh

After finish install k8s, master list:
/opt/kubernetes/
├── bin
│   ├── etcd
│   ├── etcdctl
│   ├── kube-apiserver
│   ├── kube-controller-manager
│   ├── kubectl
│   ├── kubelet
│   ├── kube-proxy
│   ├── kube-scheduler
├── cfg
│   ├── bootstrap.kubeconfig
│   ├── etcd.yml
│   ├── kube-apiserver
│   ├── kube-controller-manager
│   ├── kube-proxy.kubeconfig
│   ├── kube-scheduler
│   └── token.csv
└── ssl
    ├── ca-key.pem
    ├── ca.pem
    ├── metrics-server.csr
    ├── metrics-server-csr.json
    ├── metrics-server-key.pem
    ├── metrics-server.pem
    ├── server-key.pem
    └── server.pem

3 directories, 26 files


After finish install k8s, node list
/opt/kubernetes/
├── bin
│   ├── kubelet
│   └── kube-proxy
├── cfg
│   ├── bootstrap.kubeconfig
│   ├── kubelet.conf
│   ├── kubelet-config.yml
│   ├── kubelet.kubeconfig
│   ├── kube-proxy.conf
│   ├── kube-proxy-config.yml
│   └── kube-proxy.kubeconfig
└── ssl
    ├── ca-key.pem
    ├── ca.pem
    ├── kubelet-client-2020-08-19-01-01-28.pem    //auto generate
    ├── kubelet-client-current.pem -> /opt/kubernetes/ssl/kubelet-client-2020-08-19-01-01-28.pem
    ├── kubelet.crt                               //auto generate
    ├── kubelet.key                               //auto generate
    ├── kube-proxy-key.pem
    ├── kube-proxy.pem
    ├── server-key.pem
    └── server.pem

3 directories, 19 files