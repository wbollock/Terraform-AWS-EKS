variable "cluster_name" {
  default = "wordpress-prod"
}

variable "region" {
  default     = "us-east-1"
  description = "AWS region"
  type        = string
}

variable "access_key" {
  description = "AWS IAM access key"
  type        = string
}

variable "secret_key" {
  description = "AWS IAM secret key"
  type        = string
}

variable "db_password" {
  description = "Database root password"
  type        = string
}

variable "availability_zones" {
  description = "AZs in use"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "app_cidr" {
  description = "CIDR for application tier"
  default     = "10.0.0.0/16"
}

variable "db_cidr" {
  description = "CIDR for database tier"
  default     = "11.0.0.0/16"
}

variable "app_private_subnets" {
  description = "CIDR used for app private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "app_public_subnets" {
  description = "CIDR used for app public subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "db_private_subnets" {
  description = "CIDR used for db private subnets"
  default     = ["11.0.1.0/24", "11.0.2.0/24", "11.0.3.0/24"]
}

variable "db_public_subnets" {
  description = "CIDR used for db public subnets"
  default     = ["11.0.101.0/24", "11.0.102.0/24", "11.0.103.0/24"]
}
