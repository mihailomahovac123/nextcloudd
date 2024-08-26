variable "region" {
  default = "eu-central-1"
}
variable "cluster_oidc_id" {
  default = "https://oidc.eks.eu-central-1.amazonaws.com/id/2E5778C6EBF10ACE8AA57B0CDEED4A14"
}
variable "namespace" {
  default = "default"
}

variable "service_account_name" {
  default="myfutuerroute53serviceaccount" //tek ce biti kreiran
}

variable "account_id" {
  default = "976552365380"
}