
terraform {
  backend "s3" {
    region = "us-east-1"
    key    = "tfstate/eks/terraform.tfstate"
    bucket = "eks-state"
  }
}

locals {
  rds_private_subnet_ids = [
    module.rds-vpc.private_subnet_1a_id,
    module.rds-vpc.private_subnet_1b_id,
    module.rds-vpc.private_subnet_1c_id
  ]  
  rds_public_subnet_ids = [
    module.rds-vpc.public_subnet_1a_id,
    module.rds-vpc.public_subnet_1b_id,
    module.rds-vpc.public_subnet_1c_id
  ]
  eks_private_subnet_ids = [
    module.eks-vpc.private_subnet_1a_id,
    module.eks-vpc.private_subnet_1b_id,
    module.eks-vpc.private_subnet_1c_id
  ]  
  eks_public_subnet_ids = [
    module.eks-vpc.public_subnet_1a_id,
    module.eks-vpc.public_subnet_1b_id,
    module.eks-vpc.public_subnet_1c_id
  ]

  eks_private_route_table_ids = [
    module.eks-vpc.private_route_table_1a_id,
    module.eks-vpc.private_route_table_1b_id,
    module.eks-vpc.private_route_table_1c_id
  ]

  eks_private_route_tables = {
    "1a" = module.eks-vpc.private_route_table_1a_id
    "1b" = module.eks-vpc.private_route_table_1b_id
    "1c" = module.eks-vpc.private_route_table_1c_id
  }

  rds_private_route_tables = {
    "1a" = module.rds-vpc.private_route_table_1a_id
    "1b" = module.rds-vpc.private_route_table_1b_id
    "1c" = module.rds-vpc.private_route_table_1c_id
  }

}

#rds-vpc
module "rds-vpc" {
  source                      = "./modules/vpc"
  region                      = var.region
  private_subnet_ids          = local.rds_private_subnet_ids
  public_subnet_ids           = local.rds_public_subnet_ids
  resource                    = "rds"
  vpc_subnet_prefix           = var.rds-cidr_block
  enable_nat_gateway          = false
}

#eks-vpc
module "eks-vpc" {
  source                      = "./modules/vpc"
  region                      = var.region
  private_subnet_ids          = local.eks_private_subnet_ids
  public_subnet_ids           = local.eks_public_subnet_ids
  resource                    = "eks"
  vpc_subnet_prefix           = var.eks-cidr_block
  enable_nat_gateway          = true
}

#RDS
module "rds" {
  source                  = "./modules/rds"
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = var.db_password
  db_subnet_ids           = local.rds_private_subnet_ids
  db_instance_class       = var.db_size
  allocated_storage       = 50
  multi_az                = true
  engine_version          = "17.2"
  vpc_id = module.rds-vpc.vpc_id
  rds-cidr_block = ["${var.rds-cidr_block}.0.0/16"]
  rds-sg = var.db_sg
  availability_zones = var.db_azs
}


module "eks-iam-master-role" {
  cluster_base_name = var.cluster_base_name
  source            = "./modules/iam/eks-master-role"
  depends_on = [
    module.eks-vpc
  ]
}


module "eks" {
  source                   = "./modules/eks"
  cluster_base_name        = var.cluster_base_name
  role_arn                 = module.eks-iam-master-role.role-arn
  role_name                = module.eks-iam-master-role.role-name
  vpc_subnets              = local.eks_private_subnet_ids
  eks_version              = var.eks_version
  vpc_id                   = module.eks-vpc.vpc_id
  rds_cidr                 = var.rds_cidr 
  depends_on = [
    module.eks-vpc,
    module.eks-iam-master-role
  ]
}

module "eks-iam-node-role" {
  source            = "./modules/iam/eks-node-role"
  cluster_base_name = var.cluster_base_name

  depends_on = [
    module.eks-vpc,
    module.eks
  ]
}

module "eks_node" {
  source            = "./modules/eks_node"
  cluster_base_name = var.cluster_base_name
  vpc_subnets       = local.eks_private_subnet_ids
  node-role_arn     = module.eks-iam-node-role.role-arn
  node-role_name    = module.eks-iam-node-role.role-name
  eks_version       = var.eks_version
  instance_type     = var.instance_type
  eks_cluster_name  = module.eks.eks-cls-name
  desired_size     = var.desired_size
  max_size         = var.max_size
  min_size         = var.min_size
  disk_size         = 100
  tags = {
    Name = "${var.cluster_base_name}-worker-nodes"
  }

  labels = {
    fw-rapid = "dedicated"
  }

  taints = [
    {
      key    = "dedicated"
      value  = "fw-rapid"
      effect = "NO_SCHEDULE"
    }
  ]
  depends_on = [
    module.eks-vpc,
    module.eks,
    module.eks-iam-node-role
  ]
}

#EKS-addons

resource "aws_eks_addon" "addons" {
  for_each                  = var.eks_addons
  cluster_name              = module.eks.eks-cls-name
  addon_name                = each.key
  addon_version             = each.value.version
  configuration_values      = lookup(each.value, "configuration_values", null)
  depends_on = [
    module.eks_node
  ]
}


module "s3" {
  source = "./modules/s3"
  region = var.region
  vpc_id = module.eks-vpc.vpc_id
  route_table_ids = local.eks_private_route_table_ids
  bucket_name = var.bucket_name
}



#peering connection

resource "aws_vpc_peering_connection" "peering-to-rds-vpc" {
  peer_vpc_id = module.eks-vpc.vpc_id
  vpc_id      = module.rds-vpc.vpc_id
  auto_accept = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
  tags = {
    Name = "eks-to-rds"
  }
}

resource "aws_route" "eks_to_rds" {
  for_each = local.eks_private_route_tables

  route_table_id            = each.value
  destination_cidr_block    = "${var.rds-cidr_block}.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering-to-rds-vpc.id
}

resource "aws_route" "rds_to_eks" {
  for_each = local.rds_private_route_tables

  route_table_id            = each.value
  destination_cidr_block    = "${var.eks-cidr_block}.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering-to-rds-vpc.id
}


