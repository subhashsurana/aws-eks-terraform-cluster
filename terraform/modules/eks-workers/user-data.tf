locals {
  eks_node_private_userdata = <<USERDATA
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash -xe
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${var.cluster_endpoint}' \
--b64-cluster-ca '${var.cluster_cert_authority}' '${var.cluster_full_name}' \
--kubelet-extra-args '--node-labels=kube/nodetype=app'

yum install -y amazon-ssm-agent
echo "yum'd agent" >> /tmp/me.txt
systemctl enable amazon-ssm-agent && systemctl start amazon-ssm-agent
date >> /tmp/me.txt

--==MYBOUNDARY==--
USERDATA
}