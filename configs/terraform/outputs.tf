
locals {
  config_map = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.wordpress-workers.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: ${var.iam_arn}
      username: designated_role
      groups:
        - system:masters
CONFIGMAPAWSAUTH
}
# output "cluster_id" {
#   description = "EKS cluster ID"
#   value       = module.eks.cluster_id
# }

output "cluster_endpoint" {
  description = "Endpoint for EKS"
  value       = module.eks.cluster_endpoint
}

# output "cluster_security_group_id" {
#   description = "Security group ids attached to the cluster control plane."
#   value       = module.eks.cluster_security_group_id
# }

# output "kubeconfig" {
#   description = "Kubectl configuration"
#   value       = local.kubeconfig
# }

# output "config_map_aws" {
#   description = "Config Map for EKS to autoscale"
#   value       = module.eks.config_map_aws_auth
# }

# output "region" {
#   description = "AWS region"
#   value       = var.region
# }

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = var.cluster_name
}

output "config_map" {
  description = "Config map to allow EKS to autoscale"
  value       = local.config_map
}
