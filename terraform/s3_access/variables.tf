variable "region" {
  default = "eu-central-1"
}
variable "cluster_oidc_id" {
  default = "https://oidc.eks.eu-central-1.amazonaws.com/id/9BF18955F2CB5DB9D497C2A7C24367DB"
}
variable "namespace" {
  default = "default"
}

variable "service_account_name" {
  default="futureserviceaccount" //tek ce biti kreiran
}

variable "account_id" {
  default = "976552365380"
}