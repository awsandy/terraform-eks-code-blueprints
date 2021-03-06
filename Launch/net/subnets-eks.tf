# File generated by aws2tf see https://github.com/aws-samples/aws2tf

# aws_subnet.subnet-i1:
resource "aws_subnet" "subnet-i1" {
  depends_on=[aws_vpc_ipv4_cidr_block_association.vpc-cidr-assoc]
  #assign_ipv6_address_on_creation = true

  availability_zone               = data.aws_availability_zones.az.names[0]
  cidr_block                      = "100.64.0.0/18"
  ipv6_cidr_block = "${cidrsubnet(module.vpc_eks.vpc_ipv6_cidr_block, 8, 0)}"
  assign_ipv6_address_on_creation = true
  
  map_public_ip_on_launch         = false
  tags = {
    "Name"                                        = format("i1-%s",var.cluster-name)
    "kubernetes.io/cluster/${var.cluster-name}"            = "shared"
     "workshop" = "subnet-i1"
  }
  vpc_id = module.vpc_eks.vpc_id

  timeouts {}
}


resource "aws_subnet" "subnet-i2" {
  depends_on=[aws_vpc_ipv4_cidr_block_association.vpc-cidr-assoc]
  #assign_ipv6_address_on_creation = true

  availability_zone               = data.aws_availability_zones.az.names[1]
  cidr_block                      = "100.64.64.0/18"
  ipv6_cidr_block = "${cidrsubnet(module.vpc_eks.vpc_ipv6_cidr_block, 8, 1)}"
  assign_ipv6_address_on_creation = true
  
  map_public_ip_on_launch         = false
  tags = {
    "Name"                                        = format("i2-%s",var.cluster-name)
    "kubernetes.io/cluster/${var.cluster-name}"            = "shared"
     "workshop" = "subnet-i2"
  }
  vpc_id = module.vpc_eks.vpc_id

  timeouts {}
}




resource "aws_subnet" "subnet-i3" {
  depends_on=[aws_vpc_ipv4_cidr_block_association.vpc-cidr-assoc]
  #assign_ipv6_address_on_creation = true

  availability_zone               = data.aws_availability_zones.az.names[2]
  cidr_block                      = "100.64.128.0/18"
  ipv6_cidr_block = "${cidrsubnet(module.vpc_eks.vpc_ipv6_cidr_block, 8, 2)}"
  assign_ipv6_address_on_creation = true
  
  map_public_ip_on_launch         = false
  tags = {
    "Name"                                        = format("i3-%s",var.cluster-name)
    "kubernetes.io/cluster/${var.cluster-name}"            = "shared"
     "workshop" = "subnet-i3"
  }
  vpc_id = module.vpc_eks.vpc_id

  timeouts {}
}


