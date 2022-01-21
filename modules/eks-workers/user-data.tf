locals {
  kubelet_extra_args = <<ARGS
--v=3 \
ARGS

  userdata = <<USERDATA

  MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash -xe
set -o xtrace
/etc/eks/bootstrap.sh --b64-cluster-ca "${var.cluster_ca}" --apiserver-endpoint "${var.cluster_endpoint}"
--==MYBOUNDARY==--
USERDATA

  workers_userdata = "${local.userdata} --kubelet-extra-args \"${local.kubelet_extra_args}\"  \"${var.cluster_full_name}\""
}