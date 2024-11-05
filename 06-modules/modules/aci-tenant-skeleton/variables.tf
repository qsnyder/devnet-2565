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
    type    = map(string)
}

variable "vrf" {
    type    = map(string)
    default = {
    }
}
variable "bd" {
    type    = map(string)
    default = {
    }
}
variable "subnet" {
    type    = map(string)
    default = {
    }
}