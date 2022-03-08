module "wordpress-prod" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = var.cluster_name
  subnet_ids   = module.app_vpc.private_subnets
  vpc_id       = module.app_vpc.vpc_id

  eks_managed_node_groups = {
    prod = {
      instance_types = ["t2.small"]
      min_size       = 1
      max_size       = 3
      desired_size   = 3

      create_launch_template = false
      launch_template_name   = ""

      pre_bootstrap_user_data = <<-EOT
      echo "foo"
      export FOO=bar
      EOT

      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"

      post_bootstrap_user_data = <<-EOT
      cd /tmp
      sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      sudo systemctl enable amazon-ssm-agent
      sudo systemctl start amazon-ssm-agent
      EOT

      tags = {
        key                 = "Name"
        value               = "wordpress-worker"
        propagate_at_launch = true
      }
    }
  }

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  tags = {
    environment = "prod"
  }
}
