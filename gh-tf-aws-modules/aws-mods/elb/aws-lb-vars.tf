# Load Balancer variables 
# Load Balancer Name
variable "elb-name" {
  type    = string
  default = "tf-lb"
}

# Load Balancer Ports 
variable "elb-ports" {
  type    = string
  default = "80"
}

# Load Balancer Internal 
# using false wont be set as an internal lb
# using true make the lb a internal lb
variable "elb-internal" {
  type    = string
  default = "false"
}

# Load Balancer type
# application - application Load Balancer 
# network - network Load Balancer
variable "elb-type" {
  type    = string
  default = "application"
}


# Load Balancer Security Groups 
variable "elb-sg-id" {
  type = list(string)
}

# Load Balancer Subnets
variable "elb-subnets-id" {
  type = list(string)
}

# Load Balancer environment
variable "elb-env" {
  type    = string
  default = "Non-prod"
}


# Target Groups variables 
# Target Groups Name
variable "tg-name" {
  type    = string
  default = "tf-tgroup"
}

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


# Target Groups VPC ID
variable "tg-vpc-id" {
  type = string
}

# Target Groups target types (ip, instance, alb)
variable "tg-target-type" {
  type    = string
  default = "alb"
}

# LISTENER Protocol
variable "elb-list-protocol" {
  type    = string
  default = "HTTP"
}

# LISTENER Ports
variable "elb-list-ports" {
  type    = string
  default = "80"
}

