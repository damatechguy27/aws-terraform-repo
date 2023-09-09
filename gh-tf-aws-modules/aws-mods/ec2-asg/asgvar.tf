
########################################
# KEYPAIR VARIABLES
#########################################
#enter the path to store your pem key locally on your PC
variable "key_path" {
  default = "/home/user1/Documents/terrform-sshkey/tfAWS-keypair.pem"
}
#enter the name of the keypair here
variable "key_name" {
  default = "tfAWS-keypair"
}
########################################
# ASG MODULE VARIABLES
#########################################

// ASG Name
variable "asg-name" {
  type    = string
  default = "ASG-TF"

}

// ASG Name
variable "asg-prefix" {
  type    = string
  default = "ASG-TF-"

}

//ASG availability zones ID
variable "asg-az1-id" {
  type    = string
  default = "us-west-2a"
}

variable "asg-az2-id" {
  type    = string
  default = "us-west-2b"
}

//ASG subnets ID 
variable "asg-subnet-id" {
  type = list(string)
}
/*
variable "asg-subnet1-id" {
    type = string
  
}

variable "asg-subnet2-id" {
    type = string
  
}
*/
//ASG security groups ID
variable "asg-sg-id" {
  type = list(string)
}
/*
variable "asg-sg1-id" {
    type = string
  
}

variable "asg-sg2-id" {
    type = string
  
}
*/

// ASG ebs sizes
variable "asg-ebs-size" {
  type    = string
  default = "20"
}

// ASG EBS type 
variable "asg-ebs-type" {
  type    = string
  default = "gp3"

}

// ASG instances size
variable "asg-instance-type" {
  type    = string
  default = "t3.micro"

}


// ASG Desired Capacity
variable "asg-desired-capacity" {
  type    = string
  default = "2"

}

// ASG Minimum number
variable "asg-min-num" {
  type    = string
  default = "2"
}

// ASG Max number
variable "asg-max-num" {
  type    = string
  default = "4"
}

variable "aws-ec2-image" {
    type    = string
    default = "ami-0b2b4f610e654d9ac"
}

variable "asg-tg-arn-id" {
    type    = string
}

variable "asg-healthcheck-type" {
    type    = list(string)
    default = ["EC2", "ELB"]
}