##### VPC information 
variable "vpc_names" {
    type = list(string)
    default = ["mars", "saturn"]
  
}


## enabling Hostnames 
variable "enable_hostnames" {
    type = bool
    default = true
  
}





variable "cidr_ip" {
    type = string
    default = "10.0.0.0/16"
  
}

# public subent information
variable "map_ip_enable" {
    type = bool
    default = true
  
}

variable "pub_subnets" {

    type = map(object({
      cidr_block = string
      availability_zone= string
    }))
    default = {
      "pub_subnet1" = {
        cidr_block="10.0.1.0/24"
        availability_zone="us-west-2a"        
      }
      "pub_subnet2" = {
        cidr_block="10.0.2.0/24"
        availability_zone="us-west-2b"        
      }
    }
  
}

variable "priv_subnets" {

    type = map(object({
      cidr_block = string
      availability_zone= string
    }))
    default = {
      "priv_subnet1" = {
        cidr_block="10.0.100.0/24"
        availability_zone="us-west-2a"        
      }
      "priv_subnet2" = {
        cidr_block="10.0.200.0/24"
        availability_zone="us-west-2b"        
      }
    }
  
}



