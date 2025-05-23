variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "db_subnet_ids" {
  description = "List of subnet IDs for RDS subnet group"
  type        = list(string)
}


variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "RDS allocated storage (GB)"
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Multi-AZ deployment?"
  type        = bool
  default     = false
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15.4"
}

variable "availability_zones" {
  type = list(string)
}

variable "rds-cidr_block"{}

variable "rds-sg" {}

variable "vpc_id" {}