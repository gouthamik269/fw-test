output "eks-cls-name" {
  value       = aws_eks_cluster.eks-cluster.name
  description = "The name of the EKS cluster."
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.eks-cluster.endpoint
  description = "The endpoint URL of the EKS cluster."
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.eks-cluster.certificate_authority.0.data
  description = "The certificate authority data of the EKS cluster."
}

output "aws_iam_openid_connect_provider" {
  value       = data.tls_certificate.eks.url
  description = "The URL of the AWS IAM OpenID Connect provider."
}

output "thumbprint_list" {
  value       = data.tls_certificate.eks.certificates[0].sha1_fingerprint
  description = "The SHA1 fingerprint of the TLS certificate."
}

output "cluster_provider_url" {
  value = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}