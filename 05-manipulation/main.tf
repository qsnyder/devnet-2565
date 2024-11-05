locals {
  leafs = {}
  
  session_id = "devnet-2565"

  fabric_inventory = [
    {
      name = "spine1"
      ip   = "10.10.20.171"
      role = "spine"
    },
    {
      name = "spine2"
      ip   = "10.10.20.172"
      role = "spine"
    },
    {
      name = "leaf1"
      ip   = "10.10.20.173"
      role = "leaf"
    },
    {
      name = "leaf2"
      ip   = "10.10.20.174"
      role = "leaf"
    },
    {
      name = "leaf3"
      ip   = "10.10.20.175"
      role = "leaf"
    }
  ]

demo_vrfs = [
  "VRF_A",
  "VRF_B"
]

}