resource "random_string" "random" {
  length  = 30
  special = false
  lower   = true
  upper   = false
}

resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = "cloudfront-logs-${random_string.random.result}"

  tags = {
    Name        = "Cloudfront_Logs"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_acl" "wordpress-acl" {
  bucket = aws_s3_bucket.cloudfront_logs.id
  acl    = "private"
}

module "cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"

  # aliases = ["${local.subdomain}.${local.domain_name}"]
  aliases = []

  comment             = "Wordpress CDN"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = false

  create_monitoring_subscription = false

  logging_config = {
    bucket = aws_s3_bucket.cloudfront_logs.bucket_domain_name
    prefix = "cloudfront"
  }

  origin = {
    wordpress = {
      # domain_name = "<ELB-FROM-KUBERNETES>"
      domain_name = data.local_file.elb_hostname.content
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "wordpress"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    query_string           = true

    # This is id for SecurityHeadersPolicy copied from https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-response-headers-policies.html
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }
}
