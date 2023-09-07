variable "aws_reg" {
  type    = list(string)
  default = ["us-east-1", "us-east-2", "us-west-1", "us-west-2"]

}

variable "inst_types" {
  type = map(string)
  default = {
    micro   = "t3.micro"
    small   = "t3.small"
    medium  = "t3.medium"
  }

}

variable "avail_name" {

  type    = list(string)
  default = ["us-west-2a", "us-west-2b"]

}
#########################
# EC2 VARIABLES
#########################
