
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
# EC2 MODULE VARIABLES
#########################################

// EC2 Name
variable "ec2-name" {
  type    = string
  default = "EC2-TF"

}

//EC2 availability zones ID
variable "ec2-az-id" {
  type    = string
  default = "us-west-2a"
}

//EC2 subnets ID 
variable "ec2-subnet-id" {
  type = string

}

//Ec2 security groups ID
variable "ec2-sg-id" {
  type = list(string)

}
/*
variable "ec2-sg2-id" {
    type = string
  
}

variable "ec2-sg1-id" {
    type = string
  
}

variable "ec2-sg2-id" {
    type = string
  
}
*/
// EC2 ebs sizes
variable "ec2-ebs-size" {
  type    = string
  default = "20"
}

// EC2 EBS type 
variable "ec2-ebs-type" {
  type    = string
  default = "gp3"

}

// EC2 instances size
variable "ec2-instance-size" {
  type    = string
  default = "t3.micro"

}

variable "aws-ec2-image" {
    type    = string
    default = "ami-0b2b4f610e654d9ac"
}