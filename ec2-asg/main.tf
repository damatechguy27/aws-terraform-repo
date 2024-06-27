#Launch template 
resource "aws_launch_template" "asg-template" {
    #count = aws_autoscaling_group.ec2-asg.desired_capacity
    name = "${var.vpc_names[0]}-${var.ec2-name[0]}-${random_pet.petname.id}-Launch-Template"
    description = "WebServer Launch template"
    image_id = var.ec2-image[0]
    instance_type = var.ec2-inst-type
    key_name = aws_key_pair.publickey.key_name
    vpc_security_group_ids = [aws_security_group.ec2-security-group.id]
    user_data = base64encode(<<-EOF
                #!/bin/bash
                sudo yum -y update
                sudo yum -y install httpd
                sudo yum -y install git
                sudo mkdir /home/games && sudo cd /home/games
                sudo git clone https://github.com/damatechguy27/gameapps.git
                sudo cp -rf gameapps/Glokar/* /var/www/html
                sudo chown -R apache:apache /var/www/html/*
                sudo systemctl start httpd
                sudo systemctl enable httpd
                sudo rm-rf /home/games
                amazon-linux-extras install epel -y 
                yum install -y stress
                EOF
                )
    ebs_optimized = true
    #default_version = 1
    update_default_version = true
    block_device_mappings {
        device_name = "/dev/sda1"
        ebs {
            volume_size = var.ebs-size
            #volume_size = 20 # LT Update Testing - Version 2 of LT      
            delete_on_termination = true
            volume_type           = var.ebs-type # default is gp2
            encrypted = var.ebs-encryption
        }
    }
    monitoring {
        enabled = true
    }

    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "${var.vpc_names[0]}-${var.ec2-name[0]}-${random_pet.petname.id}"
        }
    }

  
}

#
#Autoscaling Group Resource
#
resource "aws_autoscaling_group" "ec2-asg" {
    name                  = "${var.vpc_names[0]}-${var.ec2-name[0]}-${random_pet.petname.id}-Autoscaling-Group"
    desired_capacity    = 1
    max_size            = 2
    min_size            = 1
    vpc_zone_identifier = [for name, subnet in var.priv_subnets : aws_subnet.priv-Subnets[name].id]


  // Use selection "EC2" for EC2 healthchecks 
  // Use ELB for ELB healthchecks use this if you want to use the ELB for check your ALB
  health_check_type = var.asg-healthcheck-type[1]

  depends_on = [ aws_instance.ec2-bastion ]
  #health_check_grace_period = 300 # default is 300 seconds  
  # Launch Template
  launch_template {
    id      = aws_launch_template.asg-template.id
    version = aws_launch_template.asg-template.latest_version
  }
  # Instance Refresh
  instance_refresh {
    strategy = "Rolling"
    preferences {
      #instance_warmup = 300 # Default behavior is to use the Auto Scaling Group's health check grace period.
      min_healthy_percentage = 50
    }
    triggers = [/*"launch_template",*/ "desired_capacity"] # You can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger
  }
  tag {
    key                 = "Owners"
    value               = "Web-Team"
    propagate_at_launch = true
  }
}

#Scaling policies 
#scaling out 
resource "aws_autoscaling_policy" "ec2-asg-scaleOut" {
  name                   = "${var.ec2-name[0]}-${random_pet.petname.id}-scaleOut"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2-asg.name
}

#scaling In
resource "aws_autoscaling_policy" "ec2-asg-scaleIn" {
  name                   = "${var.ec2-name[0]}-${random_pet.petname.id}-scaleIn"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 600
  autoscaling_group_name = aws_autoscaling_group.ec2-asg.name
}

# Cloudwatch alarms to connect ot the policies 

#High CPU Alarm
resource "aws_cloudwatch_metric_alarm" "asg-cw-scalout" {
  alarm_name          = "${var.ec2-name[0]}-${random_pet.petname.id}-scaleOut"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2-asg.name
  }

  alarm_description = "This metric monitors EC2 CPU utilization"
  actions_enabled   = true

  alarm_actions = [
    aws_autoscaling_policy.ec2-asg-scaleOut.arn
  ]
}


#Low CPU Alarm
resource "aws_cloudwatch_metric_alarm" "asg-cw-scalIn" {
  alarm_name          = "${var.ec2-name[0]}-${random_pet.petname.id}-scaleIn"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 40


  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2-asg.name
  }

  alarm_description = "This metric monitors EC2 CPU utilization"
  actions_enabled   = true

  ok_actions = [
    aws_autoscaling_policy.ec2-asg-scaleIn.arn
  ]

}