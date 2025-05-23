locals {
  role_name = "${var.cluster_base_name}-eks-master-role"
}

resource "aws_iam_role" "eks-iam-master-role" {
  name = "${var.cluster_base_name}-eks-master-role"

  tags = {
    Name = local.role_name
  }

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
