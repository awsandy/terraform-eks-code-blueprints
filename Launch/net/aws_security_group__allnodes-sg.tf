resource "aws_security_group" "allnodes-sg" {
  description = "Communication between all nodes in the cluster"
  vpc_id      = module.vpc_eks.vpc_id
  tags = {
    "Name"   = format("eks-%s-cluster/ClusterSharedNodeSecurityGroup",var.cluster-name)
    "Label"  = "TF-EKS All Nodes Comms"
  }
}

