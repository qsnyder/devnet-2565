terraform {
  required_providers {
    cml2 = {
      source = "registry.terraform.io/ciscodevnet/cml2"
    }
  }
}

locals {
  cml_server = terraform.workspace == "default" ? "192.168.128.55" : "192.168.128.226"
}

provider "cml2" {
  address     = "https://${local.cml_server}"
  username    = "admin"
  password    = "C1sco12345"
  skip_verify = true
}

resource "cml2_lab" "clams2026" {
  title = "CLAMS2026 DEVNET-3722 - ${terraform.workspace}"
}

resource "cml2_node" "external" {
  lab_id         = cml2_lab.clams2026.id
  nodedefinition = "external_connector"
  label          = "sbx_backend"
  configuration  = "System Bridge"
  x              = "-400"
  y              = "-160"
}

resource "cml2_node" "breakout_switch" {
  lab_id         = cml2_lab.clams2026.id
  nodedefinition = "unmanaged_switch"
  label          = "breakout_switch"
  x              = "-400"
  y              = "-40"
}

resource "cml2_node" "r1" {
  lab_id         = cml2_lab.clams2026.id
  label          = "R1"
  nodedefinition = "iol-xe"
  x              = "-120"
  y              = "-80"
}

resource "cml2_node" "r2" {
  lab_id         = cml2_lab.clams2026.id
  label          = "R2"
  nodedefinition = "iol-xe"
  x              = "-200"
  y              = "80"
}

resource "cml2_node" "r3" {
  lab_id         = cml2_lab.clams2026.id
  label          = "R3"
  nodedefinition = "iol-xe"
  x              = "-40"
  y              = "80"
}

resource "cml2_link" "ext_2_us" {
  lab_id = cml2_lab.clams2026.id
  node_a = cml2_node.external.id
  node_b = cml2_node.breakout_switch.id
}

resource "cml2_link" "us_2_r1" {
  lab_id = cml2_lab.clams2026.id
  node_a = cml2_node.breakout_switch.id
  node_b = cml2_node.r1.id
}

resource "cml2_link" "us_2_r2" {
  lab_id = cml2_lab.clams2026.id
  node_a = cml2_node.breakout_switch.id
  node_b = cml2_node.r2.id
}

resource "cml2_link" "us_2_r3" {
  lab_id = cml2_lab.clams2026.id
  node_a = cml2_node.breakout_switch.id
  node_b = cml2_node.r3.id
}

resource "cml2_link" "r1_2_r2" {
  lab_id = cml2_lab.clams2026.id
  node_a = cml2_node.r1.id
  node_b = cml2_node.r2.id
}

resource "cml2_link" "r1_2_r3" {
  lab_id = cml2_lab.clams2026.id
  node_a = cml2_node.r1.id
  node_b = cml2_node.r3.id
}

resource "cml2_link" "r2_2_r3" {
  lab_id = cml2_lab.clams2026.id
  node_a = cml2_node.r2.id
  node_b = cml2_node.r3.id
}

resource "cml2_lifecycle" "clus2023" {
  lab_id = cml2_lab.clams2026.id

  configs = {
    "R1" : file("r1.info")
    "R2" : file("r2.info")
    "R3" : file("r3.info")
  }
}

