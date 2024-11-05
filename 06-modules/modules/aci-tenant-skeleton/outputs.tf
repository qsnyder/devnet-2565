# Output variable definitions
output "vrf" {
  description = "Name of the created VRF"
  value       = aci_vrf.terraform_vrf.name
}

output "bd" {
  description = "Name of the created BD"
  value       = aci_bridge_domain.terraform_bd.name
}
