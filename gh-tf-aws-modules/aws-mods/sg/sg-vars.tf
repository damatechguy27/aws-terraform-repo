// Security Groups 
variable "SG_name" {
  type    = list(string)
  default = ["tf_websg", "tf_remotesg"]
}

variable "sg-vpc-id" {
  type = string

}