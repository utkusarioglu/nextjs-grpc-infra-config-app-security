module "vault" {
  source = "./modules/vault"

  helm_timeout_unit = var.helm_timeout_unit
  helm_atomic       = var.helm_atomic
  deployment_mode   = var.deployment_mode
  tld               = var.tld
  sld               = var.sld
  vault_subdomain   = "vault"
  assets_path       = var.assets_path
  secrets_path      = var.secrets_path
}
