output "vrf_name" {
  description = "name of the defined VRF"
  value = module.aci-tenant-scaffold.vrf
}

output "bd_name" {
  description = "name of the defined BD"
  value = module.aci-tenant-scaffold.bd
}