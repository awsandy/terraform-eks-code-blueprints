resource "aws_security_group" "eks-cicd-sg" {
  description = "eks-cicd all"
  vpc_id      = module.vpc_cicd.vpc_id
  tags = {
    "Name"     = "eks-cicd-all"
    "workshop" = "eks-cicd"
  }
}
