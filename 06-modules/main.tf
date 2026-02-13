terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
    }
  }
}

module "aci-tenant-scaffold" {
  source = "./modules/aci-tenant-skeleton"

  tenant = {
    name = "aardvark-1"
    description = "Demo tenant for DEVNET TF Module discussion"
  }

  subnet = {
    cidr_block = "10.10.10.1/24"
  }
}