locals {
  deployment_config_presets = {
    all = {
      vault = {
        count = 1
      }
    }
    ethereum_storage = {
      vault = {
        count = 0
      }
    }
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]

  certs = {
    vault = {
      key  = var.tls_key
      cert = var.tls_crt
      ca   = var.ca_crt

      bundle = join("", [
        var.tls_crt,
        var.ca_crt
      ])
    }
  }
}

# file(".certs/intermediate/intermediate.crt"),
# file(".certs/root/root.crt"),
