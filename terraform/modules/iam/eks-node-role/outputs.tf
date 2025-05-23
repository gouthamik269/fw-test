output "iam_instance_profile" {
  description = "The name of the IAM instance profile for the EKS nodes"
  value       = aws_iam_instance_profile.eks-node-profile.name
}

output "role-arn" {
  description = "The ARN of the IAM role for the EKS nodes"
  value       = aws_iam_role.eks-iam-node-role.arn
}

output "role-name" {
  description = "The name of the IAM role for the EKS nodes"
  value       = aws_iam_role.eks-iam-node-role.name
}
