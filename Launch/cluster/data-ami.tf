locals {
amazonlinux2eks = "amazon-eks-node-${var.eks_version}-*"
bottlerocket    = "bottlerocket-aws-k8s-${var.eks_version}-x86_64-*"
}

data "aws_ami" "amazonlinux2eks" {
  most_recent = true
  filter {
    name   = "name"
    values = [local.amazonlinux2eks]
  }
  owners = ["amazon"]
}

data "aws_ami" "bottlerocket" {
  most_recent = true
  filter {
    name   = "name"
    values = [local.bottlerocket]
  }
  owners = ["amazon"]
}
