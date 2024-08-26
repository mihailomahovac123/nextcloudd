variable "ebs_size" {
  description = "EBS volume for persistent volumes on EKS"
  type = number
  default = 10
}