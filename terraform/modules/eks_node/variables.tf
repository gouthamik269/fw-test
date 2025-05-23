variable "node-role_name" {}
variable "node-role_arn" {}
variable "vpc_subnets" {}
variable "eks_version" {}
variable "instance_type" {}
variable "eks_cluster_name" {}
variable "cluster_base_name" {}
variable "node_group_name" {
  default = ""
}

variable "max_size" {
}

variable "desired_size" {
}

variable "min_size" {
}

variable "taints" {
  description = "The Kubernetes taints to be applied to the nodes in the node group. Maximum of 50 taints per node group"
  type        = any
  default     = {}
}

variable "labels" {
  description = "Key-value map of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed"
  type        = map(string)
  default     = null
}


variable "disk_size" {
  description = "Disk size in GiB for nodes. Defaults to `20`."
  type        = number
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

