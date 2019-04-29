#!/bin/sh
set -e -x

docker pull coredns/coredns:1.2.2
docker pull coredns/coredns:1.2.6
docker pull coredns/coredns:1.3.1
docker pull minio/minio:RELEASE.2018-05-25T19-49-13Z
docker pull rancher/alertmanager-helper:v0.0.2
docker pull quay.io/calico/cni:v3.1.3
docker tag quay.io/calico/cni:v3.1.3 rancher/calico-cni:v3.1.3
docker push rancher/calico-cni:v3.1.3
docker pull quay.io/calico/cni:v3.4.0
docker tag quay.io/calico/cni:v3.4.0 rancher/calico-cni:v3.4.0
docker push rancher/calico-cni:v3.4.0
docker pull quay.io/calico/ctl:v2.0.0
docker tag quay.io/calico/ctl:v2.0.0 rancher/calico-ctl:v2.0.0
docker push rancher/calico-ctl:v2.0.0
docker pull quay.io/calico/node:v3.1.3
docker tag quay.io/calico/node:v3.1.3 rancher/calico-node:v3.1.3
docker push rancher/calico-node:v3.1.3
docker pull quay.io/calico/node:v3.4.0
docker tag quay.io/calico/node:v3.4.0 rancher/calico-node:v3.4.0
docker push rancher/calico-node:v3.4.0
docker pull gcr.io/google_containers/cluster-proportional-autoscaler-amd64:1.0.0
docker tag gcr.io/google_containers/cluster-proportional-autoscaler-amd64:1.0.0 rancher/cluster-proportional-autoscaler-amd64:1.0.0
docker push rancher/cluster-proportional-autoscaler-amd64:1.0.0
docker pull gcr.io/google_containers/cluster-proportional-autoscaler:1.0.0
docker tag gcr.io/google_containers/cluster-proportional-autoscaler:1.0.0 rancher/cluster-proportional-autoscaler:1.0.0
docker push rancher/cluster-proportional-autoscaler:1.0.0
docker pull gcr.io/google_containers/cluster-proportional-autoscaler:1.3.0
docker tag gcr.io/google_containers/cluster-proportional-autoscaler:1.3.0 rancher/cluster-proportional-autoscaler:1.3.0
docker push rancher/cluster-proportional-autoscaler:1.3.0
docker pull quay.io/coreos/etcd:v3.2.18
docker tag quay.io/coreos/etcd:v3.2.18 rancher/coreos-etcd:v3.2.18
docker push rancher/coreos-etcd:v3.2.18
docker pull quay.io/coreos/etcd:v3.2.24-rancher1
docker tag quay.io/coreos/etcd:v3.2.24-rancher1 rancher/coreos-etcd:v3.2.24-rancher1
docker push rancher/coreos-etcd:v3.2.24-rancher1
docker pull quay.io/coreos/etcd:v3.3.10-rancher1
docker tag quay.io/coreos/etcd:v3.3.10-rancher1 rancher/coreos-etcd:v3.3.10-rancher1
docker push rancher/coreos-etcd:v3.3.10-rancher1
docker pull quay.io/coreos/flannel-cni:v0.3.0
docker tag quay.io/coreos/flannel-cni:v0.3.0 rancher/coreos-flannel-cni:v0.3.0
docker push rancher/coreos-flannel-cni:v0.3.0
docker pull quay.io/coreos/flannel:v0.10.0
docker tag quay.io/coreos/flannel:v0.10.0 rancher/coreos-flannel:v0.10.0
docker push rancher/coreos-flannel:v0.10.0
docker pull quay.io/coreos/flannel:v0.10.0-rancher1
docker tag quay.io/coreos/flannel:v0.10.0-rancher1 rancher/coreos-flannel:v0.10.0-rancher1
docker push rancher/coreos-flannel:v0.10.0-rancher1
docker pull rancher/flannel-cni:v0.3.0-rancher1
docker pull rancher/fluentd-helper:v0.1.2
docker pull rancher/fluentd:v0.1.11
docker pull rancher/hyperkube:v1.11.9-rancher1
docker pull rancher/hyperkube:v1.12.7-rancher1
docker pull rancher/hyperkube:v1.13.5-rancher1
docker pull rancher/hyperkube:v1.14.1-rancher1
docker pull jenkins/jnlp-slave:3.10-1-alpine
docker tag jenkins/jnlp-slave:3.10-1-alpine rancher/jenkins-jnlp-slave:3.10-1-alpine
docker push rancher/jenkins-jnlp-slave:3.10-1-alpine
docker pull plugins/docker:17.12
docker tag plugins/docker:17.12 rancher/jenkins-plugins-docker:17.12
docker push rancher/jenkins-plugins-docker:17.12
docker pull gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.10
docker tag gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.10 rancher/k8s-dns-dnsmasq-nanny-amd64:1.14.10
docker push rancher/k8s-dns-dnsmasq-nanny-amd64:1.14.10
docker pull gcr.io/google_containers/k8s-dns-dnsmasq-nanny:1.14.13
docker tag gcr.io/google_containers/k8s-dns-dnsmasq-nanny:1.14.13 rancher/k8s-dns-dnsmasq-nanny:1.14.13
docker push rancher/k8s-dns-dnsmasq-nanny:1.14.13
docker pull gcr.io/google_containers/k8s-dns-dnsmasq-nanny:1.15.0
docker tag gcr.io/google_containers/k8s-dns-dnsmasq-nanny:1.15.0 rancher/k8s-dns-dnsmasq-nanny:1.15.0
docker push rancher/k8s-dns-dnsmasq-nanny:1.15.0
docker pull gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.10
docker tag gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.10 rancher/k8s-dns-kube-dns-amd64:1.14.10
docker push rancher/k8s-dns-kube-dns-amd64:1.14.10
docker pull gcr.io/google_containers/k8s-dns-kube-dns:1.14.13
docker tag gcr.io/google_containers/k8s-dns-kube-dns:1.14.13 rancher/k8s-dns-kube-dns:1.14.13
docker push rancher/k8s-dns-kube-dns:1.14.13
docker pull gcr.io/google_containers/k8s-dns-kube-dns:1.15.0
docker tag gcr.io/google_containers/k8s-dns-kube-dns:1.15.0 rancher/k8s-dns-kube-dns:1.15.0
docker push rancher/k8s-dns-kube-dns:1.15.0
docker pull gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.10
docker tag gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.10 rancher/k8s-dns-sidecar-amd64:1.14.10
docker push rancher/k8s-dns-sidecar-amd64:1.14.10
docker pull gcr.io/google_containers/k8s-dns-sidecar:1.14.13
docker tag gcr.io/google_containers/k8s-dns-sidecar:1.14.13 rancher/k8s-dns-sidecar:1.14.13
docker push rancher/k8s-dns-sidecar:1.14.13
docker pull gcr.io/google_containers/k8s-dns-sidecar:1.15.0
docker tag gcr.io/google_containers/k8s-dns-sidecar:1.15.0 rancher/k8s-dns-sidecar:1.15.0
docker push rancher/k8s-dns-sidecar:1.15.0
docker pull rancher/kube-api-auth:v0.1.3
docker pull rancher/log-aggregator:v0.1.4
docker pull gcr.io/google_containers/metrics-server-amd64:v0.2.1
docker tag gcr.io/google_containers/metrics-server-amd64:v0.2.1 rancher/metrics-server-amd64:v0.2.1
docker push rancher/metrics-server-amd64:v0.2.1
docker pull gcr.io/google_containers/metrics-server:v0.3.1
docker tag gcr.io/google_containers/metrics-server:v0.3.1 rancher/metrics-server:v0.3.1
docker push rancher/metrics-server:v0.3.1
docker pull k8s.gcr.io/defaultbackend:1.4
docker tag k8s.gcr.io/defaultbackend:1.4 rancher/nginx-ingress-controller-defaultbackend:1.4
docker push rancher/nginx-ingress-controller-defaultbackend:1.4
docker pull k8s.gcr.io/defaultbackend:1.4-rancher1
docker tag k8s.gcr.io/defaultbackend:1.4-rancher1 rancher/nginx-ingress-controller-defaultbackend:1.4-rancher1
docker push rancher/nginx-ingress-controller-defaultbackend:1.4-rancher1
docker pull k8s.gcr.io/defaultbackend:1.5-rancher1
docker tag k8s.gcr.io/defaultbackend:1.5-rancher1 rancher/nginx-ingress-controller-defaultbackend:1.5-rancher1
docker push rancher/nginx-ingress-controller-defaultbackend:1.5-rancher1
docker pull rancher/nginx-ingress-controller:0.16.2-rancher1
docker pull rancher/nginx-ingress-controller:0.21.0-rancher3
docker pull gcr.io/google_containers/pause-amd64:3.1
docker tag gcr.io/google_containers/pause-amd64:3.1 rancher/pause-amd64:3.1
docker push rancher/pause-amd64:3.1
docker pull gcr.io/google_containers/pause:3.1
docker tag gcr.io/google_containers/pause:3.1 rancher/pause:3.1
docker push rancher/pause:3.1
docker pull rancher/pipeline-jenkins-server:v0.1.0
docker pull rancher/pipeline-tools:v0.1.9
docker pull prom/alertmanager:v0.15.2
docker tag prom/alertmanager:v0.15.2 rancher/prom-alertmanager:v0.15.2
docker push rancher/prom-alertmanager:v0.15.2
docker pull rancher/rke-tools:v0.1.15
docker pull rancher/rke-tools:v0.1.27
docker pull rancher/rke-tools:v0.1.28
docker pull registry:2
docker pull rancher/coreos-kube-state-metrics:v1.5.0
docker pull rancher/nginx:1.15.8-alpine
docker pull rancher/prom-alertmanager:v0.16.1
docker pull rancher/kubernetes-external-dns:v0.5.11
docker pull rancher/fluentd:v0.1.12
docker pull rancher/coreos-prometheus-operator:v0.29.0
docker pull rancher/coreos-prometheus-config-reloader:v0.29.0
docker pull rancher/coreos-configmap-reload:v0.0.1
docker pull rancher/grafana-grafana:5.4.3
docker pull rancher/prom-prometheus:v2.7.1
docker pull jimmidyson/configmap-reload:v0.2.2
docker pull rancher/fluentd:v0.1.13
docker pull rancher/log-aggregator:v0.1.5
docker pull rancher/prometheus-auth:v0.2.0
docker pull rancher/prom-node-exporter:v0.17.0
docker pull rancher/rancher:v2.2.2
docker pull rancher/rancher-agent:v2.2.2
