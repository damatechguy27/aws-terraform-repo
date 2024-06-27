variable "ec2-name" {
  type = list(string)
  default = ["Webserver", "db-Server", "Bastion"]
  
}

variable "ec2-inst-type" {
    type = string
    default = "t3.micro"
}



# Option 0: AWS linux west2 region ID ami-0663b059c6536cac8
# Option 1: Ubuntu image ami-08116b9957a259459 & redhat ami-0f7197c592205b389
# Option 2: AWS linux NAT instance  ami-0218a6903ac31c61f
variable "ec2-image" {
  type = list(string)
  default = ["ami-0663b059c6536cac8","ami-0f7197c592205b389", "ami-0218a6903ac31c61f"]
}

variable "ebs-size" {
  type = number
  default = 20
  
}

variable "ebs-type" {
  type = string
  default = "gp3"
}


variable "avail-zones" {
  type = string
  default = "us-west-2a"
  
}

variable "inst-Num" {
  type = number
  default = 2
}

variable "ebs-encryption" {
  type = bool
  default = false
  
}


#### Keypair ####

variable "keyname" {
  type = string
  default = "aws-ec2-keypair" 
}


variable "asg-healthcheck-type" {
    type    = list(string)
    default = ["EC2", "ELB"]
}

/*
variable "key_path" {
  type = string
  #default = file("${path.module}/aws-ec2-keypair.pem")
}*/
/*
variable "ec2-list" {

    type = map(object({
    count = string
    instance_type = string
    ami = string
    key_name = string
    availability_zone = string
    subnet_id = string
    vpc_security_group_ids = list(string)
    Name = string
    }))
    default = {
      "web-server" = {
            count = var.inst-Num   
            instance_type = var.ec2-isnt-type
            ami = var.ec2-image
            key_name = aws_key_pair.publickey.key_name
            #this ensures that each ec2 instance is deploy into a different availability zone and subnet
            availability_zone = values(aws_subnet.pub-Subnets)[count.index].availability_zone
            subnet_id = values(aws_subnet.pub-Subnets)[count.index].id
          
            #used a for loop to store the IDs each security group in the list into a variable call sg 
            vpc_security_group_ids = [for sg in aws_security_group.security-groups : sg.id]

            tags = {Name = "${var.ec2-name[0]}-${random_pet.petname.id}-${count.index}"}        
      }
      "database" = {
            count = var.inst-Num   
            instance_type = var.ec2-isnt-type
            ami = var.ec2-image
            key_name = aws_key_pair.publickey.key_name
            #this ensures that each ec2 instance is deploy into a different availability zone and subnet
            availability_zone = values(aws_subnet.pub-Subnets)[count.index].availability_zone
            subnet_id = values(aws_subnet.pub-Subnets)[count.index].id
          
            #used a for loop to store the IDs each security group in the list into a variable call sg 
            vpc_security_group_ids = [for sg in aws_security_group.security-groups : sg.id]

            tags = {Name = "${var.ec2-name[0]}-${random_pet.petname.id}-${count.index}"}        
      }
      "bastion" = {
            count = var.inst-Num   
            instance_type = var.ec2-isnt-type
            ami = var.ec2-image
            key_name = aws_key_pair.publickey.key_name
            #this ensures that each ec2 instance is deploy into a different availability zone and subnet
            availability_zone = values(aws_subnet.pub-Subnets)[count.index].availability_zone
            subnet_id = values(aws_subnet.pub-Subnets)[count.index].id
          
            #used a for loop to store the IDs each security group in the list into a variable call sg 
            vpc_security_group_ids = [for sg in aws_security_group.security-groups : sg.id]

            tags = {Name = "${var.ec2-name[0]}-${random_pet.petname.id}-${count.index}"}        
      }
    }
  
}
*/