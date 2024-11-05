variable "user" {
  description = "Login information"
  type        = map
  default     = {
    username = "admin"
    password = "!v3G@!4@Y"
    url      = "https://sandboxapicdc.cisco.com"
  }
}
variable "tenant" {
    type    = string
    default = "aardvark-8"
}
variable "vrf" {
    type    = string
    default = "vrf"
}
variable "bd" {
    type    = string
    default = "bd"
}
variable "subnet" {
    type    = string
    default = "10.100.1.1/24"
}
