#################################
# HTTP FORWARDER
#################################
resource "aws_lb_listener" "HTTP_LIST" {
  load_balancer_arn = aws_lb.tf-lb.arn #aws_lb.front_end.arn
  port              = var.elb-list-ports
  protocol          = var.elb-list-protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf-tg-instance.arn
  }
}

/*
#################################
# HTTPS FORWARDER
#################################
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}
*/