locals {
  sgs              = [aws_security_group.eks-cluster-master.id]
  sg_name          = "${var.cluster_base_name}-eks-master-sg"
}


resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = var.role_name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = var.role_name
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.cluster_base_name}-eks-cls"
  role_arn = var.role_arn
  version  = var.eks_version

  vpc_config {
    security_group_ids      = local.sgs
    subnet_ids              = flatten([var.vpc_subnets])
    endpoint_private_access = true
    endpoint_public_access  = false
  }
}

resource "aws_security_group" "eks-cluster-master" {
  name   = "${var.cluster_base_name}-eks-master-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = [var.rds_cidr]
  }

  tags = {
    Name  = local.sg_name
  }
}


data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

