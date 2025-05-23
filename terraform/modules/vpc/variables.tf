variable "region" {
  description = "Working region"
}

variable "resource" {
  type = string
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Whether to create a NAT Gateway"
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}
variable "vpc_subnet_prefix" {
  description = "The first two octets of the CIDR block (e.g., 10.10, 10.20)"
  type        = string
}

