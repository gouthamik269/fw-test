
variable "region" {
 default = "us-east-1"
}

variable "rds-cidr_block" {
    default =  "10.42"
}

variable "eks-cidr_block" {
    default =  "10.74"
}

variable "cluster_base_name" {
  default     = "fw-test"
  description = "Base name for the EKS cluster"
}

variable "rds_cidr" {
  default = "10.42.0.0/16"
}

variable "eks_version" {
  default = "1.32"
}

variable "instance_type" {
  default     = "m6a.2xlarge"
  description = "EC2 instance type"
}

variable "max_size" {
  default = 4
}

variable "desired_size" {
  default = 3
}

variable "min_size" {
  default = 3
}

variable "bucket_name" {
  default = "fw-test"
}

variable "db_name" {
  default = "mydb"
}

variable "db_username" {
  default = "masteruser"
}

variable "db_password" {
  default = "supersecretpassword"
  sensitive = true
}

variable "db_size" {
  default = "db.t3.small"
}

variable "db_azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "db_sg" {
  default = "rds-sg"
}

variable "eks_addons" {
  description = "Map of EKS addons to create. Key is addon name."
  type = map(object({
    version                  = string
    configuration_values     = optional(string)
  }))
  default = {
    "coredns" = {
      version = "v1.11.1-eksbuild.4"
    }
    "kube-proxy" = {
      version = "v1.31.2-eksbuild.1"
    }
    "vpc-cni" = {
      version              = "v1.18.1-eksbuild.1"
      configuration_values = "{ \"enableNetworkPolicy\": \"true\" }"
    }
  }
}
