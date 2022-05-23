

locals {
  tenant      = var.tenant      # AWS account name or unique id for tenant
  environment = var.environment # Environment area eg., preprod or prod
  zone        = var.zone        # Environment with in one sub_tenant or business unit


  vpc_cidr     = var.cidr_block
  secondary_cidr_blocks = [var.cidr_block2]

  vpc_name     = join("-", [local.tenant, local.environment, local.zone, "vpc"])
  azs          = slice(data.aws_availability_zones.az.names, 0, 3)
  cluster_name = join("-", [local.tenant, local.environment, local.zone, "eks"])

  terraform_version = "Terraform v1.1.9"
}


module "vpc_eks" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.vpc_name
  cidr = local.vpc_cidr
  azs  = local.azs

  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  #module won't accept secondary cidr for subnets - 400 error on apply - create externally
  #intra_subnets = [for k, v in local.azs : cidrsubnet(local.secondary_cidr_blocks[0], 8, k)]

  
  enable_ipv6                                    = true
  assign_ipv6_address_on_creation                = true # Assign IPv6 address on subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  private_subnet_assign_ipv6_address_on_creation = true # Assign IPv6 address on private subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch

  #intra_subnet_ipv6_prefixes  = [0, 1, 2] # Assigns IPv6 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list
  private_subnet_ipv6_prefixes = [3, 4, 5] # Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list

  enable_nat_gateway   = false
  create_igw           = false
  create_egress_only_igw = false
  single_nat_gateway   = false

  enable_dns_hostnames = true

  intra_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }


  manage_default_security_group = true

  default_security_group_name = "${local.vpc_name}-endpoint-secgrp"
  default_security_group_ingress = [
    {
      protocol    = -1
      from_port   = 0
      to_port     = 0
      cidr_blocks = local.vpc_cidr
  }]
  default_security_group_egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = "0.0.0.0/0"
  }]
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc_eks.vpc_id
}




