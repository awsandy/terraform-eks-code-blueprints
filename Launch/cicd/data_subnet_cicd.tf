data "aws_subnet" "cicd" {
  id = data.terraform_remote_state.net.outputs.cicd-priv-sub
  #filter {
  #  name   = "tag:workshop"
  #  values = ["cicd-private1"]
  #}
}