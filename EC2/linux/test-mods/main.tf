module aws-vpc-mod {

    source = "./aws-mods/vpc"
}

module aws-sg-mod {

    source = "./aws-mods/sg"
    sg-vpc-id = module.aws-vpc-mod.vpc-id

}

module my-aws-mods {

    source = "./aws-mods/"
}
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
# EC2 VARIABLES
#########################################
variable "ec2name" {
  default = "tf-EC2"

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
// Main body of script
resource "aws_ebs_volume" "ebsvol" {
  availability_zone = module.aws-vpc-mod.vpc-az
  size              = 20
  type              = "gp2"

  tags = {
    Name = var.ec2name
  }
}

resource "aws_volume_attachment" "attachebs" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebsvol.id
  instance_id = aws_instance.awsec2.id
}

resource "aws_instance" "awsec2" {
  instance_type          = var.inst_types.small
  ami                    = "ami-a0cfeed8"
  subnet_id              = module.aws-vpc-mod.vpc-sub0-id
  vpc_security_group_ids = ["${module.aws-sg-mod.sg-web-id}", "${module.aws-sg-mod.sg-remotesg-id}"]
  key_name = aws_key_pair.publickey.key_name


  tags = { Name = var.ec2name }

}
