variable "user" {
  description = "Login information"
  type        = map
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
