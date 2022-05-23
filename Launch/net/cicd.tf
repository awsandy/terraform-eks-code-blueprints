locals {


  vpc_cidr_cicd     = "172.30.0.0/16"

}


module "vpc_cicd" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  #name = "vpc-separate-private-route-tables"
  name = "eks-cicd"

  cidr = local.vpc_cidr_cicd
  azs  = local.azs
  
  #public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr_cicd, 8, k)]
  #private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr_cicd, 8, k + 10)]
  public_subnets  = [ "172.30.0.0/24"]

  private_subnets     = ["172.30.10.0/24"]

  #create_private_subnet_route_table    = true

  single_nat_gateway = true
  enable_nat_gateway = true

  tags = {
    "Name"     = "eks-cicd"
    "workshop" = "eks-cicd"
  }
}