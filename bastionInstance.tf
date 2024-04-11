resource "aws_instance" "example" {
  depends_on = [aws_security_group.bastion_sg]
  ami           = var.amiAL2023
  instance_type = "t2.micro"
  key_name = aws_key_pair.terraform_key.key_name
  user_data = <<EOF
#!/bin/sh
sudo swapoff -a
echo -e "overlay\nbr_netfilter" > /etc/modules-load.d/k8s.conf
echo -e "net.bridge.bridge-nf-call-iptables  = 1\nnet.bridge.bridge-nf-call-ip6tables = 1\nnet.ipv4.ip_forward  = 1" >  /etc/sysctl.d/k8s.conf
sudo sysctl --system
sudo setenforce 0
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install containerd -y
containerd config default | tee /etc/containerd/config.toml >/dev/null 2>&1
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl enable --now containerd
sudo systemctl status containerd
echo -e "[kubernetes]\nname=Kubernetes\nbaseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/\nenabled=1\ngpgcheck=1\ngpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key\nexclude=kubelet kubeadm kubectl cri-tools kubernetes-cni" > /etc/yum.repos.d/kubernetes.repo
dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
kubeadm config images pull
kubeadm init --v=5
EOF

  network_interface {
    network_interface_id = aws_network_interface.ni.id
    device_index         = 0
  }
  tags = {
    Name = "bastion-instance"
  }
}
