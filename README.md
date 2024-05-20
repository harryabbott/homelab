# Homelab
## Ubuntu 24.04LTS 
(VM has 4cpu + 8gig Mem + 128mb VRAM (3d accel off)
user was called 'harry', machine called 'harryvm'


# Steps:


## Pre-install packages needed
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl gpg net-tools



## Docker apt repo setup via this: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

Add Docker's official GPG key:

    sudo apt update
    sudo apt install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

Add the repository to Apt sources:

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y software-properties-common docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


## K8s apt repo setup via this: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl

    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    
    sudo apt install kubelet kubeadm kubectl kubectx
    sudo apt-mark hold kubelet kubeadm kubectl


## Swap off
    
    sudo swapoff -a
    nano /etc/fstab #then comment out the swap line
    


## Docker perms
    
    sudo groupadd docker
    sudo usermod -aG docker harry
    newgrp docker

    sudo systemctl start docker
    sudo systemctl enable docker


## Kubectl config

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config



## Start up the k8s system

    sudo systemctl enable --now kubelet
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16

## Calico for networking

    kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

## Remove the control plane taint
    kubectl taint nodes harryvm node-role.kubernetes.io/control-plane:NoSchedule-

## Optional: Test cluster with a deployment of nginx
    kubectl create deployment nginx --image=nginx
    kubectl expose deployment nginx --port=80 --type=NodePort

then get node ip from here:

    kubectl get nodes -o wide

port from here:

    kubectl get services

then run:

    curl http://<ip>:<port>

then to clean this test up:
    kubectl delete deployment nginx
    kubectl delete service nginx





