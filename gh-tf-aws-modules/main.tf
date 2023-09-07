module aws-vpc-mod {

    source = "./aws-mods/vpc"
}

module aws-sg-mod {

    source = "./aws-mods/sg"
    sg-vpc-id = module.aws-vpc-mod.vpc-id

}

module aws-ec2-mod {

    source = "./aws-mods/ec2"

    ec2-az-id     = var.avail_name[0]
    ec2-subnet-id = module.aws-vpc-mod.vpc-sub0-id
    ec2-sg1-id    = module.aws-sg-mod.sg-web-id
    ec2-sg2-id    = module.aws-sg-mod.sg-remotesg-id
    

    //variables below has default value but you can change them if you like
    // By uncommenting the variable below:
    // Default value is Ec2-TF
#   ec2-name = "jeffrey"

    // Default value is 20
#    ec2-ebs-size = "30"

    // Default value is gp2
#    ec2-ebs-type = "gp3"

    // Default value is t3.micro
#    ec2-instance-size = var.inst_types.small
}