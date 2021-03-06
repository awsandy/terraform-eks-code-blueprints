# TF_VAR_region
variable "region" {
  description = "The name of the AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "profile" {
  description = "The name of the AWS profile in the credentials file"
  type        = string
  default     = "default"
}

variable "cluster-name" {
  description = "The name of the EKS Cluster"
  type        = string
  default     = "mycluster1"
}

variable "eks_version" {
  type    = string
  default = "1.22"
}

variable "no-output" {
  description = "The name of the EKS Cluster"
  type        = string
  default     = "secret"
  sensitive   = true
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block for the VPC."
}

variable "cidr_block2" {
  type        = string
  default     = "100.64.0.0/16"
  description = "The CIDR block for the VPC."
}


variable "availability_zones" {
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  description = "The availability zones to create subnets in"
}

variable "az_counts" {
  default = 3
}


variable "tenant" {
  type        = string
  description = "Account Name or unique account unique id e.g., apps or management or aws007"
  default     = "aws001"
}

variable "environment" {
  type        = string
  default     = "preprod"
  description = "Environment area, e.g. prod or preprod "
}

variable "zone" {
  type        = string
  description = "zone, e.g. dev or qa or load or ops etc..."
  default     = "dev"
}


variable "managed_node_group_name" {
  type        = string
  description = "managed node group name"
  default     = "managed_node"
}




