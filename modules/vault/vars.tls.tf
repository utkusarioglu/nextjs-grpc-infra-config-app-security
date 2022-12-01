variable "tls_key" {
  type        = string
  description = "key for the tls cert for Vault Api"
  sensitive   = true
}

variable "tls_crt" {
  type        = string
  description = "cert for Vault Api"
}

variable "ca_crt" {
  type        = string
  description = "CA for the Vault Api"
}
