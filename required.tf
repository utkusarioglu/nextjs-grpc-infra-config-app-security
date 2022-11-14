terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.14.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.2.3"
    }
  }
}
