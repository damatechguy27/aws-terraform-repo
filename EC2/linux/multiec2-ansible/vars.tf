
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

#enter the name of the keypair here
variable "user_name" {
  default = "ec2-user"
}



########################################
# EC2 VARIABLES
#########################################

variable "ec2count" {
  type = number
  default = 1

}

variable "ec2name" {
  default = "tf-EC2"

}

variable "ec2ami"{
  default = "ami-08970fb2e5767e3b8"
}

variable "SG_name" {
  type    = list(string)
  default = ["tf_websg", "tf_remotesg"]
}


variable "aws_reg" {
  type    = list(string)
  default = ["us-east-1", "us-east-2", "us-west-1", "us-west-2"]

}

variable "inst_types" {
  type = map(string)
  default = {
    small  = "t3.micro"
    medium = "t3.small"
    large  = "t3.medium"
  }

}


########################################
# NETWORKING VARIABLES
#########################################
variable "vpc_name" {
  default = "tfvpc"
}

variable "interGW_name" {
  default = "tfintgw"
}

variable "pubroute_name" {
  default = "tfpubrt"
}

variable "priroute_name" {
  default = "tfprivrt"
}



variable "CIDR_IP" {

  default = "11.0.0.0/16"

}


variable "PUBSUB_IP" {

  type    = list(string)
  default = ["11.0.0.0/24", "11.0.1.0/24", "11.0.2.0/24", "11.0.3.0/24"]

}

variable "numofsubs" {
  type = number
  default = 4
  
}



variable "PRIVSUB_IP" {

  type    = list(string)
  default = ["11.1.0.0/24", "11.1.1.0/24", "11.1.2.0/24", "11.1.3.0/24"]

}

variable "avail_name" {

  type    = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]

}


######################################
#Ansible host file & playbook
#########################################
variable "ansi_hostfile_path" {
  default = "/home/user1/cloudutils/ansible/winansible/inventory/aws-hosts2.ini"
}

variable "ansible-http-playbook" {
#enter path to ansible playbook here 
  default = "/home/user1/cloudutils/ansible/playbooks/playbook-awsterra-test.yaml"

}