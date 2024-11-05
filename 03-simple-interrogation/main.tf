locals {
  leafs = {}
  
  session_id = "devnet-2565"

  user = {
    description = "Login information for DCNM/NDFC"
    username    = "admin"
    password    = "Cisco1234!"
    url         = "https://10.10.20.18"
  }
  fabric = {
    description = "Desired fabric for Terraform"
    name        = "DevNet_Fabric"
  }

  leaf4 = {
    description = "Information for leaf4 switch within Devnet Sandbox"
    username    = "cisco"
    password    = "cisco12345"
    ip          = "10.10.20.176"
    role        = "leaf"
  }
}