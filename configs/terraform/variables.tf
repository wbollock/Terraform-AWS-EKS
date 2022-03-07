variable "access_key" {
  description = "AWS IAM access key"
  type        = string
}

variable "secret_key" {
  description = "AWS IAM secret key"
  type        = string
}

variable "region" {
  default     = "us-east-1"
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  default = "wordpress-prod"
  type    = string
}

variable "iam_arn" {
  default = "null"
  type    = string
}

variable "vpc_name" {
  default = "wordpress-vpc"
  type    = string
}
