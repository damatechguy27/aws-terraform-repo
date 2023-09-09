
# Instance Target Group
resource "aws_lb_target_group" "tf-tg-instance" {
  name        = var.tg-name
  port        = var.tg-ports
  protocol    = var.tg-protocol
  target_type = var.tg-target-type
  vpc_id      = var.tg-vpc-id
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