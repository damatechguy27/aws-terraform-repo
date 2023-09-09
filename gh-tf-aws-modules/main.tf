
##############################
# VPC MODULE
##############################

module aws-vpc-mod {

    source = "./aws-mods/vpc"
}



##############################
# SECURITY GROUP MODULE
##############################
module aws-sg-mod {

    source = "./aws-mods/sg"
    sg-vpc-id = module.aws-vpc-mod.vpc-id

}


##############################
# EC2 MODULE
##############################
module aws-ec2-mod {

    source = "./aws-mods/ec2"

    ec2-az-id     = var.avail_name[0]
    ec2-subnet-id = module.aws-vpc-mod.vpc-sub0-id
    ec2-sg-id     = [ "${module.aws-sg-mod.sg-web-id}", "${module.aws-sg-mod.sg-remotesg-id}"]
   

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


##############################
# LOAD BALANCERS MODULE
##############################
module aws-elb-mod {

    source = "./aws-mods/elb"
    
#    var.elb-name       =
#    var.elb-internal   =
#    var.elb-type       =
    elb-sg-id       = ["${module.aws-sg-mod.sg-web-id}"]
    elb-subnets-id  = [ "${module.aws-vpc-mod.vpc-sub0-id}", "${module.aws-vpc-mod.vpc-sub1-id}"]
#    var.elb-env        =
    elb-list-protocol   = "HTTP"
    elb-list-ports      = "80"
#    var.tg-name        =
#    var.tg-ports       =
#    var.tg-protocol    =
    tg-vpc-id       = module.aws-vpc-mod.vpc-id
    tg-target-type = "instance"
    #tg-arn-id       = ["${module.aws-elb-mod.tf-tg-alb.arn}"]
    tg-instance-id  = module.aws-ec2-mod.aws_ec2instance_id #["${module.aws-ec2-mod.aws_ec2instance_id}"]
}
