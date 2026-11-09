terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}

# Address and token come from VAULT_ADDR / VAULT_TOKEN env vars
provider "vault" {}

variable "kv_mount" {
  type    = string
  default = "kv"
}

# List every secret name at the root of the mount
data "vault_kv_secrets_list_v2" "all" {
  mount = var.kv_mount
}

locals {
  # names is marked sensitive; for_each can't key on sensitive values.
  # Entries ending in "/" are sub-folders, not secrets - skip them.
  secret_names = toset([
    for n in nonsensitive(data.vault_kv_secrets_list_v2.all.names) : n
    if !endswith(n, "/")
  ])
}

data "vault_kv_secret_v2" "each" {
  for_each = local.secret_names
  mount    = var.kv_mount
  name     = each.key
}

output "secrets" {
  value = {
    for name, s in data.vault_kv_secret_v2.each :
    name => nonsensitive(s.data)
  }
}

