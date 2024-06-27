
# ASG Target Group

resource "aws_lb_target_group" "tg-ec2-autoscaling-group" {
  name        = "TG-${var.vpc_names[0]}-${random_pet.petname.id}"
  port        = var.tg-ports
  protocol    = var.tg-protocol
  target_type = var.tg-target-type[2]
  vpc_id      = aws_vpc.vpc.id
  
  health_check {
    timeout = 30
    protocol = "HTTP"
    port = 80
    unhealthy_threshold = 5
    path = "/"
    interval = 60
  }
}
# ASG attachments
resource "aws_autoscaling_attachment" "tf-asg-tg-attachment" {
  autoscaling_group_name = aws_autoscaling_group.ec2-asg.name
  lb_target_group_arn    = aws_lb_target_group.tg-ec2-autoscaling-group.arn
} 

# Target Group types and examples  
/*
# Instance Target Group
resource "aws_lb_target_group" "tf-tg-instance" {
  name        = var.tg-name
  port        = var.tg-ports
  protocol    = var.tg-protocol
  target_type = var.tg-target_type
  vpc_id      = var.tg-vpc-id
}

# IP Target Group 
resource "aws_lb_target_group" "tf-tg-ip" {
  name        = var.tg-name
  port        = var.tg-ports
  protocol    = var.tg-protocol
  target_type = var.tg-target_type
  vpc_id      = var.tg-vpc-id
}

# Application Target Group 
resource "aws_lb_target_group" "tf-tg-alb" {
  name        = var.tg-name
  port        = var.tg-ports
  protocol    = var.tg-protocol
  target_type = var.tg-target_type
  vpc_id      = var.tg-vpc-id
}
*/

/*
If you are deploying an EC2 instance and want to attach it to a ALB 
uncomment the EC2 section 

If you are deploying an ASG instance and want to attach it to a ALB 
uncomment the ASG section 

*/

/*
// USE WHEN USING AN EC2 DEPLOYMENT
# Target Group Instance IDs
variable "tg-instance-id" {
  type = string
}

# Target Group ARN ID
variable "tg-arn-id" {
  type = string
}

resource "aws_lb_target_group_attachment" "tf_tg_attachment" {
  target_group_arn = var.tg-arn-id #aws_lb_target_group.tf-tg-instance.arn
  target_id        = var.tg-instance-id
  port             = var.tg-ports
}

*/

/*
// USE WHEN USING AN EC2 AUTOSCALING DEPLOYMENT

# Autoscaling Group ID
variable "tg-asg-id" {
  type = string
}

resource "aws_autoscaling_attachment" "tf-asg-tg-attachment" {
  autoscaling_group_name = var.tg-asg-id
  lb_target_group_arn    = aws_lb_target_group.tf-tg-instance.arn
} 
*/