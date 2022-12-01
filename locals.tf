locals {
  certs = {
    intermediate = {
      key  = file(".certs/intermediate/intermediate.key")
      cert = file(".certs/intermediate/intermediate.crt")

    }
    ca = {
      cert = file(".certs/root/root.crt"),
    }
  }
}
