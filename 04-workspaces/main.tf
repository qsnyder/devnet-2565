terraform {
  required_providers {
    cml2 = {
      source = "registry.terraform.io/ciscodevnet/cml2"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}

# Address and token come from VAULT_ADDR / VAULT_TOKEN env vars
provider "vault" {}

locals {
  cml_server = terraform.workspace == "default" ? "198.18.128.100" : "198.18.129.100"
  cml_secret = terraform.workspace == "default" ? "cml-prod" : "cml-dev"
}

data "vault_kv_secret_v2" "cml_creds" {
  mount = "kv"
  name  = local.cml_secret
}

provider "cml2" {
  address     = "https://${local.cml_server}"
  username    = data.vault_kv_secret_v2.cml_creds.data["username"]
  password    = data.vault_kv_secret_v2.cml_creds.data["password"]
  skip_verify = true
}

resource "cml2_lab" "cisco_demo" {
  title = "Terraform-Demo-${terraform.workspace}"
}

resource "cml2_node" "external" {
  lab_id         = cml2_lab.cisco_demo.id
  nodedefinition = "external_connector"
  label          = "sbx_backend"
  configuration  = "bridge0"
  x              = "-400"
  y              = "-160"
}

resource "cml2_node" "breakout_switch" {
  lab_id         = cml2_lab.cisco_demo.id
  nodedefinition = "unmanaged_switch"
  label          = "breakout_switch"
  x              = "-400"
  y              = "-40"
}

resource "cml2_node" "r1" {
  lab_id         = cml2_lab.cisco_demo.id
  label          = "R1"
  nodedefinition = "iol-xe"
  x              = "-120"
  y              = "-80"
}

resource "cml2_node" "r2" {
  lab_id         = cml2_lab.cisco_demo.id
  label          = "R2"
  nodedefinition = "iol-xe"
  x              = "-200"
  y              = "80"
}

resource "cml2_node" "r3" {
  lab_id         = cml2_lab.cisco_demo.id
  label          = "R3"
  nodedefinition = "iol-xe"
  x              = "-40"
  y              = "80"
}

resource "cml2_link" "ext_2_us" {
  lab_id = cml2_lab.cisco_demo.id
  node_a = cml2_node.external.id
  node_b = cml2_node.breakout_switch.id
}

resource "cml2_link" "us_2_r1" {
  lab_id = cml2_lab.cisco_demo.id
  node_a = cml2_node.breakout_switch.id
  node_b = cml2_node.r1.id
  slot_b = 0
}

resource "cml2_link" "us_2_r2" {
  lab_id = cml2_lab.cisco_demo.id
  node_a = cml2_node.breakout_switch.id
  node_b = cml2_node.r2.id
  slot_b = 0
}

resource "cml2_link" "us_2_r3" {
  lab_id = cml2_lab.cisco_demo.id
  node_a = cml2_node.breakout_switch.id
  node_b = cml2_node.r3.id
  slot_b = 0
}

resource "cml2_link" "r1_2_r2" {
  lab_id = cml2_lab.cisco_demo.id
  node_a = cml2_node.r1.id
  node_b = cml2_node.r2.id
  slot_a = 1
  slot_b = 1
}

resource "cml2_link" "r1_2_r3" {
  lab_id = cml2_lab.cisco_demo.id
  node_a = cml2_node.r1.id
  node_b = cml2_node.r3.id
  slot_a = 2
  slot_b = 1
}

resource "cml2_link" "r2_2_r3" {
  lab_id = cml2_lab.cisco_demo.id
  node_a = cml2_node.r2.id
  node_b = cml2_node.r3.id
  slot_a = 2
  slot_b = 2
}

resource "cml2_lifecycle" "cisco_demo" {
  lab_id = cml2_lab.cisco_demo.id

  depends_on = [
    cml2_node.r1,
    cml2_node.r2,
    cml2_node.r3,
  ]

  configs = {
    "R1" : file("r1.info")
    "R2" : file("r2.info")
    "R3" : file("r3.info")
  }
}

# DHCP-assigned management addresses, as learned by CML on each router.
# Only the MGMT interface (Gi0/0) faces the external connector, so it's
# the only one CML reports an IPv4 address for.
output "mgmt_addresses" {
  value = {
    for n in cml2_lifecycle.cisco_demo.nodes : n.label => flatten([
      for i in n.interfaces : i.ip4 if i.ip4 != null
    ]) if n.nodedefinition == "iol-xe"
  }
}
