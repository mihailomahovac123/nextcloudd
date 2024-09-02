variable "name" {
  description = "Persistant volume name."
  type = string
  default = "ebs-pv1"
}

variable "access_mode" {
  description = "PV Access Mode."
  type = string
  default = "ReadWriteOnce"
}

variable "storage" {
  description = "PV's storage capacity."
  type = string
  default = "8Gi"
}

variable "driver" {
  description = "AWS EBS driver."
  type = string
  default = "ebs.csi.aws.com"
}

variable "volume_handle" {
  description = "Volume ID from AWS EBS volume."
  type = string
  default = "" //depends on
}

variable "storage_class_name" {
  description = "Name of the storage class."
  type = string
  default = "gp2" 
}

variable "persistent_volume_reclaim_policy" {
  description = "Persistent volume's reclaim policy."
  type = string
  default = "Retain"
}



