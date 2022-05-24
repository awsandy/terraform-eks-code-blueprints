output "eks-vpc" {
  value = module.vpc_eks.vpc_id
}

output "cicd-vpc" {
  value = module.vpc_cicd.vpc_id
}

output "eks-cidr" {
  value = module.vpc_eks.vpc_cidr_block
}

output "sub-isol1" {
  value = aws_subnet.subnet-i1.id
}

output "sub-isol2" {
  value = aws_subnet.subnet-i2.id
}

output "sub-isol3" {
  value = aws_subnet.subnet-i3.id
}

output "priv-rtbs" {
  value = module.vpc_eks.private_route_table_ids
}

output "rtb-priv1" {
  value = module.vpc_eks.private_route_table_ids[0]
}

output "rtb-priv2" {
  value = module.vpc_eks.private_route_table_ids[1]
}

output "rtb-priv3" {
  value = module.vpc_eks.private_route_table_ids[2]
}

output "cicd-priv-rtb" {
  value = module.vpc_cicd.private_route_table_ids[0]
}

output "cicd-priv-sub" {
  value = module.vpc_cicd.private_subnets[0]
}

output "allnodes-sg" {
  value = aws_security_group.allnodes-sg.id
}

output "cluster-sg" {
  value = aws_security_group.cluster-sg.id
}

output "eks-priv-subnets" {
  value = module.vpc_eks.private_subnets
}



