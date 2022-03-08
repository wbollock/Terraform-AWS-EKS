variable "access_key" {
  description = "AWS IAM access key"
  type        = string
}

variable "secret_key" {
  description = "AWS IAM secret key"
  type        = string
}

# variable "cloudfront_domain" {
#   description = "ELB cloudfront domain"
#   type = string
# }

variable "region" {
  default     = "us-east-1"
  description = "AWS region"
  type        = string
}