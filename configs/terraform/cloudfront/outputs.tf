output "cloudfront_endpount" {
  value = module.cloudfront.cloudfront_distribution_domain_name
}

data "local_file" "elb_hostname" {
  filename = "${path.module}/elb_hostname"
}

output "elb_hostname" {
  value = data.local_file.elb_hostname.content
}
