resource "aws_security_group" "cluster-sg" {
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = module.vpc_eks.vpc_id
  tags = {
    "Name" = format("eks-%s-cluster/ControlPlaneSecurityGroup",var.cluster-name)
    "Label" = "TF-EKS Control Plane & all worker nodes comms"
  }
}


