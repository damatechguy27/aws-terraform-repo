# Target Groups variables 
# Target Groups Name
/*
variable "tg-name" {
  type    = string
  default = "tf-tgroup"
}

# Target Groups VPC ID
variable "tg-vpc-id" {
  type = string
}
*/
# Target Groups Ports
variable "tg-ports" {
  type    = string
  default = "80"
}

# Target Groups Protocol
variable "tg-protocol" {
  type    = string
  default = "HTTP"
}




# Target Groups target types (ip, instance, alb)
variable "tg-target-type" {
  type    = list(string)
  default = ["alb", "ip", "instance"]
}