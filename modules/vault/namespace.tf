resource "kubernetes_namespace" "this" {
  # for_each = toset(["vault"])

  metadata {
    name = "vault"
  }
}
