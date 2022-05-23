data "aws_route_table" "cicd-rtb" {
  vpc_id = data.aws_vpc.vpc-cicd.id
  route_table_id=data.terraform_remote_state.net.outputs.cicd-priv-rtb
  #filter {
  #  name   = "tag:Name"
  #  values = ["rtb-eks-cicd-priv1"]
  #}
}







