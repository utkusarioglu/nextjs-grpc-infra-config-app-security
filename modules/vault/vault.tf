resource "helm_release" "vault" {
  count           = local.deployment_configs.vault.count
  name            = "vault"
  repository      = "https://helm.releases.hashicorp.com"
  chart           = "vault"
  version         = "0.22.0"
  namespace       = kubernetes_namespace.this.metadata[0].name
  cleanup_on_fail = true
  lint            = true
  atomic          = var.helm_atomic
  timeout         = var.helm_timeout_unit

  values = [
    yamlencode({
      global = {
        enabled    = true
        tlsDisable = true
        # serverTelemetry = {
        #   prometheusOperator = true
        # }
      }
      server = {
        dataStorage = {
          enabled = true
        }
        auditStorage = {
          enabled = true
        }
        nodeSelector = {
          vault_in_k8s = "true"
        }
        affinity = {
          podAntiAffinity = {
            requiredDuringSchedulingIgnoredDuringExecution = [
              {
                labelSelector = {
                  matchLabels = {
                    "app.kubernetes.io/name"     = "vault"
                    "app.kubernetes.io/instance" = "vault"
                    "component"                  = "server"
                  }
                }
                topologyKey = "kubernetes.io/hostname"
              },
              {
                labelSelector = {
                  matchLabels = {
                    "app.kubernetes.io/name"     = "vault"
                    "app.kubernetes.io/instance" = "vault"
                    "component"                  = "server"
                  }
                }
                topologyKey = "topology.kubernetes.io/zone"
              }
            ]
          }
        }

        ha = {
          enabled  = true
          replicas = 3
          raft = {
            enabled   = true
            setNodeId = true
            config    = <<-EOF
              ui = true
              api_addr = "http://vault-ui.${var.sld}.${var.tld}:8200"
              cluster_addr = "http://vault-0.vault-internal:8201"

              listener "tcp" {
                address     = "[::]:8200"
                cluster_address = "[::]:8201"
                tls_disable = 1
                
                telemetry {
                  unauthenticated_metrics_access = "true"
                }
              }

              storage "raft" {
                path = "/vault/data"
                setNodeId = true

                retry_join {
                  leader_api_addr = "http://vault-0.vault-internal:8200"
                }

                retry_join {
                  leader_api_addr = "http://vault-1.vault-internal:8200"
                }

                retry_join {
                  leader_api_addr = "http://vault-2.vault-internal:8200"
                }

                autopilot {
                  cleanup_dead_servers = "true"
                  last_contact_threshold = "200ms"
                  last_contact_failure_threshold = "10m"
                  max_trailing_logs = 250000
                  min_quorum = 3
                  server_stabilization_time = "10s"
                }
              }

              service_registration "kubernetes" {}
            EOF
          }
        }
      }

      injector = {
        enabled = true
        agentDefaults = {
          metrics = {
            enabled = true
          }
        }
      }

      ui = {
        enabled         = true
        serviceType     = "LoadBalancer"
        serviceNodePort = null
        externalPort    = 8200
      }
    })
  ]
}
