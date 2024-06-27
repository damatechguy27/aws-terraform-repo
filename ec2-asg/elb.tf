# Application Load Balancers

resource "aws_lb" "aws-elb" {

    name = "ALB-${var.vpc_names[0]}-${random_pet.petname.id}"
    internal = var.is-internal
    load_balancer_type = var.elb-type[0]
    security_groups = [aws_security_group.alb-security-group.id]#[for sg in aws_security_group.security-groups : sg.id]
    subnets = [for subnet in aws_subnet.pub-Subnets : subnet.id]

    tags = {Name = "ALB-${var.vpc_names[0]}-${random_pet.petname.id}"}

  
}

#################################
# LISTENER HTTP FORWARDER
#################################
resource "aws_lb_listener" "HTTP_LIST" {
  load_balancer_arn = aws_lb.aws-elb.arn #aws_lb.front_end.arn
  port              = var.elb-list-ports
  protocol          = var.elb-list-protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-ec2-autoscaling-group.arn
  }
}