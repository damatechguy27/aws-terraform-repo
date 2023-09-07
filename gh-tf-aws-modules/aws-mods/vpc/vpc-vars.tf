########################################
# NETWORKING VARIABLES
#########################################
variable "vpc_name" {
  type = string
  default = "tfvpc"
}

variable "interGW_name" {
  type = string
  default = "tfintgw"
}

variable "subnet_name" {
  type    = list(string)
  default = ["tfsub0", "tfsub1", "tfsub2", "tfsub3"]

}

variable "pubroute_name" {
  type = string
  default = "tfpubrt"
}

variable "priroute_name" {
  type = string
  default = "tfprivrt"
}



variable "CIDR_IP" {
  type = string
  default = "11.0.0.0/16"

}


variable "PUBSUB_IP" {

  type    = list(string)
  default = ["11.0.0.0/24", "11.0.1.0/24", "11.0.2.0/24", "11.0.3.0/24"]

}

variable "PRIVSUB_IP" {

  type    = list(string)
  default = ["11.1.0.0/24", "11.1.1.0/24", "11.1.2.0/24", "11.1.3.0/24"]

}

variable "avail_name" {

  type    = list(string)
  default = ["us-west-2a", "us-west-2b"]

}

