variable "eks_node_group_role" {
  description = "Role for EKS cluster's nodes to authenticate."
  type = string
  default = "karpenter-eks-node-group-20240902071908084500000002"
}


variable "account_id" {
  description = "AWS user's account ID."
  type = string
  default = ""
}

