
data "template_file" "user_data_linux"{
  template = <<EOF
#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
sudo touch /var/www/html/index.html
sudo echo "Hello World this is unit " > /var/www/html/index.html
sudo hostname >> /var/www/html/index.html
sudo chown -R apache:apache /var/www/html/*
sudo systemctl start httpd
sudo systemctl enable httpd
  EOF
}

# Launch Template Resource
resource "aws_launch_template" "tf_template" {
  name                   = var.asg-name
  description            = "My Launch Template"
  image_id               = var.aws-ec2-image
  instance_type          = var.asg-instance-type
  vpc_security_group_ids = var.asg-sg-id
  key_name               = aws_key_pair.publickey.key_name
  user_data              = "${base64encode(data.template_file.user_data_linux.rendered)}"
  ebs_optimized = true
  #default_version = 1
  update_default_version = true
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.asg-ebs-size
      #volume_size = 20 # LT Update Testing - Version 2 of LT      
      delete_on_termination = true
      volume_type           = var.asg-ebs-type # default is gp2
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