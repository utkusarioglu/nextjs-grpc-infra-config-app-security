resource "tls_private_key" "vault_api_pk" {
  count = local.deployment_configs.vault.count

  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "vault_api_csr" {
  count = local.deployment_configs.vault.count

  private_key_pem = tls_private_key.vault_api_pk[0].private_key_pem

  subject {
    common_name  = "vault.${var.sld}.${var.tld}"
    organization = "nextjs-grpc"
  }

  dns_names = [
    "vault.${var.sld}.${var.tld}",
    "vault-0.vault-internal",
    "vault-1.vault-internal",
    "vault-2.vault-internal",

    # "vault-0.vault-active",
    # "vault-1.vault-active",
    # "vault-2.vault-active",
  ]

  ip_addresses = [
    "127.0.0.1"
  ]
}

resource "tls_locally_signed_cert" "vault_api" {
  count = local.deployment_configs.vault.count

  cert_request_pem   = tls_cert_request.vault_api_csr[0].cert_request_pem
  ca_cert_pem        = file(".certs/intermediate/intermediate.crt")
  ca_private_key_pem = file(".certs/intermediate/intermediate.key")

  validity_period_hours = 12

  allowed_uses = [
    "server_auth",
  ]
}

resource "kubernetes_secret" "vault_api_tls_cert" {
  count = local.deployment_configs.vault.count

  metadata {
    name      = "vault-api-tls-cert"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  type = "kubernetes.io/tls"
  data = {
    "tls.key" = tls_private_key.vault_api_pk[0].private_key_pem
    "tls.crt" = join("", [
      tls_locally_signed_cert.vault_api[0].cert_pem,
      file(".certs/intermediate/intermediate.crt"),
      file(".certs/root/root.crt"),
    ])
    "ca.crt" = file(".certs/root/root.crt")
  }
}
