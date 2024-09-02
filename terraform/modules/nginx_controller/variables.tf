variable "name" {
description = "Chart name."
type = string
default = "ingress-nginx"
}

variable "repository" {
description = "Repository name."
type = string
default = "https://kubernetes.github.io/ingress-nginx"
}

variable "chart" {
description = "Chart name."
type = string
default = "ingress-nginx"
}

variable "namespace" {
description = "Nemaspace"
type = string
default = "ingress-nginx"
}