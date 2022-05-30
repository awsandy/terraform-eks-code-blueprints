module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.0.6"

  eks_cluster_id = module.eks_blueprints.eks_cluster_id

  # EKS Addons
  enable_amazon_eks_vpc_cni            = false
  enable_amazon_eks_coredns            = false
  enable_amazon_eks_kube_proxy         = false
  enable_amazon_eks_aws_ebs_csi_driver = false

  #K8s Add-ons
  enable_argocd                       = false
  enable_aws_for_fluentbit            = false
  enable_aws_load_balancer_controller = false
  enable_cluster_autoscaler           = false
  enable_metrics_server               = false
  enable_prometheus                   = false
  enable_karpenter = false
}