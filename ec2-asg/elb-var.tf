
variable "is-internal" {
    type = bool
    default = false
  
}

variable "elb-type" {
    type = list(string)
    default = [ "application", "network" ]
  
}


#listner variables ports and protocols
variable "elb-list-ports" {
    type = number
    default = 80
  
}

variable "elb-list-protocol" {
  type    = string
  default = "HTTP"
}