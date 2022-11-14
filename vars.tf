variable "helm_timeout_unit" {
  type = number
}

variable "helm_atomic" {
  type = bool
}

variable "sld" {
  type = string
}

variable "tld" {
  type = string
}

# variable "persistent_volumes_root" {
#   type        = string
#   description = "Root folder for all the persistent volumes attached to nodes"
# }

variable "deployment_mode" {
  type        = string
  description = "Specify a mode that determines which resources will be deployed. Example: 'all' deploys everything"
}

variable "secrets_path" {
  type        = string # path
  description = "Root path where the configuration secrets are kept"
}

variable "assets_path" {
  type        = string # path
  description = "Root path where the non-secrets assets for the configuration are kept"
}
