
data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${var.eks_version}/amazon-linux-2023/x86_64/standard/recommended/release_version"
}


resource "aws_eks_node_group" "eks-nodes" {
  cluster_name    = var.eks_cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node-role_arn
  subnet_ids      = flatten([var.vpc_subnets])
  version = var.eks_version
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  release_version = data.aws_ssm_parameter.eks_ami_release_version.value
  disk_size = var.disk_size

  instance_types = [var.instance_type]
  update_config {
    max_unavailable = 1

  }

  labels = var.labels
   
   dynamic "taint" {
    for_each = var.taints

    content {
      key    = taint.value.key
      value  = try(taint.value.value, null)
      effect = taint.value.effect
    }
  }

  tags = var.tags
}


