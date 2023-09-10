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

// USE WHEN USING AN EC2 AUTOSCALING DEPLOYMENT

# Autoscaling Group ID
variable "tg-asg-id" {
  type = string
}

resource "aws_autoscaling_attachment" "tf-asg-tg-attachment" {
  autoscaling_group_name = var.tg-asg-id
  lb_target_group_arn    = aws_lb_target_group.tf-tg-instance.arn
} 