# Launch Template Resource
resource "aws_launch_template" "my_tf_template" {
  name = var.asg-name
  description = "My Launch Template"
  image_id = "ami-a0cfeed8"
  instance_type = var.asg-instance-type

  vpc_security_group_ids = var.asg-sg-id
  key_name = aws_key_pair.publickey.key_name 
  #user_data = filebase64("${path.module}/app1-install.sh")
  ebs_optimized = true
  #default_version = 1
  update_default_version = true
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.asg-ebs-size
      #volume_size = 20 # LT Update Testing - Version 2 of LT      
      delete_on_termination = true
      volume_type = var.asg-ebs-type # default is gp2
     }
  }
  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.asg-name
    }
  }
}