resource "aws_iam_role" "wordpress-cluster" {
  name = "terraform-eks-wordpress-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "wordpress-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.wordpress-cluster.name
}

resource "aws_iam_role_policy_attachment" "wordpress-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.wordpress-cluster.name
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = var.cluster_name
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    disk_size      = 10
    instance_types = ["t2.small"]
    # iam_role_additional_policies = aws_iam_role.wordpress-workers.arn
    # vpc_security_group_ids = [aws_security_group.additional.id]
  }

  eks_managed_node_groups = {
    prod = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      additional_security_group_ids = [aws_security_group.worker_group_application.id]
    }
  }

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}
