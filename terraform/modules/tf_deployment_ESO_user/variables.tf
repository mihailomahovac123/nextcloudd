variable "username_for_secrets_reader_user" {
  description = "User with premissions for reading secrets."
  type = string
  default = ""
}

variable "user_policy_name" {
  description = "Policy name for user accessing AWS secrets manager."
  type = string
  default = ""
}

variable "secrets_name" {
  description = "Secret name from secret manager"
  type = string
  default = "" //import from additional module
}

variable "region" {
  description = "Region for storing resources on AWS"
  type = string
  default = ""
}

variable "account_id" {
  description = "ID of the user with grants to access s3 bucket"
  type = string
  default=""
}


