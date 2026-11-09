terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}

# Address and token come from VAULT_ADDR / VAULT_TOKEN env vars
provider "vault" {}

data "vault_kv_secret_v2" "aci_creds" {
  mount = "kv"
  name  = "aci-prod"
}

module "aci-tenant-scaffold" {
  source = "./modules/aci-tenant-skeleton"

  user = {
    username = data.vault_kv_secret_v2.aci_creds.data["username"]
    password = data.vault_kv_secret_v2.aci_creds.data["password"]
    url      = "https://198.18.133.101"
  }

  tenant = {
    name = "aardvark-1"
    description = "Demo tenant for DEVNET TF Module discussion"
  }

  subnet = {
    cidr_block = "10.10.10.1/24"
  }
}