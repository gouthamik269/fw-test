output "role-arn" {
  description = "The ARN (Amazon Resource Name) of the EKS master IAM role."
  value       = aws_iam_role.eks-iam-master-role.arn
}

output "role-name" {
  description = "The name of the EKS master IAM role."
  value       = aws_iam_role.eks-iam-master-role.name
}