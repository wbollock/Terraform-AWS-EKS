
resource "aws_eip" "nat" {
  count = 3

  vpc = true
}

module "app_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "wordpress-app-vpc"
  cidr = var.app_cidr

  azs             = var.availability_zones
  private_subnets = var.app_private_subnets
  public_subnets  = var.app_public_subnets

  enable_nat_gateway   = true
  enable_vpn_gateway   = true
  enable_dns_hostnames = true
  reuse_nat_ips        = true
  external_nat_ip_ids  = aws_eip.nat.*.id

  tags = {
    Context                                     = "wordpress-app"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

module "db_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "wordpress-db-vpc"
  cidr = var.db_cidr

  azs             = var.availability_zones
  private_subnets = var.db_private_subnets
  public_subnets  = var.db_public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true
  single_nat_gateway = true

  tags = {
    Context = "wordpress-rds"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}
