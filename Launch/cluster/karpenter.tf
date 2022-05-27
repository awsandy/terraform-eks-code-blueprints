# Creates Launch templates for Karpenter
# Launch template outputs will be used in Karpenter Provisioners yaml files. Checkout this examples/karpenter/provisioners/default_provisioner_with_launch_templates.yaml

locals {

vpc_name=data.terraform_remote_state.net.outputs.eks-vpv-name
node_group_name=  module.managed_node_groups.node_group_name
}


module "karpenter_launch_templates" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/launch-templates?ref=v4.0.6"
  eks_cluster_id = module.eks_blueprints.eks_cluster_id
  tags           = { Name = "karpenter" }

  launch_template_config = {
    linux = {
      ami                    = data.aws_ami.amazonlinux2eks.id
      launch_template_prefix = "karpenter"
      iam_instance_profile   = module.eks_blueprints.self_managed_node_group_iam_instance_profile_id[0]
      vpc_security_group_ids = [module.eks_blueprints.worker_node_security_group_id]
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          volume_type = "gp3"
          volume_size = "200"
        }
      ]
    },
    bottlerocket = {
      ami                    = data.aws_ami.bottlerocket.id
      launch_template_os     = "bottlerocket"
      launch_template_prefix = "bottle"
      iam_instance_profile   = module.eks_blueprints.self_managed_node_group_iam_instance_profile_id[0]
      vpc_security_group_ids = [module.eks_blueprints.worker_node_security_group_id]
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          volume_type = "gp3"
          volume_size = "200"
        }
      ]
    },
  }
}


# Deploying default provisioner for Karpenter autoscaler
data "kubectl_path_documents" "karpenter_provisioners" {
  pattern = "${path.module}/provisioners/default_provisioner.yaml"
  vars = {
    azs                     = join(",", local.azs)
    iam-instance-profile-id = format("%s-%s", local.cluster_name, local.node_group_name)
    eks-cluster-id          = local.cluster_name
    eks-vpc_name            = local.vpc_name
  }
}

# You can also deploy multiple provisioner files with the below code snippet
# data "kubectl_path_documents" "karpenter_provisioners" {
#   pattern = "${path.module}/provisioners/*.yaml"
# }

#resource "kubectl_manifest" "karpenter_provisioner" {
#  for_each  = toset(data.kubectl_path_documents.karpenter_provisioners.documents)
#  yaml_body = each.value

#  depends_on = [module.eks_blueprints_kubernetes_addons]
#}
