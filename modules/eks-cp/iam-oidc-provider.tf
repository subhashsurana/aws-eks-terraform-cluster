data "tls_certificate" "eks_tls" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_tls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

# Create IAM policy allowing the k8s service account to assume the IAM role

data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

# Limit the scope so that only our desired service account can assume this role
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
      type        = "Federated"
    }
  }
}

# Create the IAM role that will be assumed by the service account

resource "aws_iam_role" "iam_oidc" {
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role_policy.json
  name               = "iam-oidc"

  tags = merge(
    var.common_tags,
    {
      "ServiceAccountName"      = "aws-node"
      "ServiceAccountNameSpace" = "kube-system"
    }
  )
  depends_on = [aws_iam_openid_connect_provider.oidc_provider]
}


resource "aws_iam_policy" "s3-oidc-policy" {
  name = "s3-oidc-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "s3_oidc_policy_attach" {
  role       = aws_iam_role.iam_oidc.name
  policy_arn = aws_iam_policy.s3-oidc-policy.arn
}

