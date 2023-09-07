/*
This is the template for each module 
just copy and paste the mods you want into the main.tf file
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
# ASG MODULE
##############################
module aws-asg-mod {

    source = "./aws-mods/ec2-asg"

    asg-az1-id     = var.avail_name[0]
    asg-az2-id     = var.avail_name[1]
    asg-subnet-id  = [ "${module.aws-vpc-mod.vpc-sub0-id}", "${module.aws-vpc-mod.vpc-sub1-id}"]
    asg-sg-id      = [ "${module.aws-sg-mod.sg-web-id}", "${module.aws-sg-mod.sg-remotesg-id}"]    

    //variables below has default value but you can change them if you like
    // By uncommenting the variable below:
    
    // The autoscaling group name 
#    asg-name = 

#    asg-prefix = 

    // Autoscaling rules 
#    asg-desired-capacity = 

#    asg-max-num = 

#    asg-min-num = 


    // Autoscaling EBS sizes
#    asg-ebs-size = 

#    asg-ebs-type = 

    
}
*/