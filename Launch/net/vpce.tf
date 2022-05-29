# autoscaling-y
# ec2-y,ec2messages-y
# ecr.api-y, ecr.dkr-y
# elasticloadbalancing-y
# logs-y, s3-y 
# ssm-y , ssmmessages
# sts -y 
# kms-y

# ssmmessages



module "vpc_endpoint_gateway" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "v3.2.0"

  create = true
  vpc_id = module.aws_vpc.vpc_id

  endpoints = {
    s3 = {
      service      = "s3"
      service_type = "Gateway"
      route_table_ids = flatten([
        module.aws_vpc.intra_route_table_ids,
      module.aws_vpc.private_route_table_ids])
      tags = { Name = "s3-vpc-Gateway" }
    },
  }
}


module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "v3.2.0"
  create  = true
  vpc_id  = module.aws_vpc.vpc_id
  security_group_ids = [
  data.aws_security_group.default.id]
  subnet_ids = module.aws_vpc.intra_subnets

  endpoints = {
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
    },
    logs = {
      service             = "logs"
      private_dns_enabled = true
    },
    autoscaling = {
      service             = "autoscaling"
      private_dns_enabled = true
    },
    sts = {
      service             = "sts"
      private_dns_enabled = true
    },
    elasticloadbalancing = {
      service             = "elasticloadbalancing"
      private_dns_enabled = true
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
    },
    kms = {
      service             = "kms"
      private_dns_enabled = true
    }
    xray = {
      service             = "xray"
      private_dns_enabled = true
    }
    appmesh-envoy-management = {
      service             = "appmesh-envoy-management"
      private_dns_enabled = true
    }
  }
  tags = {
    Project  = "EKS"
    Endpoint = "true"
  }
}

