
locals {
  tenant      = var.tenant      # AWS account name or unique id for tenant
  environment = var.environment # Environment area eg., preprod or prod
  zone        = var.zone        # Environment with in one sub_tenant or business unit
  azs          = slice(data.aws_availability_zones.az.names, 0, 3)
  cluster_name = join("-", [local.tenant, local.environment, local.zone, "eks"])

  terraform_version = "Terraform v1.1.9"
}


module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.0.6"

  tenant            = local.tenant
  environment       = local.environment
  zone              = local.zone
  terraform_version = local.terraform_version

  #cluster_ip_family = "ipv6"
  # EKS Cluster VPC and Subnet mandatory config
  vpc_id  =  data.terraform_remote_state.net.outputs.eks-vpc

  private_subnet_ids = data.terraform_remote_state.net.outputs.eks-priv-subnets

  # EKS CONTROL PLANE VARIABLES
  cluster_version = var.eks_version

  # Step 1. Set cluster API endpoint both private and public
  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true

  # Step 2. Change cluster endpoint to private only, comment out the above lines and uncomment the below lines.
  # cluster_endpoint_public_access  = false
  # cluster_endpoint_private_access = true

  #----------------------------------------------------------------------------------------------------------#
  # Security groups used in this module created by the upstream modules terraform-aws-eks (https://github.com/terraform-aws-modules/terraform-aws-eks).
  #   Upstream module implemented Security groups based on the best practices doc https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html.
  #   So, by default the security groups are restrictive. Users needs to enable rules for specific ports required for App requirement or Add-ons
  #   See the notes below for each rule used in these examples
  #----------------------------------------------------------------------------------------------------------#
  node_security_group_additional_rules = {
    # Extend node-to-node security group rules. Recommended and required for the Add-ons
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    #Recommended outbound traffic for Node groups
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    # for SSM allow incoming 443
    ingress_https_all = {
      description = "https from infra subnet - would be better with vpce SG"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks      = ["100.64.0.0/16"]
    }
    ingress_ssh_def = {
      description = "ssh from def subnet - would be better with vpce SG"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      type        = "ingress"
      cidr_blocks = ["172.31.0.0/16"]
    }
    #Recommended outbound traffic for Node groups
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }





    # Allows Control Plane Nodes to talk to Worker nodes on all ports. Added this to simplify the example and further avoid issues with Add-ons communication with Control plane.
    # This can be restricted further to specific port based on the requirement for each Add-on e.g., metrics-server 4443, spark-operator 8080, karpenter 8443 etc.
    # Change this according to your security requirements if needed
    ingress_cluster_to_node_all_traffic = {
      description                   = "Cluster API to Nodegroup all traffic"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
  # this is the secondary cluster SG (additional one)
  cluster_security_group_additional_rules = {
    # EKS nodes
    ingress_cluster_to_def_vpc = {
      description                   = "Cluster API to def vpc"
      protocol                      = "tcp"
      from_port                     = 443
      to_port                       = 443
      type                          = "ingress"
      cidr_blocks                   = ["172.31.0.0/16"]
    }
  }

# node group here ?


}






