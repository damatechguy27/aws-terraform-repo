
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

    // DETERMINE SECURITY GROUPS VPC ID 
    sg-vpc-id = module.aws-vpc-mod.vpc-id

}

/*
##############################
# EC2 MODULE
##############################
module aws-ec2-mod {

    source = "./aws-mods/ec2"

// EC2 AVAILABILITY ZONES
    ec2-az-id     = var.avail_name[0]

// EC2 SUBNETS 
    ec2-subnet-id = module.aws-vpc-mod.vpc-sub0-id

// EC2 SECURITY GROUP
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
*/

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
    // default name is ASG-TF
#    asg-name = "Jeffery-asg"

    // default prefix is ASG-TF-
#    asg-prefix = "Jeffery-asg-"

    // Autoscaling rules 
    // default desired capacity is 2
#    asg-desired-capacity = "3"
    // default maximum size is 4
#    asg-max-num = "6"
    // default maximum size is 2
#    asg-min-num = "3"


    // Autoscaling EBS sizes
    // default size is 20
#    asg-ebs-size = "30"
    // default instance type is gp2
#    asg-ebs-type = "gp3"


}


##############################
# LOAD BALANCERS MODULE
##############################
module aws-elb-mod {

    source = "./aws-mods/elb"
    
    elb-sg-id       = ["${module.aws-sg-mod.sg-web-id}"]

// ELB SUBNETS
    elb-subnets-id  = [ "${module.aws-vpc-mod.vpc-sub0-id}", "${module.aws-vpc-mod.vpc-sub1-id}"]

// ELB PROTOCOLS
    elb-list-protocol   = "HTTP"

// ELB PORTS 
    elb-list-ports      = "80"

// TARGET GROUP VPC ID 
    tg-vpc-id       = module.aws-vpc-mod.vpc-id

// Target Groups target types (ip, instance, alb)
    tg-target-type = "instance"

  //variables below has default value but you can change them if you like
  // By uncommenting the variable below based on the deployment you want

 // ELB PROPERTIES
 // ELB NAME
#    var.elb-name       =

/* 
THE DETERMINE WHETHER YOUR ELB IS INTERNET FACING OR NOT
TRUE = IS NOT INTERNET FACING 
FALSE = IS INTERNET FACING
*/
#    var.elb-internal   =

/* 
THE DETERMINE WHETHER YOUR ELB IS APPLICTION OR NETWORK ELB
APPLICATION = APPLICATION ELB 
NETWORK = NETWORK ELB
*/
#    var.elb-type       =

/* 
ENVIRONMENT TAG DETERMINE WHAT ENVIRONMENT YOU INSTANCES BELONG TOO
EXAMPLE TAG: ENV: PRODUCTION
*/
#    var.elb-env        =

/* 
DETERMINE ELB TARGET AND PROVIDE THE NAME, PROTOCOL AND PORT NUMBER TO USE 
DEFAULTS ARE:
NAME: TFTGROUP
PORT: 80
PROTOCOL: HTTP
*/
#    var.tg-name        =
#    var.tg-ports       =
#    var.tg-protocol    =


/*
ONLY USE THIS AREA IF YOU ARE USING AN LOAD BALANCER WITH YOUR DEPLOYMENTS

UNCOMMENT THE EC2 SECTION ONLY IF YOU ARE USING AN EC2 DEPLOYMENT 
UNCOMMENT THE ASG SECTION ONLY IF YOU ARE USING AN ASG DEPLOYMENT 
*/


/*
 # EC2 DEPLOYMENT AND ATTACHMENT TO THE ALB   
    tg-arn-id       = module.aws-elb-mod.tg-arn
    tg-instance-id  = module.aws-ec2-mod.aws_ec2instance_id #["${module.aws-ec2-mod.aws_ec2instance_id}"]
*/
 
 # asg DEPLOYMENT AND ATTACHMENT TO THE ALB   
    tg-asg-id       = module.aws-asg-mod.asg-id

}
