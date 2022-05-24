
locals {
  tenant      = var.tenant      # AWS account name or unique id for tenant
  environment = var.environment # Environment area eg., preprod or prod
  zone        = var.zone        # Environment with in one sub_tenant or business unit


  #vpc_cidr     = var.cidr_block
  #secondary_cidr_blocks = [var.cidr_block2]

  #vpc_name     = join("-", [local.tenant, local.environment, local.zone, "vpc"])
  azs          = slice(data.aws_availability_zones.az.names, 0, 3)
  cluster_name = join("-", [local.tenant, local.environment, local.zone, "eks"])

  terraform_version = "Terraform v1.1.9"
}



provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks_blueprints.eks_cluster_id]
  }
}

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.0.6"

  tenant            = local.tenant
  environment       = local.environment
  zone              = local.zone
  terraform_version = local.terraform_version

  # EKS Cluster VPC and Subnet mandatory config
  vpc_id  =  data.terraform_remote_state.net.outputs.eks-vpc

  private_subnet_ids = data.terraform_remote_state.net.outputs.eks-priv-subnets

  # EKS CONTROL PLANE VARIABLES
  cluster_version = var.eks_version

  # Step 1. Set cluster API endpoint both private and public
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Step 2. Change cluster endpoint to private only, comment out the above lines and uncomment the below lines.
  # cluster_endpoint_public_access  = false
  # cluster_endpoint_private_access = true

  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    mg_4 = {
      node_group_name = "managed-ondemand"
      instance_types  = ["m5.large"]
      subnet_ids      = data.terraform_remote_state.net.outputs.eks-priv-subnets
    }
  }
}
