resource "aws_eks_cluster" "was" {
  name     = "was"
  role_arn = aws_iam_role.was.arn
  vpc_config {
    subnet_ids = [aws_subnet.was-subnet1.id, aws_subnet.was-subnet2.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.was
  ]
  enabled_cluster_log_types = ["api", "audit"]
}

output "endpoint" {
  value = aws_eks_cluster.was.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.was.certificate_authority[0].data
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "was" {
  name               = "eks-cluster-was"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.was.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.was.name
}

resource "aws_cloudwatch_log_group" "was" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/was/cluster"
  retention_in_days = 7
}
data "tls_certificate" "was" {
  url = aws_eks_cluster.was.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "was" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.was.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.was.url
}
