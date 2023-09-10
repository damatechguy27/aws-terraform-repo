# Autoscaling Group Resource
resource "aws_autoscaling_group" "tf_asg" {
  name_prefix         = var.asg-prefix
  desired_capacity    = var.asg-desired-capacity
  max_size            = var.asg-max-num
  min_size            = var.asg-min-num
  vpc_zone_identifier = var.asg-subnet-id


  // Use selection "EC2" for EC2 healthchecks 
  // Use ELB for ELB healthchecks use this if you want to use the ELB for check your ALB
  health_check_type = var.asg-healthcheck-type[1]

  #health_check_grace_period = 300 # default is 300 seconds  
  # Launch Template
  launch_template {
    id      = aws_launch_template.tf_template.id
    version = aws_launch_template.tf_template.latest_version
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