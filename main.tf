module "vault" {
  source = "./modules/vault"

  # project_root_path = local.project_root_path
  helm_timeout_unit = var.helm_timeout_unit
  helm_atomic       = var.helm_atomic
  deployment_mode   = var.deployment_mode
  tld               = var.tld
  sld               = var.sld
}
